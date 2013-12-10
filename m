Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab3LJMn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 07:43:29 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:43867 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3LJMn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 07:43:27 -0500
MIME-Version: 1.0
In-Reply-To: <1386348542-9584-1-git-send-email-ynvich@gmail.com>
References: <1385879185-22455-3-git-send-email-ynvich@gmail.com>
	<1386348542-9584-1-git-send-email-ynvich@gmail.com>
Date: Tue, 10 Dec 2013 13:43:27 +0100
Message-ID: <CACRpkdYVsGSyMS6sSTqqJ4XrE3GqpWkJsY7GDazi5ix7xjKQ=Q@mail.gmail.com>
Subject: Re: [PATCH v2 02/11] arm: pxa27x: support ICP DAS LP-8x4x
From: Linus Walleij <linus.walleij@linaro.org>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Haojian Zhuang <haojian.zhuang@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 6, 2013 at 5:48 PM, Sergei Ianovich <ynvich@gmail.com> wrote:

> ICP DAS calls LP-8x4x 'programmable automation controller'. It is
> an industrial computer based on PXA270 SoC. They ship it with a 2.6.19
> kernel and proprietary kernel module and userspace library to access
> its industrial IO.

OK... so we only have device tree support for PXA3xx and noone is
working on PXA2xx. And now we pile up some more legacy code.
Such is life. But this:

> +static unsigned long lp8x4x_pin_config[] = {
> +       /* MMC */
> +       GPIO32_MMC_CLK,
> +       GPIO112_MMC_CMD,
> +       GPIO92_MMC_DAT_0,
> +       GPIO109_MMC_DAT_1,
> +       GPIO110_MMC_DAT_2,
> +       GPIO111_MMC_DAT_3,
> +
> +       /* USB Host Port 1 */
> +       GPIO88_USBH1_PWR,
> +       GPIO89_USBH1_PEN,
> +};

(...)
> +static void __init lp8x4x_init(void)
> +{
> +       pxa2xx_mfp_config(ARRAY_AND_SIZE(lp8x4x_pin_config));
(...)

Argh! Now you're adding another user for a legacy custom pin control
implementation. But if noone is going to modernize PXA2xx what
can we do :-/

Yours,
Linus Walleij
