Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbaLIMaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 07:30:25 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:62254 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680AbaLIMaY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 07:30:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: psci: Fix build breakage without PM_SLEEP
Date: Tue, 09 Dec 2014 13:29:29 +0100
Message-ID: <2290734.BRljGaICu4@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418125716-18528-1-git-send-email-k.kozlowski@samsung.com>
References: <1418125716-18528-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V03:K0:YPR3ryVFFzO0Xkm3EcyZZ8XkiTTGpwQI+kT9Zynmi6lvsC0NoSj
 ynnWGXY9mam1hOMmSmZzeW8rnOcFONx1B2jnF9CIN18XKbm6BUqkkv7IdQ5EIT7QVQNTeT+
 SCAnDF3ZooLtt2KXSqywx7EA9lrkIGVFLG3DPf1INa/hqibCzqmfjRsU8pEIGIkXhv/y6lq
 fJN2QadwD5HAy3HjDB1RA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 December 2014 12:48:36 Krzysztof Kozlowski wrote:
> Fix build failure of defconfig when PM_SLEEP is disabled (e.g. by
> disabling SUSPEND) and CPU_IDLE enabled:
> 
> arch/arm64/kernel/psci.c:543:2: error: unknown field ‘cpu_suspend’ specified in initializer
>   .cpu_suspend = cpu_psci_cpu_suspend,
>   ^
> arch/arm64/kernel/psci.c:543:2: warning: initialization from incompatible pointer type [enabled by default]
> arch/arm64/kernel/psci.c:543:2: warning: (near initialization for ‘cpu_psci_ops.cpu_prepare’) [enabled by default]
> make[1]: *** [arch/arm64/kernel/psci.o] Error 1
> 
> The cpu_operations.cpu_suspend field exists only if ARM64_CPU_SUSPEND is
> defined, not CPU_IDLE.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 

No objection to fixing this obvious build bug, but why do we even have
an ARM64_CPU_SUSPEND option? On ARM32 we only have the respective option
because we have a random collection of platform specific drivers that
use the symbols, but that's not the case on ARM64.


	Arnd
