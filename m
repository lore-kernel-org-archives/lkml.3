Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaJJUmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 16:42:05 -0400
Received: from mail.kernel.org ([198.145.19.201]:41046 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaJJUmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 16:42:03 -0400
Date: Fri, 10 Oct 2014 17:41:58 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/1] rasd: Use perf_evlist__open() instead of open coded
Message-ID: <20141010204158.GA13834@kernel.org>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
 <20141006212606.GF14113@kernel.org>
 <CAFrcx1=swP-3E_pxWEcozFJhL+5YaUBPavQX=OfMtc8h4e=bDg@mail.gmail.com>
 <20141007133236.GG14113@kernel.org>
 <20141007140433.GG30146@pd.tnic>
 <20141010200708.GB18775@kernel.org>
 <20141010202854.GC13017@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010202854.GC13017@pd.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 10, 2014 at 10:28:54PM +0200, Borislav Petkov escreveu:
> On Fri, Oct 10, 2014 at 05:07:08PM -0300, Arnaldo Carvalho de Melo wrote:
> > I'll try  lding rasd.c with it and checking if it works.

> > Never having tried this, what are the requisites to test it? Some
> > specific hardware and a kernel with the right tracepoint? I guess some
> > recent 3.17-rc kernel is all that I need?

> Well, you'd need the part of Jean's patches which adds the event to evlist:
 
> https://lkml.kernel.org/r/1412933690-25576-1-git-send-email-jean.pihet@linaro.org
 
> AFAICT, you could apply patches 1-5 and replace 6 with yours. Now,
> rasd.cfg has the mce:mce_record tracepoint which rasd opens but you
> probably want to put a tracepoint which is much easier to exercise,
> maybe some syscall or whatever.

Right, stoopid me, no need for some specific tracepoint, just to see
that whatever tp it is, it will show up in "rasd"'s event loop. Ok, I'll
try that later.

Next stuff I probably will do is to move the bare minimum used by rasd
to tools/lib/api/perf/, i.e. there will be:

tools/lib/api/perf/evsel.c
tools/perf/util/evsel.c

Both will share the perf_evsel__ namespace (which I thought at some
point to make just: evsel__<METHOD_NAME>, wdyt?).

That way we just make public the bare minimum that already proved to be
useful outside tools/perf/ and over time we move stuff from
tools/perf/util/evsel.c (and from other tools in or out perf's repo)
into the lib.
 
> I think that should do it but we won't know until we've tried it.
> 
> HTH and thanks a lot for doing this!

Np, had to be done at some point :)

- Arnaldo
 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
