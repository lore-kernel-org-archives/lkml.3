Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab3CGDou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 22:44:50 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:40666 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab3CGDot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 22:44:49 -0500
MIME-Version: 1.0
In-Reply-To: <51346D7C.5080307@gaisler.com>
References: <1360653873-25368-1-git-send-email-andreas@gaisler.com>
	<CACRpkdaYQSrzm_Yj3ZH9YZLC_zPJN06X-9ZM9jd7=X0OB1shXQ@mail.gmail.com>
	<51346D7C.5080307@gaisler.com>
Date: Thu, 7 Mar 2013 04:44:48 +0100
Message-ID: <CACRpkdaC9DsNj56_q33Z5N3_90Ffdq9qZeOxrFdrVSoL4wrTbQ@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: Add device driver for GRGPIO cores and support
 custom accessors with gpio-generic
From: Linus Walleij <linus.walleij@linaro.org>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        software@gaisler.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 10:46 AM, Andreas Larsson <andreas@gaisler.com> wrote:
> [Me]
>>> +struct grgpio_priv {
>>> +       struct bgpio_chip bgc;
>>> +       struct grgpio_regs __iomem *regs;
>>> +
>>> +       u32 imask;      /* irq mask shadow register */
>>> +       s32 *irqmap;    /* maps offset to irq or -1 if no irq */
>>
>>
>> irqmap? Argh what is this... I think you want to use irqdomain
>> for this instead. (Documentation/IRQ-domain.txt)
>
>
> Yeah, that comment is not clear. An entry in the irqmap array (for a gpio
> line) can be either -1 indicating no irq for that line or an index into the
> array of irq:s for the of device. Thus it is simply either -1 or a valid
> second argument to irq_of_parse_and_map.

So just make the mapping function in the irqdomain handle that?

Maybe I'm talking weird, I'm not really familiar with
irq_of_parse_and_map().

> Given that this is generally running on SPARC, it seems irqdomain is not an
> option (IRQ_DOMAIN is not selected by SPARC).

That has nothing to do with this. This driver can just select IRQ_DOMAIN
in *it's* Kconfig entry.

Using irqdomain for a certain irq_chip does not at all mandate that the
entire system has to use irqdomain for everything, and two wrongs does
not make one right.

> Given this, is just a better formulated comment OK with you in this case?

No...

Yours,
Linus Walleij
