Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbaBZQqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:46:00 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:61052 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbaBZQp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:45:58 -0500
MIME-Version: 1.0
In-Reply-To: <20140226164142.GA18079@thin>
References: <1393432706-25708-1-git-send-email-rashika.kheria@gmail.com>
	<20140226164142.GA18079@thin>
Date: Wed, 26 Feb 2014 22:15:57 +0530
Message-ID: <CAMpEsFFjR2e_kDn9-QuKcS3RjsSmru9XGjXqXXdO7sYeWdh9dw@mail.gmail.com>
Subject: Re: [PATCH v2] drivers: cpufreq: Mark function as static in cpufreq.c
From: Rashika Kheria <rashika.kheria@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 10:11 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> On Wed, Feb 26, 2014 at 10:08:26PM +0530, Rashika Kheria wrote:
>> Mark function as static in cpufreq.c because it is not
>> used outside this file.
>>
>> This eliminates the following warning in cpufreq.c:
>> drivers/cpufreq/cpufreq.c:355:9: warning: no previous prototype for 'show_boost' [-Wmissing-prototypes]
>>
>> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
>
> I don't see any uses of this function in cpufreq.c; have uses appeared
> in a development branch?
>

It isn't used directly but through "define_one_global_rw(boost);".

The "define_one_global_rw()" is defined in include/linux/cpufreq.h. It
therefore, need the definition of the function.

>>  drivers/cpufreq/cpufreq.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 08ca8c9..54fd670 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -352,7 +352,7 @@ EXPORT_SYMBOL_GPL(cpufreq_notify_post_transition);
>>  /*********************************************************************
>>   *                          SYSFS INTERFACE                          *
>>   *********************************************************************/
>> -ssize_t show_boost(struct kobject *kobj,
>> +static ssize_t show_boost(struct kobject *kobj,
>>                                struct attribute *attr, char *buf)
>>  {
>>       return sprintf(buf, "%d\n", cpufreq_driver->boost_enabled);
>> --
>> 1.7.9.5
>>



-- 
Rashika Kheria
B.Tech CSE
IIIT Hyderabad
