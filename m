Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab3GEWeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:34:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62659 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab3GEWeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:34:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: MTD EEPROM support and driver integration
Date: Sat, 6 Jul 2013 00:33:13 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, oliver@schinagl.nl,
        linux-mtd@lists.infradead.org
References: <20130705201118.GM2959@lukather> <201307052302.40588.arnd@arndb.de> <20130705222342.GP2959@lukather>
In-Reply-To: <20130705222342.GP2959@lukather>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201307060033.13259.arnd@arndb.de>
X-Provags-ID: V02:K0:kqIrTSoR6GHOww1AP/aDZCFwpP32fEZcmkWRoLK4Sjf
 zZCBJnFs1LF5SpTrYyUr475ANmQNXMF5veKDBGYaM1F0LxuOKL
 xTVHABnPImwkHBw047GuDrpP9faENIXJkK6h4X1r8GVJo+oQx7
 9GuYxZ0OqQcZOdB/g5hhw/eLQbtCcHKoqj8o7xCXQr+CpodPzz
 oXUpPVUy8T6l1Ch4+MNYf6+oII3jqW3SW+WPQLZOvJH2UG+3YT
 ozJsgUa7gf5e9oy2KjfIuNJshslrcdgAJ4AiOd160rHCDWo4Kh
 MxdHEM/Ew8lNQ5Cpf6qTo9AOd2JsDKUNHS0k8/GdCiJ13+PGDg
 Id6ztTzqtFRiaamCiSgs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 July 2013, Maxime Ripard wrote:
> > My first thought is that it should be more generic than that and not
> > have the mac address hardcoded as the purpose. We could possibly use
> > regmap as the in-kernel interface, and come up with a more generic
> > way of referring to registers in another device node.
> 
> Hmm, I maybe wasn't as clear as I wanted. Here mac-storage was just an
> example. It should indeed be completely generic, and a device could have
> several "storage source" defined, each driver knowing what property it
> would need, pretty much like what's done currently for the regulators
> for example.
> 
> We will have such a use case anyway for the Allwinner stuff, since the
> fuses can be used for several thing, including storing the SoC ID,
> serial numbers, and so on.

Ah, I see. In general, we have two ways of expressing the same thing
here:

a) like interrupts, regs, dmas, clocks, pinctrl, reset, pwm: fixed property names

	regmap = <&at25 0xstart 0xlen>;
	regmap-names = "mac-address";

b) like gpio, regulator: variable property names

	mac-storage = <&at25 0xstart 0xlen>;

It's unfortunate that we already have examples of both. They are largely
equivalent, but the tendency is towards the first.

	Arnd
