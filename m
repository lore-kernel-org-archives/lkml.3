Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab3AXMT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 07:19:59 -0500
Received: from antcom.de ([188.40.178.216]:40930 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916Ab3AXMTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 07:19:54 -0500
Message-ID: <510126E7.5090802@antcom.de>
Date: Thu, 24 Jan 2013 13:19:51 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.11) Gecko/20121123 Icedove/10.0.11
MIME-Version: 1.0
To: Stijn Devriendt <highguy@gmail.com>
CC: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de, wg@grandegger.com, mark.rutland@arm.com,
        nicolas.ferre@atmel.com
Subject: Re: [PATCH 6/6 v14] gpio: Add block gpio to several gpio drivers
References: <1358856404-8975-1-git-send-email-stigge@antcom.de> <1358856404-8975-7-git-send-email-stigge@antcom.de> <CAOY=C6H5xETt5UNXUfRkGW9q+bj0y2R3sXNvW87XXvQcYoL_-g@mail.gmail.com>
In-Reply-To: <CAOY=C6H5xETt5UNXUfRkGW9q+bj0y2R3sXNvW87XXvQcYoL_-g@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 01:02 PM, Stijn Devriendt wrote:
>> +static void lpc32xx_gpio_set_block_p3(struct gpio_chip *chip,
>> +                                     unsigned long mask,
>> +                                     unsigned long values)
>> +{
>> +       struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
>> +       u32 set_bits = values & mask;
>> +       u32 clr_bits = ~values & mask;
>> +
>> +       /* States of GPIO 0-5 start at bit 25 */
>> +       set_bits <<= 25;
>> +       clr_bits <<= 25;
>> +
>> +       /* Note: On LPC32xx, GPOs can only be set at once or cleared at once,
>> +        *       but not set and cleared at once
>> +        */
>> +       if (set_bits)
>> +               __raw_writel(set_bits, group->gpio_grp->outp_set);
>> +       if (clr_bits)
>> +               __raw_writel(clr_bits, group->gpio_grp->outp_clr);
>> +}
>> +
> 
> In my patch, I go out of the way of this kind of thing for a simple reason:
> You may generate incorrect timing by doing this.

You are right, certain things like synchronous on+off is not really
possible.

However, the above at least supports switching on simulaneously, and
switching off simultaneously, which is an improvement in certain cases
(and this certain hardware part doesn't support more). Maybe this
certain driver behaviour can be documented even better than just in the
driver source.

If there is consensus that everything else in the patch set is settled,
and we just don't want to support behaviour like the above - well, we
can still drop it.

Thanks for the note,

Roland

