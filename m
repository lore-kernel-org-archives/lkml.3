Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab3A1KNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:13:21 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55668 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab3A1KNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:13:18 -0500
Date: Mon, 28 Jan 2013 21:13:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Millenbach <jmillenbach@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: linux-next: manual merge of the usb tree with the tty tree
Message-Id: <20130128211307.a235b6793587fea5e1fc5074@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Jan_2013_21_13_07_+1100_72IxzQBzoR=eMnt8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Jan_2013_21_13_07_+1100_72IxzQBzoR=eMnt8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/gadget/Kconfig between commit 4f73bc4dd3e8 ("tty: Added a
CONFIG_TTY option to allow removal of TTY") from the tty tree and commit
3249ca22c088 ("usb: gadget: u_serial: convert into a module") from the
usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/gadget/Kconfig
index a1bd951,6665d25..0000000
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@@ -750,7 -760,8 +760,9 @@@ config USB_GADGET_TARGE
 =20
  config USB_G_SERIAL
  	tristate "Serial Gadget (with CDC ACM and CDC OBEX support)"
 +	depends on TTY
+ 	select USB_U_SERIAL
+ 	select USB_F_ACM
  	select USB_LIBCOMPOSITE
  	help
  	  The Serial Gadget talks to the Linux-USB generic serial driver.

--Signature=_Mon__28_Jan_2013_21_13_07_+1100_72IxzQBzoR=eMnt8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRBk8zAAoJEECxmPOUX5FEfD4P/jBi6aYugcyauWmUcRBM4RAQ
qmjyQ+Zj0XGfNYc4m1VIKBTIq090+NSsnARBYU9DgXoJgEK7vtoiL1iPWZcwNXrn
LEsm+PHj5KDmVT9qeexKOBGKNWB7F8YNufUZ/rzSFy+lOf4X8LEOSouJkCwFXbT+
76httP7VL+qIxEXGvnAfTv/PhTWAZ992DqsuKt+NaH7cRuVUptt/XSWvbTvGXwsg
TktA+G/dnWe/StX0o3kmGqu9RwXvPCRVgC2DjQjzh5M2z/YI+MpI38syxMrRgF3+
YFMRA+90N9/B7Lw683iRZwf9YRIdkkA1KEPBcGZuWNIdiyj3Y/4GiyAQjv3JmQXT
r3xTHx4dHltxJCL0pbt8+QHFyXi6CvSF/Fd8zzI7RFaYemnUPknhyNkdySBXnp5b
xkS71zFGFfPJIQLVi6Wy2/pK29RTnCqljv2uCgA30/coLl3jQZvccg0IWmvE/r4h
/rdh3Hosmhz5sRtXUn2qn+TdFnWYGXxxEwlrW8qw21aeDMsePriaPG4ryb1yvZ9i
7Ksnx4dXPjI7Hd71KJRF2u4Nc+4nNynfKSjTkmD2zGoq0bxAXjxxqhp3KJGVD+//
Yt1I/YdannelebhovHGSeT8nIun6fDmT7SuvGy8kvMRLuJ44rwXN64DaW2i5IMMi
jNm1FHDdngg8f8Pjyh0w
=oOHc
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Jan_2013_21_13_07_+1100_72IxzQBzoR=eMnt8--
