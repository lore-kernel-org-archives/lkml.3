Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbaAHBvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 20:51:06 -0500
Received: from ozlabs.org ([203.10.76.45]:41241 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbaAHBvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 20:51:02 -0500
Date: Wed, 8 Jan 2014 12:50:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Jani Nikula <jani.nikula@intel.com>
Subject: linux-next: manual merge of the drm tree with the  tree
Message-Id: <20140108125055.13f06eee25e1ee0765d61d05@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__8_Jan_2014_12_50_55_+1100_4LdPLHt8cbBN+HN9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__8_Jan_2014_12_50_55_+1100_4LdPLHt8cbBN+HN9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/intel_display.c between commit be505f643925 ("Revert
"drm/i915: assume all GM45 Acer laptops use inverted backlight PWM"")
from the drm-intel-fixes tree and commit bc0bb9fd1c78 ("drm/i915: remove
QUIRK_NO_PCH_PWM_ENABLE") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_display.c
index 769b864465a9,0bb3d6d596d9..000000000000
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@@ -10541,25 -10731,11 +10731,20 @@@ static struct intel_quirk intel_quirk=
s[
  	/* Sony Vaio Y cannot use SSC on LVDS */
  	{ 0x0046, 0x104d, 0x9076, quirk_ssc_force_disable },
 =20
 -	/*
 -	 * All GM45 Acer (and its brands eMachines and Packard Bell) laptops
 -	 * seem to use inverted backlight PWM.
 -	 */
 -	{ 0x2a42, 0x1025, PCI_ANY_ID, quirk_invert_brightness },
 +	/* Acer Aspire 5734Z must invert backlight brightness */
 +	{ 0x2a42, 0x1025, 0x0459, quirk_invert_brightness },
 +
 +	/* Acer/eMachines G725 */
 +	{ 0x2a42, 0x1025, 0x0210, quirk_invert_brightness },
 +
 +	/* Acer/eMachines e725 */
 +	{ 0x2a42, 0x1025, 0x0212, quirk_invert_brightness },
 +
 +	/* Acer/Packard Bell NCL20 */
 +	{ 0x2a42, 0x1025, 0x034b, quirk_invert_brightness },
 +
 +	/* Acer Aspire 4736Z */
 +	{ 0x2a42, 0x1025, 0x0260, quirk_invert_brightness },
-=20
- 	/* Dell XPS13 HD Sandy Bridge */
- 	{ 0x0116, 0x1028, 0x052e, quirk_no_pcm_pwm_enable },
- 	/* Dell XPS13 HD and XPS13 FHD Ivy Bridge */
- 	{ 0x0166, 0x1028, 0x058b, quirk_no_pcm_pwm_enable },
  };
 =20
  static void intel_init_quirks(struct drm_device *dev)

--Signature=_Wed__8_Jan_2014_12_50_55_+1100_4LdPLHt8cbBN+HN9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSzK8DAAoJEMDTa8Ir7ZwV36wP/R/xzb6mqKyYTg2noS+1OFFQ
8LY5OG4BCb1skxg0VhA4w0LK5XEW+eggEkIJfMk7TieQ4aWEUh1z1yZEmglOura5
nfsPjIG8Mt2wrFmGy8bWCoFTqjh4tlABrk+3dbVCJ8A0s7mzHF1cnHJIkJm6nWaQ
p0FYAPXWHiHiE/dwDR1vdv5GtqBe5jqpBtavOhOXDgGLYwwzz4wtzuOnw+qNaRhm
aD10okYYYty4o8Jo07gp8Y/lkJ8zCxAG+DJuRXqoD69Dsm5tqh0iWGd9dE89cCyD
KJ8fQjS0RzRI8LabjhhSSkNWViu06+ZUAxWXIPjHJYC2eOQwl/zmL93/ebthil8r
8RXOPE/2dDHiPEiIZvupRAbXuAxvniqmYCUhD8QprQt4fFpvjWeeztuqrbkxenNv
uQgoQUGrptlUOrcWLJkNRbzya8bEUx47q/9Xwj7JVqTft5jBFwN8e7roXJ8z7I56
ypkkiRM62h5YETGYjUgwpOA6kWmZQZdW3vwzR/coDxg0tMKtpJ/9uIx+hSoaV8PM
Se8QOH937EJ1XIK0H3Jn7/trDBIz7tpb7uY//Umm9pCOzi9i9vFkwDX/SKdqUNd/
ZLFOAVeD1QGU/FlMRYG7cOaUaQNfQ/lf2fsdLsfCZp3zAvQXoKi1Mc8enn3F/gqQ
/ra4Q+BfITt+aqSfS+Ib
=zo6b
-----END PGP SIGNATURE-----

--Signature=_Wed__8_Jan_2014_12_50_55_+1100_4LdPLHt8cbBN+HN9--
