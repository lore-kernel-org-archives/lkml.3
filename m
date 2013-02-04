Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab3BDUeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 15:34:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36120 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755202Ab3BDUeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 15:34:05 -0500
Date: Mon, 4 Feb 2013 20:33:58 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Cyril Chemparathy <cyril@ti.com>, balbi@ti.com,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, "Nair, Sandeep" <sandeep_n@ti.com>,
        Chris Ball <cjb@laptop.org>, Matt Porter <mporter@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Landley <rob@landley.net>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to
 arm/common
Message-ID: <20130204203358.GX4720@opensource.wolfsonmicro.com>
References: <510C2A47.1090607@mvista.com>
 <20130201205600.GA31762@arwen.pp.htv.fi>
 <20130201213003.GW2637@n2100.arm.linux.org.uk>
 <20130204154153.GA18237@arwen.pp.htv.fi>
 <510FF1A6.403@mvista.com>
 <20130204164712.GB4269@arwen.pp.htv.fi>
 <510FF5C9.3030600@mvista.com>
 <20130204170216.GC4269@arwen.pp.htv.fi>
 <51100A72.6030909@ti.com>
 <CACRpkdZihnp3_Df==QRWxQupgi7W_YXZxc-MxkusVH6J+Vx56A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QQ0dNM4HnH4+xgqD"
Content-Disposition: inline
In-Reply-To: <CACRpkdZihnp3_Df==QRWxQupgi7W_YXZxc-MxkusVH6J+Vx56A@mail.gmail.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QQ0dNM4HnH4+xgqD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 04, 2013 at 09:29:46PM +0100, Linus Walleij wrote:
> On Mon, Feb 4, 2013 at 8:22 PM, Cyril Chemparathy <cyril@ti.com> wrote:

> > Based on our experience with fitting multiple subsystems on top of this
> > DMA-Engine driver, I must say that the DMA-Engine interface has proven
> > to be a less than ideal fit for the network driver use case.

> > The first problem is that the DMA-Engine interface expects to "push"
> > completed traffic up into the upper layer as a part of its callback.
> > This doesn't fit cleanly with NAPI, which expects to "pull" completed
> > traffic from below in the NAPI poll.  We've somehow kludged together a
> > solution around this, but it isn't very elegant.

> I cannot understand the actual technical problem from the above
> paragraphs though. dmaengine doesn't have a concept of pushing
> nor polling, it basically copies streams of words from A to B, where
> A/B can be a device or a buffer, nothing else.

> The thing you're looking for sounds more like an adapter on top
> of dmaengine, which can surely be constructed, some
> drivers/dma/dmaengine-napi.c or whatever.

Broadly speaking what NAPI wants is to never get any callbacks from the
hardware (or DMAs).  It wants to wake up periodically, take a look at
what packets have been read by the hardware and process them.  The goal
is to have the DMAs sitting and running without disturbing the processor
at all after the first packet has been handled.

--QQ0dNM4HnH4+xgqD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJREBsvAAoJELSic+t+oim9gPkP/1B4xZUtjrKkxCZzZQbQoBdT
0kOI5MJhqvvNUNhGc3HWSZV7u1QfR3HeLYa+xEpJfUMmqawpMyTkDaju08Y3d1eU
MXM8fx7Uj3l8TfJ0UiqcerGMyRjUUY7xQJNH/J3FdP0iqOGsoeGA7QKnonwS3LEe
4tRP2hVFWceooq5PdZs5Ya1aKIdhBvMst77xSHxeoK/ljhePKSg915a03mmXiho6
+ikeNw/dgHSrMkqReQz3DwTbL/yzeJeAYNAI8DuWh4ogXGdpzQzi8gOyxiPC02B2
i/lcLPb5khLs/aB9NyOhoTC0yYKGvZE7rlX4t8d5afDcmFb4LB4mCiwsGw7jG+AN
v59ggyzzgtTOSpZQ6Ha+putZJGRsnaL/3f+uIE5jeHsPwkEjxq9VKrxJlTmChdYN
vraf2JyeibxSlORdQqzJ1UGRGNyGL1tHY+CQ/5QkjPKL+PxZxuE3p9KQmB8e4S5R
YTdGlSVBPRH5MnvR9W+WLSqe7PpX0eL+GGktO6oo//w710Y7Ne/Hvxd0gEI2+Ezg
VdnqnAmOIF+W/DM/4um9w/hn4id5uSMie+hW9yiDoB9SdAMMQ+zsVAU0gzGKt5tz
P8regcr4V7Vpw2BLCjvqNPbq7ilTksp0lhAZI352i3Mr8Ai+R60i7Jz7Fqnbk0Ut
pd155HoumXzeG6zHQuV8
=M6TV
-----END PGP SIGNATURE-----

--QQ0dNM4HnH4+xgqD--
