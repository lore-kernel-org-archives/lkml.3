Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbaLCBMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:12:48 -0500
Received: from ozlabs.org ([103.22.144.67]:38060 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaLCBMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:12:47 -0500
Date: Wed, 3 Dec 2014 12:12:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: linux-next: manual merge of the pm tree with the arm tree
Message-ID: <20141203121235.3eabd77b@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/LonQYs_zs168hu1tVxmAx+d"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/LonQYs_zs168hu1tVxmAx+d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the pm tree got a conflict in
include/linux/pm_runtime.h between commit 3fb1581ea1ab ("ARM: 8199/1:
PM / Runtime: Add getter for querying the IRQ safe option v12") from
the arm tree and commit 6d14dd40f550 ("PM: Drop CONFIG_PM_RUNTIME from
the driver core") from the pm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/pm_runtime.h
index 44d74f0f182e,eda4feede048..000000000000
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@@ -128,12 -118,14 +118,19 @@@ static inline void pm_runtime_mark_last
  	ACCESS_ONCE(dev->power.last_busy) =3D jiffies;
  }
 =20
 +static inline bool pm_runtime_is_irq_safe(struct device *dev)
 +{
 +	return dev->power.irq_safe;
 +}
 +
- #else /* !CONFIG_PM_RUNTIME */
+ #else /* !CONFIG_PM */
+=20
+ static inline bool queue_pm_work(struct work_struct *work) { return false=
; }
+=20
+ static inline int pm_generic_runtime_suspend(struct device *dev) { return=
 0; }
+ static inline int pm_generic_runtime_resume(struct device *dev) { return =
0; }
+ static inline int pm_runtime_force_suspend(struct device *dev) { return 0=
; }
+ static inline int pm_runtime_force_resume(struct device *dev) { return 0;=
 }
 =20
  static inline int __pm_runtime_idle(struct device *dev, int rpmflags)
  {

--Sig_/LonQYs_zs168hu1tVxmAx+d
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUfmOKAAoJEMDTa8Ir7ZwV2FkP/jWWhNV/qM9TpsahBq4x+MZC
ufFE8DVbgOJOFo0nAj5HBi8hyrWHwnm7kdGjQ0f79cz2Y2/KnMPvFW+UTa2fIYac
Abd7j6QNLsilSvB/0Z2azf+wPwawRYH/FJvfYulR86dGFDkTGBtyD6QCq4MpSd82
rRvFUo1kZOeeORI15wIhtV8qP2Y4oDf2sMnY/6SN8PO3rYw1LdHo+sNRK2krFMZb
+ToirmTqRPQiMwecc7AezlTsrxRylAYa7/S8mTI0n6mKPQ7LWpy9DYd1oueIwX7L
cJXidaMuHtuT9S7V/1O3zffwMsfUHes02FPplptNQkdJV3XAPSZNMsYRxgmcu318
ZYPBC9oJjS4upi1bhpDNGRYq1ftraDu/m4OjUMnw3uv7C3evhapvGeVO3ElJHpHH
IJCmtyZHCYt3ajT8eTM22T8qhJ5iwsWmloemikB9xbXUfu1c2QPD/6f82141XBUo
JbJbqI9L1yPZY7QZDCIKeNrPcD5SsMt5S/MfHpieSGRRV+WPRju7opekqEwOwXp0
cmzwuW3Eh6uvYcGLtoQL7SGkgaU1tRhcbQwEarfbkQwv43auDagY2hME89kOYSyx
PqzJBrQvR8gHcykxJ83x9wIDw84oNWweCHoCzh5OeRsCni9sMmxPq6SdqWIW7cdd
tql27gq4ElDDXn2VMlf3
=jRj0
-----END PGP SIGNATURE-----

--Sig_/LonQYs_zs168hu1tVxmAx+d--
