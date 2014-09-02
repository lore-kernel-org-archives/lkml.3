Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbaIBP7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:59:25 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33372 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbaIBP7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:59:23 -0400
Message-ID: <5405E988.7050707@arm.com>
Date: Tue, 02 Sep 2014 17:00:08 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "naveenkrishna.ch@gmail.com" <naveenkrishna.ch@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] irqchip: exynos-combiner: Fix compilation error on ARM64
References: <1409671492-7725-1-git-send-email-ch.naveen@samsung.com>
In-Reply-To: <1409671492-7725-1-git-send-email-ch.naveen@samsung.com>
X-OriginalArrivalTime: 02 Sep 2014 15:59:18.0978 (UTC) FILETIME=[DA90CA20:01CFC6C6]
X-MC-Unique: 114090216592101301
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/09/14 16:24, Naveen Krishna Chatradhi wrote:
> The following compilation error occurs on 64-bit Exynos7 SoC:
>
> drivers/irqchip/exynos-combiner.c: In function ‘combiner_irq_domain_map’:
> drivers/irqchip/exynos-combiner.c:162:2: error: implicit declaration of function ‘set_irq_flags’ [-Werror=implicit-function-declaration]
>    set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
>    ^
> drivers/irqchip/exynos-combiner.c:162:21: error: ‘IRQF_VALID’ undeclared (first use in this function)
>    set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
>                       ^
> drivers/irqchip/exynos-combiner.c:162:21: note: each undeclared identifier is reported only once for each function it appears in
> drivers/irqchip/exynos-combiner.c:162:34: error: ‘IRQF_PROBE’ undeclared (first use in this function)
>    set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
>
> Fix the build error by including asm/hardirq.h.
>

You should avoid using asm headers whenever possible esp. in driver
code. linux/hardirq.h or much better linux/interrupt.h should fix this
error.

Regards,
Sudeep

