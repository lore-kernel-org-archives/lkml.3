Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934029AbaE3THI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 15:07:08 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:50978 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933084AbaE3THE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 15:07:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAC5m3Bz53QO5tTTvk7qnBQtwtjMvSgYZ15prAvnLjdogQRsfMQ@mail.gmail.com>
References: <1401074613-29227-1-git-send-email-t.dakhran@samsung.com>
	<7hr43f9mmn.fsf@paris.lan>
	<538737CA.4070709@suse.de>
	<53874862.5080809@samsung.com>
	<538775AB.3000604@suse.de>
	<CAC5m3Bz53QO5tTTvk7qnBQtwtjMvSgYZ15prAvnLjdogQRsfMQ@mail.gmail.com>
Date: Fri, 30 May 2014 23:07:01 +0400
Message-ID: <CANhyOUeq1MMHHn9t+Fy5gpkb43y_rS9F_OAoJ_KFyM1pL4ZJ4w@mail.gmail.com>
Subject: Re: [PATCH v11 0/3] Exynos 5410 support
From: Tarek Dakhran <t.dakhran@gmail.com>
To: Tushar Behera <trblinux@gmail.com>
Cc: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Kevin Hilman <khilman@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, devicetree@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, May 30, 2014 at 7:41 AM, Tushar Behera <trblinux@gmail.com> wrote:
> On Thu, May 29, 2014 at 11:30 PM, Andreas Färber <afaerber@suse.de> wrote:
>> Hi Tarek,
>>
>>
>> And I reproducibly get failures for CPUs 1-3, resulting in only one CPU
>> in /proc/cpuinfo (compared to 4 on downstream 3.14):
>>
>> [    0.045778] CPU: Testing write buffer coherency: ok
>> [    0.045968] /cpus/cpu@0 missing clock-frequency property
>> [    0.045993] /cpus/cpu@1 missing clock-frequency property
>> [    0.046016] /cpus/cpu@2 missing clock-frequency property
>> [    0.046040] /cpus/cpu@3 missing clock-frequency property
>> [    0.046059] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
>> [    0.046135] Setting up static identity map for 0x403a8920 - 0x403a8978
>> [    2.075052] CPU1: failed to come online
>> [    4.085095] CPU2: failed to come online
>> [    6.095142] CPU3: failed to come online
>> [    6.095237] Brought up 1 CPUs
>> [    6.095269] SMP: Total of 1 processors activated.
>> [    6.095303] CPU: All CPU(s) started in HYP mode.
>> [    6.095336] CPU: Virtualization extensions available.
>>
>> I also notice another apparent device tree issue:
>>
>> [    7.341814] of_get_named_gpiod_flags: can't parse gpios property of
>> node '/soc/mmc@12220000/slot@0[0]'
>> [    7.341850] of_get_named_gpiod_flags: can't parse gpios property of
>> node '/soc/mmc@12220000/slot@0[0]'
>>
>> Are any of those known issues and being worked on?
>> (The CPU failures affected 5420 Arndale Octa as well iirc.)
>>
>
> Can you check after applying following two patches for Arndale-Octa
> ([1],[2])? In other words, a patch similar to [2] might be required
> for this board too if it is booting under secure mode.

Firmware node already present into exynos5410-smdk5410.dts
So with only patch[1] 4xA15 cores will boot on ODROID-XU and SMDK5410.

>
> [1] http://www.spinics.net/lists/linux-samsung-soc/msg31776.html
>
> [PATCH v2 Resend 1/2] ARM: EXYNOS: Update secondary boot addr for secure mode
>
> [2] http://www.spinics.net/lists/linux-samsung-soc/msg31777.html
>
> [PATCH v2 Resend 2/2] ARM: dts: Add secure firmware support for Arndale-octa
>
>
> --
> Tushar Behera

Best regards,
    Tarek
