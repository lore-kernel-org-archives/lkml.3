Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbaDOM5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:57:40 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33991 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaDOM5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:57:39 -0400
Date: Tue, 15 Apr 2014 13:56:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Message-ID: <20140415125654.GD12304@sirena.org.uk>
References: <1397292335-5516-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397480885-11962-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140414210429.GJ25182@sirena.org.uk>
 <534CE16D.8010508@free-electrons.com>
 <20140415100922.GN12304@sirena.org.uk>
 <534D1DDA.40207@free-electrons.com>
 <534D252B.8060009@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SSQrXjJAjSvYS5Wm"
Content-Disposition: inline
In-Reply-To: <534D252B.8060009@metafoo.de>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH v2] regmap: smbus: add support for regmap over smbus
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SSQrXjJAjSvYS5Wm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 15, 2014 at 02:25:15PM +0200, Lars-Peter Clausen wrote:
> On 04/15/2014 01:54 PM, Boris BREZILLON wrote:

> >And, should I keep one method to register an smbus regmap or should I
> >provide one method per access type and get rid of the
> >regmap_smbus_transfer_type enum ?

> I don't think we should leave the decision which bus to use to the driver.
> Neither should the driver have to choose whether to use smbus or native I2C.
> We want to use native I2C when available, because it is more efficient than
> going through the smbus emulation layer. On the other hand we want to
> automatically switch to smbus when native I2C is not available and the
> device can work fine with smbus. Also I'm afraid that we'll otherwise soon
> see code popping up like:

I have to say I'd misread the commit message (due to the multiple copies
that arrived before I actually reviewed it I think I just skimmed it and
went into incremental review) and was reviewing this as being for
*device* limitations not controller ones.  That also matches with what
Boris was saying about not being able to decide to use the word or byte
at a time operations automatically, though the commit message does say
it's about controller limitations.

> My suggestion is that in regmap_init_i2c() you check the capabilities of the
> I2C adapter. If it supports native I2C you setup the regmap with the
> regmap_i2c struct just as it does right now. If the adapter does not support
> native I2C, check if the device can be supported by smbus (reg_bytes == 8 &&
> val_bytes % 8 == 0). For each type of smbus operations have one regmap_bus
> struct, and if you can fallback to smbus choose the bus depending on the
> config's val_bytes.

That'd definitely be useful but potentially orthogonal, we can also do
both and expose smbus explicitly with I2C falling back to it
transparently.

If the device *is* limited to smbus and the controller supports both
(some do) I'd naively have expected that the native smbus support would
do a little better - otherwise why bother using it?  We could identify
the constraint set automatically for I2C devices though it's more for
the client driver to specify.

This means there's two changes to consider here:

 - Providing APIs for registering actual smbus devices as a convenience
   for devices with that constraint, regardless of how that is done
   behind the scenes.

 - Having the I2C implementation automatically use the smbus APIs if
   it can and either the controller is smbus only or it makes sense to
   do so for optimisation.

both of which are independently useful.

--SSQrXjJAjSvYS5Wm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTSyTAAoJELSic+t+oim9voEP/1817WeFN9zVzgIvIGPt46ag
w2EDpJ8QRT3/Q7Q+VPhEnYKK9uha8nVjf1H+uuG23qwgTd0GzEWC4xmcFYmCjI/f
dBPojalizUuEZWg47DXRUrhG/TZh+Mwp2wQ00Pta98ilUhEM8tocSfzp2Z+0S0Fw
v4r/P0SzZUsXQ7fp++KxEDK1ygcgzyS1BoUG8ECRR7CXxRgDIhB8cy+trbVt8h1N
vXPZL+emfX0lEQ/RonqcmdHrELxkA3ubWxUDsabh2OraTyPv4APEBz8yMVnTekDG
HbglYNhTvF0PwCKc/fS3tGHBVTnO9CnAC5hWSX1mZjEHERtvCdF+UKGY8nXj1cli
U974iO35/OZdgSiujZyNRbRz5yCFKuHEHwv6P/9rdzw7L77vB8BT1qvRwtYn2amh
SsWNLTUpZQX4D9xn7PPqMgmO//1MAgEoYnIY7jc2HruukOIs4NDSnTul8SWQFsy2
b7K8kFQpkQxr3a8Aows5MRtCH8RCKgJF7nNCbuiyz2PqwMeedNVjBmCVWPIFyx+4
PAR9zieVF2QHMDBzr24oO00ihbcT5x56JIFdLwXsO7cWhkRctjCTaEosUDITtnqI
bx92PUj6jHQhtxNrzCmbi0XcOvPrkbnqJnYmT428UH4Cn3Jh7nCkWy3Ah4ulz3su
jveBNSGEiXYsFYaK9ziT
=hJTS
-----END PGP SIGNATURE-----

--SSQrXjJAjSvYS5Wm--
