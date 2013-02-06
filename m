Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab3BFCIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:08:51 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:64616 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab3BFCIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:08:49 -0500
Message-ID: <5111BB2E.2090505@gmail.com>
Date: Tue, 05 Feb 2013 18:08:46 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: dirk.brandewie@gmail.com, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH 5/7] cpufreq: balance out cpufreq_cpu_{get,put} for scaling
 drivers using setpolicy
References: <1360088646-19104-1-git-send-email-dirk.brandewie@gmail.com> <1360088646-19104-6-git-send-email-dirk.brandewie@gmail.com> <CAOh2x=kJPFyhkG3y_q=a5ciG1HRAn-JkoVYy9OZ9POA+-isbCQ@mail.gmail.com>
In-Reply-To: <CAOh2x=kJPFyhkG3y_q=a5ciG1HRAn-JkoVYy9OZ9POA+-isbCQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 05:58 PM, Viresh Kumar wrote:
> On Tue, Feb 5, 2013 at 11:54 PM,  <dirk.brandewie@gmail.com> wrote:
>> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>>
>> There is an additional reference added to the driver in
>> cpufreq_add_dev()  that is removed in__cpufreq_governor() if the
>> driver implements target().  Remove the last reference when the
>> driver implements setpolicy()
>>
>> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
>> ---
>>   drivers/cpufreq/cpufreq.c |    3 +++
>>   1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 622e282..d17477b 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -1049,6 +1049,9 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>>          if (cpufreq_driver->target)
>>                  __cpufreq_governor(data, CPUFREQ_GOV_STOP);
>>
>> +       if (cpufreq_driver->setpolicy)
>> +               cpufreq_cpu_put(data);
>
> I don't understand this patch at all.. I grepped both cpufreq_cpu_get() & put()
> in bleeding-edge and found everything to be correct.
>
> Can you please point me to the exact line numbers ?
>

Line 878 in cpufreq_add_dev()

--Dirk
