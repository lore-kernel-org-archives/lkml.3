Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbaBCIaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 03:30:18 -0500
Received: from top.free-electrons.com ([176.31.233.9]:49925 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751566AbaBCIaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 03:30:14 -0500
Date: Sun, 2 Feb 2014 15:54:27 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH 0/3] spi: core: Introduce devm_spi_alloc_master
Message-ID: <20140202145427.GB3157@lukather>
References: <1391163792-21819-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140131121215.GB22609@sirena.org.uk>
 <20140131133111.GF2950@lukather>
 <20140201173841.GU22609@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uZ3hkaAS1mZxFaxD"
Content-Disposition: inline
In-Reply-To: <20140201173841.GU22609@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Feb 01, 2014 at 05:38:41PM +0000, Mark Brown wrote:
> On Fri, Jan 31, 2014 at 02:31:11PM +0100, Maxime Ripard wrote:
> > On Fri, Jan 31, 2014 at 12:12:15PM +0000, Mark Brown wrote:
>=20
> > > This seems confusing - the idea here is that if we've handed the
> > > device off to the managed function then the managed function
> > > deals with destroying it.  Note that spi_alloc_master() says
> > > that the put is only required after errors adding the device
> > > (which would be the expected behaviour if you look at other
> > > APIs).  Looking at the code I think there is an issue here but
> > > I'm not at all clear that this is the best fix.
>=20
> > Ah, right, spi_master_put doesn't free the memory either...
>=20
> The memory is freed by the driver core calling the
> spi_master_release() callback when it's safe to do so (after the
> last reference to the device has gone away).
>=20
> > I guess we have a few choices here, either:
> >   - Add a devm_kzalloc to spi_alloc_master, since most of the drivers
> >     I've been looking at fail to free the memory, this would be the
> >     least intrusive solution. We'd still have to remove all the kfree
> >     calls in the driver that rightfully free the memory.
> >   - Make devm_unregister_master also call kfree on the master
> >   - Add a kfree to my devm_put_master so that the memory is reclaimed,
> >     which isn't the case for now.
>=20
> > I don't have a strong preference here, maybe for the third one, since
> > it makes obvious that it's managed and you don't have to do anything
> > about it, while the other do not.
>=20
> None of the above, definitely nothing to do with calling kfree() once
> the device is registered.  We already have that free, it's not the
> issue.  The issue is making sure that we hold references when we need
> them and drop them when we don't.  I (or someone) needs to sit down and
> think it through since things are a bit confused in the code.

Ok. I'll drop the patches and repost the A31 SPI patches.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--uZ3hkaAS1mZxFaxD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS7lwjAAoJEBx+YmzsjxAgxM8P/R3dhxFRTi63rm7U/VvmvPqZ
j4yLxll8vuniN64ij2f5nra+eRQpZ+QgYmmJPvmPb1j4GPAHfdXNuCtU88e1ip/x
bid9SahYP1d50RpZGcFovRcGACThysVSoOBXlazkf9ITXYeqv08sKPq20RIq1593
MSiKSCltWKuPvaUV2TQ9Ze3JuZJGEGtp7uiDnCF4LoatHtlPXqOZdPeHr24td762
HYqBwjoNEWKJ6WxPaLjLK3eIrfaS620sEmDZjOif39vD0+MWtfP6rqs0vpc5tAqC
r84hPmxyN53Q9viPcdDgxcQQPCbWEhPyUFntQv47RUrhM1qslbojJeha0MUNoV2c
7rh33PlX+zGmSJdhoxZe36ic/EqQhct33MbQOODiATQdTxYPueesyKpHPrninOfT
3k1JUtTnUGR8VRUxgNgHZayeF5BLQiOb/5d4t6OvFZ8Pj7tU53aiMh49HuYdSd51
umXOVMFn1flYEhOaCzkn54bUruMVwZZw1nDPb2+6530UxQNVoD5tfCfDBEuoafrG
flPkOI5Ht4EyIp36aiJ/WDtWJuskmaa1YKWo449SVAcD2vBu1n2Su6UcoqXGv1dd
a9tONsY1zKASmAGT/XSaMD6GcN0OzZx81FfquP7tZwnDkK6cAOCyqdJCILXHS0Yp
GiSCRWgHfYvSkqGDlzLs
=okiQ
-----END PGP SIGNATURE-----

--uZ3hkaAS1mZxFaxD--
