Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaFMQ45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:56:57 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:36909 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753490AbaFMQ44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:56:56 -0400
Message-ID: <539B2D54.6070108@semaphore.gr>
Date: Fri, 13 Jun 2014 19:56:52 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Doug Smythies <dsmythies@telus.net>
CC: viresh.kumar@linaro.org, dirk.j.brandewie@intel.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: intel_pstate: Fix rounding of core_pct
References: <1402490012-19969-1-git-send-email-stratosk@semaphore.gr> <00b301cf85ba$40fe4290$c2fac7b0$@net> <5399BACF.6060201@semaphore.gr> <1815178.vjJU51ubGD@vostro.rjw.lan> <539B0147.8020407@gmail.com>
In-Reply-To: <539B0147.8020407@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/2014 04:48 μμ, Dirk Brandewie wrote:
> On 06/12/2014 01:03 PM, Rafael J. Wysocki wrote:
>> On Thursday, June 12, 2014 05:35:59 PM Stratos Karafotis wrote:
>>> On 12/06/2014 12:15 πμ, Doug Smythies wrote:
>>>>
>>>>
>>>> -----Original Message-----
>>>> From: Stratos Karafotis [mailto:stratosk@semaphore.gr]
>>>> Sent: June-11-2014 13:20
>>>> To: Doug Smythies
>>>> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; rjw@rjwysocki.net; viresh.kumar@linaro.org; dirk.j.brandewie@intel.com
>>>> Subject: Re: [PATCH] cpufreq: intel_pstate: Fix rounding of core_pct
>>>>
>>>> On 2014.06.11 13:20 Stratos Karafotis wrote:
>>>>> On 11/06/2014 06:02 μμ, Doug Smythies wrote:
>>>>>>
>>>>>> On 2104.06.11 07:08 Stratos Karafotis wrote:
>>>>>>> On 11/06/2014 04:41 μμ, Doug Smythies wrote:
>>>>>>>
>>>>>>> No.
>>>>>>
>>>>>>> The intent was only ever to round properly the pseudo floating point result of the divide.
>>>>>>> It was much more important (ugh, well 4 times more) when FRACBITS was still 6, which also got changed to 8 in a recent patch.
>>>>>>>
>>>>>>
>>>>>> Are you sure?
>>>>>>
>>>>>> Yes.
>>>>>>
>>>>>>> This rounding was very recently added.
>>>>>>> As far as I can understand, I don't see the meaning of this rounding, as is.
>>>>>>> Even if FRAC_BITS was 6, I think it would have almost no improvement in
>>>>>>> calculations.
>>>>>>
>>>>>> Note: I had not seen this e-mail when I wrote a few minutes ago:
>>>>>>
>>>>>> You may be correct.
>>>>>> If Dirk agrees, I will re-analyse the entire driver for rounding effects soon.
>>>>>> When FRACBITS was 6 there were subtle cases where the driver would get stuck, and not make a final pstate change, with the default PID gains.
>>>>>> Other things have changed, and the analysis needs to be re-done.
>>>>>>
>>>>
>>>>> Could you please elaborate a little bit more what we need these 2 lines below?
>>>>>
> 
> Sorry for being MIA on this thread I have been up to my eyeballs.
> 
>>>>>         if ((rem << 1) >= int_tofp(sample->mperf))
>>>>>                 core_pct += 1;
> 
> The rounding should have been
>        core_pct += (1 << (FRAC_BITS-1));
> Since core_pct is is in fixeded point notation at this point. Adding .5 to
> core_pct to round up.
> 
> As Stratos pointed out the the current code only adds 1/256 to core_pct
> 
> Since core_pct_busy stays in fixed point through out the rest of the
> calculations ans we only do the rounding when the PID is returning an
> int I think we can safely remove these two lines.
> 

Please let me know if you want me to send a new patch for this (after the merge
window). Or will you or Doug handle this?


>> Depending on the original reason, it may or may not be.
>>
>> In theory, it may help reduce numerical drift resulting from rounding always in
>> one direction only, but I'm not really sure if that matters here.
>>
>> Doug seems to have carried out full analysis, though.
>>
>> Rafael
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 

Thank you all, for your comments!

Stratos
