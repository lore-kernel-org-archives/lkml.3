Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab3BFCQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:16:01 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:41160 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab3BFCP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:15:58 -0500
Message-ID: <5111BCDA.1060507@gmail.com>
Date: Tue, 05 Feb 2013 18:15:54 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: dirk.brandewie@gmail.com, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH 2/7] cpufreq: Retrieve current frequency from scaling
 drivers with internal governors
References: <1360088646-19104-1-git-send-email-dirk.brandewie@gmail.com> <1360088646-19104-3-git-send-email-dirk.brandewie@gmail.com> <CAOh2x=nYOf32jKqwwikgBS2oRHwmhZdVug=pLzQZWp-N2S9CGw@mail.gmail.com>
In-Reply-To: <CAOh2x=nYOf32jKqwwikgBS2oRHwmhZdVug=pLzQZWp-N2S9CGw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 05:45 PM, Viresh Kumar wrote:
> On Tue, Feb 5, 2013 at 11:54 PM,  <dirk.brandewie@gmail.com> wrote:
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 2817c3c..96bc302 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -1181,6 +1181,13 @@ unsigned int cpufreq_quick_get(unsigned int cpu)
>>          struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
>>          unsigned int ret_freq = 0;
>>
>> +       if (cpufreq_driver && cpufreq_driver->setpolicy &&
>> +               cpufreq_driver->get) {
>> +               ret_freq = cpufreq_driver->get(cpu);
>> +               cpufreq_cpu_put(policy);
>> +               return ret_freq;
>> +       }
>> +
>
How about this?

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2817c3c..9c0eac4 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1182,7 +1182,12 @@ unsigned int cpufreq_quick_get(unsigned int cpu)
  	unsigned int ret_freq = 0;

  	if (policy) {
-		ret_freq = policy->cur;
+		if (cpufreq_driver && cpufreq_driver->setpolicy &&
+			cpufreq_driver->get) {
+			ret_freq = cpufreq_driver->get(cpu);
+		} else {
+			ret_freq = policy->cur;
+		}
  		cpufreq_cpu_put(policy);
  	}


