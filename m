Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3LJMya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 07:54:30 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:43028 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3LJMy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 07:54:27 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdYVsGSyMS6sSTqqJ4XrE3GqpWkJsY7GDazi5ix7xjKQ=Q@mail.gmail.com>
References: <1385879185-22455-3-git-send-email-ynvich@gmail.com>
 <1386348542-9584-1-git-send-email-ynvich@gmail.com> <CACRpkdYVsGSyMS6sSTqqJ4XrE3GqpWkJsY7GDazi5ix7xjKQ=Q@mail.gmail.com>
From: Vasily Khoruzhick <anarsoul@gmail.com>
Date: Tue, 10 Dec 2013 15:54:06 +0300
Message-ID: <CA+E=qVc4pNU_e5YjUZX7hG21FzS3omdd1XvgwFcHQy2z_Mnm8A@mail.gmail.com>
Subject: Re: [PATCH v2 02/11] arm: pxa27x: support ICP DAS LP-8x4x
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sergei Ianovich <ynvich@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 3:43 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Dec 6, 2013 at 5:48 PM, Sergei Ianovich <ynvich@gmail.com> wrote:
>
>> ICP DAS calls LP-8x4x 'programmable automation controller'. It is
>> an industrial computer based on PXA270 SoC. They ship it with a 2.6.19
>> kernel and proprietary kernel module and userspace library to access
>> its industrial IO.
>
> OK... so we only have device tree support for PXA3xx and noone is
> working on PXA2xx. And now we pile up some more legacy code.
> Such is life. But this:
>
>> +static unsigned long lp8x4x_pin_config[] = {
>> +       /* MMC */
>> +       GPIO32_MMC_CLK,
>> +       GPIO112_MMC_CMD,
>> +       GPIO92_MMC_DAT_0,
>> +       GPIO109_MMC_DAT_1,
>> +       GPIO110_MMC_DAT_2,
>> +       GPIO111_MMC_DAT_3,
>> +
>> +       /* USB Host Port 1 */
>> +       GPIO88_USBH1_PWR,
>> +       GPIO89_USBH1_PEN,
>> +};
>
> (...)
>> +static void __init lp8x4x_init(void)
>> +{
>> +       pxa2xx_mfp_config(ARRAY_AND_SIZE(lp8x4x_pin_config));
> (...)
>
> Argh! Now you're adding another user for a legacy custom pin control
> implementation. But if noone is going to modernize PXA2xx what
> can we do :-/

I tried a ~year ago, but it's not so trivial. PXA2xx has no separate
pin control module, it's
highly integrated into GPIO controller. I've asked the maillist what
should I do for that case, but AFAIR no one answered.

Regards
Vasily

> Yours,
> Linus Walleij
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
