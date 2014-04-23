Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbaDWEt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 00:49:27 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:49751 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbaDWEtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 00:49:22 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCHSET 0/9] perf tools: Fixup for the --percentage change
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
	<20140422095557.GB10813@gmail.com>
Date: Wed, 23 Apr 2014 13:49:05 +0900
In-Reply-To: <20140422095557.GB10813@gmail.com> (Ingo Molnar's message of
	"Tue, 22 Apr 2014 11:55:57 +0200")
Message-ID: <87k3agsla6.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Tue, 22 Apr 2014 11:55:57 +0200, Ingo Molnar wrote:
> I gave it some quick testing and after fixing a trivial merge conflict 
> in tools/lib/lockdep/Makefile all seems to be working fine.

Thanks for testing!

>
> But while looking at it I remembered one of my old UI complains about 
> perf top and report, the hard to read nature of:
>
>    Event count (approx.): 226958779
>
> the values displayed are typically way too large to be easily human 
> readable. More importantly, they are also nonsensical! That we have a 
> sampling interval and can sum up all the intervals sampled has very 
> little meaning to the overwhelming majority of humans looking at the 
> data.
>
> And printing that just spams the visual field and confuses people.
>
> People care about the quality and speed of sampling itself, not 
> directly the interval of sampling (which will often be variable with 
> auto-freq sampling).

You meant 'period' by 'interval', right?

There's --show-total-period option (should be equivalent to -F period
later) in perf report, so there might be people want to see the numbers
IMHO.

>
> So instead of:
>
>   Samples: 42K of event 'cycles', Event count (approx.): 226958779
>
> How about only printing this in 'perf top' and 'perf report':
>
>   Captured 42.1K 'cycles' event samples
>
> Note the extra decimal (which helps monitor smaller changes as well), 
> and note the different wording.
>
> Thoughts?

Well, I'm okay to add the extra decimal, but it seems that it only makes
sense when the unit is 'K'..

And I think it might be worth adding filtered sample count as well if
filtering is enabled something like:

  Captured 13.2K/42.1K 'cycles' event samples


Thanks,
Namhyung
