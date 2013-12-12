Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab3LLJI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 04:08:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48266 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3LLJIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 04:08:43 -0500
Date: Thu, 12 Dec 2013 10:08:38 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: delicious quinoa <delicious.quinoa@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jamie Iles <jamie@jamieiles.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: Re: [PATCH v9] gpio: add a driver for Synopsys DesignWare APB GPIO
Message-ID: <20131212090838.GD25478@pengutronix.de>
References: <1386364179-28650-1-git-send-email-delicious.quinoa@gmail.com>
 <CANk1AXS=CADN53aO5KVN3UorddJ0wZ2PTqwo2XmeRuxYe_DoLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANk1AXS=CADN53aO5KVN3UorddJ0wZ2PTqwo2XmeRuxYe_DoLg@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:32:22 up 109 days, 18:03, 49 users,  load average: 0,15, 0,14,
 0,09
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan!

On Wed, Dec 11, 2013 at 02:15:25PM -0600, delicious quinoa wrote:
> On Fri, Dec 6, 2013 at 3:09 PM, Alan Tull <delicious.quinoa@gmail.com> wrote:
> > From: Alan Tull <atull@altera.com>
> >
> > Hi Linus,
> >
> > If you don't have any further comments, can you take this patch?
> >
> > Alan
> 
> Basically, this is a driver that Jamie wrote and was upstreaming a few
> years ago.  For some reason it never quite made it into the kernel.  I
> picked it up, updated the interrupt support, posted it to the list and
> went through some reviews with it.
> 
> This driver has been reviewed, I hope it can make it into the kernel.
> 
> Alan
> 

Sorry for chiming in late. I tested your driver on the Sockit and the GPIOs
work fine (basically just tested the 4 HPS LEDS that are on this board).

With the interrupt support I had a little trouble though:
The Sockit has an ADXL345 on the i2c bus with a gpio as interrupt line.

First: When you use "interrupt-parent", you have to specify the gpio node,
rather than the gpio-bank that has the interrupt-controller property. Is
that expected? I'm not really sure if that is normal behavior...

Second: The interrupt is registered as "GIC 37", which is a real interrupt on
the Socfpga. I would expect it to be marked as "GPIO 2xx" (or something in that
range). The interrupt from the gpiochip itself isn't registered at all ?!

Third: The interrupt didn't work. But that might also be my failure. I guess/hope
you tested interrupts successfully?!

(Fourth: small typo in the documentation example: "snps,nr-gpio" instead of "snps,nr-gpios")

Regards,
Steffen


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
