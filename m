Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaDKHPD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 03:15:03 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:29773 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaDKHPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 03:15:01 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-fb-53479672f69d
Message-id: <5347966D.7040300@samsung.com>
Date: Fri, 11 Apr 2014 09:14:53 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Sangbeom Kim <sbkim73@samsung.com>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        "'Olof Johansson'" <olof@lixom.net>
Cc: linux-samsung-soc@vger.kernel.org, hyunhee.kim@samsung.com,
        sw0312.kim@samsung.com, linux-kernel@vger.kernel.org,
        yj44.cho@samsung.com, inki.dae@samsung.com, kyungmin.park@samsung.com,
        kgene.kim@samsung.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/27] ARM: EXYNOS: Support secondary CPU boot of Exynos4212
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
 <1397122658-16013-5-git-send-email-cw00.choi@samsung.com>
 <20140411014424.GA14934@quad.lixom.net> <53477A19.6070509@samsung.com>
 <006f01cf554b$dbc6a2d0$9353e870$@samsung.com>
In-reply-to: <006f01cf554b$dbc6a2d0$9353e870$@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t/xK7pF09yDDfY2qltc//Kc1eLzhxZ2
	i0n3J7BY9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaLU9c/s1lcXPGFyWLG5JdsFnt3TmZ0
	4PHYvKTe48qJJlaPvi2rGD0+b5ILYInisklJzcksSy3St0vgyji5fi5jwVXOir0nVjM2MF5j
	72Lk5JAQMJFovr6SFcIWk7hwbz1bFyMXh5DAUkaJG3fuMkI4nxklnq+9wQxSxSugJbF87h0m
	EJtFQFWi+ccPMJtNQE3ic8MjNhCbH6hmTdN1FhBbVCBC4l7jYVaIXkGJH5PvgcVFBIolVvR/
	AtvGLPCPUaKt5wojSEJYIEBiRudtqDN+MUqsfbEX7FZOASuJzrPXwCYxC1hLrJy0jRHClpfY
	vOYt8wRGwVlIlsxCUjYLSdkCRuZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCGR8mUH4+Jj
	VocYBTgYlXh4D1xyCxZiTSwrrsw9xCjBwawkwssx2T1YiDclsbIqtSg/vqg0J7X4ECMTB6dU
	AyMjn23T80n3jQrlzlZ1H++dvK+9v/reB5t2f72FsQtUdTeuKGBYfSJUstvz7m0NBSGrkqCl
	0g1/LLZJMOcuuZU+43IJG68Q18+JPW/TJhsvW7QwL/CwJw/TfRWRiedSbbRuS86JE+y8fM/c
	RLPif8/mKhf9KIWCqS/65iVYNf16Urch8kHldiWW4oxEQy3mouJEAF332VZyAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sangbeom,

On 11.04.2014 08:04, Sangbeom Kim wrote:
> Hi,
> On 04/11/2014 2:14 PM, Chanwoo Choi wrote:
>
>>>>   {
>>>> -	exynos_smc(SMC_CMD_CPU1BOOT, cpu, 0, 0);
>>>> +	if (soc_is_exynos4212())
>>>> +		exynos_smc(SMC_CMD_CPU1BOOT, 0, 0, 0);
>>>> +	else
>>>> +		exynos_smc(SMC_CMD_CPU1BOOT, cpu, 0, 0);
>>>
>>> 	/* <explain why you need this special case on 4212> */
>>
>> It's better to ask system lsi person. We don't know it well.
>> I got the guide about secondary boot from system lsi.
>> But, this patch was completely tested.
>
> exynos_smc(SMC_CMD_CPU1BOOT, ...) is cpu hotplug SMC interface.
> Exynos4212 is dual core processor.
> Exynos4212 only have to boot cpu1 on smp boot.
> So, Second parameter of exynos_smc is fixed by 0 which means cpu1.
> It don't need to boot another cpu (ex. cpu2, cpu3 for quad core processor).
> But In case of quad core processor (ex. Exynos4412),
> It need to boot another cpu and specify parameter of booting core.
> As I know, Exynos3250 is dual core.
> So It can be included 1st condition too.

Is the smc API defined to ignore the first argument of SMC_CMD_CPU1BOOT 
command for dual core systems or it is defined as should be zero?

Best regards,
Tomasz
