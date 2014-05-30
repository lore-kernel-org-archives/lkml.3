Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaE3DiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 23:38:13 -0400
Received: from ozlabs.org ([103.22.144.67]:39879 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbaE3DiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 23:38:11 -0400
Date: Fri, 30 May 2014 13:38:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pekon Gupta <pekon@ti.com>, Sathya Prakash M R <sathyap@ti.com>
Subject: linux-next: manual merge of the omap_dss2 tree with the arm-soc
 tree
Message-ID: <20140530133804.414f6d5c@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/TME6qP4uMUtTDteN=5is9G6"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/TME6qP4uMUtTDteN=5is9G6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
arch/arm/boot/dts/am437x-gp-evm.dts between commit 99ffa6425f1b ("ARM:
dts: am437x-gp-evm: add support for parallel NAND flash") from the
arm-soc tree and commit 0186bec97131 ("ARM: dts: am437x-gp-evm: add LCD
data") from the omap_dss2 tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/am437x-gp-evm.dts
index c25d15837ce9,3acccdf258e9..000000000000
--- a/arch/arm/boot/dts/am437x-gp-evm.dts
+++ b/arch/arm/boot/dts/am437x-gp-evm.dts
@@@ -151,26 -193,46 +193,67 @@@
  		>;
  	};
 =20
 +	nand_flash_x8: nand_flash_x8 {
 +		pinctrl-single,pins =3D <
 +			0x26c(PIN_OUTPUT_PULLDOWN | MUX_MODE7)	/* spi2_cs0.gpio/eMMCorNANDsel =
*/
 +			0x0  (PIN_INPUT  | MUX_MODE0)	/* gpmc_ad0.gpmc_ad0 */
 +			0x4  (PIN_INPUT  | MUX_MODE0)	/* gpmc_ad1.gpmc_ad1 */
 +			0x8  (PIN_INPUT  | MUX_MODE0)	/* gpmc_ad2.gpmc_ad2 */
 +			0xc  (PIN_INPUT  | MUX_MODE0)	/* gpmc_ad3.gpmc_ad3 */
 +			0x10 (PIN_INPUT  | MUX_MODE0)	/* gpmc_ad4.gpmc_ad4 */
 +			0x14 (PIN_INPUT  | MUX_MODE0)	/* gpmc_ad5.gpmc_ad5 */
 +			0x18 (PIN_INPUT  | MUX_MODE0)	/* gpmc_ad6.gpmc_ad6 */
 +			0x1c (PIN_INPUT  | MUX_MODE0)	/* gpmc_ad7.gpmc_ad7 */
 +			0x70 (PIN_INPUT_PULLUP | MUX_MODE0)	/* gpmc_wait0.gpmc_wait0 */
 +			0x74 (PIN_OUTPUT_PULLUP | MUX_MODE7)	/* gpmc_wpn.gpmc_wpn */
 +			0x7c (PIN_OUTPUT | MUX_MODE0)		/* gpmc_csn0.gpmc_csn0  */
 +			0x90 (PIN_OUTPUT | MUX_MODE0)		/* gpmc_advn_ale.gpmc_advn_ale */
 +			0x94 (PIN_OUTPUT | MUX_MODE0)		/* gpmc_oen_ren.gpmc_oen_ren */
 +			0x98 (PIN_OUTPUT | MUX_MODE0)		/* gpmc_wen.gpmc_wen */
 +			0x9c (PIN_OUTPUT | MUX_MODE0)		/* gpmc_be0n_cle.gpmc_be0n_cle */
 +		>;
 +	};
++
+ 	dss_pins: dss_pins {
+ 		pinctrl-single,pins =3D <
+ 			0x020 (PIN_OUTPUT_PULLUP | MUX_MODE1) /*gpmc ad 8 -> DSS DATA 23 */
+ 			0x024 (PIN_OUTPUT_PULLUP | MUX_MODE1)
+ 			0x028 (PIN_OUTPUT_PULLUP | MUX_MODE1)
+ 			0x02c (PIN_OUTPUT_PULLUP | MUX_MODE1)
+ 			0x030 (PIN_OUTPUT_PULLUP | MUX_MODE1)
+ 			0x034 (PIN_OUTPUT_PULLUP | MUX_MODE1)
+ 			0x038 (PIN_OUTPUT_PULLUP | MUX_MODE1)
+ 			0x03c (PIN_OUTPUT_PULLUP | MUX_MODE1) /*gpmc ad 15 -> DSS DATA 16 */
+ 			0x0a0 (PIN_OUTPUT_PULLUP | MUX_MODE0) /* DSS DATA 0 */
+ 			0x0a4 (PIN_OUTPUT_PULLUP | MUX_MODE0)
+ 			0x0a8 (PIN_OUTPUT_PULLUP | MUX_MODE0)
+ 			0x0ac (PIN_OUTPUT_PULLUP | MUX_MODE0)
+ 			0x0b0 (PIN_OUTPUT_PULLUP | MUX_MODE0)
+ 			0x0b4 (PIN_OUTPUT_PULLUP | MUX_MODE0)
+ 			0x0b8 (PIN_OUTPUT_PULLUP | MUX_MODE0)
+ 			0x0bc (PIN_OUTPUT_PULLUP | MUX_MODE0)
+ 			0x0c0 (PIN_OUTPUT_PULLUP | MUX_MODE0)
+ 			0x0c4 (PIN_OUTPUT_PULLUP | MUX_MODE0)
+ 			0x0c8 (PIN_OUTPUT_PULLUP | MUX_MODE0)
+ 			0x0cc (PIN_OUTPUT_PULLUP | MUX_MODE0)
+ 			0x0d0 (PIN_OUTPUT_PULLUP | MUX_MODE0)
+ 			0x0d4 (PIN_OUTPUT_PULLUP | MUX_MODE0)
+ 			0x0d8 (PIN_OUTPUT_PULLUP | MUX_MODE0)
+ 			0x0dc (PIN_OUTPUT_PULLUP | MUX_MODE0) /* DSS DATA 15 */
+ 			0x0e0 (PIN_OUTPUT_PULLUP | MUX_MODE0) /* DSS VSYNC */
+ 			0x0e4 (PIN_OUTPUT_PULLUP | MUX_MODE0) /* DSS HSYNC */
+ 			0x0e8 (PIN_OUTPUT_PULLUP | MUX_MODE0) /* DSS PCLK */
+ 			0x0ec (PIN_OUTPUT_PULLUP | MUX_MODE0) /* DSS AC BIAS EN */
+=20
+ 		>;
+ 	};
+=20
+ 	lcd_pins: lcd_pins {
+ 		pinctrl-single,pins =3D <
+ 			/* GPIO 5_8 to select LCD / HDMI */
+ 			0x238 (PIN_OUTPUT_PULLUP | MUX_MODE7)
+ 		>;
+ 	};
  };
 =20
  &i2c0 {
@@@ -273,89 -330,16 +356,103 @@@
  	phy-mode =3D "rgmii";
  };
 =20
 +&elm {
 +	status =3D "okay";
 +};
 +
 +&gpmc {
 +	status =3D "okay";
 +	pinctrl-names =3D "default";
 +	pinctrl-0 =3D <&nand_flash_x8>;
 +	ranges =3D <0 0 0 0x01000000>;	/* minimum GPMC partition =3D 16MB */
 +	nand@0,0 {
 +		reg =3D <0 0 4>;		/* device IO registers */
 +		ti,nand-ecc-opt =3D "bch8";
 +		ti,elm-id =3D <&elm>;
 +		nand-bus-width =3D <8>;
 +		gpmc,device-width =3D <1>;
 +		gpmc,sync-clk-ps =3D <0>;
 +		gpmc,cs-on-ns =3D <0>;
 +		gpmc,cs-rd-off-ns =3D <40>;
 +		gpmc,cs-wr-off-ns =3D <40>;
 +		gpmc,adv-on-ns =3D <0>;
 +		gpmc,adv-rd-off-ns =3D <25>;
 +		gpmc,adv-wr-off-ns =3D <25>;
 +		gpmc,we-on-ns =3D <0>;
 +		gpmc,we-off-ns =3D <20>;
 +		gpmc,oe-on-ns =3D <3>;
 +		gpmc,oe-off-ns =3D <30>;
 +		gpmc,access-ns =3D <30>;
 +		gpmc,rd-cycle-ns =3D <40>;
 +		gpmc,wr-cycle-ns =3D <40>;
 +		gpmc,wait-pin =3D <0>;
 +		gpmc,wait-on-read;
 +		gpmc,wait-on-write;
 +		gpmc,bus-turnaround-ns =3D <0>;
 +		gpmc,cycle2cycle-delay-ns =3D <0>;
 +		gpmc,clk-activation-ns =3D <0>;
 +		gpmc,wait-monitoring-ns =3D <0>;
 +		gpmc,wr-access-ns =3D <40>;
 +		gpmc,wr-data-mux-bus-ns =3D <0>;
 +		/* MTD partition table */
 +		/* All SPL-* partitions are sized to minimal length
 +		 * which can be independently programmable. For
 +		 * NAND flash this is equal to size of erase-block */
 +		#address-cells =3D <1>;
 +		#size-cells =3D <1>;
 +		partition@0 {
 +			label =3D "NAND.SPL";
 +			reg =3D <0x00000000 0x00040000>;
 +		};
 +		partition@1 {
 +			label =3D "NAND.SPL.backup1";
 +			reg =3D <0x00040000 0x00040000>;
 +		};
 +		partition@2 {
 +			label =3D "NAND.SPL.backup2";
 +			reg =3D <0x00080000 0x00040000>;
 +		};
 +		partition@3 {
 +			label =3D "NAND.SPL.backup3";
 +			reg =3D <0x000c0000 0x00040000>;
 +		};
 +		partition@4 {
 +			label =3D "NAND.u-boot-spl-os";
 +			reg =3D <0x00100000 0x00080000>;
 +		};
 +		partition@5 {
 +			label =3D "NAND.u-boot";
 +			reg =3D <0x00180000 0x00100000>;
 +		};
 +		partition@6 {
 +			label =3D "NAND.u-boot-env";
 +			reg =3D <0x00280000 0x00040000>;
 +		};
 +		partition@7 {
 +			label =3D "NAND.u-boot-env.backup1";
 +			reg =3D <0x002c0000 0x00040000>;
 +		};
 +		partition@8 {
 +			label =3D "NAND.kernel";
 +			reg =3D <0x00300000 0x00700000>;
 +		};
 +		partition@9 {
 +			label =3D "NAND.file-system";
 +			reg =3D <0x00a00000 0x1f600000>;
 +		};
 +	};
 +};
++
+ &dss {
+ 	status =3D "ok";
+=20
+ 	pinctrl-names =3D "default";
+ 	pinctrl-0 =3D <&dss_pins>;
+=20
+ 	port {
+ 		dpi_out: endpoint@0 {
+ 			remote-endpoint =3D <&lcd_in>;
+ 			data-lines =3D <24>;
+ 		};
+ 	};
+ };

--Sig_/TME6qP4uMUtTDteN=5is9G6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTh/0hAAoJEMDTa8Ir7ZwVGwgP/jHNqf2XtjWTB+wnDFNHLYh7
u9pGZ2/C4cAh1FWpuXNrqZGaWfFdE9OJuu7Dj6Ah6E2R4ovfg+0H6ok3ds+U4QHA
uinqVuAYlMuWhpqdIoxAVeQZqgYfDVdjLIjqddVAn+dz5dVM55Io/7hD7RIYIBTC
MsvM+EkOQZ+tsITJGD73ywGyBbjOFq18AOSbsZzGZcPxS0KTKKTKP3pf9CYB1UjZ
AvW7vBqmM5pvzsaOqrpQJqFPrkEcYtNEwxpQnUuJ0pvzQxKBgKPClXqG6sgocWcA
OXwx9qZE6UZwE7bkk24leU31n43F6G175BNz4ll1OVVYSwV+haH8MV/cgQI0W2iJ
YiFu8g0oTYOGgRAVnXlXjZRfQ0rJ1kzqBJVhz3mmahVu4Q0r7wFeBixZkDXd7i+T
4Vit6VzvbXoyVw8givZ9Em+aaeM2B8FXRwtII0zqkjBDlrqM6f/KtHs7kl8XXfB9
15Bqa/sy00ybZmgnZcXVknU5nU3E+IDkX2dzywZ2xy3ChbCMawYY4KQ4wz7YwzQc
mvhC9PN0x9rY6IdQ/tCUW/Xs+8nRcrk8426fho4SrQFyMy5Lc7HWX3+v9vmMeZ9Z
o4kAqiNcLptaP7NRoGsSrDNHN2ixy67/3qWc3i5sltDUbEsZtoOMC6s8FXqhPJlw
b76FxUL1u1XsBTSqx30o
=Mvk8
-----END PGP SIGNATURE-----

--Sig_/TME6qP4uMUtTDteN=5is9G6--
