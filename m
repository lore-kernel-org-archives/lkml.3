Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaJPIAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:00:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:48167 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbaJPIAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:00:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,730,1406617200"; 
   d="asc'?scan'208";a="619706057"
Message-ID: <1413446382.2412.57.camel@jtkirshe-mobl>
Subject: Re: [PATCH v2] bcm/CmHost.c: Fix noisy compile warnings
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Date: Thu, 16 Oct 2014 00:59:42 -0700
In-Reply-To: <20141016075211.GE23154@mwanda>
References: <1413399701-4321-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <20141015195549.GR26918@mwanda> <1413404767.2412.31.camel@jtkirshe-mobl>
	 <20141016075211.GE23154@mwanda>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-BlcKrhKDJXE+44uJA1rJ"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BlcKrhKDJXE+44uJA1rJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-10-16 at 10:52 +0300, Dan Carpenter wrote:
> On Wed, Oct 15, 2014 at 01:26:07PM -0700, Jeff Kirsher wrote:
> > On Wed, 2014-10-15 at 22:55 +0300, Dan Carpenter wrote:
> > > On Wed, Oct 15, 2014 at 12:01:41PM -0700, Jeff Kirsher wrote:
> > > > From: Fabio Estevam <fabio.estevam@freescale.com>
> > > >=20
> > > > The Beceem WIMAX was generating compile warnings on 64bit machines,
> > > > which were:
> > > >=20
> > > > drivers/staging/bcm/CmHost.c: In function =E2=80=98StoreCmControlRe=
sponseMessage=E2=80=99:
> > > > drivers/staging/bcm/CmHost.c:1503:3: warning: cast to pointer from =
integer of different size [-Wint-to-pointer-cast]
> > > >    (struct bcm_connect_mgr_params *) ntohl(
> > > >    ^
> > > > drivers/staging/bcm/CmHost.c:1546:3: warning: cast to pointer from =
integer of different size [-Wint-to-pointer-cast]
> > > >    (struct bcm_connect_mgr_params *) ntohl(
> > > >    ^
> > > > drivers/staging/bcm/CmHost.c:1564:3: warning: cast to pointer from =
integer of different size [-Wint-to-pointer-cast]
> > > >    (struct bcm_connect_mgr_params *) ntohl(
> > > >=20
> > > > This resolves the issue by preventing the driver to compile if CONF=
IG_64BIT
> > > > is enabled, since the driver is known to be broken for 64 bit arch'=
s.
> > > >=20
> > >=20
> > > Oops.  Someone turned a Joe patch into a real patch.  Please enable
> > > COMPILE_TEST for this.
> >=20
> > I agree with Joe, that COMPILE_TEST is not useful for this driver.
>=20
> If we remove the driver fine, but if we keep the driver then we should
> do enable any QA testing we can.

Sorry, after thinking about this more, I think that Joe and I jumped to
the conclusion that adding COMPILE_TEST meant to add " || COMPILE_TEST"
which would generate the same compile warnings we see now, especially
when doing allmodconfig.  But, if we added " && COMPILE_TEST", along
with the other Kconfig change, then I am fine with that.

So yes, I am on the same page with you.  If we end up keeping the
driver, then I will respin the patch to add && COMPILE_TEST.  I will
wait to re-spin based on whether Greg accepts the patch to remove the
driver or not.

--=-BlcKrhKDJXE+44uJA1rJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUP3ruAAoJEOVv75VaS+3ODtwP+gLtaH3XIgw/L76nwp5PRi5Q
fS0I69DAje47oIfWYMSb7zqmfxYZp7tdouUF3eRhiRy4dCrZfH/aEOE6rjq6JhZ/
cnCUE4+ulxFtyluyZujXN/0PPwW+VHoUOExnzoC5OywS7wR9dEY4v1EaPVgpul8h
etq5ku2O4D0iWboG8DoWJts4XEgs603Yx1+D+dBQ1F5E2cc2+XN08qGAI2tbbt/O
2JxOyyoWO0n2/j/FGO+BtOqfpSXvsHRRmxOSNzydeZfpRo7BIF0tLmi+bxm5r1gO
jSsFT8pwfyRsNvVrJpTE2FKS9sk5sPzTZaOm1YlCivWEFgqcKQg/sBr9u1UFjYgX
YKhA23BkWSPRWmw4wFW3KmqwFMg7rddf5Z/OkCrrd1pgr1WEmlskAijSma3mhILt
/KIUosYEO5gqv/Q3iBn7wrKil8lr7bAFX3AFCYP22FxKaCQhBH6XUjQWa0H/XIji
PIcoMYjvj87h2y8bcB1BmSZj6jIJbWx4Qqrir3k40kr8ZoIYlLjC71FdhTJRTi6c
IPzRLR/ddomVkDggCtqft0sxPIuDelCCZ7VvA8OkCYgt3OysK+g4WnqRWsDkDo1q
nV8MW3W+GKkuMvZieI3nK0eyD9xc2ttM4XSRHbOhqfLBu/QI5xLIlBrFHqoZkXNh
kAJBWrzqmCNHbv0DG+nT
=Aiva
-----END PGP SIGNATURE-----

--=-BlcKrhKDJXE+44uJA1rJ--

