Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbaEIBl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 21:41:58 -0400
Received: from ozlabs.org ([103.22.144.67]:39253 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbaEIBl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 21:41:57 -0400
Date: Fri, 9 May 2014 11:41:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petri Gynther <pgynther@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: linux-next: manual merge of the bluetooth tree with Linus' tree
Message-ID: <20140509114149.30c2c1c1@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/LzreT9ZAet5wlOu2Zhc=/LG"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/LzreT9ZAet5wlOu2Zhc=/LG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Gustavo,

Today's linux-next merge of the bluetooth tree got a conflict in
drivers/bluetooth/btusb.c between commit 3c49aa852e00 ("Revert
"Bluetooth: Enable autosuspend for Intel Bluetooth device"") from
Linus' tree and commit 10d4c6736ea6 ("Bluetooth: btusb: Add Broadcom
patch RAM support") from the bluetooth tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/bluetooth/btusb.c
index a7dfbf9a3afb,8f579cd9bbaf..000000000000
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@@ -1486,8 -1635,13 +1636,11 @@@ static int btusb_probe(struct usb_inter
  	if (id->driver_info & BTUSB_BCM92035)
  		hdev->setup =3D btusb_setup_bcm92035;
 =20
+ 	if (id->driver_info & BTUSB_BCM_PATCHRAM)
+ 		hdev->setup =3D btusb_setup_bcm_patchram;
+=20
 -	if (id->driver_info & BTUSB_INTEL) {
 -		usb_enable_autosuspend(data->udev);
 +	if (id->driver_info & BTUSB_INTEL)
  		hdev->setup =3D btusb_setup_intel;
 -	}
 =20
  	/* Interface numbers are hardcoded in the specification */
  	data->isoc =3D usb_ifnum_to_if(data->udev, 1);

--Sig_/LzreT9ZAet5wlOu2Zhc=/LG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTbDJiAAoJEMDTa8Ir7ZwV8xwP/3jBWYzkbNSt5CsauDoT2g+s
pIx45Xnh8ENaEmhyWzJxhp/EijhQAvWdSgaiAqdTv4wQh6p8EA3E4UZjyHPM8/RI
aayvvrs7bg4pRTfnOIxCt16Gj1j1MkP/vSsa9zXjFyUrBbCa3jqiLDJLuW5SlrYo
waiwaK273Ff04+WCDaVqYA3IYAZQViUILiPt4TPqcCY/O/KIE6TCIICzBoxZ455k
C54EeOzaVWNtU9w+dV2t1heeTi9ezKaihJGVcq7zLN7cfd9/2TV8HZyaO65KdgwQ
OEt9FG8bLXkuAmlFPH1Y1FUSry639nVxNBDZVu+JnnHNiFK7d/nA+kyJYvaad7nq
pFAECGTOHQOQahxvXSyNOem4IBTygE/D4xtRuumUvZST/crOurLOjCll6OyO+PLf
rrHMjWDej8mipirlvwK48qmO3G7ZdqtZ+tz0br5gLzyDoLChudVEdmwmic/6h+I6
A0l94qUGWLQfjJRO+bFFbgzJxE8Racsv9nW6r7SdLmqpedjsz6fUmk9UE0RsUUbz
6L7/BQ0WEEmjINZfiB0UtqrXH7ISoUA/feZMriOTDpuwKJBZiK913E2v2xFu/Aig
wVg0TO8ZGVoJPF/u9fDl2xKzMDUvaGqZS3SjBcVWrzpH9ggeWXzMBhO9A08p/F6s
VkHDPgOmh5c8Mxzy92BZ
=JknW
-----END PGP SIGNATURE-----

--Sig_/LzreT9ZAet5wlOu2Zhc=/LG--
