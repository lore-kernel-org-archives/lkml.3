Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaFCKRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:17:40 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:33681 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaFCKRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:17:37 -0400
Message-ID: <538DA06A.2000103@linux.vnet.ibm.com>
Date: Tue, 03 Jun 2014 15:46:10 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: governor: Be friendly towards latency-sensitive
 bursty workloads
References: <20140526205337.1100.55275.stgit@srivatsabhat.in.ibm.com> <CAKohpokdnHag=79cXuwgNjX-k+JJU9GE3KUBhixcj3PZ6y78GQ@mail.gmail.com> <538D9631.9090500@linux.vnet.ibm.com> <CAKohpomynD9m-Cq4zsVSp3Xbw5Tx2cSe_Fcp5y0U8uAKSpQ1Tw@mail.gmail.com> <538D9DBD.2030605@linux.vnet.ibm.com> <CAKohpomS+ayvCavhXMHubcx2Pn6NcTDkV5iyUV+nz6_fKJetDg@mail.gmail.com> <538D9FDB.6070607@linux.vnet.ibm.com> <CAKohpomEX8+WN2pVdUZwFsSE4JgnFuUuHTu0WcDmLy71JxWGOA@mail.gmail.com>
In-Reply-To: <CAKohpomEX8+WN2pVdUZwFsSE4JgnFuUuHTu0WcDmLy71JxWGOA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060310-6102-0000-0000-000005B49E0F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 03:46 PM, Viresh Kumar wrote:
> On 3 June 2014 15:43, Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
>> index e1c6433..2597bbe 100644
>> --- a/drivers/cpufreq/cpufreq_governor.c
>> +++ b/drivers/cpufreq/cpufreq_governor.c
>> @@ -36,14 +36,29 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>>         struct od_dbs_tuners *od_tuners = dbs_data->tuners;
>>         struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
>>         struct cpufreq_policy *policy;
>> +       unsigned int sampling_rate;
>>         unsigned int max_load = 0;
>>         unsigned int ignore_nice;
>>         unsigned int j;
[...]
>> diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
>> index bfb9ae1..b56552b 100644
>> --- a/drivers/cpufreq/cpufreq_governor.h
>> +++ b/drivers/cpufreq/cpufreq_governor.h
>> @@ -134,6 +134,7 @@ struct cpu_dbs_common_info {
>>         u64 prev_cpu_idle;
>>         u64 prev_cpu_wall;
>>         u64 prev_cpu_nice;
>> +       unsigned int prev_load;
>>         struct cpufreq_policy *cur_policy;
>>         struct delayed_work work;
>>         /*
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 

Thanks a lot!
 
Regards,
Srivatsa S. Bhat

