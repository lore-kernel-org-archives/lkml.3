Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab3GWKw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 06:52:28 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:50496 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306Ab3GWKwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 06:52:23 -0400
Message-ID: <51EE6062.3080304@linaro.org>
Date: Tue, 23 Jul 2013 11:52:18 +0100
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: stefano.stabellini@eu.citrix.com, ian.campbell@citrix.com,
        patches@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Subject: Re: [PATCH v4] xen/arm: enable PV control for ARM
References: <1374529321-12955-1-git-send-email-julien.grall@linaro.org> <5228e08a-1cdb-4240-b10f-9ad690c94ac4@email.android.com>
In-Reply-To: <5228e08a-1cdb-4240-b10f-9ad690c94ac4@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 01:32 AM, Konrad Rzeszutek Wilk wrote:
> Julien Grall <julien.grall@linaro.org> wrote:
>> Enable power management from the toolstack for ARM guest.
>>
>> Signed-off-by: Julien Grall <julien.grall@linaro.org>
>>
>> ---
>>    Changes in v4:
>>        - Divide the patch in 2 distinct parts
>>    Changes in v3:
>>        - Fix condition to compile cpu_hotplug.o
>>    Changes in v2:
>>        - Don't compile xen/cpu_hotplug.o with ARM64
>> ---
>> drivers/xen/Makefile |    3 +--
>> 1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
>> index a609353..f185e8d 100644
>> --- a/drivers/xen/Makefile
>> +++ b/drivers/xen/Makefile
>> @@ -1,9 +1,8 @@
>> ifeq ($(filter y, $(CONFIG_ARM) $(CONFIG_ARM64)),)
>> -obj-y	+= manage.o
>> obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
>> endif
>> obj-$(CONFIG_X86)			+= fallback.o
>> -obj-y	+= grant-table.o features.o events.o balloon.o time.o
>> +obj-y	+= grant-table.o features.o events.o balloon.o time.o manage.o
>> obj-y	+= xenbus/
>>
>> nostackp := $(call cc-option, -fno-stack-protector)
> 
> The patch looks Ok but the description is off.  Power management is the term used for cpu freq,  C states and P states. While this patch touches none of that. 
> 

What about : "Enable lifecycle (reboot, shutdown) management from the
toolstack for ARM guest"?

-- 
Julien

