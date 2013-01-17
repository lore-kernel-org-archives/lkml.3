Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab3AQCEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:04:33 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51840 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab3AQCEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:04:32 -0500
Date: Thu, 17 Jan 2013 13:04:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: linux-next: manual merge of the tty tree with Linus' tree
Message-Id: <20130117130423.63a5e1004942853bf6a49e56@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__17_Jan_2013_13_04_23_+1100_orS2AKMBsVDkVbHD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Jan_2013_13_04_23_+1100_orS2AKMBsVDkVbHD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/staging/sb105x/Kconfig between commit db210312f77b ("staging:
Make SystemBase PCI Multiport UART only for x86") from the  tree and
commit e27a7d7977b0 ("Staging: sb105x: mark it BROKEN") from the tty tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/sb105x/Kconfig
index 1facad6,3d0d0eb..0000000
--- a/drivers/staging/sb105x/Kconfig
+++ b/drivers/staging/sb105x/Kconfig
@@@ -1,8 -1,7 +1,8 @@@
  config SB105X
  	tristate "SystemBase PCI Multiport UART"
  	select SERIAL_CORE
- 	depends on PCI
+ 	depends on PCI && BROKEN
 +	depends on X86
  	help
  	  A driver for the SystemBase Multi-2/PCI serial card
 =20

--Signature=_Thu__17_Jan_2013_13_04_23_+1100_orS2AKMBsVDkVbHD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ91wnAAoJEECxmPOUX5FEVlEQAJSy/9HZqpQ7AjjwP57uBksS
3AKQKF+gsS3JWuj96N0YYEFWEvyIxHz3XCAaV2X3nuznyv/OJK/LuIDb94QhqJiw
0uNJW9OnoUtoThBmeTvsRwyWW6DKHvX6oAFNHE5nTm4aGhNrYgXRF+FObRRiW8CC
ybLUKlaYzkIbW/brwPk1WTZnQ8cxAGo0UZq74pf42bERDrh1IrHW/BqTaYsQCWkV
m2lNGZU66Q365lx0VF0P+FjbhfsNBlhyVTWcgEaQ3pk4pPuFoaXvjfCBMu56H8jD
k/FzLHOg9Ar22eCF4OagWiuPNeSISN8vfs9Js7p4WIS9tQ36wtdFDXtJD8hZ1YZ4
RTkz2Y5mDMGYkwief9brtbPDmjM0h2C8d3iuW7N3hTi7WqLBjfsHc02PUMXYe8yU
cZCHY5q+IQ0nwui4sH5LCB8oHrmhfP02nDm2+10FP/B9mXMqsdKHtOfr45UrylYC
8VpKXwAbWXtAVrAvan+9hrM9IPv0H8DmN12FLvA0xBL74i4nGFdrRI3UXBCoMBNH
KxBNHCDuf4pkivKzo/sfOPfmo6IuEhNMtfJDUTw5ST5WVwqmO5g52daB7VuNnZCP
2W+gZqbt5duQjPr0Lv06WbkZwrc2xmgWTuMMvP+PauokCooFa8c7CZ1lifpQs3Nc
FxxY0kL3Eq3sdEGTAkSz
=8puR
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Jan_2013_13_04_23_+1100_orS2AKMBsVDkVbHD--
