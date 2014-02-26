Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaBZQw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:52:57 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:52401 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaBZQwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:52:53 -0500
Message-ID: <530E1BE1.3030605@gmail.com>
Date: Wed, 26 Feb 2014 08:52:49 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>,
        Rashika Kheria <rashika.kheria@gmail.com>
CC: dirk.brandewie@gmail.com, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org
Subject: Re: [PATCH v2] drivers: cpufreq: Mark function as static in cpufreq.c
References: <linux-pm@vger.kernel.org20140226154625.GA10701@rashika> <1393432706-25708-1-git-send-email-rashika.kheria@gmail.com> <20140226164142.GA18079@thin>
In-Reply-To: <20140226164142.GA18079@thin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 08:41 AM, Josh Triplett wrote:
> On Wed, Feb 26, 2014 at 10:08:26PM +0530, Rashika Kheria wrote:
>> Mark function as static in cpufreq.c because it is not
>> used outside this file.
>>
>> This eliminates the following warning in cpufreq.c:
>> drivers/cpufreq/cpufreq.c:355:9: warning: no previous prototype for ‘show_boost’ [-Wmissing-prototypes]
>>
>> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
>
> I don't see any uses of this function in cpufreq.c; have uses appeared
> in a development branch?
>

This is a sysfs accessor used to control the boost feature it is not used by the
core but userspace.


>>   drivers/cpufreq/cpufreq.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 08ca8c9..54fd670 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -352,7 +352,7 @@ EXPORT_SYMBOL_GPL(cpufreq_notify_post_transition);
>>   /*********************************************************************
>>    *                          SYSFS INTERFACE                          *
>>    *********************************************************************/
>> -ssize_t show_boost(struct kobject *kobj,
>> +static ssize_t show_boost(struct kobject *kobj,
>>   				 struct attribute *attr, char *buf)
>>   {
>>   	return sprintf(buf, "%d\n", cpufreq_driver->boost_enabled);
>> --
>> 1.7.9.5
>>
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

