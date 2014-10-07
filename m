Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbaJGORT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:17:19 -0400
Received: from mail.kernel.org ([198.145.19.201]:39497 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbaJGORR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:17:17 -0400
Date: Tue, 7 Oct 2014 11:17:12 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/1] rasd: Use perf_evlist__open() instead of open coded
Message-ID: <20141007141712.GK14113@kernel.org>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
 <20141006212606.GF14113@kernel.org>
 <CAFrcx1=swP-3E_pxWEcozFJhL+5YaUBPavQX=OfMtc8h4e=bDg@mail.gmail.com>
 <20141007133236.GG14113@kernel.org>
 <20141007140433.GG30146@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007140433.GG30146@pd.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 07, 2014 at 04:04:33PM +0200, Borislav Petkov escreveu:
> On Tue, Oct 07, 2014 at 10:32:36AM -0300, Arnaldo Carvalho de Melo wrote:
> > Hopefully we will completely remove the need to set up any thread or cpu
> > map, as what you want is syswide tracing, right?
 
> Yeah, I was questioning the need to open at least one thread even for
> system-wide tracing.

Right, evsel/evlist evolved out of tons of refactoring steps moving
stuff out of open coded tools (record, report, top) while trying to make
it work for those tools, sometimes this resulted in sub-optimal defaults
(or plain bugs) like needing a thread_map and/or a cpu_map to do syswide
tracing, need to get that clarified and sorted out.

- Arnaldo
 
> See, source libraries are the new great thing for collaborative
> development - f*ck "cloud"!
 
> :-D

:-)

- Arnaldo
