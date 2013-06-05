Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab3FEI7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 04:59:05 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:51611 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab3FEI66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 04:58:58 -0400
Message-ID: <51AEFDC4.8070801@linux.vnet.ibm.com>
Date: Wed, 05 Jun 2013 16:58:44 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, rjw@sisk.pl,
        Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] cpufreq: prevent 'policy->cpus' become offline in __gov_queue_work()
References: <51AEFBA1.302@linux.vnet.ibm.com> <CAKohpom571kXwLVPzmAb1n16EuHwyOaiM3khXkjQZQixGCpX8Q@mail.gmail.com>
In-Reply-To: <CAKohpom571kXwLVPzmAb1n16EuHwyOaiM3khXkjQZQixGCpX8Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060508-8256-0000-0000-000007CD4F8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Viresh

On 06/05/2013 04:53 PM, Viresh Kumar wrote:
[snip]
>> It was caused by the policy->cpus changed during the process of
>> __gov_queue_work(), in other word, cpu offline happened.
>>
>> This patch will use get/put_online_cpus() to prevent the offline
>> happen inside __gov_queue_work(), after applied the patch, the
>> warning is gone as Jiri tested:
>>
>>         Link: https://lkml.org/lkml/2013/6/5/88
>>
>> CC: "Rafael J. Wysocki" <rjw@sisk.pl>
>> CC: Viresh Kumar <viresh.kumar@linaro.org>
>> Reported-by: Borislav Petkov <bp@alien8.de>
>> Reported-by: Jiri Kosina <jkosina@suse.cz>
>> Tested-by: Jiri Kosina <jkosina@suse.cz>
>> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
>> ---
>>  drivers/cpufreq/cpufreq_governor.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Thanks for your ack :)

Regards,
Michael Wang

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

