Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab3KAJ2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 05:28:05 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:47904 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3KAJ2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 05:28:03 -0400
Date: Fri, 1 Nov 2013 10:27:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [RFC/PATCHSET 00/14] perf report: Add support to accumulate hist
 periods (v2)
Message-ID: <20131101092759.GC27063@gmail.com>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
 <20131031080932.GA8479@gmail.com>
 <87vc0c4ny2.fsf@sejong.aot.lge.com>
 <20131101075502.GA25547@gmail.com>
 <874n7w4gtm.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874n7w4gtm.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> >> > 2)
> >> >
> >> > Is it possible to configure the default 'report -g' style, so that 
> >> > people who'd like to use it all the time don't have to type '-g 
> >> > cumulative' all the time?
> >> 
> >> Hmm.. maybe I can add support for the 'report.call-graph' config option.
> >
> > If we display your new 'total' field by default then it's not as 
> > pressing to me :)
> 
> Do you mean -g cumulative without 'self' column?

So, if by default we display both 'self' and 'total' and sort by 
'total', then I'm personally a happy camper: while it's a change of 
the default perf report output, it's also a step forward.

But some people might complain about it once this hits v3.13 (or 
v3.14) and might want to hide individual columns and have different 
sorting preferences.

So out of defensive caution you might want to provide toggles for 
such things, maybe even generalize it a bit to allow arbitrary 
hiding/display of individual colums in perf report.

That would probably also make it easier to do minimal tweaks to the 
upstream reporting defaults.

> > Btw., if anyone is interested in improving the GTK front-end, it 
> > would be _really_ nice if it had a 'start profiling' button like 
> > sysprof has today, with a 'samples' field showing the current 
> > number of samples. (We could even improve upon sysprof by adding 
> > 'stop' functionality as well ;-)
> 
> Wow, I'm impressed that the sysprof doesn't have one. :)

At least I haven't found it: I tried pressing 'start' once more but 
that doesn't do it, it just keeps collecting data.

Still many developers love sysprof, so I think there would be quite 
some plus in providing a gtk perf top version with the controls 
Pekka and me listed.

Thanks,

	Ingo
