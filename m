Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbaEBWqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 18:46:08 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:54486 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaEBWqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 18:46:07 -0400
MIME-Version: 1.0
In-Reply-To: <535B2B35.2090502@linux.intel.com>
References: <1397649959-29762-1-git-send-email-yao.jin@linux.intel.com>
	<CAN+gG=E7jbpQxxVuhmY5E2msgdMhLLjMd=Kxn9JO57eCN+5nCQ@mail.gmail.com>
	<5353A1F6.60602@linux.intel.com>
	<5353B8A4.1080900@linux.intel.com>
	<1398007690.2674.0.camel@adam.happyassassin.net>
	<5354BA59.2000008@linux.intel.com>
	<53551D0F.40906@linux.intel.com>
	<CAN+gG=H2X9cUWMixCQakiWz45AOpDAJyEULB0Z9d2jyxy9hUNA@mail.gmail.com>
	<1398230210.2704.8.camel@adam.happyassassin.net>
	<20140423083430.GV30677@intel.com>
	<20140423122344.GX30677@intel.com>
	<5359120E.2030007@linux.intel.com>
	<1398375234.2708.122.camel@adam.happyassassin.net>
	<CACRpkdasjd2HGR199_aqhemAnJD5z6--=Rr=tSoJX_hJ6-ukFA@mail.gmail.com>
	<1398438814.2708.141.camel@adam.happyassassin.net>
	<535B2250.2010509@linux.intel.com>
	<535B2B35.2090502@linux.intel.com>
Date: Fri, 2 May 2014 15:46:05 -0700
Message-ID: <CACRpkdboEToKZuq-YbEGrZmAS0d8H6u2R=s6ghpvYTtPMu04rA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl-baytrail: fix for irq descriptor conflict on ASUS T100TA
From: Linus Walleij <linus.walleij@linaro.org>
To: "Jin, Yao" <yao.jin@linux.intel.com>
Cc: Adam Williamson <awilliam@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Alan Cox <alan@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 8:42 PM, Jin, Yao <yao.jin@linux.intel.com> wrote:
> On 2014/4/26 11:04, Jin, Yao wrote:
(...)
> I think we still need a small modification on pinctrl-baytrail.c, that
> is moving gpiochip_add forward, otherwise the to_irq method is not set.
>
> diff --git a/drivers/pinctrl/pinctrl-baytrail.c
> b/drivers/pinctrl/pinctrl-baytrail.c
> index e599834..fdfb84b 100644
> --- a/drivers/pinctrl/pinctrl-baytrail.c
> +++ b/drivers/pinctrl/pinctrl-baytrail.c
> @@ -491,12 +491,6 @@ static int byt_gpio_probe(struct platform_device *pdev)
>         gc->can_sleep = false;
>         gc->dev = dev;
>
> -       ret = gpiochip_add(gc);
> -       if (ret) {
> -               dev_err(&pdev->dev, "failed adding byt-gpio chip\n");
> -               return ret;
> -       }
> -
>         /* set up interrupts  */
>         irq_rc = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>         if (irq_rc && irq_rc->start) {
> @@ -514,6 +508,12 @@ static int byt_gpio_probe(struct platform_device *pdev)
>                 irq_set_chained_handler(hwirq, byt_gpio_irq_handler);
>         }
>
> +       ret = gpiochip_add(gc);
> +       if (ret) {
> +               dev_err(&pdev->dev, "failed adding byt-gpio chip\n");
> +               return ret;
> +       }
> +

Now I feel I'm not following what combo of patches solves the
problem any more.

Do you mean you think that this patch combined with Thomas'
will solve the root cause?

Yours,
Linus Walleij
