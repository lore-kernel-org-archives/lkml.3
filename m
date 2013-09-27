Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319Ab3I0D0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 23:26:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48356 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3I0D0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 23:26:52 -0400
Date: Fri, 27 Sep 2013 13:26:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: linux-next: manual merge of the bluetooth tree with the wireless
 tree
Message-Id: <20130927132644.3aca01f917f0bf569a0a6942@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Sep_2013_13_26_44_+1000_F+KQUFT+vX09Za3n"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Sep_2013_13_26_44_+1000_F+KQUFT+vX09Za3n
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Gustavo,

Today's linux-next merge of the bluetooth tree got a conflict in
net/bluetooth/hci_core.c between commit 5e130367d43f ("Bluetooth:
Introduce a new HCI_RFKILLED flag") from the wireless tree and commit
0736cfa8e5bb ("Bluetooth: Introduce user channel flag for HCI devices")
from the bluetooth tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

P.S. that closing brace is badly indented :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/bluetooth/hci_core.c
index 1b66547,3d9f02b..0000000
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@@ -1570,13 -1642,13 +1646,16 @@@ static int hci_rfkill_set_block(void *d
 =20
  	BT_DBG("%p name %s blocked %d", hdev, hdev->name, blocked);
 =20
+ 	if (test_bit(HCI_USER_CHANNEL, &hdev->dev_flags))
+ 		return -EBUSY;
+=20
 -	if (!blocked)
 -		return 0;
 -
 -	hci_dev_do_close(hdev);
 +	if (blocked) {
 +		set_bit(HCI_RFKILLED, &hdev->dev_flags);
 +		if (!test_bit(HCI_SETUP, &hdev->dev_flags))
 +			hci_dev_do_close(hdev);
 +	} else {
 +		clear_bit(HCI_RFKILLED, &hdev->dev_flags);
 +}
 =20
  	return 0;
  }

--Signature=_Fri__27_Sep_2013_13_26_44_+1000_F+KQUFT+vX09Za3n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSRPr4AAoJEMDTa8Ir7ZwV7isQAI3zj4yOz1d1LT/QrBV8ng12
CJKw2iog0ZSN5cQfHf+PVt/VP9rk8Xe/b1wa5rRWIzvlvaAHnCsfABnfjK+IREQx
6/ub6+cz8CgqAWTUvVFoT11/QyijEKg+VvS/3ddVFmKORU/dwYa+Sh8/PyCVusti
7XYOVZTvI/fVgUYv5INLmNIws8brmSvqqBght55TV0y4TDUgXVZV27ma6IVNwJN9
PVEYhnw4S5YVdmJYZdPXqJcrHOib+fi9bC41jg2MdoOsW+qERCQO1+Q01dQFxbA5
P7V4kgVMC6S6y3gaAgnQNF9IRUCxApE/i97wP4JRFzkBLVtZ4wS+4gpPJ2X9jHTT
5G20npGeuPACWHPokXq6Iw45GxiXYfemoRe+N2Cx2D5GbT2PFaWrjT5gNGmJukUU
UkzkRLN4pgtDEIGl7Mx83vAdCczh9D37NzxRCX8PmsH/bGNmZ5VOrtB3W6reAle1
9zqrr4fBxb/6lz3RI5/8KbkZB5fGZT3W9zzAy4zD9I5gToUMCjMzsz264L3+bnIG
tyPNuqLsBYqSz5BliFf4SagAuAL72D6rotdarcUSsDvvx9oE6/oTCKF5umFzDvoM
qLg52xVs98tJrtJ4GitJDvJ8ErCfmMBI6vfQEtiw5gzgJ/HixDapYGp/7Ws9J5li
nyIe4R7lbCWwRCqm39ni
=BYBn
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Sep_2013_13_26_44_+1000_F+KQUFT+vX09Za3n--
