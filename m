Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaGHNyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:54:43 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45252 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaGHNyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:54:41 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-56-53bbf81eac9c
Message-id: <53BBF7FF.6050105@samsung.com>
Date: Tue, 08 Jul 2014 15:54:07 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>
Subject: Re: [PATCH 4/6] ARM: SAMSUNG: Restore Samsung PM Debug functionality
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
 <1403618235-19353-5-git-send-email-t.figa@samsung.com>
 <033901cf9ab3$44c469a0$ce4d3ce0$@samsung.com>
In-reply-to: <033901cf9ab3$44c469a0$ce4d3ce0$@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xq7pyP3YHG3TP0rXoXXCVzWLT42us
	Fpd3zWGzmHF+H5PF2iN32S1W7frD6MDmsXPWXXaPzUvqPfq2rGL0+LxJLoAlissmJTUnsyy1
	SN8ugStj+ct7zAUPeCv6ty1nbGCcyt3FyMkhIWAi8eP0FmYIW0ziwr31bF2MXBxCAksZJV59
	28II4XxmlPix4iYLSBWvgJbEi2Mb2EBsFgFViU/Xp4DF2QTUJD43PAKL8wPVrGm6DhTn4BAV
	iJB4fEEIolVQ4sfke2DlIgKeEh/On2AGmc8ssIBR4uytGewgCWEBX4lN7dugrljNKHF78lQm
	kASngJXEjKMnwGxmAR2J/a3T2CBseYnNa94yT2AUnIVkySwkZbOQlC1gZF7FKJpamlxQnJSe
	a6RXnJhbXJqXrpecn7uJERLqX3cwLj1mdYhRgINRiYfX4PzuYCHWxLLiytxDjBIczEoivF9O
	AYV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwsv2o/7DVu4Df63Dovc13U08u7XwXOE25c81RG9aq
	JYerzlhX/Ft0gWFqSJlun5NHsVsYS51lWoG1ZLwWL/f6f35PpCQqTNmPNq3WTnVMj/90curP
	QO/rwbvMoyfX3F6+aM+yB6t/Ss603bMkPPJHp8SL/A0nJx6t/eVX41UnMnOJr8y/b0J3lFiK
	MxINtZiLihMBehbZvlMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.07.2014 15:48, Kukjin Kim wrote:
> Tomasz Figa wrote:
>>
>> Due to recently merged patches and previous merge conflicts, the Samsung
>> PM Debug functionality no longer can be enabled. This patch fixes
>> incorrect dependency of SAMSUNG_PM_DEBUG on an integer symbol and adds
>> missing header inclusion.
>>
> Yes, you're right and it should be fixed...but I have comments...
> 
>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>> ---
>>  arch/arm/plat-samsung/Kconfig    | 8 +++++++-
>>  arch/arm/plat-samsung/pm-debug.c | 1 +
>>  2 files changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
>> index 301b892..483c959 100644
>> --- a/arch/arm/plat-samsung/Kconfig
>> +++ b/arch/arm/plat-samsung/Kconfig
>> @@ -412,9 +412,14 @@ config S5P_DEV_MFC
>>
>>  comment "Power management"
>>
>> +config HAVE_SAMSUNG_PM_DEBUG
>> +	bool
>> +	help
>> +	  Allow compilation of Samsung PM debugging code.
>> +
>>  config SAMSUNG_PM_DEBUG
>>  	bool "S3C2410 PM Suspend debug"
>> -	depends on PM && DEBUG_KERNEL && DEBUG_S3C_UART
>> +	depends on PM && DEBUG_KERNEL && HAVE_SAMSUNG_PM_DEBUG
>>  	help
>>  	  Say Y here if you want verbose debugging from the PM Suspend and
>>  	  Resume code. See <file:Documentation/arm/Samsung-S3C24XX/Suspend.txt>
>> @@ -484,6 +489,7 @@ config S5P_SLEEP
>>
>>  config DEBUG_S3C_UART
>>  	depends on PLAT_SAMSUNG
>> +	select HAVE_SAMSUNG_PM_DEBUG
> 
> Hmm...
> 
> The DEBUG_S3C_UART will be '0' when we select DEBUG_S3C_UART0, then the
> HAVE_SAMSUNG_PM_DEBUG will not be selected so SAMSUNG_PM_DEBUG is also...

Yes, that's right. I posted v2 after a while in another reply to this
thread.

Best regards,
Tomasz
