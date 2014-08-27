Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339AbaH0L6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 07:58:41 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35922 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaH0L6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 07:58:40 -0400
Date: Wed, 27 Aug 2014 12:58:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140827115819.GB17528@sirena.org.uk>
References: <1409061793-10495-1-git-send-email-jarkko.nikula@linux.intel.com>
 <1409061793-10495-2-git-send-email-jarkko.nikula@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="My//7p6P0WSQXrfY"
Content-Disposition: inline
In-Reply-To: <1409061793-10495-2-git-send-email-jarkko.nikula@linux.intel.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regmap: cache: Fix regcache_sync_block for
 non-autoincrementing devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--My//7p6P0WSQXrfY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2014 at 05:03:12PM +0300, Jarkko Nikula wrote:
> Commit 75a5f89f635c ("regmap: cache: Write consecutive registers in a sin=
gle
> block write") expected that autoincrementing writes are supported if
> hardware has a register format which can support raw writes.
>=20
> This is not necessarily true and thus for instance rbtree sync can fail w=
hen
> there is need to sync multiple consecutive registers but block write to
> device fails due not supported autoincrementing writes.
>=20
> Fix this by spliting raw block sync to series of single register writes f=
or
> devices that don't support autoincrementing writes.

This seems like the wrong place for this - we already have a one
register at a time mechanism for syncing the registers, making the block
write scheme able to do it as well is rather missing the point.  Better
to move the check into sync_block() instead.

--My//7p6P0WSQXrfY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/cfXAAoJELSic+t+oim90YIP/2UPwpb/Ixw/jW2jpWwi37wY
L6ZdhPZAxhWi2zdqLpRHKz3CDG5PEDMB09YF00GAuebJNe+OWokodrZCpFpNO2MV
xsSgO6+pAbEMtfUe9qY/MV5KJsN+CE+VUz2IGFCH15kiUgCCjv9d0eNI+xEabhIB
Fxlyio660TU9xeOWZvzMJtEIJMZxvapts1gziqpB44DyX2/zU5pMHmzBZeTVz5uj
BOvwen85AIqqQ61MgEqc/GQEi4s+CTscudZfHumOUdbUAabVnIrpYGTCnwbNG5UO
EOx8W8VSGgcDOJIWYE6b50Y1XmlyYCRJEEBRFpGXw4L1cJAK/6B83/iAHXEmTV7h
R7n6Q/L4BD+G4a2B3URzyxXcfsd04njbRhMsS+yVeynMljWyoRwBfbxSH2yBIt+B
Nv5REOG3Di1ahUxE6a/l+sqzrrDiV7v/uPxfcqWvQyxoNsR3BQoq2UH22D4PXlQc
YjHBxJO4mdnsjhes0EkQew+DTzsym48/bKbxDChVt3NAlqt4FCMl99C4BqjpR+Nb
qfYMPVjNzR2arhDhgI6/7xNKtGVyHc2GOVk5fvXd7boRBs1SWHOrIpUegF+XVbPQ
lz0L2BCoiRScJ4It7037YKi0NVp276BO7jJjpUldf6bF1OrYePisXBIWvgRExEvt
+UvWDBz5x6akze3MHRUr
=r74Z
-----END PGP SIGNATURE-----

--My//7p6P0WSQXrfY--
