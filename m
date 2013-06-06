Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347Ab3FFMyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:54:36 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:38376 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933138Ab3FFMye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:54:34 -0400
Date: Thu, 06 Jun 2013 15:54:20 +0300
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of
 target frequency
Message-ID: <fqrv6c2yk2ebwb4182ect77d.1370523260717@email.android.com>
From: Stratos Karafotis <stratosk@semaphore.gr>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Borislav Petkov <bp@suse.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r56CseVQ011219

Hi Rafael,

I will try to provide the requested info (although, I'm not sure how to measure total energy :) )

Thanks,
Stratos

"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

>On Wednesday, June 05, 2013 08:13:26 PM Stratos Karafotis wrote:
>> Hi Borislav,
>> 
>> On 06/05/2013 07:17 PM, Borislav Petkov wrote:
>> > On Wed, Jun 05, 2013 at 07:01:25PM +0300, Stratos Karafotis wrote:
>> >> Ondemand calculates load in terms of frequency and increases it only
>> >> if the load_freq is greater than up_threshold multiplied by current
>> >> or average frequency. This seems to produce oscillations of frequency
>> >> between min and max because, for example, a relatively small load can
>> >> easily saturate minimum frequency and lead the CPU to max. Then, the
>> >> CPU will decrease back to min due to a small load_freq.
>> >
>> > Right, and I think this is how we want it, no?
>> >
>> > The thing is, the faster you finish your work, the faster you can become
>> > idle and save power.
>> 
>> This is exactly the goal of this patch. To use more efficiently middle
>> frequencies to finish faster the work.
>> 
>> > If you switch frequencies in a staircase-like manner, you're going to
>> > take longer to finish, in certain cases, and burn more power while doing
>> > so.
>> 
>> This is not true with this patch. It switches to middle frequencies
>> when the load < up_threshold.
>> Now, ondemand does not increase freq. CPU runs in lowest freq till the
>> load is greater than up_threshold.
>> 
>> > Btw, racing to idle is also a good example for why you want boosting:
>> > you want to go max out the core but stay within power limits so that you
>> > can finish sooner.
>> >
>> >> This patch changes the calculation method of load and target frequency
>> >> considering 2 points:
>> >> - Load computation should be independent from current or average
>> >> measured frequency. For example an absolute load 80% at 100MHz is not
>> >> necessarily equivalent to 8% at 1000MHz in the next sampling interval.
>> >> - Target frequency should be increased to any value of frequency table
>> >> proportional to absolute load, instead to only the max. Thus:
>> >>
>> >> Target frequency = C * load
>> >>
>> >> where C = policy->cpuinfo.max_freq / 100
>> >>
>> >> Tested on Intel i7-3770 CPU @ 3.40GHz and on Quad core 1500MHz Krait.
>> >> Phoronix benchmark of Linux Kernel Compilation 3.1 test shows an
>> >> increase ~1.5% in performance. cpufreq_stats (time_in_state) shows
>> >> that middle frequencies are used more, with this patch. Highest
>> >> and lowest frequencies were used less by ~9%
>
>Can you also use powertop to measure the percentage of time spent in idle
>states for the same workload with and without your patchset?  Also, it would
>be good to measure the total energy consumption somehow ...
>
>Thanks,
>Rafael
>
>
>-- 
>I speak only for myself.
>Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
