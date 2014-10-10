Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaJJU3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 16:29:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52152 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaJJU3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 16:29:06 -0400
Date: Fri, 10 Oct 2014 22:28:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/1] rasd: Use perf_evlist__open() instead of open coded
Message-ID: <20141010202854.GC13017@pd.tnic>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
 <20141006212606.GF14113@kernel.org>
 <CAFrcx1=swP-3E_pxWEcozFJhL+5YaUBPavQX=OfMtc8h4e=bDg@mail.gmail.com>
 <20141007133236.GG14113@kernel.org>
 <20141007140433.GG30146@pd.tnic>
 <20141010200708.GB18775@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141010200708.GB18775@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 05:07:08PM -0300, Arnaldo Carvalho de Melo wrote:
> Ok, so what is now at my perf/hists branch at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git
> 
> should do the trick, the patch below makes rasd.c use it.

Cool.

> I'll try  lding rasd.c with it and checking if it works.
> 
> Never having tried this, what are the requisites to test it? Some
> specific hardware and a kernel with the right tracepoint? I guess some
> recent 3.17-rc kernel is all that I need?

Well, you'd need the part of Jean's patches which adds the event to evlist:

https://lkml.kernel.org/r/1412933690-25576-1-git-send-email-jean.pihet@linaro.org

AFAICT, you could apply patches 1-5 and replace 6 with yours. Now,
rasd.cfg has the mce:mce_record tracepoint which rasd opens but you
probably want to put a tracepoint which is much easier to exercise,
maybe some syscall or whatever.

I think that should do it but we won't know until we've tried it.

HTH and thanks a lot for doing this!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
