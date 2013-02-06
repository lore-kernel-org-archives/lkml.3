Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab3BFCGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:06:37 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:48481 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab3BFCGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:06:35 -0500
Message-ID: <5111BAA8.5050101@gmail.com>
Date: Tue, 05 Feb 2013 18:06:32 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: dirk.brandewie@gmail.com, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH 3/7] cpufreq: Only query drivers that implement cpufreq_driver.target()
References: <1360088646-19104-1-git-send-email-dirk.brandewie@gmail.com> <1360088646-19104-4-git-send-email-dirk.brandewie@gmail.com> <CAOh2x=nXQrgwm2Jw88GjQe-fjpJrK+cjTWd-vK377UEBeXGu3w@mail.gmail.com>
In-Reply-To: <CAOh2x=nXQrgwm2Jw88GjQe-fjpJrK+cjTWd-vK377UEBeXGu3w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 05:47 PM, Viresh Kumar wrote:
> On Tue, Feb 5, 2013 at 11:54 PM,  <dirk.brandewie@gmail.com> wrote:
>> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>>
>> Scaling drivers that implement cpufreq_driver.setpolicy() have
>> internal governors and may/will change the current operating frequency
>> very frequently this will cause cpufreq_out_of_sync() to be called
>> every time. Only call cpufreq_driver.get() for drivers that implement
>> cpufreq_driver.target()
>>
>> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
>> ---
>>   drivers/cpufreq/cpufreq.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 96bc302..d8daa4b 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -1787,7 +1787,7 @@ int cpufreq_update_policy(unsigned int cpu)
>>
>>          /* BIOS might change freq behind our back
>>            -> ask driver for current freq and notify governors about a change */
>> -       if (cpufreq_driver->get) {
>> +       if (cpufreq_driver->get && cpufreq_driver->target) {
>>                  policy.cur = cpufreq_driver->get(cpu);
>>                  if (!data->cur) {
>>                          pr_debug("Driver did not initialize current freq");
>
> I am really not liking copy-pasting my older comments here :(
>
> "This would mean policy->cur has a garbage value. I don't really know
> how would other routine behave on this. Would it make sense to make
> policy->cur zero atleast?
> "
>
The driver implements get() and will return a valid value but the other 
components that track the current frequency will not have been notified about 
any change so there is nothing to be out of sync with.  There is no reason to 
call cpufreq_out_of_sync() where the driver being used implements an internal
governor.

--Dirk

