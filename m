Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab3B1F7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 00:59:55 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62821 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3B1F7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 00:59:53 -0500
X-AuditID: 9c930179-b7b61ae000004061-fa-512ef2573bfc
From: Namhyung Kim <namhyung@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH -next 3/3] cpufreq: conservative: Fix relation when decreasing frequency
References: <1362029882-28993-1-git-send-email-namhyung@kernel.org>
	<1362029882-28993-3-git-send-email-namhyung@kernel.org>
	<CAKohpomiG1G2NUScDpzbqTBJAOfNr3PcWe55PoGK8bvY4tCdMw@mail.gmail.com>
Date: Thu, 28 Feb 2013 14:59:50 +0900
In-Reply-To: <CAKohpomiG1G2NUScDpzbqTBJAOfNr3PcWe55PoGK8bvY4tCdMw@mail.gmail.com>
	(Viresh Kumar's message of "Thu, 28 Feb 2013 11:17:03 +0530")
Message-ID: <87lia9rnah.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Thu, 28 Feb 2013 11:17:03 +0530, Viresh Kumar wrote:
> On 28 February 2013 11:08, Namhyung Kim <namhyung@kernel.org> wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>>
>> The relation should be CPUFREQ_RELATION_L to find optimal frequency
>> when decreasing.
>>
>> Cc: Viresh Kumar <viresh.kumar@linaro.org>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  drivers/cpufreq/cpufreq_conservative.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
>> index dd2fd9094819..0d582811d66c 100644
>> --- a/drivers/cpufreq/cpufreq_conservative.c
>> +++ b/drivers/cpufreq/cpufreq_conservative.c
>> @@ -106,7 +106,7 @@ static void cs_check_cpu(int cpu, unsigned int load)
>>                         dbs_info->requested_freq = policy->min;
>>
>>                 __cpufreq_driver_target(policy, dbs_info->requested_freq,
>> -                               CPUFREQ_RELATION_H);
>> +                               CPUFREQ_RELATION_L);
>
> Other two patches are fine but really not sure about this one.
> When decreasing freq, what do we want:
> - lowest frequency at or above target, i.e. >= requested_freq
> - highest frequency below or at target, i.e. <= requested_freq
>
> I thought second option was better and so CPUFREQ_RELATION_H
> suits more. What made you do this change?

When decreasing, we were on a higher frequency than target so selecting
above or equal to the target frequency seems to be "conservative".  And
AFAICS the ondemance governor also uses RELATION_L for decreasing.

Thanks,
Namhyung
