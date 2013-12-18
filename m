Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242Ab3LRFxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:53:46 -0500
Received: from ozlabs.org ([203.10.76.45]:34404 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab3LRFxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:53:44 -0500
Date: Wed, 18 Dec 2013 16:53:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Peter Chen <peter.chen@freescale.com>
Subject: linux-next: manual merge of the usb tree with the usb.current tree
Message-Id: <20131218165337.b4ed157d1c013d1eaaf2c218@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__18_Dec_2013_16_53_37_+1100_3.p55qv8hBmKbhhQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Dec_2013_16_53_37_+1100_3.p55qv8hBmKbhhQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/host/ohci-at91.c between commit fb5f1834c322 ("usb:
ohci-at91: fix irq and iomem resource retrieval") from the usb.current
tree and commit 3c9740a117d4 ("usb: hcd: move controller wakeup setting
initialization to individual driver") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/host/ohci-at91.c
index 8c356af79409,29d2093e3cee..000000000000
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@@ -203,9 -199,11 +203,11 @@@ static int usb_hcd_at91_probe(const str
  	ohci->num_ports =3D board->ports;
  	at91_start_hc(pdev);
 =20
 -	retval =3D usb_add_hcd(hcd, pdev->resource[1].start, IRQF_SHARED);
 +	retval =3D usb_add_hcd(hcd, irq, IRQF_SHARED);
- 	if (retval =3D=3D 0)
+ 	if (retval =3D=3D 0) {
+ 		device_wakeup_enable(hcd->self.controller);
  		return retval;
+ 	}
 =20
  	/* Error handling */
  	at91_stop_hc(pdev);

--Signature=_Wed__18_Dec_2013_16_53_37_+1100_3.p55qv8hBmKbhhQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSsThlAAoJEMDTa8Ir7ZwVYV0P/2pZjmoOADGoHcYedKqQ4CiR
8GgbY0jydCCOPG2peKmCAvIwXzzUl2HxudpvTu3xq4f6XM1giTjVRTatLSrlaNDz
M8S3A62nhRwu15zv5DMMZYbSaMWS8vtHmGDLKQwL8DO+A6KNjQe8RMohIMWuENcl
4gkqGznNpGAlEcNQxTnrkcX9htidiAIbAnhy2xJxuXuqqvorsWmuV8MFlEL+Q91m
uszd+1ijFFkI05dhU50S+PlKBQBnXFkWIBNB97xa1i7/vwRpJTXjg6r7v0ADmXZ8
pj+hmPWNeWz/MEylW6Ry3tWsLetjG8uzR36H/pOcBoPK0BbmxyTeoQZrUtRm41pS
waC6RRn0xsTbHvb37cgeqKct6CuqHrLci8Aya9S3hJh3uirMZz5sGxIzZ4afb2ng
KuWorhygqlCU2WE9pmT9RyfPYuXhdNaRWq7CRWDLtcU4BFwPPg6IrS39dhJRNvg6
X6KQHJb5D+PX4ROnwdzCkuaQqrokHf5DoyfJW9v0ylAuhb/29gJbZno5I/B81v4a
DaisPr8oYT+nz91zB/z8sSj4JwnxRth7IqZHbOgzRwxCeKuuVDp4feCrBupajgDP
MSRKLQo98O+KhWv2/3d/XKw0zqubmzCGYM2Y9+j6EpXda1EkQi8cjqJ47NikPiRN
19WmuI5LlRzKcRQIsAPq
=fcuX
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Dec_2013_16_53_37_+1100_3.p55qv8hBmKbhhQ--
