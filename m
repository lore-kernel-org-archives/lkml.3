Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142AbaK1GRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 01:17:13 -0500
Received: from ozlabs.org ([103.22.144.67]:43005 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbaK1GRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 01:17:11 -0500
Date: Fri, 28 Nov 2014 17:17:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Jackson <Andrew.Jackson@arm.com>
Subject: linux-next: manual merge of the tty tree with the devicetree tree
Message-ID: <20141128171704.1e0dbd96@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/3aKPvnQ8rCAG_bb8nrEuFPR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/3aKPvnQ8rCAG_bb8nrEuFPR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
Documentation/devicetree/bindings/serial/pl011.txt between commit
a81a6c654bbe ("ARM: dt: fix up PL011 device tree bindings") from the
devicetree tree and commit 98267d33e2da ("serial: pl011: Add device
tree support for RX DMA polling") from the tty tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/devicetree/bindings/serial/pl011.txt
index 52464918cfe2,0e05340055e1..000000000000
--- a/Documentation/devicetree/bindings/serial/pl011.txt
+++ b/Documentation/devicetree/bindings/serial/pl011.txt
@@@ -6,34 -6,17 +6,39 @@@ Required properties
  - interrupts: exactly one interrupt specifier
 =20
  Optional properties:
 -- pinctrl:		When present, must have one state named "sleep"
 -			and one state named "default"
 -- clocks:		When present, must refer to exactly one clock named
 -			"apb_pclk"
 -- dmas:			When present, may have one or two dma channels.
 -			The first one must be named "rx", the second one
 -			must be named "tx".
 +- pinctrl: When present, must have one state named "default",
 +	   and may contain a second name named "sleep". The former
 +	   state sets up pins for ordinary operation whereas
 +	   the latter state will put the associated pins to sleep
 +	   when the UART is unused
 +- clocks:  When present, the first clock listed must correspond to
 +	   the clock named UARTCLK on the IP block, i.e. the clock
 +	   to the external serial line, whereas the second clock
 +	   must correspond to the PCLK clocking the internal logic
 +	   of the block. Just listing one clock (the first one) is
 +	   deprecated.
 +- clocks-names: When present, the first clock listed must be named
 +	   "uartclk" and the second clock listed must be named
 +	   "apb_pclk"
 +- dmas:	   When present, may have one or two dma channels.
 +	   The first one must be named "rx", the second one
 +	   must be named "tx".
+ - auto-poll:		Enables polling when using RX DMA.
+ - poll-rate-ms:		Rate at which poll occurs when auto-poll is set,
+ 			default 100ms.
+ - poll-timeout-ms:	Poll timeout when auto-poll is set, default
+ 			3000ms.
 =20
  See also bindings/arm/primecell.txt
 +
 +Example:
 +
 +uart@80120000 {
 +	compatible =3D "arm,pl011", "arm,primecell";
 +	reg =3D <0x80120000 0x1000>;
 +	interrupts =3D <0 11 IRQ_TYPE_LEVEL_HIGH>;
 +	dmas =3D <&dma 13 0 0x2>, <&dma 13 0 0x0>;
 +	dma-names =3D "rx", "tx";
 +	clocks =3D <&foo_clk>, <&bar_clk>;
 +	clock-names =3D "uartclk", "apb_pclk";
 +};

--Sig_/3aKPvnQ8rCAG_bb8nrEuFPR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUeBNkAAoJEMDTa8Ir7ZwVMIwP/iHDxM5DZi1Lq7iuMBKTUpgD
/QZyOnFp1yKEdl/bZh8UAGDiMrszTzpqkd1G9mluLASLmN+alFCrx+z4iKPjhWWF
Ks8UUIHNZhzV74EJVTExsMOT5gh+6GuaqBP1r6y+ZzlYHbGNGehWpRiegcTCAcTe
vpJtCxCIIVr4r36uoXGPj8cAV9KzOEG1C+BBdd8OZGNK3cPWjuKohAprbuCXNet8
KOtSHRsNg4lrYhBChV1nRYtnyHuSHBatY4biblF3OYVSg4JtewPqoSXuVTuUUWQA
NAPGY9hCNrcHgOCQJbUE7lftEXXjPXxxGWV7sWNp+Wf9WYoWhPTclOy+9XVRRYIx
oC98qvvWSuwkJcMouyUwpPH7otoPMyJlIdXp9MvtpRsP0ijeNFkJoOhYywSW++qh
HIWxAhx+20w698GX4jUROJB7fJvXoznOrH0o/OfTHTqps9NwpJf6Q+qoRK2GASQC
P5QsqDPgj5wF3DubiRg1FmhaQ9HGCnLKu7oGOH5CkDN3iFHB10NPK4kU41wZuTJg
XPXMYI+X5EQBHM9Y65qzkM9DJ9Azk/KvHdd0B12Mxeu3sXrVzn9bd4dhXweaLhQ6
A1rtxugGrwlGxtI3V3FUO4jaBe5LiiBSB37vlLOz1viQECJIq7yaiCFJ0iwXQxCU
vn116JAJZRiSg5WRR1QD
=lSe7
-----END PGP SIGNATURE-----

--Sig_/3aKPvnQ8rCAG_bb8nrEuFPR--
