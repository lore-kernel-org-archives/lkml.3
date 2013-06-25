Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab3FYOaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:30:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:64159 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab3FYOaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:30:04 -0400
Message-ID: <51C9A992.7010209@windriver.com>
Date: Tue, 25 Jun 2013 10:30:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 25/32] cpufreq: delete __cpuinit usage from all cpufreq
 files
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com> <1372102237-8757-26-git-send-email-paul.gortmaker@windriver.com> <CAKohponpsJBqbj_8u8MUiu7sCEpeg5bcztWJAZdn9uxL5taVZQ@mail.gmail.com>
In-Reply-To: <CAKohponpsJBqbj_8u8MUiu7sCEpeg5bcztWJAZdn9uxL5taVZQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-06-24 11:31 PM, Viresh Kumar wrote:
> On 25 June 2013 01:00, Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> 
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index f8c2860..5687d28 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -1900,8 +1900,8 @@ no_policy:
>>  }
>>  EXPORT_SYMBOL(cpufreq_update_policy);
>>
>> -static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
>> -                                       unsigned long action, void *hcpu)
>> +static int cpufreq_cpu_callback(struct notifier_block *nfb,
>> +                               unsigned long action, void *hcpu)
> 
> You were not required to change second line here and also don't
> change its indentation level. Check this everywhere.
> 

[...]

Since you've explicitly requested it, I've left all second lines
of args untouched in v2, now pushed to the patch queue:

http://git.kernel.org/cgit/linux/kernel/git/paulg/cpuinit-delete.git

> 
> Fix these and add my
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> Probably this can go through Rafael's pm tree. So, you can take it
> out of this series if you want.

I'd encourage people to not take the patches into their specific
trees unless they really feel a specific need to do so.  It will
keep the majority of them clumped together in git history that way.

Thanks,
Paul.
--

> 
