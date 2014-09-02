Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbaIBVgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:36:31 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44878 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbaIBVg0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:36:26 -0400
Subject: Re: [PATCH v11 06/19] irqchip: gic: Provide support for interrupt	grouping
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
From: Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <20140902193355.GW30401@n2100.arm.linux.org.uk>
Date: Tue, 2 Sep 2014 22:36:20 +0100
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>,
        "kernel-team@android.com" <kernel-team@android.com>,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Dave P Martin <Dave.Martin@arm.com>,
        Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Sricharan R <r.sricharan@ti.com>, Marc Zyngier <Marc.Zyngier@arm.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <CBF5C246-DBB2-4FC3-A507-CA3E15013F7C@arm.com>
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org> <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org> <1409662853-29313-7-git-send-email-daniel.thompson@linaro.org> <20140902193355.GW30401@n2100.arm.linux.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 Sep 2014, at 20:33, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Tue, Sep 02, 2014 at 02:00:40PM +0100, Daniel Thompson wrote:
>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>> index 4b959e6..423707c 100644
>> --- a/drivers/irqchip/irq-gic.c
>> +++ b/drivers/irqchip/irq-gic.c
>> @@ -41,6 +41,9 @@
>> #include <linux/irqchip/arm-gic.h>
>> 
>> #include <asm/cputype.h>
>> +#ifdef CONFIG_FIQ
>> +#include <asm/fiq.h>
>> +#endif
> 
> Is there much advantage to this ifdef over providing a dummy asm/fiq.h
> in ARM64?

While it’s unlikely we’ll use FIQs on arm64 (they are generally
reserved for the secure world/firmware), I don’t mind an empty
asm/fiq.h file.

Catalin