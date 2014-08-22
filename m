Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaHVT5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 15:57:36 -0400
Received: from ozlabs.org ([103.22.144.67]:35332 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbaHVT5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 15:57:35 -0400
Date: Sat, 23 Aug 2014 05:57:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>, Felipe Balbi <balbi@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
Subject: linux-next: manual merge of the usb-gadget tree with the
 usb-gadget-fixes tree
Message-ID: <20140823055723.1bbfe099@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/rc0cu0JvMw0tHyCs4nlw.GE"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/rc0cu0JvMw0tHyCs4nlw.GE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
drivers/usb/phy/phy-samsung-usb.h between commit bbc66e140bab ("usb:
phy: samsung: Fix wrong bit mask for PHYPARAM1_PCS_TXDEEMPH") from the
usb-gadget-fixes tree and commit 0dafc3d94596 ("usb: phy: samsung:
Remove unnecessary lines of register bit definitions") from the
usb-gadget tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/phy/phy-samsung-usb.h
index 80eedd45a20a,4eef45555971..000000000000
--- a/drivers/usb/phy/phy-samsung-usb.h
+++ b/drivers/usb/phy/phy-samsung-usb.h
@@@ -215,8 -185,7 +185,7 @@@
  #define PHYPARAM0_REF_LOSLEVEL			(0x9 << 26)
 =20
  #define EXYNOS5_DRD_PHYPARAM1			(0x20)
-=20
 -#define PHYPARAM1_PCS_TXDEEMPH_MASK		(0x1f << 0)
 +#define PHYPARAM1_PCS_TXDEEMPH_MASK		(0x3f << 0)
  #define PHYPARAM1_PCS_TXDEEMPH			(0x1c)
 =20
  #define EXYNOS5_DRD_PHYTERM			(0x24)

--Sig_/rc0cu0JvMw0tHyCs4nlw.GE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT96CoAAoJEMDTa8Ir7ZwVqfwP/2B8DG6SFvJO0GuOxEo7YnOS
p3JUf9ss/k5AV0cG6/t29mOVNcpmOHOXFnG+FdjNuMD7evlGKZAnTWejho93J9qn
rCc7Vlfd1sd1TWIowUY9R5eWft+jxwktusBRkX3fzTYwWml4M/S3TClWjH+BeqWs
5De8/fFnoYyI3+A0AAxQMThP4juJxUwXNl5Y1xec+Ow9VeSTPCbqdzz1lsNuZlUb
g92rX7UxN94wuUDnlpzqyQLqEKVv+Zqjw501Gd4u/VW+uF/ZHvFMDnVIEfbjxthI
fKlDKygA6XfbZQBRl6pqvS/yU7aGidkdXzQ8zzPJueaauSvnOQmWAkzZxhyJWtU4
ADdctDHL/AIIaetnM8t/s9xF7+ZoFPqqByuv+a451W76ddcYkLZh/jcKkL88Df+L
X1ET0YyoAgFfBqqgwFRbqo1/hj2aAu69GNkE5exG21ytgrXQ+n//e6wizvZQ7FTw
5/2wC2TnHry+dl5/hHWImIY8t/aSJffHUXvV3HOBnNM/hYvcOFmfRObgR+w5avW3
o9yyjcpV1foloQe16M+QmShTYOcrarH68pnPX81v25szDDvVnL4jLPi52IILisU8
5rY45c7LQwVIbBz5oUz6w0dCkK79O+8tJBEShjUItf5eAdJiLxyOi1XXjtTjFYay
wE+4bfpts3/ftbx+tWXv
=vKZ3
-----END PGP SIGNATURE-----

--Sig_/rc0cu0JvMw0tHyCs4nlw.GE--
