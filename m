Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567Ab3GZSzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 14:55:38 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:36410 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759544Ab3GZSzf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 14:55:35 -0400
MIME-Version: 1.0
In-Reply-To: <51F2AB71.3070102@arm.com>
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
	<1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
	<1374492747-13879-8-git-send-email-Sudeep.KarkadaNagesha@arm.com>
	<51F2AB71.3070102@arm.com>
Date: Fri, 26 Jul 2013 13:55:34 -0500
Message-ID: <CAL_JsqK5i8fxskOtdqmPYL1pPicesAYHfW6+2NLR41t_fkf+6A@mail.gmail.com>
Subject: Re: [PATCH v3 07/16] of/device: add helper to get cpu device node
 from logical cpu index
From: Rob Herring <robherring2@gmail.com>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 12:01 PM, Sudeep KarkadaNagesha
<Sudeep.KarkadaNagesha@arm.com> wrote:
> Rob,
>
> On 22/07/13 12:32, Sudeep KarkadaNagesha wrote:
>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>
>> Multiple drivers need to get the cpu device node from the cpu logical
>> index and then access the of_node.
>>
>> This patch adds helper function to fetch the device node directly.
>>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>
> If you have no objections with this patch, can I add your ACK ?

Yes.

Acked-by: Rob Herring <rob.herring@calxeda.com>

>
> Regards,
> Sudeep
>
>> ---
>>  include/linux/of_device.h | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/include/linux/of_device.h b/include/linux/of_device.h
>> index 9d27475..82ce324 100644
>> --- a/include/linux/of_device.h
>> +++ b/include/linux/of_device.h
>> @@ -1,6 +1,7 @@
>>  #ifndef _LINUX_OF_DEVICE_H
>>  #define _LINUX_OF_DEVICE_H
>>
>> +#include <linux/cpu.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/of_platform.h> /* temporary until merge */
>>
>> @@ -43,6 +44,15 @@ static inline void of_device_node_put(struct device *dev)
>>       of_node_put(dev->of_node);
>>  }
>>
>> +static inline struct device_node *of_cpu_device_node_get(int cpu)
>> +{
>> +     struct device *cpu_dev;
>> +     cpu_dev = get_cpu_device(cpu);
>> +     if (!cpu_dev)
>> +             return NULL;
>> +     return of_node_get(cpu_dev->of_node);
>> +}
>> +
>>  #else /* CONFIG_OF */
>>
>>  static inline int of_driver_match_device(struct device *dev,
>> @@ -67,6 +77,11 @@ static inline const struct of_device_id *of_match_device(
>>  {
>>       return NULL;
>>  }
>> +
>> +static inline struct device_node *of_cpu_device_node_get(int cpu)
>> +{
>> +     return NULL;
>> +}
>>  #endif /* CONFIG_OF */
>>
>>  #endif /* _LINUX_OF_DEVICE_H */
>>
>
>
> -- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
