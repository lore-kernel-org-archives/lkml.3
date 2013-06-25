Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab3FYGxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 02:53:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50013 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab3FYGxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 02:53:22 -0400
Date: Tue, 25 Jun 2013 16:53:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: linux-next: manual merge of the usb tree with the devicetree tree
Message-Id: <20130625165310.161dafbc62ab505ecbfc3cd3@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Jun_2013_16_53_10_+1000_lgSrwy+IObQI2sdG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Jun_2013_16_53_10_+1000_lgSrwy+IObQI2sdG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/chipidea/Makefile between commit 8973ba8b325f ("usb:
chipidea: depend on CONFIG_OF instead of CONFIG_OF_DEVICE") from the
devicetree tree and commit 8e22978c5708 ("usb: chipidea: drop "13xxx"
infix") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/chipidea/Makefile
index 4113feb,3bbbcba..0000000
--- a/drivers/usb/chipidea/Makefile
+++ b/drivers/usb/chipidea/Makefile
@@@ -13,9 -13,9 +13,9 @@@ obj-$(CONFIG_USB_CHIPIDEA)	+=3D ci_hdrc_m
 =20
  # PCI doesn't provide stubs, need to check
  ifneq ($(CONFIG_PCI),)
- 	obj-$(CONFIG_USB_CHIPIDEA)	+=3D ci13xxx_pci.o
+ 	obj-$(CONFIG_USB_CHIPIDEA)	+=3D ci_hdrc_pci.o
  endif
 =20
 -ifneq ($(CONFIG_OF_DEVICE),)
 +ifneq ($(CONFIG_OF),)
- 	obj-$(CONFIG_USB_CHIPIDEA)	+=3D ci13xxx_imx.o usbmisc_imx.o
+ 	obj-$(CONFIG_USB_CHIPIDEA)	+=3D ci_hdrc_imx.o usbmisc_imx.o
  endif

--Signature=_Tue__25_Jun_2013_16_53_10_+1000_lgSrwy+IObQI2sdG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRyT5bAAoJEECxmPOUX5FET2sP/3KfhrT+LvvUz0dXUNkJfqB5
J4Wzr81x0Pfkj9WtQdEtAclyeZpAm5p3r4T2WwsySuXWxd9SnXCYue0IdKQXpda8
IY5s1Gk1wo2jN9jsKTLbUZphHN2HLU2LZ31eUtmQGMqRtKKYJ1HWh/gCkEb2F4AH
N3w2gqmNYadCoAy2hQ/fjyZe3KzWUSP7uY7IyQ3UiiMqMv4VmwPxOyafDs66Dcqp
9sp8c8TzGNdzJQgwFwnVwUhLP8msTC4bB7bCu0MhtVO1hW4D68QM03IYI/dvRl9Y
Z+X+0PGiSbQkbceBg+uIQLdQpOCQ/269X+DtJuJE037peDrup2O9OUMuCZcPssmy
9qH/vxVAaqfbQ+NZ5yIPK6wKJLot2l4zb8TnlqZyk+RWcIMDFwnFCqET0XTt+QjK
PvtqfA4DTUj07u1Rvk8rwhqJkdAVqJxLqRQmxhGwNaywchWeu0pRXDIheHcB/IFn
qU4Kt/47xUG9tEZFEOKZebv22GiY94QFat+jN+mFN/Haqvbdm8/vpifNrrocEdf3
Kn/QojNsN9/YJk7JiFSTCQabmsiVl3u+NIHyepuBHx3TzumDoUmMoNhVpV+Ggp+M
L3/fqwbNYejRIqzg1d/B7GWg8cmabJQvbwBRqh1kiPNO73nUqErPV6LNFSStnDix
Vk2uLBwzwh4A3tKfyzkM
=eBac
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Jun_2013_16_53_10_+1000_lgSrwy+IObQI2sdG--
