Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbaGaQ1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:27:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36968 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750911AbaGaQ1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:27:09 -0400
Date: Thu, 31 Jul 2014 18:13:31 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        laurent.pinchart@ideasonboard.com, ludovic.desroches@atmel.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] Documentation: dmaengine: Add a documentation for the
 dma controller API
Message-ID: <20140731161331.GD3952@lukather>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140730160607.GM8181@intel.com>
 <20140731074440.GY3952@lukather>
 <53DA3A48.8070900@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FSGgxso9lj1d9SFz"
Content-Disposition: inline
In-Reply-To: <53DA3A48.8070900@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FSGgxso9lj1d9SFz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lars-Peter,

On Thu, Jul 31, 2014 at 02:44:56PM +0200, Lars-Peter Clausen wrote:
> On 07/31/2014 09:44 AM, Maxime Ripard wrote:
> [...]
> >   - Having to set device_slave_caps or not?
>=20
> Yes. This should in my opinion be mandatory for new drivers.

Ok.=20

> One of the issues with the DMAengine API is that it is really hard
> to write generic drivers that do not already know about the
> capabilities of the DMA controller. E.g. if you have a peripheral
> that is used on SoC A it assumes that the DMA controller it is
> connected to has the capabilities of the DMA controller in SoC A. If
> the same peripheral is now used on SoC B with a DMA controller with
> different capabilities this often ends up with ugly ifdefery in the
> peripheral driver. The peripheral driver shouldn't have to know
> which specific DMA controller it is connected to (It's a bit as if a
> GPIO consumer needed to know which GPIO controller is connected
> to). We got away with the current approach since there is not that
> much diversity in the mixing of peripherals and DMA controllers
> (each vendor pretty has their own DMA controller which it uses for
> their own peripherals). But with more recent code consolidation we
> are on a path to generic DMA support within subsystem frameworks
> (there is generic DMA support for audio, there is generic DMA
> support for SPI and I also have a (currently) out of tree patch for
> generic DMA support for IIO). Also these generic drivers need to be
> able to discover the capabilities of the DMA controller to be able
> to make the right decisions.

Yeah, I've seen the generic infrastructure in both ASoC and SPI, and
it's great that it's coming to IIO as well.

I wasn't aware that it was relying on device_slave_caps though, and
been mislead by the caps name into thinking that it was related to the
caps_mask, which is obviously not.

=46rom what you're saying, and judging from the drivers that already
implement it, can't it be moved directly to the framework itself ?

The informations put there could be either used elsewhere (like
framework-level filtering of invalid directions/bus width) or could be
derived directly from which callbacks are set (in the pause/terminate
case)?

I guess that would make generic layer much easier to write, since
you'll always have this information.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--FSGgxso9lj1d9SFz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT2msrAAoJEBx+YmzsjxAg+FQP/1rtUN0fNfzwLyLloFX3aWl4
EUWxN1pP6CtSELvsWXeUF2dG2D/+vt7V2E1TXvaF6vCGZvmE/Q7tEvIPPj8UJwIr
Mb4gSyM1EDb/XU/KrhJDyKFEoFW//foKGQgonevlrRyCntv5hBFsAd8YchlajAd+
bvwc71lW0p9JDPzC90G6HIAt+d8ouMnLy6lkkEE7XhBnzp5Yhpn72z4szpgWQ9pt
KE0Lk6s7e83UiBBAmV4IaOx74QRiQvYcyyRi2lG8QExBKkQEendqe8hPp8B3TGeZ
K5ZarIvJ21CP4s37p9oOd0zISiul/cQVHxJqc76sR+uat8nfGpLiOoYYnu699axs
O/mYOA/r6z5oua5xTts9GBbkdz5fDpg43t/jhSTYU/cow1f2KRtYIPGYzDuncv9Q
qpoUIrDdyLSG/HD5jYwUkzYKDU0XvsIbAsVbVUJZRphZGIjAtAezOzKAU/ik64nJ
dRFg2riedjEJnimMPq5t0OpLzaA+nJ4Zc4U+/mB3VtMVAzYlfWMJaRaZM7GAm4CB
OokbOnjPzlLmVX00HucUIirXuVAeRyGoPglYdtgoQejJrv/VFRmUEvEdOupf1lkY
RzbfBWdESEpnRnrcfel2ucATcUFAgjExg3PohclmNrtEdOXxBsu3XiEIKJ51EArZ
uzKOBo47wMnhFLGXPf3Q
=MK8j
-----END PGP SIGNATURE-----

--FSGgxso9lj1d9SFz--
