Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaIOCq6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 22:46:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38802 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753099AbaIOCq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 22:46:56 -0400
Message-ID: <1410749203.3040.57.camel@decadent.org.uk>
Subject: Re: [PATCH 3.12 40/56] ext4: fix ext4_discard_allocated_blocks() if
 we can't allocate the pa struct
From: Ben Hutchings <ben@decadent.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>
Date: Mon, 15 Sep 2014 03:46:43 +0100
In-Reply-To: <9f48c2853290b15ecdcd9ba83b41eaab63f22682.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
	 <9f48c2853290b15ecdcd9ba83b41eaab63f22682.1409735865.git.jslaby@suse.cz>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-1U8OsZGRXLooq01KoWUP"
X-Mailer: Evolution 3.12.5-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:9881:80b9:b90a:1609
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1U8OsZGRXLooq01KoWUP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-09-03 at 11:26 +0200, Jiri Slaby wrote:
> From: Theodore Ts'o <tytso@mit.edu>
>=20
> 3.12-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> commit 86f0afd463215fc3e58020493482faa4ac3a4d69 upstream.
>=20
> If there is a failure while allocating the preallocation structure, a
> number of blocks can end up getting marked in the in-memory buddy
> bitmap, and then not getting released.  This can result in the
> following corruption getting reported by the kernel:
>=20
> EXT4-fs error (device sda3): ext4_mb_generate_buddy:758: group 1126,
> 12793 clusters in bitmap, 12729 in gd
>=20
> In that case, we need to release the blocks using mb_free_blocks().
>=20
> Tested: fs smoke test; also demonstrated that with injected errors,
> 	the file system is no longer getting corrupted
>=20
> Google-Bug-Id: 16657874
>=20
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
[...]

It's a bit late now, but Ted said this introduced a regression that's
fixed by commit c99d1e6e83b0 ("ext4: fix BUG_ON in mb_free_blocks()").

(I just made the same mistake in 3.2.63.)

Ben.

--=20
Ben Hutchings
Make three consecutive correct guesses and you will be considered an expert=
.

--=-1U8OsZGRXLooq01KoWUP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVBZTGOe/yOyVhhEJAQrb9w/9FIpBLjZririY0di9A+jvH8O7eCrmQ9X5
a+ZKiOoy4e2nX7GhWgUsjiDuq/DRznuuiEA47Y9s2GYFrMnSF/ew6EiQj9c6CExm
kQwjmPxDWV9hqDlubUxiN/megwlFM9SCdSrhiruVrS0hfTzsS/Ua4+6C6knWB4jG
3Sq2Ncf9bPo9p2R+tVGfJNKO+RQQjKZrGrAV3pxamJQGQiZnRbkTr/apSgGePtG+
3cnOz/APcKOh3wvltCZjaNhCNgaHJQg3aezcZVwjzFiRXvCJ8c+ZDwU08f/2O6Ml
5dVmNqLj3hMajwi7fNtznLY1xUqSika1SuQjXUg38yWzlQe55Ocx2SZBp1VtFT46
cs4I9Lv44j9UxGxw3t1E+0tcxFANa4Lfm9K9WDfZqa+3675mzE3WmtFLiBtr/dyP
GIhnmZ5XrRqJ2d1e2+mcnI9F4O12A9l8U+iDch5phPPDS2X3FM6gL2uEkIE7qOKk
7gsUR7vWjDh1q/P6rEQLoI3CyNJjxPAru6aG9TT4I8cIN1MSHPBMGvAmnc8l16HK
OgOqMYEPIrmN1Z1VUAr6gWNhHAXoeFhL+dkJ5sB61ARZlrrIDxv/hcCuzjrpu79t
eNKiqJ7bL5vpKU0LTutiK5ciLjK94/0yXEoaHQQjR41iir8OYqQbYAlin48XIBx1
h2k1Jkvu054=
=mjGk
-----END PGP SIGNATURE-----

--=-1U8OsZGRXLooq01KoWUP--
