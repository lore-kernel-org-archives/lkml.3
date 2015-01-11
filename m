Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbbAKVQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 16:16:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59944 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751282AbbAKVQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 16:16:33 -0500
Message-ID: <1421010983.19708.20.camel@decadent.org.uk>
Subject: [3.2-stable] Suspend regression after "x86, 64bit, mm: Mark
 data/bss/brk to nx"
From: Ben Hutchings <ben@decadent.org.uk>
To: Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org, stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 11 Jan 2015 21:16:23 +0000
In-Reply-To: <1420935783.2327.28.camel@decadent.org.uk>
References: <1420935783.2327.28.camel@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-iiGC3lk0EF0aioydrjjf"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iiGC3lk0EF0aioydrjjf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2015-01-11 at 00:23 +0000, Ben Hutchings wrote:
> Commit 45e2a9d4701d8c624d4a4bcdd1084eae31e92f58 ("x86, mm: Set NX across
> entire PMD at boot") has been backported to many stable branches:
>=20
> v3.10.62: 0b15c16c4f4a x86, mm: Set NX across entire PMD at boot
> v3.12.35: 868b19cb0314 x86, mm: Set NX across entire PMD at boot
> v3.14.26: 1a829c59816e x86, mm: Set NX across entire PMD at boot
> v3.17.5: 6231385167e0 x86, mm: Set NX across entire PMD at boot
> v3.2.65: a5c187d92d2c x86, mm: Set NX across entire PMD at boot
> v3.13.11-ckt12: 3657489f7009 x86, mm: Set NX across entire PMD at boot
> v3.16.7-ckt3: de32229b546e x86, mm: Set NX across entire PMD at boot

Sorry, I think I booted the wrong version at the last step of bisection.
It was actually the previous commit on the 3.2.y branch, which was
commit 72212675d1c96f5db8ec6fb35701879911193158 upstream ("x86, 64bit,
mm: Mark data/bss/brk to nx") that introduced the regression.  I intend
to revert both of these.

Ben.

> Unfortunately, in 3.2.65 suspend/resume stopped working on at least some
> systems - specifically, the system would reboot when woken:
>=20
> https://bugs.debian.org/774436 - Lenovo ThinkPad T530
> https://bugs.debian.org/774461 - Lenovo ThinkPad X230
> https://bugs.debian.org/774526 - ECS P4M900T-M2
> https://bugs.debian.org/775059 - ASUS X201EP
>=20
> I could reproduce this on my own ASUS P8Z68-V LX and was able to bisect
> to the backport of this commit.
>=20
> Assuming that this regression has not occurred on mainline or the other
> branches, I will revert this patch for 3.2.y unless someone can point
> out a missing dependency that I should apply.
>=20
> Ben.
>=20

--=20
Ben Hutchings
One of the nice things about standards is that there are so many of them.

--=-iiGC3lk0EF0aioydrjjf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVLLoKOe/yOyVhhEJAQqk5w/9Hrdmt1PJGvllVjqBGhd/p/GEBK2CXpLH
crLUi9qua47YCqS6Jag7bXoNcIaq5+frhK+AtFe3S91lm3zd4GG3sIk2qM9um2i5
JNBMVBXKA2ADxnYhfw27SzuY6Nr7kGizCB4qWgWFAaW5VPr6MsMzdD3mVtSdku7/
Nn8hgVZC0QJrGvNDeszW1uWVcmkdUb8hTR9PVXn/o9gp77E1z0lPitrFrODT0mP8
CWmqXIK+y+AYoKV/9p9viZ8nLXXG/IDmTVJrUmIBFQA/OuFzh+JWyB62nUPbcRcc
UKXRXrdtrK39/GejK28jfPsOEWwZhFLbE0A2igGmjYdRvRXAsOPaCyxv9PsgmAc/
GqflTv79tlQlhXuuirrN+rI21B3KEIKiC+yb+4TNCGGNmXT+txgDb/h/nu2usPXW
wckdr0d7IzOAoGJZG4m99E9dc7Hf32cDmERgrQkmso1fBlXoTWBQcbetxUx5hj55
Aw/9X0feuqHE5MH9kdplxT8fJ5ERMZwZK13RMo7/anevU/Jb2S7qkrF3G4spnkMy
YE8jQ36/rfVQjOWp28zhRqaiXIQHBNudDh6l5zltj6w0sjJKk4DJ+zEJBL/GFuB0
39j8mrzFwMRPRXW1AE92JuKgBO8LyrMgyWSdhXJ3JkOKfoV3CTDqfjv5FHsFzczK
tzE8Qy9kzU4=
=Exlu
-----END PGP SIGNATURE-----

--=-iiGC3lk0EF0aioydrjjf--
