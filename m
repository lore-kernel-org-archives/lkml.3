Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3AWEQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 23:16:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40334 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448Ab3AWEQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 23:16:53 -0500
Message-ID: <1358914581.3151.6.camel@deadeye.wl.decadent.org.uk>
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
Date: Wed, 23 Jan 2013 04:16:21 +0000
In-Reply-To: <1358802778.2496.11.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1358800838-10459-1-git-send-email-matt@console-pimps.org>
	 <1358800838-10459-2-git-send-email-matt@console-pimps.org>
	 <50FDA81B.9090602@zytor.com>
	 <1358802778.2496.11.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-rc5G/xi5TRpg2q32Fy3P"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rc5G/xi5TRpg2q32Fy3P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-01-21 at 21:12 +0000, Matt Fleming wrote:
[...]
> From 92e73f936e40a8c6562e47425d434a4e62d2b8e2 Mon Sep 17 00:00:00 2001
> From: Matt Fleming <matt.fleming@intel.com>
> Date: Wed, 14 Nov 2012 09:42:35 +0000
> Subject: [PATCH] efi: Make 'efi_enabled' a function to query EFI faciliti=
es
>=20
> Originally 'efi_enabled' indicated whether a kernel was booted from
> EFI firmware. Over time its semantics have changed, and it now
> indicates whether or not we are booted on an EFI machine with
> bit-native firmware, e.g. 64-bit kernel with 64-bit firmware.
>=20
> The immediate motivation for this patch is the bug report at,
>=20
>     https://bugs.launchpad.net/ubuntu-cdimage/+bug/1040557
>=20
> which details how running a platform driver on an EFI machine that is
> designed to run under BIOS can cause the machine to become
> bricked. Also, the following report,
>=20
>     https://bugzilla.kernel.org/show_bug.cgi?id=3D47121
>=20
> details how running said driver can also cause Machine Check
> Exceptions. Drivers need a new means of detecting whether they're
> running on an EFI machine, as sadly the expression,
>=20
>     if (!efi_enabled)
>=20
> hasn't been a sufficient condition for quite some time.
[...]

This patch maps the old efi_enabled flag to efi_enabled(EFI_BOOT).  Your
second patch adds a test for efi_enabled(EFI_BOOT) to the samsung-laptop
driver.  So the samsung-laptop driver could be fixed by adding a check
for the old flag; it doesn't depend on the addition of new flags at all.
The changes elsewhere may well be important, but the cited motivation
here just doesn't make sense.

Ben.

--=20
Ben Hutchings
Q.  Which is the greater problem in the world today, ignorance or apathy?
A.  I don't know and I couldn't care less.

--=-rc5G/xi5TRpg2q32Fy3P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUP9kFee/yOyVhhEJAQrJFg/8D5siJHJ5qKWA1wo/XnihjQuBK5nweJ5e
RH//i2vOliehEtgGhfs5sMtGohrg/2lTXcaS8i+MxuiwrNFW73LoHdTsTf8v4xRc
YgkLnmxkFicpvPX/X3GUqOT9fXHNgCpXnIpRlLxbMulL7G32q5I4hjLVfL21+ThG
RH518/rZg1bOg9BdvzPEkCW6QAw1lQmObRCrnKrKtupQ5SmQyOSfPMHgll8jSUwL
LMkQ69p/iMSYGR3fW4BIiMFfwEZw/lXFGERrTVhP4EWtIONHzqayqtz1ZlIftImI
WvSp7GmPzyXWI8G5nkz6rl16ljSZmV1NEoXwCa8lqekZzgaTb7Q8L8juj+ilwFbG
7Jhj/rQ6mAy2Y3Mbn5SFS9Qo8QBVutKxK7Bthfj8pb6YZqghhpeyRbz+vdhz54td
q0NzM2b3QX9al5IMVF9qOqoyEmw2GtIkosEGtR/AmQsb0T9a+qpALbPIO/UrD8Vj
w7yHeAoPQxNw4we9C1JS/XGvuYpptQQixfQD77czKd5qctczYyeCFkI9qtlbxpe/
3eSITBE40gsVyNssYdSBtV3hUPJfLYmKLbuUe04KgO6kwnulS7Q6s5YWX7qg49st
ajga1zXIqv+pIEt/c16AeeW7afQj+N7Qs9/bwhrUId5lspDjsQ0QspHSfu74rz8H
AM3vH4XKYic=
=eEVp
-----END PGP SIGNATURE-----

--=-rc5G/xi5TRpg2q32Fy3P--
