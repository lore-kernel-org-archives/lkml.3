Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaJBElW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 00:41:22 -0400
Received: from ozlabs.org ([103.22.144.67]:44987 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbaJBElU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 00:41:20 -0400
Date: Thu, 2 Oct 2014 14:41:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tanmay Inamdar <tinamdar@apm.com>, Feng Kan <fkan@apm.com>
Subject: linux-next: manual merge of the crypto tree with the pci tree
Message-ID: <20141002144113.2e1d92a8@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Nb5t_uRT+n03JH575uBFZE0"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Nb5t_uRT+n03JH575uBFZE0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

Today's linux-next merge of the crypto tree got a conflict in
arch/arm64/boot/dts/apm-storm.dtsi between commit 84ac1f2ca41f ("arm64:
dts: Add APM X-Gene PCIe device tree nodes") from the pci tree and
commit ab81873974af ("arm64: dts: add random number generator dts node
to APM X-Gene platform") from the crypto tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm64/boot/dts/apm-storm.dtsi
index 403197a0e621,f391972ad135..000000000000
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@@ -270,170 -270,18 +270,183 @@@
  				clock-output-names =3D "rtcclk";
  			};
 =20
+ 			rngpkaclk: rngpkaclk@17000000 {
+ 				compatible =3D "apm,xgene-device-clock";
+ 				#clock-cells =3D <1>;
+ 				clocks =3D <&socplldiv2 0>;
+ 				reg =3D <0x0 0x17000000 0x0 0x2000>;
+ 				reg-names =3D "csr-reg";
+ 				csr-offset =3D <0xc>;
+ 				csr-mask =3D <0x10>;
+ 				enable-offset =3D <0x10>;
+ 				enable-mask =3D <0x10>;
+ 				clock-output-names =3D "rngpkaclk";
+ 			};
++
 +			pcie0clk: pcie0clk@1f2bc000 {
 +				status =3D "disabled";
 +				compatible =3D "apm,xgene-device-clock";
 +				#clock-cells =3D <1>;
 +				clocks =3D <&socplldiv2 0>;
 +				reg =3D <0x0 0x1f2bc000 0x0 0x1000>;
 +				reg-names =3D "csr-reg";
 +				clock-output-names =3D "pcie0clk";
 +			};
 +
 +			pcie1clk: pcie1clk@1f2cc000 {
 +				status =3D "disabled";
 +				compatible =3D "apm,xgene-device-clock";
 +				#clock-cells =3D <1>;
 +				clocks =3D <&socplldiv2 0>;
 +				reg =3D <0x0 0x1f2cc000 0x0 0x1000>;
 +				reg-names =3D "csr-reg";
 +				clock-output-names =3D "pcie1clk";
 +			};
 +
 +			pcie2clk: pcie2clk@1f2dc000 {
 +				status =3D "disabled";
 +				compatible =3D "apm,xgene-device-clock";
 +				#clock-cells =3D <1>;
 +				clocks =3D <&socplldiv2 0>;
 +				reg =3D <0x0 0x1f2dc000 0x0 0x1000>;
 +				reg-names =3D "csr-reg";
 +				clock-output-names =3D "pcie2clk";
 +			};
 +
 +			pcie3clk: pcie3clk@1f50c000 {
 +				status =3D "disabled";
 +				compatible =3D "apm,xgene-device-clock";
 +				#clock-cells =3D <1>;
 +				clocks =3D <&socplldiv2 0>;
 +				reg =3D <0x0 0x1f50c000 0x0 0x1000>;
 +				reg-names =3D "csr-reg";
 +				clock-output-names =3D "pcie3clk";
 +			};
 +
 +			pcie4clk: pcie4clk@1f51c000 {
 +				status =3D "disabled";
 +				compatible =3D "apm,xgene-device-clock";
 +				#clock-cells =3D <1>;
 +				clocks =3D <&socplldiv2 0>;
 +				reg =3D <0x0 0x1f51c000 0x0 0x1000>;
 +				reg-names =3D "csr-reg";
 +				clock-output-names =3D "pcie4clk";
 +			};
 +		};
 +
 +		pcie0: pcie@1f2b0000 {
 +			status =3D "disabled";
 +			device_type =3D "pci";
 +			compatible =3D "apm,xgene-storm-pcie", "apm,xgene-pcie";
 +			#interrupt-cells =3D <1>;
 +			#size-cells =3D <2>;
 +			#address-cells =3D <3>;
 +			reg =3D < 0x00 0x1f2b0000 0x0 0x00010000   /* Controller registers */
 +				0xe0 0xd0000000 0x0 0x00040000>; /* PCI config space */
 +			reg-names =3D "csr", "cfg";
 +			ranges =3D <0x01000000 0x00 0x00000000 0xe0 0x10000000 0x00 0x00010000=
   /* io */
 +				  0x02000000 0x00 0x80000000 0xe1 0x80000000 0x00 0x80000000>; /* mem=
 */
 +			dma-ranges =3D <0x42000000 0x80 0x00000000 0x80 0x00000000 0x00 0x8000=
0000
 +				      0x42000000 0x00 0x00000000 0x00 0x00000000 0x80 0x00000000>;
 +			interrupt-map-mask =3D <0x0 0x0 0x0 0x7>;
 +			interrupt-map =3D <0x0 0x0 0x0 0x1 &gic 0x0 0xc2 0x1
 +					 0x0 0x0 0x0 0x2 &gic 0x0 0xc3 0x1
 +					 0x0 0x0 0x0 0x3 &gic 0x0 0xc4 0x1
 +					 0x0 0x0 0x0 0x4 &gic 0x0 0xc5 0x1>;
 +			dma-coherent;
 +			clocks =3D <&pcie0clk 0>;
 +		};
 +
 +		pcie1: pcie@1f2c0000 {
 +			status =3D "disabled";
 +			device_type =3D "pci";
 +			compatible =3D "apm,xgene-storm-pcie", "apm,xgene-pcie";
 +			#interrupt-cells =3D <1>;
 +			#size-cells =3D <2>;
 +			#address-cells =3D <3>;
 +			reg =3D < 0x00 0x1f2c0000 0x0 0x00010000   /* Controller registers */
 +				0xd0 0xd0000000 0x0 0x00040000>; /* PCI config space */
 +			reg-names =3D "csr", "cfg";
 +			ranges =3D <0x01000000 0x0 0x00000000 0xd0 0x10000000 0x00 0x00010000 =
  /* io  */
 +				  0x02000000 0x0 0x80000000 0xd1 0x80000000 0x00 0x80000000>; /* mem =
*/
 +			dma-ranges =3D <0x42000000 0x80 0x00000000 0x80 0x00000000 0x00 0x8000=
0000
 +				      0x42000000 0x00 0x00000000 0x00 0x00000000 0x80 0x00000000>;
 +			interrupt-map-mask =3D <0x0 0x0 0x0 0x7>;
 +			interrupt-map =3D <0x0 0x0 0x0 0x1 &gic 0x0 0xc8 0x1
 +					 0x0 0x0 0x0 0x2 &gic 0x0 0xc9 0x1
 +					 0x0 0x0 0x0 0x3 &gic 0x0 0xca 0x1
 +					 0x0 0x0 0x0 0x4 &gic 0x0 0xcb 0x1>;
 +			dma-coherent;
 +			clocks =3D <&pcie1clk 0>;
 +		};
 +
 +		pcie2: pcie@1f2d0000 {
 +			status =3D "disabled";
 +			device_type =3D "pci";
 +			compatible =3D "apm,xgene-storm-pcie", "apm,xgene-pcie";
 +			#interrupt-cells =3D <1>;
 +			#size-cells =3D <2>;
 +			#address-cells =3D <3>;
 +			reg =3D  < 0x00 0x1f2d0000 0x0 0x00010000   /* Controller registers */
 +				 0x90 0xd0000000 0x0 0x00040000>; /* PCI config space */
 +			reg-names =3D "csr", "cfg";
 +			ranges =3D <0x01000000 0x0 0x00000000 0x90 0x10000000 0x0 0x00010000  =
 /* io  */
 +				  0x02000000 0x0 0x80000000 0x91 0x80000000 0x0 0x80000000>; /* mem */
 +			dma-ranges =3D <0x42000000 0x80 0x00000000 0x80 0x00000000 0x00 0x8000=
0000
 +				      0x42000000 0x00 0x00000000 0x00 0x00000000 0x80 0x00000000>;
 +			interrupt-map-mask =3D <0x0 0x0 0x0 0x7>;
 +			interrupt-map =3D <0x0 0x0 0x0 0x1 &gic 0x0 0xce 0x1
 +					 0x0 0x0 0x0 0x2 &gic 0x0 0xcf 0x1
 +					 0x0 0x0 0x0 0x3 &gic 0x0 0xd0 0x1
 +					 0x0 0x0 0x0 0x4 &gic 0x0 0xd1 0x1>;
 +			dma-coherent;
 +			clocks =3D <&pcie2clk 0>;
 +		};
 +
 +		pcie3: pcie@1f500000 {
 +			status =3D "disabled";
 +			device_type =3D "pci";
 +			compatible =3D "apm,xgene-storm-pcie", "apm,xgene-pcie";
 +			#interrupt-cells =3D <1>;
 +			#size-cells =3D <2>;
 +			#address-cells =3D <3>;
 +			reg =3D < 0x00 0x1f500000 0x0 0x00010000   /* Controller registers */
 +				0xa0 0xd0000000 0x0 0x00040000>; /* PCI config space */
 +			reg-names =3D "csr", "cfg";
 +			ranges =3D <0x01000000 0x0 0x00000000 0xa0 0x10000000 0x0 0x00010000  =
 /* io   */
 +				  0x02000000 0x0 0x80000000 0xa1 0x80000000 0x0 0x80000000>; /* mem  =
*/
 +			dma-ranges =3D <0x42000000 0x80 0x00000000 0x80 0x00000000 0x00 0x8000=
0000
 +				      0x42000000 0x00 0x00000000 0x00 0x00000000 0x80 0x00000000>;
 +			interrupt-map-mask =3D <0x0 0x0 0x0 0x7>;
 +			interrupt-map =3D <0x0 0x0 0x0 0x1 &gic 0x0 0xd4 0x1
 +					 0x0 0x0 0x0 0x2 &gic 0x0 0xd5 0x1
 +					 0x0 0x0 0x0 0x3 &gic 0x0 0xd6 0x1
 +					 0x0 0x0 0x0 0x4 &gic 0x0 0xd7 0x1>;
 +			dma-coherent;
 +			clocks =3D <&pcie3clk 0>;
 +		};
 +
 +		pcie4: pcie@1f510000 {
 +			status =3D "disabled";
 +			device_type =3D "pci";
 +			compatible =3D "apm,xgene-storm-pcie", "apm,xgene-pcie";
 +			#interrupt-cells =3D <1>;
 +			#size-cells =3D <2>;
 +			#address-cells =3D <3>;
 +			reg =3D < 0x00 0x1f510000 0x0 0x00010000   /* Controller registers */
 +				0xc0 0xd0000000 0x0 0x00200000>; /* PCI config space */
 +			reg-names =3D "csr", "cfg";
 +			ranges =3D <0x01000000 0x0 0x00000000 0xc0 0x10000000 0x0 0x00010000  =
 /* io  */
 +				  0x02000000 0x0 0x80000000 0xc1 0x80000000 0x0 0x80000000>; /* mem */
 +			dma-ranges =3D <0x42000000 0x80 0x00000000 0x80 0x00000000 0x00 0x8000=
0000
 +				      0x42000000 0x00 0x00000000 0x00 0x00000000 0x80 0x00000000>;
 +			interrupt-map-mask =3D <0x0 0x0 0x0 0x7>;
 +			interrupt-map =3D <0x0 0x0 0x0 0x1 &gic 0x0 0xda 0x1
 +					 0x0 0x0 0x0 0x2 &gic 0x0 0xdb 0x1
 +					 0x0 0x0 0x0 0x3 &gic 0x0 0xdc 0x1
 +					 0x0 0x0 0x0 0x4 &gic 0x0 0xdd 0x1>;
 +			dma-coherent;
 +			clocks =3D <&pcie4clk 0>;
  		};
 =20
  		serial0: serial@1c020000 {

--Sig_/Nb5t_uRT+n03JH575uBFZE0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJULNdtAAoJEMDTa8Ir7ZwVgGoP/2JgYHCYkrXFICTO10ZF0lDh
Fog9NzOdmGB+Ijo9Bx2QmUXLiBgZH83zUouNcoK5t7R6a76/r5emkzF4kFXS7vwh
r3iC1aK7dL5M4ErJfZdc+1onue5V/DcqlGwCavQ2+PWu9P+Ho6vsXHlhB6tQoP5S
VPQjVtsW5HQbmFUcsMdgF06U2/msVE/WIiCuiPXXqJbIBGmRyNaV5ek0igrv+lfb
xc1gvKiIoI1GU4fO2j5QxaMH1HQfxx51ShtrU+See4zGW8pHPrzSQdyrxJz+GbMI
kUNgc+Nokrtp0yv74IG0ZcNN79uz/S7dC1WOdRLJTEpP8QdXL+3YpEns0PIGg9tz
m0v1upTQOO+XY200J8LypwBikmC2OH64UtBp/6L1W6klZKgDfCF3eWD5bwcvn4Nq
pICoXe1w01yEaD145yMI2XPwYt0FET/zIIAjSvZMxYJLPo2tjNu3sFiddz6tgDmt
LsqqrfulTEMPoMeRzn2/MSlelK8GKHccYDQu1+cJ9ehC8N5tW/vFm86wwkFspZq8
lrAeIzuOJZyX2hjubDBXuFls33+TWkPcUmruds+VpIT06+Ba4VpKKvmaHjoXPIxe
rAyA0y1rKxeXjQhqUoB6uKIKWWqRPTa7vT8BZX5v6dvMPW8SxtKvMH9wtaJX8nG0
Yy9Rj9Nhn6BoTAfFXbDl
=1djS
-----END PGP SIGNATURE-----

--Sig_/Nb5t_uRT+n03JH575uBFZE0--
