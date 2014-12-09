Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbaLIMiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 07:38:14 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59915 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257AbaLIMiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 07:38:13 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc86d0000066b7-98-5486ed332cbf
Content-transfer-encoding: 8BIT
Message-id: <1418128689.19339.3.camel@AMDC1943>
Subject: Re: [PATCH] arm64: psci: Fix build breakage without PM_SLEEP
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 09 Dec 2014 13:38:09 +0100
In-reply-to: <2290734.BRljGaICu4@wuerfel>
References: <1418125716-18528-1-git-send-email-k.kozlowski@samsung.com>
 <2290734.BRljGaICu4@wuerfel>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xK7rGb9tCDB7PY7b4O+kYu8X7ZT2M
	FpseX2O1uLxrDpvFm98v2C1efjzB4sDmsWbeGkaP378mMXpsXlLv8XmTXABLFJdNSmpOZllq
	kb5dAldGZ/NxloIFXBV9q+8wNjBu5ehi5OSQEDCRaNy4gBnCFpO4cG89WxcjF4eQwFJGie5F
	v9lAErwCghI/Jt9j6WLk4GAWkJc4cikbJMwsoC4xad4iZoj6z4wSB5pmsoPU8AroS8y6XwJS
	IyzgKnHi6yYmEJtNwFhi8/IlYCNFBBQlpr54BtbLLHCcUeLd4XXsIAkWAVWJA5/Ogc3hFNCU
	eNUONkdIIE3i/u6dTCBhCQFlicZ+twmMArOQHDcL4bhZSI5bwMi8ilE0tTS5oDgpPddIrzgx
	t7g0L10vOT93EyMkkL/uYFx6zOoQowAHoxIP7w7FthAh1sSy4srcQ4wSHMxKIrxTjgKFeFMS
	K6tSi/Lji0pzUosPMTJxcEo1MMoEu63uVRB1k288oaBf+jnwM5dP+NsPF6fNT5+mocdvNlnq
	8T0LlvyXB60LdiTMLVyfzN8Sf37xn2Ztn3v9c1x1phVlmpm/4Pptnj9rV56xWNWFOSp8ezPP
	ztDm+NZ0uW4S15M5ig82bvkseWD/+gXKkuesD06P+JzycJ/Zhnnd2/5sP/qep0qJpTgj0VCL
	uag4EQCPeds/QgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-12-09 at 13:29 +0100, Arnd Bergmann wrote:
> On Tuesday 09 December 2014 12:48:36 Krzysztof Kozlowski wrote:
> > Fix build failure of defconfig when PM_SLEEP is disabled (e.g. by
> > disabling SUSPEND) and CPU_IDLE enabled:
> > 
> > arch/arm64/kernel/psci.c:543:2: error: unknown field ‘cpu_suspend’ specified in initializer
> >   .cpu_suspend = cpu_psci_cpu_suspend,
> >   ^
> > arch/arm64/kernel/psci.c:543:2: warning: initialization from incompatible pointer type [enabled by default]
> > arch/arm64/kernel/psci.c:543:2: warning: (near initialization for ‘cpu_psci_ops.cpu_prepare’) [enabled by default]
> > make[1]: *** [arch/arm64/kernel/psci.o] Error 1
> > 
> > The cpu_operations.cpu_suspend field exists only if ARM64_CPU_SUSPEND is
> > defined, not CPU_IDLE.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > 
> 
> No objection to fixing this obvious build bug, but why do we even have
> an ARM64_CPU_SUSPEND option? On ARM32 we only have the respective option
> because we have a random collection of platform specific drivers that
> use the symbols, but that's not the case on ARM64.

I believe because of cpuidle. It's the same as on ARM32: the cpu_suspend
is used by both PM_SLEEP and CPU_IDLE.

Best regards,
Krzysztof



