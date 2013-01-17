Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318Ab3AQCHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:07:42 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56508 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757707Ab3AQCHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:07:41 -0500
Date: Thu, 17 Jan 2013 13:07:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: linux-next: manual merge of the tty tree with the tty.current tree
Message-Id: <20130117130738.b3d750f70143792e9471063c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__17_Jan_2013_13_07_38_+1100_Zc=BaTFQeYHRr_nP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Jan_2013_13_07_38_+1100_Zc=BaTFQeYHRr_nP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/tty/serial/8250/8250_dw.c between commit 68e56cb3a068 ("tty:
8250_dw: Fix inverted arguments to serial_out in IRQ handler") from the
tty.current tree and commit 30046df26187 ("serial: 8250_dw: Set FIFO size
dynamically") from the tty tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/tty/serial/8250/8250_dw.c
index 096d2ef,117bb8b..0000000
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@@ -78,8 -104,8 +104,8 @@@ static int dw8250_handle_irq(struct uar
  		return 1;
  	} else if ((iir & UART_IIR_BUSY) =3D=3D UART_IIR_BUSY) {
  		/* Clear the USR and write the LCR again. */
- 		(void)p->serial_in(p, UART_USR);
+ 		(void)p->serial_in(p, DW_UART_USR);
 -		p->serial_out(p, d->last_lcr, UART_LCR);
 +		p->serial_out(p, UART_LCR, d->last_lcr);
 =20
  		return 1;
  	}

--Signature=_Thu__17_Jan_2013_13_07_38_+1100_Zc=BaTFQeYHRr_nP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ91zqAAoJEECxmPOUX5FEiiEQAJA6Nh0Q3PxHNDuAGpGo9dgv
7DKvJmyRTEdKlm5ZtOsNNOXmtMI+1d01W9aYNDtLMnjGI1/V/2/S4PlaqGpda5Nh
fQrhan2oF6Y+gdm2VyC4W1gokiNgk1vc/By/oEOXyre2eVMY/xa8C3ws9mp6Nizw
milEhD9p9spR3RRNycUEUiDtl6bOYN44y0vunfSMZLSZ0ZTR2JJRUxpJdxFRzWtw
/zw7Fse4rs69mqgZ+WGMbOUqULfVs5HJO+WdcQg0TKjBe+BRGxoZiQukprX0vtgo
reDWXN/VA/2GJe/buLzWmZQssWorlEGc1lWlQWTY6PCG1aihXNFr5kveNPP8zJ1O
kVcAwtI+/qcr1nuPFLtEcwinCETQSCazMRV5+VplWyxLwSqK1FNA72JBBQQCTPwH
mPP15H58gAntQt6G3n5XOqUC4Q6RdP8q/SVgpZix68mDBScF7WUgDR5SHWlFqbAj
w1ArS0K/owMnocEzg5T9K1FnmsfVybSm+rOBTI+DkZ92bVMZiGsYVxiQyxxtYAjg
BRf64mdBbbIFFfrFEQmTigMrEoxDVnjjtJYct8JdQ20qBYB92HG0DSTyaN4L0DPV
dz+8+z5ErhVktompX9FeAWBJAKzhXSd5kDXJpNjAL15R8DQ57UdlJYmhJevqpu//
yvtKzKjvTK4Pzua13R1K
=R9fI
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Jan_2013_13_07_38_+1100_Zc=BaTFQeYHRr_nP--
