Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab3GFJQq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 05:16:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53440 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab3GFJQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 05:16:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, oliver@schinagl.nl,
        linux-mtd@lists.infradead.org
Subject: Re: MTD EEPROM support and driver integration
Date: Sat, 06 Jul 2013 11:18 +0200
Message-ID: <5811519.oHVuMujf0I@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.4; x86_64; ; )
In-Reply-To: <20130706082804.GZ2959@lukather>
References: <20130705201118.GM2959@lukather> <201307060033.13259.arnd@arndb.de> <20130706082804.GZ2959@lukather>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:CE91GvuQUdm+LXsMsLR5tuF/pH4CeFULfxbJJkNMYmu
 l0CWkWh1c5EJmvGWfqUYLASmhfK1anBlH1KopWJxC2/KVYB2AV
 Rlnjp+5TJlnQhG4rLmvOrBI5+WLiv1L/opXwDUa/h7M721ZxsB
 VpXhTUpc5USZFrCTDO6oehd6+DAqelfM9/JF3t4ikMlr/Kgohx
 KOK2ezAuVA9YXyZNmO0x2a+plEg0b2BPAb1IZr2Cr/OSUaVUxU
 W7ea9ZxmhXfymQsbRILLLNQyx9nH5FuhBV3Ohrd/4Xww2XMhZu
 L52Fp30EoJg2+rDseJByZtXsx+9mlt12+qTx0BXdjF1w5j/67/
 +XkvEcfbde2Yb2gM5BQI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 July 2013 10:28:04 Maxime Ripard wrote:
> > a) like interrupts, regs, dmas, clocks, pinctrl, reset, pwm: fixed property names
> > 
> >       regmap = <&at25 0xstart 0xlen>;
> >       regmap-names = "mac-address";
> > 
> > b) like gpio, regulator: variable property names
> > 
> >       mac-storage = <&at25 0xstart 0xlen>;
> > 
> > It's unfortunate that we already have examples of both. They are largely
> > equivalent, but the tendency is towards the first.
> 
> I don't have a strong feeling for one against another, so whatever works
> best. Both solutions will be a huge improvement anyway 
> 
> Just out of curiosity, is there any advantages besides having a fixed
> property name to the first solution?

I think it's mostly for consistency: trying to get most subsystems to
do it the same way to make it easier for people to write dts files.

A lesser point is that it simplifies the driver code if you don't
have to pass a name.


	Arnd
