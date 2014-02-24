Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaBXKSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:18:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51226 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaBXKSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:18:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [GIT PULL] integrator base patches for v3.15
Date: Mon, 24 Feb 2014 11:17:48 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>
References: <CACRpkdYeaMqTNUTqBSg6vNa9=VucjpFFkx3diHJJNgZTg+iq1w@mail.gmail.com>
In-Reply-To: <CACRpkdYeaMqTNUTqBSg6vNa9=VucjpFFkx3diHJJNgZTg+iq1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402241117.48617.arnd@arndb.de>
X-Provags-ID: V02:K0:n6okZRscOFO+4XWPKii633fGqZk+NAG03kzwNlf2qSD
 FQ4jYqykFiS3IOnq/B3+xTSP8bquKzL7vnFDF0V0Gh8z3zqfbd
 C3jKLqdqqMwCscw9fzZmmjoKmwv0WAUy3L8yF7RuzQg8WSLyQa
 kQzJWx0rRO+li4xcEg1wEoO1yKf+c2dZUxha18gdu5Tq1YzsOe
 xEOcDow7x2dyh/UBP+iC+eK1WM708S/diy2+7gASj7NzKL9O5k
 1KG1HLNZof33mdsYCkozJ9GIuOP++dP4lovX82OGIDO0Wrkat1
 u3fOvbNDIvyB9jDk/irvyvXlgA35XCcmMJifAa99bkSMr/HkkZ
 3YZS8ENDvL7CLUlPYftw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 February 2014, Linus Walleij wrote:
>       irqchip: vic: update the base IRQ member correctly
>       irqchip: support cascaded VICs
>       ARM: integrator: register the IM-PD1 VIC

I got a randconfig build error for CONFIG_IMPD1=m. Ok to apply this
fix on top?

8<---

irqchip: VIC: export vic_init_cascaded

vic_init_cascaded is called by integrator impd1 code that can
be a loadable module, so the function has to be exported.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/irqchip/irq-vic.c b/drivers/irqchip/irq-vic.c
index 6002942..fd2c980 100644
--- a/drivers/irqchip/irq-vic.c
+++ b/drivers/irqchip/irq-vic.c
@@ -509,6 +509,7 @@ int __init vic_init_cascaded(void __iomem *base, unsigned int parent_irq,
 	/* Return out acquired base */
 	return v->irq;
 }
+EXPORT_SYMBOL_GPL(vic_init_cascaded);
 
 #ifdef CONFIG_OF
 int __init vic_of_init(struct device_node *node, struct device_node *parent)
