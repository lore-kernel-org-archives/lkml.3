Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaHTL7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:59:10 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:53595 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbaHTL7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:59:07 -0400
Date: Wed, 20 Aug 2014 12:59:01 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Daniel Drake <drake@endlessm.com>, Tobias Jakobi <Liquid.Acid@gmx.net>,
        Olof Johansson <olof@lixom.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH] mfd: max77686: make interrupts support optional
Message-ID: <20140820115901.GJ4266@lee--X1>
References: <1408516009-22106-1-git-send-email-m.szyprowski@samsung.com>
 <20140820081909.GH4266@lee--X1>
 <53F45C73.1030304@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F45C73.1030304@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2014, Javier Martinez Canillas wrote:

> Hello Lee, Marek,
> 
> On 08/20/2014 10:19 AM, Lee Jones wrote:
> > On Wed, 20 Aug 2014, Marek Szyprowski wrote:
> > 
> >> Commit 6f1c1e71d93 ("mfd: max77686: Convert to use regmap_irq") broke
> >> support for boards, which provide no irq for MAX 77686 PMIC. In such
> >> case, not all functions of PMIC are available, but the driver still
> >> should at least handle voltage regulators instead of failing to init.
> >> This patch restores previous behavior.
> >> 
> >> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> >> ---
> >> Hello,
> >> 
> >> This patch fixes booting issues with recently merged support for
> >> Exynos4412 based Odroid X2/U3 boards. See
> >> http://www.spinics.net/lists/linux-samsung-soc/msg35773.html
> >> thread for more details.
> >> 
> >> Best regards
> >> Marek Szyprowski
> >> Samsung R&D Institute Poland
> 
> I already gave my opinion about this patch on thread:
> 
> "[PATCH v2 0/4] Add Exynos4412 based Odroid X2 and U2/U3/U3+ support"
> 
> where the issue was reported by Olof but I'll add it here as well for
> completeness since I don't know if the same people are cc'ed on both threads.
> 
> Bartlomiej Zolnierkiewicz posted a similar patch [0] before but as I said
> on that thread, I'm not sure if is correct to make that DT property
> optional. Or rather, if we need to make it optional then we should also
> change the Documentation/devicetree/bindings/mfd/max77686.txt that list
> "interrupts" DT property as required.
> 
> It's true that before converting the max77686 to use the regmap irq API,
> the driver was loose on that regard but max77686_irq_init() in
> max77686-irq.c was returning -ENODEV when the IRQ was not provided and
> that error code was not checked in max77686_i2c_probe() (which was a bug
> IMHO).
> 
> More importantly I wonder if a design where a IRQ line is not connected to
> the max77686 PMIC makes even sense. If such a design is possible then the
> "interrupt" property should be made optional but if not then I think that
> the driver should fail to probe in that case. Yes, it is a regression but
> the Odroid DTS was not following the DT binding and was just lucky that
> the driver was not checking the required DT properties.
> 
> Daniel Drake posted the correct fix for the Odroid DTS [1]. So I tend to
> say that Daniel's fix should be added as a -rc fix and we should keep both
> the max77686 driver and its DT binding as it is now but as I said, if from
> a hardware point of view makes sense to leave that line unconnected then I
> don't oppose to this change.

I wasn't aware that this had already been discussed.

FWIW, I agree with everything you just said, so unless someone insists
that the device can be functional without an IRQ line, I'm going to
shelve (not accept) this patch.

> [0]: https://lkml.org/lkml/2014/8/7/374
> [1]:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/272869.html

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
