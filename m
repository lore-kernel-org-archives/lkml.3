Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbaGKRaD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 13:30:03 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:60019 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752072AbaGKRaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 13:30:00 -0400
Message-ID: <53C01F15.2090702@semaphore.gr>
Date: Fri, 11 Jul 2014 20:29:57 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: rjw@rjwysocki.net, viresh.kumar@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpufreq: ondemand: Eliminate the deadband effect
References: <1404147574-17422-1-git-send-email-stratosk@semaphore.gr> <1404147574-17422-3-git-send-email-stratosk@semaphore.gr> <20140711165710.GA18033@amd.pavel.ucw.cz>
In-Reply-To: <20140711165710.GA18033@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel!

On 11/07/2014 07:57 μμ, Pavel Machek wrote:
> Hi!
> 
>> Tested on Intel i7-3770 CPU @ 3.40GHz and on ARM quad core 1500MHz Krait
>> (Android smartphone).
>> Benchmarks on Intel i7 shows a performance improvement on low and medium
>> work loads with lower power consumption. Specifics:
>>
>> Phoronix Linux Kernel Compilation 3.1:
>> Time: -0.40%, energy: -0.07%
>> Phoronix Apache:
>> Time: -4.98%, energy: -2.35%
>> Phoronix FFMPEG:
>> Time: -6.29%, energy: -4.02%
> 
> Hmm. Intel i7 should be race-to-idle machine. So basically rule like
> if (load > 0) go to max frequency else go to lowest frequency would do
> the right thing in your test, right?

I don't think that "if (load > 0) go to max" will work even on i7.
For low load this will have impact on energy consumption.
On my tests, a simple mp3 decoding (very low load on my machine) have no
difference with and without this patch.

> So... should we do that, or do we need better benchmark?

I'm sorry. I'm not sure I understood exactly what do you mean by "better
benchmark".
Of course, we should do as many benchmarks as we can.
I usually do these 5 sets of benchmarks on my i7 that IMHO give a good
indication about the changes in different CPU loads.

1) Linux kernel compilation (about 85% busy CPU)
2) Apache (about 32% busy CPU)
3) ffmpeg (about 24% busy CPU)
4) mp3 decoding (about 0.3% CPU)
5) Idle system (about 0.06% CPU)

The patch was also tested on a Android smartphone (kernel 3.4). The kernel
distributed to 1000+ users.
Unfortunately I have no benchmarks, but no regressions reported on
consumption. Actually, there reports for better performance and
lower power consumption, but of course we can't rely on these reports. :)


Thanks for your comments!

Stratos


