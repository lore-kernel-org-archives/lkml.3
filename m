Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219Ab3FRQ7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:59:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50675 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932879Ab3FRQ7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:59:04 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: linux-next: origen build failed at drivers/pinctrl/pinctrl-exynos.c
Date: Tue, 18 Jun 2013 18:58:37 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Milosz Wasilewski <milosz.wasilewski@linaro.org>
References: <CA+G9fYu3_-RZxFyRENuqJvzsM=YToT7PG+5fUytMzhsFu3=z7g@mail.gmail.com>
In-Reply-To: <CA+G9fYu3_-RZxFyRENuqJvzsM=YToT7PG+5fUytMzhsFu3=z7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8bit
Message-Id: <201306181858.37999.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:uxwG8vFuSY8kOyAJqSJKJd6hTc5B5MZa0w+RdaRalqN
 HREGGw5XTa3A4Lwf2ksB/88P7DnrYKYVgZXVROwIcZWvvBufB6
 /BtTtBAgW7mz28MzD40HjvHpJchjM4RQFz7oOrn99FWrn1I4SI
 lZ3yVprgD0gP+sLo7Td842o6yc5KAKgrOV4JucjPsQOjkWtrJC
 bzmR0/GOTMfEbVWsJaJBFvwyNRrzCLS/yRFvtEH2A3Jwp1Sl4K
 fzPGVcKAmltJgpf/y36Q+QAMOvzLImEeNeg+ycj3Q4M4PfPZjA
 lFWBXtWp/2gLRzNmd0xMybLZw5Fn0kqw0gKXfRe6Q3NL4OzJVb
 jcGaG3qjBjcIgHsXBSp2UYklz8wj+0qqs9G3IL6dX
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 June 2013, Naresh Kamboju wrote:
> Hi,
> 
> linux-next branch failed to build origen build
> 
> defconfig: exynos_defconfig
> 
> full build log:
> ----------------
> https://ci.linaro.org/jenkins/job/linux-next/hwpack=origen,label=kernel_cloud/72/console
> 
> build error log:
> --------------------
> 05:02:12 /mnt/ci_build/workspace/linux-next/hwpack/origen/label/kernel_cloud/drivers/pinctrl/pinctrl-exynos.c:
> In function ‘exynos_wkup_irq_mask’:
> 05:02:12 /mnt/ci_build/workspace/linux-next/hwpack/origen/label/kernel_cloud/drivers/pinctrl/pinctrl-exynos.c:299:3:
> error: implicit declaration of function ‘exynos_wkup_irq_ack’
> [-Werror=implicit-function-declaration]
> 05:02:12    exynos_wkup_irq_ack(irqd);
> 05:02:12    ^
> 05:02:12 /mnt/ci_build/workspace/linux-next/hwpack/origen/label/kernel_cloud/drivers/pinctrl/pinctrl-exynos.c:
> At top level:
> 05:02:12 /mnt/ci_build/workspace/linux-next/hwpack/origen/label/kernel_cloud/drivers/pinctrl/pinctrl-exynos.c:310:13:
> warning: conflicting types for ‘exynos_wkup_irq_ack’ [enabled by
> default]
> 05:02:12  static void exynos_wkup_irq_ack(struct irq_data *irqd)
> 05:02:12              ^
> 05:02:12 /mnt/ci_build/workspace/linux-next/hwpack/origen/label/kernel_cloud/drivers/pinctrl/pinctrl-exynos.c:310:13:
> error: static declaration of ‘exynos_wkup_irq_ack’ follows non-static
> declaration
> 05:02:12 /mnt/ci_build/workspace/linux-next/hwpack/origen/label/kernel_cloud/drivers/pinctrl/pinctrl-exynos.c:299:3:
> note: previous implicit declaration of ‘exynos_wkup_irq_ack’ was here
> 05:02:12    exynos_wkup_irq_ack(irqd);
> 05:02:12    ^
> 05:02:12 cc1: some warnings being treated as errors
> 05:02:12 make[3]: *** [drivers/pinctrl/pinctrl-exynos.o] Error 1
> 05:02:12 make[2]: *** [drivers/pinctrl] Error 2
> 
> Best regards
> Naresh kamboju
> 

I got the same thing and used this patch to fix it up.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---

Linus, could you fold that into Doug's patch?

diff --git a/drivers/pinctrl/pinctrl-exynos.c b/drivers/pinctrl/pinctrl-exynos.c
index ef75321..00cd89a 100644
--- a/drivers/pinctrl/pinctrl-exynos.c
+++ b/drivers/pinctrl/pinctrl-exynos.c
@@ -279,6 +279,15 @@ err_domains:
 	return ret;
 }
 
+static void exynos_wkup_irq_ack(struct irq_data *irqd)
+{
+	struct samsung_pin_bank *b = irq_data_get_irq_chip_data(irqd);
+	struct samsung_pinctrl_drv_data *d = b->drvdata;
+	unsigned long pend = d->ctrl->weint_pend + b->eint_offset;
+
+	writel(1 << irqd->hwirq, d->virt_base + pend);
+}
+
 static void exynos_wkup_irq_mask(struct irq_data *irqd)
 {
 	struct samsung_pin_bank *b = irq_data_get_irq_chip_data(irqd);
@@ -296,15 +305,6 @@ static void exynos_wkup_irq_mask(struct irq_data *irqd)
 	spin_unlock_irqrestore(&b->slock, flags);
 }
 
-static void exynos_wkup_irq_ack(struct irq_data *irqd)
-{
-	struct samsung_pin_bank *b = irq_data_get_irq_chip_data(irqd);
-	struct samsung_pinctrl_drv_data *d = b->drvdata;
-	unsigned long pend = d->ctrl->weint_pend + b->eint_offset;
-
-	writel(1 << irqd->hwirq, d->virt_base + pend);
-}
-
 static void exynos_wkup_irq_unmask(struct irq_data *irqd)
 {
 	struct samsung_pin_bank *b = irq_data_get_irq_chip_data(irqd);

