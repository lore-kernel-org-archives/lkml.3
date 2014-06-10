Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaFJRKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:10:54 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:48781 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaFJRKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:10:53 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-f7-53973c1a30e9
Message-id: <53973C0B.2000903@samsung.com>
Date: Tue, 10 Jun 2014 19:10:35 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, chow.kim@samsung.com,
        yg1004.jang@samsung.com, vikas.sajjan@samsung.com
Subject: Re: [PATCH v4 06/11] ARM: EXYNOS: Add support for mapping PMU base
 address via DT
References: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
 <1399704998-13321-7-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1399704998-13321-7-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t/xy7pSNtODDS79ZLFYNukum0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCxuX+a1WLT1C7vFzWfbmSx2tKxmceD0aGnuYfPYvKTeo2/LKkaP
	z5vkAliiuGxSUnMyy1KL9O0SuDLe/7nPVnCMo2LC3pNsDYzf2LoYOTkkBEwkLix/wQhhi0lc
	uLceKM7FISSwlFHiz65VLBDOZ0aJ07O2glXxCmhJzJl7nBXEZhFQlZg34z8LiM0moCbxueER
	2FR+oJo1TdeB4hwcogIREo8vCEG0Ckr8mHwPbKaIwBRGiYs9y8BmMgvUSCzo3Aw2R1ggRuLg
	/n+sEIvbGSUONF0DW8Yp4Cnx7+YTZogGHYn9rdPYIGx5ic1r3jJPYBSchWTJLCRls5CULWBk
	XsUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREgdfdjAuPmZ1iFGAg1GJh5dDZ1qwEGtiWXFl
	7iFGCQ5mJRHetr9AId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYyVkXf3vHk27/Rpr2dKUjtTHG/G
	NRV+kv2tf0pvYaPLw/OFOZO9jS9sPXP7tleJjPgW97nHUx3rnmSUPbwUcDJwM4fJnGWaU9ey
	zOfTf33r4WPWowmT+XiXqp5pmnE8puPv/LUq255xcgqI72TjKesK2KTuv7v53JWSg9oLOAL/
	2lR8vHIspT5DiaU4I9FQi7moOBEA7mIAbWECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10.05.2014 08:56, Pankaj Dubey wrote:
> From: Young-Gun Jang <yg1004.jang@samsung.com>
> 
> Add support for mapping Samsung Power Management Unit (PMU)
> base address from device tree. This patch also adds helper
> function as "get_exynos_pmuregmap". This function can be used
> by other machine files such as "pm.c", "hotplug.c" for accessing
> PMU regmap handle.
> 

I don't think there is a need to use regmap to provide access to PMU to
such low level code such as pm.c or hotplug.c. Moreover, I believe that
it might be undesirable in some cases, e.g. very low level code running
at early resume or late suspend.

IMHO, based on what we now have for SYSRAM, you could simply map PMU
from device tree one time, before SMP init, and keep the address in some
globally accessible variable, like those for SYSRAM we have right now
(sysram_base_addr, sysram_ns_base_addr -> pmu_base_addr).

Then, registration of the normal syscon would happen through standard
platform driver mechanisms and no special early handling would be necessary.

Best regards,
Tomasz
