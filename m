Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbbAVSTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:19:11 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:65462 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbbAVSTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:19:09 -0500
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 22 Jan 2015 13:20:15 -0500 (EST)
To: Stephane Eranian <eranian@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        cl@linux.com
Subject: Re: perf: easily crash kernel with rapl event close
In-Reply-To: <CAMsRxfLek-_4o+t2OV_31MyC=76z6u7wn4Nm-yKpa1NN9kjh7Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1501221317330.14136@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1501211348470.22707@vincent-weaver-1.umelst.maine.edu> <CAMsRxfJVxUcTvpaUSvTY19Ha93J1R-=o97hO+bfgkL3zU7Nrpw@mail.gmail.com> <20150122101720.GA2896@worktop.programming.kicks-ass.net> <CAMsRxfKnDVxc4awnGPQ+7s1BvsUHDQV5GwDRmV2J9BGKP2EMXg@mail.gmail.com>
 <CAMsRxfLek-_4o+t2OV_31MyC=76z6u7wn4Nm-yKpa1NN9kjh7Q@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Stephane Eranian wrote:

> Fix looks like this:
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
> b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
> index 6e434f8..c4bb8b8 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
> @@ -142,7 +142,7 @@ static inline u64 rapl_scale(u64 v)
>          * or use ldexp(count, -32).
>          * Watts = Joules/Time delta
>          */
> -       return v << (32 - __this_cpu_read(rapl_pmu->hw_unit));
> +       return v << (32 - __this_cpu_read(rapl_pmu)->hw_unit);
>  }
> 
> 
> Will post the patch shortly.
> Thanks Vince for reporting this issue.

Well that's obviously a classic misplaced-parenthesis bug, but I patched 
and re-ran my tests anyway to make sure this really fixed things.
(It did).  So in case it is useful:

Tested-by: Vince Weaver <vincent.weaver@maine.edu>


