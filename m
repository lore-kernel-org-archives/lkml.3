Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbaDGIAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 04:00:51 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:64850 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaDGIAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 04:00:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAOLUe6aspffO1PUjKWW7ejpbxnYtb+RKRQrK=y30kuF7KXUUhA@mail.gmail.com>
References: <1393842463-5206-1-git-send-email-thloh@altera.com>
	<20140307151455.GI18529@joshc.qualcomm.com>
	<CAOLUe6aspffO1PUjKWW7ejpbxnYtb+RKRQrK=y30kuF7KXUUhA@mail.gmail.com>
Date: Mon, 7 Apr 2014 16:00:43 +0800
X-Google-Sender-Auth: MyHAZmNDagHeN1_caQ1Jh5yRUnY
Message-ID: <CAOLUe6aPWmkJJSiBLL8tmw2MNfpaeLpSp3CSwP1u7q+qXxCh9Q@mail.gmail.com>
Subject: Re: [PATCH V7 1/1] drivers/gpio: Altera soft IP GPIO driver and
 devicetree binding
From: Tien Hock Loh <thloh@altera.com>
To: Tien Hock Loh <thloh@altera.com>
Cc: Josh Cartwright <joshc@codeaurora.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, Mark Rutland <mark.rutland@arm.com>,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        dinguyen@altera.com, "lftan@altera.com" <lftan@altera.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 6:09 PM, Tien Hock Loh <thloh@altera.com> wrote:
> On Fri, Mar 7, 2014 at 11:14 PM, Josh Cartwright <joshc@codeaurora.org> wrote:
>> On Mon, Mar 03, 2014 at 06:27:43PM +0800, thloh@altera.com wrote:
>>> From: Tien Hock Loh <thloh@altera.com>
>>>
>>> Add driver support for Altera GPIO soft IP, including interrupts and I/O.
>>> Tested on Altera CV SoC board using dipsw and LED using LED framework.
>>>
>>> Signed-off-by: Tien Hock Loh <thloh@altera.com>
>>> ---
>>
>>> +             return -ENOMEM;
>>> +     }
>>> +     altera_gc->domain = 0;
>>> +
>>> +     spin_lock_init(&altera_gc->gpio_lock);
>>> +
>>> +     id = pdev->id;
>>> +
>>> +     if (of_property_read_u32(node, "altr,gpio-bank-width", &reg))
>>> +             /*By default assume full GPIO controller*/
>>> +             altera_gc->mmchip.gc.ngpio = 32;
>>> +     else
>>> +             altera_gc->mmchip.gc.ngpio = reg;
>>> +
>>> +     if (altera_gc->mmchip.gc.ngpio > 32) {
>>> +             dev_warn(&pdev->dev,
>>> +                     "ngpio is greater than 32, defaulting to 32\n");
>>> +             altera_gc->mmchip.gc.ngpio = 32;
>>> +     }
>>> +
>>> +     altera_gc->mmchip.gc.direction_input    = altera_gpio_direction_input;
>>> +     altera_gc->mmchip.gc.direction_output   = altera_gpio_direction_output;
>>> +     altera_gc->mmchip.gc.get                = altera_gpio_get;
>>> +     altera_gc->mmchip.gc.set                = altera_gpio_set;
>>> +     altera_gc->mmchip.gc.to_irq             = altera_gpio_to_irq;
>>> +     altera_gc->mmchip.gc.owner              = THIS_MODULE;
>>> +
>>> +     ret = of_mm_gpiochip_add(node, &altera_gc->mmchip);
>>> +     if (ret) {
>>> +             dev_err(&pdev->dev, "Failed adding memory mapped gpiochip\n");
>>> +             return ret;
>>> +     }
>>> +
>>> +     platform_set_drvdata(pdev, altera_gc);
>>> +
>>> +     altera_gc->mapped_irq = irq_of_parse_and_map(node, 0);
>>>
>>
>> platform_get_irq(pdev, 0);
>>
> OK.
>

platform_get_irq doesn't create the irq mapping which is needed by the
driver. Since this driver is targeted at using of, should I be using
irq_of_parse_and_map or should I still redo the codes with
platform_get_irq and irq_create_mapping? I think the latter would be
introducing code redundancy. Please advice.

Thanks.
