Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab3DXH4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 03:56:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54274 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab3DXH4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 03:56:11 -0400
Date: Wed, 24 Apr 2013 17:56:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: linux-next: build failure after merge of the final tree (staging
 tree related))
Message-Id: <20130424175600.df4a7e5307ea813e3afe73ea@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__24_Apr_2013_17_56_00_+1000_xUAKuiKs4HWxLd8D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Apr_2013_17_56_00_+1000_xUAKuiKs4HWxLd8D
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/staging/comedi/drivers/ni_labpc.c: In function 'labpc_ai_cmd':
drivers/staging/comedi/drivers/ni_labpc.c:980:9: error: implicit declaratio=
n of function 'virt_to_bus' [-Werror=3Dimplicit-function-declaration]

Probably caused by commit fa3cb2191091 ("staging: comedi: ni_labpc: split
out PCI support").

I have disabled this driver for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 24 Apr 2013 17:52:15 +1000
Subject: [PATCH] staging: comedi: disable building ni_labpc.c

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/comedi/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index 7871579..f6569fd 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -488,6 +488,7 @@ config COMEDI_NI_LABPC_ISA
 	tristate "NI Lab-PC and compatibles ISA support"
 	select COMEDI_NI_LABPC
 	depends on VIRT_TO_BUS
+	depends on BROKEN
 	---help---
 	  Enable support for National Instruments Lab-PC and compatibles
 	  Lab-PC-1200, Lab-PC-1200AI, Lab-PC+.
@@ -1024,6 +1025,7 @@ config COMEDI_NI_LABPC_PCI
 	tristate "NI Lab-PC PCI-1200 support"
 	select COMEDI_NI_LABPC
 	select COMEDI_MITE
+	depends on BROKEN
 	---help---
 	  Enable support for National Instruments Lab-PC PCI-1200.
=20
@@ -1151,6 +1153,7 @@ config COMEDI_NI_DAQ_DIO24_CS
 config COMEDI_NI_LABPC_CS
 	tristate "NI DAQCard-1200 PCMCIA support"
 	select COMEDI_NI_LABPC
+	depends on BROKEN
 	---help---
 	  Enable support for the National Instruments PCMCIA DAQCard-1200
=20
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__24_Apr_2013_17_56_00_+1000_xUAKuiKs4HWxLd8D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRd5AQAAoJEECxmPOUX5FEZAQP/0oxMZULzEp/BP0+VcvxFxqH
vaAP5AIqISP3r6qv/4ZSiyXOzY6LCo0mxKWOSXTzQg9O2OiN37B5v8yZaeMLcDb7
aQiYQritsjzUQZsdPBwejJxoWv96r8ksat9vY/cYXexUHs+4V+EQEHtKbEhOm39w
4AHThagHFbOxrlnN7O/tT5DcCyTmuARlSrGeGwetaqSAn5vzjPUfavTOIkDdCtmg
M5oqe121MNeC/+PTS3/fRwy25hqj5szQEt4Zvm+W5UuX9HC+sp3FCgxrsWD0LI63
gWbhZNKg36pXKzWNNy9dTXMazx7Je0C0JTL1J9rlTJrqCA+60J9V5OB1Yr2vGHZ1
PnIUwDC1bvdDFvZF45Gx0BhD6WF3FKPHgWm7BWuvIHHO40vEmF/UxWvYoFv7vu0i
7bEESJU0nvPq4hclaln1TQIqzfxdnfoUPOtMig0xVqM1rXbNhhGkeTZ1hojdiYOL
7HdXgc1bV2OaplFCNfiqC0aN9srNn+33XhzZtEVb/rBAtZ0iQ+E0FhGauVxpMmCv
pbZbTnqbiIKo8FjnHMjaJ+XITYyb4vHq6yoytw67d6NNCCa4m6GIX2IRVW7UKzQr
f30c0vAbnesk3Ok+XMHJ/fdub0cXBoFqePTRnueq+UJgjG0tcenh5kP7cGtPpFPR
4yGCvavhrzdZnhBmzQka
=Zxpz
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Apr_2013_17_56_00_+1000_xUAKuiKs4HWxLd8D--
