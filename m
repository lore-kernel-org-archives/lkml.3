Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaFKUUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:20:32 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:32910 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751328AbaFKUUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:20:30 -0400
Message-ID: <5398BA0B.7070903@semaphore.gr>
Date: Wed, 11 Jun 2014 23:20:27 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Doug Smythies <dsmythies@telus.net>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@rjwysocki.net,
        viresh.kumar@linaro.org, dirk.j.brandewie@intel.com
Subject: Re: [PATCH] cpufreq: intel_pstate: Fix rounding of core_pct
References: <1402490012-19969-1-git-send-email-stratosk@semaphore.gr> <009b01cf857a$d5032090$7f0961b0$@net> <539862DB.9060905@semaphore.gr> <00a001cf8586$24eb5c70$6ec21550$@net>
In-Reply-To: <00a001cf8586$24eb5c70$6ec21550$@net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 06:02 μμ, Doug Smythies wrote:
> 
> On 2104.06.11 07:08 Stratos Karafotis wrote:
>> On 11/06/2014 04:41 μμ, Doug Smythies wrote:
>>
>> No.
>>
>> The intent was only ever to round properly the pseudo floating point result of the divide.
>> It was much more important (ugh, well 4 times more) when FRACBITS was still 6, which also got changed to 8 in a recent patch.
>>
> 
> Are you sure?
> 
> Yes.
> 
>> This rounding was very recently added.
>> As far as I can understand, I don't see the meaning of this rounding, as is.
>> Even if FRAC_BITS was 6, I think it would have almost no improvement in
>> calculations.
> 
> Note: I had not seen this e-mail when I wrote a few minutes ago:
> 
> You may be correct.
> If Dirk agrees, I will re-analyse the entire driver for rounding effects soon.
> When FRACBITS was 6 there were subtle cases where the driver would get stuck, and not make a final pstate change, with the default PID gains.
> Other things have changed, and the analysis needs to be re-done.
> 

Could you please elaborate a little bit more what we need these 2 lines below?

        if ((rem << 1) >= int_tofp(sample->mperf))
                core_pct += 1;

Because nothing is mentioned for them in commit's changelog.
Do we need to round core_pct or not?
Because if we try to round it, I think this patch should work.

Thanks,
Stratos


