Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaBXMUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 07:20:09 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:35664 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaBXMUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 07:20:06 -0500
MIME-Version: 1.0
In-Reply-To: <CANk1AXTnnhSnt_ayJYwDHRth44CWAwmxVA5kkbvnjqW39ssLQg@mail.gmail.com>
References: <1391724370-30589-1-git-send-email-delicious.quinoa@gmail.com>
	<CACRpkdYiC=nzVG4_nQuRVSNP9TB4W=3VL9QhBQjmqvLvmP6McA@mail.gmail.com>
	<CANk1AXTnnhSnt_ayJYwDHRth44CWAwmxVA5kkbvnjqW39ssLQg@mail.gmail.com>
Date: Mon, 24 Feb 2014 13:20:05 +0100
Message-ID: <CACRpkdbkcuByEh_pasBoAQpXwa479iTuWLPPQW1TLRapbqjE7Q@mail.gmail.com>
Subject: Re: [PATCH v11] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
From: Linus Walleij <linus.walleij@linaro.org>
To: delicious quinoa <delicious.quinoa@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jamie Iles <jamie@jamieiles.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 5:17 PM, delicious quinoa
<delicious.quinoa@gmail.com> wrote:

> I am wondering about the change in usage of
> irq_find_mapping/irq_create_mapping.  It seems like all the GPIO
> drivers that use irq domains do it the way I was doing it

It is a well known problems that the kernel contain many bad
examples. When in doubt ask for a good example to be provided.

In gpio-omap.c you will find that this is done in the probe()
path.

> (that's
> where I got the idea in the first place): irq_create_mapping is used
> in the to_irq() function.  I guess this is a general direction all the
> other drivers will be encouraged to go in also?

Yes. The reason is that it should be possible to reques an IRQ
from an irqchip no matter whether the gpio_to_irq() function
was called first, as the APIs are orthogonal.

Yours,
Linus Walleij
