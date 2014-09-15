Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745AbaIOW6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:58:55 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43946 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085AbaIOW6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:58:53 -0400
Date: Mon, 15 Sep 2014 15:58:20 -0700
From: Mark Brown <broonie@kernel.org>
To: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        wsa@the-dreams.de
Message-ID: <20140915225820.GI7960@sirena.org.uk>
References: <54119DB6.8020807@collabora.co.uk>
 <20140911193325.GT4015@sirena.org.uk>
 <5412C1DF.3040707@collabora.co.uk>
 <20140912101442.GR7960@sirena.org.uk>
 <1410768612.22941.1.camel@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X51x5yMCUZddmyY1"
Content-Disposition: inline
In-Reply-To: <1410768612.22941.1.camel@collabora.co.uk>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: SPI and module auto-loading
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X51x5yMCUZddmyY1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 15, 2014 at 10:10:12AM +0200, Sjoerd Simons wrote:
> On Fri, 2014-09-12 at 11:14 +0100, Mark Brown wrote:

> > The vendor identifier is an important part of the OF device ID, vendors
> > can and do end up with different devices of the same name.

> Indeed, which actually points at a problem with module loading for SPI
> as the vendor prefix gets dropped when generating the modalias for the
> uevent. So if there is a case where we have two SPI devices with the
> same device name (but a different vendor identifier), module loading
> can't work as the generated modalias for both will be spi:devicename
> even if OF can properly distinguish between both.

It's a relatively minor risk on that front though.

> So for things to be consistent for both cases the options are to either:
> a) the generated MODALIAS uevent variable should be an OF based alias
>   + Upside is that both kernel and userspace can use the full OF
>     information for matching
>   + Downside is that that would mean adding OF match tables to all
>     drivers that can possible used on a DT based system otherwise module
>     auto-loading for those will be broken.

This isn't a disadvantage for the drivers, anything being used with OF
should have an explicit match table defined.

> b) Stop using OF style matching and rely solely on the SPI id table
>   + Downside here is that the vendor prefix isn't used anymore for
>     matching. Otoh that's the current status quo for drivers without an
>     OF match table and for how userspace matches modules currently.
>   + Upside is that no extra work is required for drivers that currently
>     work with DT even if they don't have any direct OF support.

There's also the option of providing both bits of information in the
event which is less disruptive all round.

--X51x5yMCUZddmyY1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUF28LAAoJECTWi3JdVIfQkSEH/2NyWlz5Td0YJcT7IdTFmVjc
ujWaJA+bOrFQeOeO7uCiXuWQja/fU7rKqlpY0gICm+SUPs7/gREmfvbwq8Zrs0m8
idO68e/QGFdg7iKfadJA9tP7l9P6/mp/akFGExaISFNdNsr2u5X90GvNvps9AmRU
nB75ajLJc7g8wGuN7c/FbfiSiN+t1lNPQZ7I2tAVhr6O2WtMgeaQy9+Bh4iDWm4r
Juc2/4rGxS5FuMYLAUEuWBnLQr6Qd9sLTATyhinGpw6rOy6TusAHjIFXxAm7Xmz/
4A2gU/3+/QWYQQK2wwIaMyc+hNRCaqMdtJylb4/8qP2mwLptkgVqQyY4ALNwbJ0=
=1838
-----END PGP SIGNATURE-----

--X51x5yMCUZddmyY1--
