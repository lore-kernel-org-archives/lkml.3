Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596AbaCQPih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 11:38:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:18445 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604AbaCQPie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 11:38:34 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-8d-532716f7ed31
Date: Mon, 17 Mar 2014 16:38:24 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lukasz Majewski <l.majewski@samsung.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Thomas Abraham <ta.omasab@gmail.com>,
        thomas.ab@samsung.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [RFC v3 0/5] cpufreq:LAB: Support for LAB governor.
Message-id: <20140317163824.3c5480b3@amdc2363>
In-reply-to: <1393928852-22725-1-git-send-email-l.majewski@samsung.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
 <1393928852-22725-1-git-send-email-l.majewski@samsung.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t9jQd3vYurBBv1PrC02zljPavG06Qe7
	RefZJ8wWbx5xW7x5uJnRYtPja6wWl3fNYbP43HuE0WLG+X1MFrcbV7BZnDl9idVi/YzXLBab
	J2xks+hYxmix8auHA7/Hzll32T3uXNvD5rF5Sb3HumlvmT22XG1n8ejbsorR4/MmuQD2KC6b
	lNSczLLUIn27BK6MS3tqCn6IV3xbs5itgfGWUBcjJ4eEgInEvKX32SBsMYkL99YD2VwcQgLT
	GSWWT97NCuH8YpTobLrKBFLFIqAq8e/JARYQm01AT+Lz3adgcRGBUImjU7+ygzQwC5xhkZhz
	dAJYkbCAg8SJXU3MIDYvUEProgOMIDangLvE8RXNzBAbWhklLu+8ATaJX0BSov3fD2aIm+wk
	zn3awA7RLCjxY/I9sKHMAloSm7c1sULY8hKb17xlnsAoOAtJ2SwkZbOQlC1gZF7FKJpakFxQ
	nJSea6hXnJhbXJqXrpecn7uJERxdz6R2MK5ssDjEKMDBqMTD+4JNPViINbGsuDL3EKMEB7OS
	CO8lXqAQb0piZVVqUX58UWlOavEhRmkOFiVx3gOt1oFCAumJJanZqakFqUUwWSYOTqkGxglK
	U6d8avv3vXtyhYbewfqHWd/jc3c/NHdlvjBN4a9xQ5umO7tx5ly5JXdY1q+ZXuquHcDYvLbJ
	cs3lVY1t3FyVFnOuvz80yTSwO2C2f5+pwLwUiwDW/fJvhO+d/fSr5IGm+Fq3p00Hf6+6sTtF
	WNL01OU2udgzPVMa+bdUe6ytVO7Pu1Aer8RSnJFoqMVcVJwIADgeVBCqAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

> Despite this patch set is working and applicable on top of 3.14-rc5, 
> please regard it solely as a pure RFC.
> 
> This patch provides support for LAB governor build on top of ondemand.
> Previous version of LAB can be found here:
> http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq
> 
> LAB short reminder:
> 
> LAB uses information about how many cores are in "idle" state (the
> core idleness is represented as the value between 0 and 100) and the
> overall load of the system (from 0 to 100) to decide about frequency
> to be set. It is extremely useful with SoCs like Exynos4412, which
> can set only one frequency for all cores.
> 
> Important design decisions:
> 
> - Reuse well established ondemand governor's internal code. To do this
>   I had to expose some previously static internal ondemand code. 
>   This allowed smaller LAB code when compared to previous version.
> 	
> - LAB works on top of ondemand, which means that one via device tree
>   attributes can specify if and when e.g. BOOST shall be enabled or
> if any particular frequency shall be imposed. For situation NOT
> important from the power consumption reduction viewpoint the ondemand
> is used to set proper frequency.
> 
> - It is only possible to either compile in or not the LAB into the
> kernel. There is no "M" option for Kconfig. It is done on purpose,
> since ondemand itself can be also compiled as a module and then it
> would be possible to remove ondemand when LAB is working on top of it.
> 
> - The LAB operation is specified (and thereof extendable) via device
> tree lab-ctrl-freq attribute defined at /cpus/cpu0.
> 
> 
> Problems:
> - How the governor will work for big.LITTLE systems (especially
> Global Task Scheduling).
> - Will there be agreement to expose internal ondemand code to be
> reused for more specialized governors.
> 
> Test HW:
> 	Exynos4412 - Trats2 board.
> Above patches were posted on top of Linux 3.14-rc5
> (SHA1: 3f9590c281c66162bf8ae9b7b2d987f0a89043c6)
> 

Any comments about those patches?

> Lukasz Majewski (5):
>   cpufreq:LAB:ondemand Adjust ondemand to be able to reuse its methods
>   cpufreq:LAB:cpufreq_governor Adjust cpufreq_governor.[h|c] to
> support LAB
>   cpufreq:LAB:lab Add LAB governor code
>   cpufreq:LAB:Kconfig Add LAB definitions to Kconfig
>   cpufreq:LAB:dts:trats2: Add DTS nodes for LAB governor
> 
>  arch/arm/boot/dts/exynos4412-trats2.dts |   29 ++
>  drivers/cpufreq/Kconfig                 |   28 ++
>  drivers/cpufreq/Makefile                |    1 +
>  drivers/cpufreq/cpufreq_governor.c      |    7 +
>  drivers/cpufreq/cpufreq_governor.h      |   12 +
>  drivers/cpufreq/cpufreq_lab.c           |  457
> +++++++++++++++++++++++++++++++
> drivers/cpufreq/cpufreq_ondemand.c      |   24 +- 7 files changed,
> 550 insertions(+), 8 deletions(-) create mode 100644
> drivers/cpufreq/cpufreq_lab.c
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
