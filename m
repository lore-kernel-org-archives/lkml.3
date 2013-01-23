Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab3AYW1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:27:17 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38170 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753116Ab3AYW1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:27:14 -0500
Message-ID: <1358947052.2976.1.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 1/2] efi: Make 'efi_enabled' a function to query EFI
 facilities
From: Ben Hutchings <ben@decadent.org.uk>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, Tim Gardner <rtg.canonical@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Tony Luck <tony.luck@intel.com>,
        Steve Langasek <steve.langasek@canonical.com>,
        Colin Ian King <colin.king@canonical.com>,
        David Airlie <airlied@linux.ie>,
        Corentin Chary <corentincj@iksaif.net>,
        Dave Jiang <dave.jiang@intel.com>, Peter Jones <pjones@redhat.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, stable@vger.kernel.org
Date: Wed, 23 Jan 2013 13:17:32 +0000
In-Reply-To: <1358927532.2496.24.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1358800838-10459-1-git-send-email-matt@console-pimps.org>
	 <1358800838-10459-2-git-send-email-matt@console-pimps.org>
	 <50FDA81B.9090602@zytor.com>
	 <1358802778.2496.11.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1358914581.3151.6.camel@deadeye.wl.decadent.org.uk>
	 <1358927532.2496.24.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-eKJOdLrlPpxd5ETaO7nW"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 78.32.9.209
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eKJOdLrlPpxd5ETaO7nW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-01-23 at 07:52 +0000, Matt Fleming wrote:
> On Wed, 2013-01-23 at 04:16 +0000, Ben Hutchings wrote:
> > On Mon, 2013-01-21 at 21:12 +0000, Matt Fleming wrote:
> > [...]
> > > From 92e73f936e40a8c6562e47425d434a4e62d2b8e2 Mon Sep 17 00:00:00 200=
1
> > > From: Matt Fleming <matt.fleming@intel.com>
> > > Date: Wed, 14 Nov 2012 09:42:35 +0000
> > > Subject: [PATCH] efi: Make 'efi_enabled' a function to query EFI faci=
lities
> > >=20
> > > Originally 'efi_enabled' indicated whether a kernel was booted from
> > > EFI firmware. Over time its semantics have changed, and it now
> > > indicates whether or not we are booted on an EFI machine with
> > > bit-native firmware, e.g. 64-bit kernel with 64-bit firmware.
> > >=20
> > > The immediate motivation for this patch is the bug report at,
> > >=20
> > >     https://bugs.launchpad.net/ubuntu-cdimage/+bug/1040557
> > >=20
> > > which details how running a platform driver on an EFI machine that is
> > > designed to run under BIOS can cause the machine to become
> > > bricked. Also, the following report,
> > >=20
> > >     https://bugzilla.kernel.org/show_bug.cgi?id=3D47121
> > >=20
> > > details how running said driver can also cause Machine Check
> > > Exceptions. Drivers need a new means of detecting whether they're
> > > running on an EFI machine, as sadly the expression,
> > >=20
> > >     if (!efi_enabled)
> > >=20
> > > hasn't been a sufficient condition for quite some time.
> > [...]
> >=20
> > This patch maps the old efi_enabled flag to efi_enabled(EFI_BOOT).  You=
r
> > second patch adds a test for efi_enabled(EFI_BOOT) to the samsung-lapto=
p
> > driver.  So the samsung-laptop driver could be fixed by adding a check
> > for the old flag; it doesn't depend on the addition of new flags at all=
.
> > The changes elsewhere may well be important, but the cited motivation
> > here just doesn't make sense.
>=20
> If we instead check for the old flag then the samsung-laptop driver
> would run if booting a 32-bit kernel with 64-bit EFI firmware, or vice
> versa, because efi_enabled =3D=3D 0 in that case.
>=20
> It's not sufficient to just check the old flag, the samsung-laptop
> driver really can't be allowed to run at all if booting from EFI, and
> the old flag doesn't provide us with that guarantee.

OK, yes, I misread this.  Sorry to waste your time.

Ben.

--=20
Ben Hutchings
Q.  Which is the greater problem in the world today, ignorance or apathy?
A.  I don't know and I couldn't care less.

--=-eKJOdLrlPpxd5ETaO7nW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUP/i7Oe/yOyVhhEJAQrb9RAAifOOrFZmQ+udsylkDaudJkNnnYT7D8Qx
z9ypuUyP25BvJTspysI+Xo7hNw+lGbhKKzCsxyMd/xhf9MsmdOu0hh7TKpRF9dQn
nnVEjhuK1uqic2E7j3B6/y3C9IEPTTBU2JJA6CHi7miyydY31385Uj4S9pwbaFGU
y7QRh3DXNgS+ffRXWNIJZOFBriJRBpUK0SQBDbwxwUsis2sAH7OkYMGG1Q4gMpQg
LGiEqRcbaOJFlI2rPjl3UcfJAVOKrC8p8NuP03I+uQX8DJU+D6B9y+oDpl/ivhGp
GNisFn2vJ00inmSOLJjE0vcJUR43Pg995bL67gwsddJ+XjDCuuX/7yXIfJisiJLq
5pqBBkSDwhz+xoNTmHL7yEBxpVTEOlTiFhRRU/F9hyqn2VqRHv6enUJJ7ZieR3ab
nfQTeShf9muNlqW7BjvB96+M0lDA2Gz3y4ruO5OnfspMFC7OHL6oDjmC7MmsHBGP
eVU/6kitk/jvYG5OM01TDOhNFJktrshCJRcyLEPBo+93WBLPlJsliTNCiHPIK/7K
G9VGebOVLpCf6fB1LipatNUIRE+U7CA8zTAIjdxgGu9v3dD9v/6muOksJrCNxKFL
yHnghHdO8MGUxQ5h4rg9FvYz6b7uAub03qquuoOxqdgvA1GRXkzuR2eyVmizavOW
7oYg0kwlMG0=
=bWPX
-----END PGP SIGNATURE-----

--=-eKJOdLrlPpxd5ETaO7nW--
