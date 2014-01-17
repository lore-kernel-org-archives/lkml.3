Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaAQDJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 22:09:04 -0500
Received: from ozlabs.org ([203.10.76.45]:53465 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbaAQDJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 22:09:01 -0500
Date: Fri, 17 Jan 2014 14:08:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>
Subject: linux-next: manual merge of the devicetree tree with the arm-soc
 tree
Message-Id: <20140117140853.6faf2c053617c5e66648526f@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Jan_2014_14_08_53_+1100_YBo_8wUFf.az//3o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Jan_2014_14_08_53_+1100_YBo_8wUFf.az//3o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the devicetree tree got a conflict in
arch/arm/boot/dts/dove.dtsi between commits 40aad3c1a9b6 ("dt/bindings:
Remove all references to device_type "ethernet-phy"") and b31b32119abe
("ARM: dove: sort DT nodes by address") from the devicetree tree and
commit 351291754df3 ("dt/bindings: remove device_type "network"
references") from the devicetree tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/dove.dtsi
index 8de1031233ae,39ffabe04cc5..000000000000
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@@ -170,224 -192,34 +170,222 @@@
  				status =3D "disabled";
  			};
 =20
 -			gpio0: gpio-ctrl@d0400 {
 -				compatible =3D "marvell,orion-gpio";
 -				#gpio-cells =3D <2>;
 -				gpio-controller;
 -				reg =3D <0xd0400 0x20>;
 -				ngpios =3D <32>;
 +			spi1: spi-ctrl@14600 {
 +				compatible =3D "marvell,orion-spi";
 +				#address-cells =3D <1>;
 +				#size-cells =3D <0>;
 +				cell-index =3D <1>;
 +				interrupts =3D <5>;
 +				reg =3D <0x14600 0x28>;
 +				clocks =3D <&core_clk 0>;
 +				status =3D "disabled";
 +			};
 +
 +			mbusc: mbus-ctrl@20000 {
 +				compatible =3D "marvell,mbus-controller";
 +				reg =3D <0x20000 0x80>, <0x800100 0x8>;
 +			};
 +
 +			bridge_intc: bridge-interrupt-ctrl@20110 {
 +				compatible =3D "marvell,orion-bridge-intc";
  				interrupt-controller;
 -				#interrupt-cells =3D <2>;
 -				interrupts =3D <12>, <13>, <14>, <60>;
 +				#interrupt-cells =3D <1>;
 +				reg =3D <0x20110 0x8>;
 +				interrupts =3D <0>;
 +				marvell,#interrupts =3D <5>;
  			};
 =20
 -			gpio1: gpio-ctrl@d0420 {
 -				compatible =3D "marvell,orion-gpio";
 -				#gpio-cells =3D <2>;
 -				gpio-controller;
 -				reg =3D <0xd0420 0x20>;
 -				ngpios =3D <32>;
 +			intc: main-interrupt-ctrl@20200 {
 +				compatible =3D "marvell,orion-intc";
  				interrupt-controller;
 -				#interrupt-cells =3D <2>;
 -				interrupts =3D <61>;
 +				#interrupt-cells =3D <1>;
 +				reg =3D <0x20200 0x10>, <0x20210 0x10>;
  			};
 =20
 -			gpio2: gpio-ctrl@e8400 {
 -				compatible =3D "marvell,orion-gpio";
 -				#gpio-cells =3D <2>;
 -				gpio-controller;
 -				reg =3D <0xe8400 0x0c>;
 -				ngpios =3D <8>;
 +			timer: timer@20300 {
 +				compatible =3D "marvell,orion-timer";
 +				reg =3D <0x20300 0x20>;
 +				interrupt-parent =3D <&bridge_intc>;
 +				interrupts =3D <1>, <2>;
 +				clocks =3D <&core_clk 0>;
 +			};
 +
 +			crypto: crypto-engine@30000 {
 +				compatible =3D "marvell,orion-crypto";
 +				reg =3D <0x30000 0x10000>,
 +				      <0xffffe000 0x800>;
 +				reg-names =3D "regs", "sram";
 +				interrupts =3D <31>;
 +				clocks =3D <&gate_clk 15>;
 +				status =3D "okay";
 +			};
 +
 +			ehci0: usb-host@50000 {
 +				compatible =3D "marvell,orion-ehci";
 +				reg =3D <0x50000 0x1000>;
 +				interrupts =3D <24>;
 +				clocks =3D <&gate_clk 0>;
 +				status =3D "okay";
 +			};
 +
 +			ehci1: usb-host@51000 {
 +				compatible =3D "marvell,orion-ehci";
 +				reg =3D <0x51000 0x1000>;
 +				interrupts =3D <25>;
 +				clocks =3D <&gate_clk 1>;
 +				status =3D "okay";
 +			};
 +
 +			xor0: dma-engine@60800 {
 +				compatible =3D "marvell,orion-xor";
 +				reg =3D <0x60800 0x100
 +				       0x60a00 0x100>;
 +				clocks =3D <&gate_clk 23>;
 +				status =3D "okay";
 +
 +				channel0 {
 +					interrupts =3D <39>;
 +					dmacap,memcpy;
 +					dmacap,xor;
 +				};
 +
 +				channel1 {
 +					interrupts =3D <40>;
 +					dmacap,memcpy;
 +					dmacap,xor;
 +				};
 +			};
 +
 +			xor1: dma-engine@60900 {
 +				compatible =3D "marvell,orion-xor";
 +				reg =3D <0x60900 0x100
 +				       0x60b00 0x100>;
 +				clocks =3D <&gate_clk 24>;
 +				status =3D "okay";
 +
 +				channel0 {
 +					interrupts =3D <42>;
 +					dmacap,memcpy;
 +					dmacap,xor;
 +				};
 +
 +				channel1 {
 +					interrupts =3D <43>;
 +					dmacap,memcpy;
 +					dmacap,xor;
 +				};
 +			};
 +
 +			sdio1: sdio-host@90000 {
 +				compatible =3D "marvell,dove-sdhci";
 +				reg =3D <0x90000 0x100>;
 +				interrupts =3D <36>, <38>;
 +				clocks =3D <&gate_clk 9>;
 +				pinctrl-0 =3D <&pmx_sdio1>;
 +				pinctrl-names =3D "default";
 +				status =3D "disabled";
 +			};
 +
 +			eth: ethernet-ctrl@72000 {
 +				compatible =3D "marvell,orion-eth";
 +				#address-cells =3D <1>;
 +				#size-cells =3D <0>;
 +				reg =3D <0x72000 0x4000>;
 +				clocks =3D <&gate_clk 2>;
 +				marvell,tx-checksum-limit =3D <1600>;
 +				status =3D "disabled";
 +
 +				ethernet-port@0 {
- 					device_type =3D "network";
 +					compatible =3D "marvell,orion-eth-port";
 +					reg =3D <0>;
 +					interrupts =3D <29>;
 +					/* overwrite MAC address in bootloader */
 +					local-mac-address =3D [00 00 00 00 00 00];
 +					phy-handle =3D <&ethphy>;
 +				};
 +			};
 +
 +			mdio: mdio-bus@72004 {
 +				compatible =3D "marvell,orion-mdio";
 +				#address-cells =3D <1>;
 +				#size-cells =3D <0>;
 +				reg =3D <0x72004 0x84>;
 +				interrupts =3D <30>;
 +				clocks =3D <&gate_clk 2>;
 +				status =3D "disabled";
 +
 +				ethphy: ethernet-phy {
- 					device_type =3D "ethernet-phy";
 +					/* set phy address in board file */
 +				};
 +			};
 +
 +			sdio0: sdio-host@92000 {
 +				compatible =3D "marvell,dove-sdhci";
 +				reg =3D <0x92000 0x100>;
 +				interrupts =3D <35>, <37>;
 +				clocks =3D <&gate_clk 8>;
 +				pinctrl-0 =3D <&pmx_sdio0>;
 +				pinctrl-names =3D "default";
 +				status =3D "disabled";
 +			};
 +
 +			sata0: sata-host@a0000 {
 +				compatible =3D "marvell,orion-sata";
 +				reg =3D <0xa0000 0x2400>;
 +				interrupts =3D <62>;
 +				clocks =3D <&gate_clk 3>;
 +				phys =3D <&sata_phy0>;
 +				phy-names =3D "port0";
 +				nr-ports =3D <1>;
 +				status =3D "disabled";
 +			};
 +
 +			sata_phy0: sata-phy@a2000 {
 +				compatible =3D "marvell,mvebu-sata-phy";
 +				reg =3D <0xa2000 0x0334>;
 +				clocks =3D <&gate_clk 3>;
 +				clock-names =3D "sata";
 +				#phy-cells =3D <0>;
 +				status =3D "ok";
 +			};
 +
 +			audio0: audio-controller@b0000 {
 +				compatible =3D "marvell,dove-audio";
 +				reg =3D <0xb0000 0x2210>;
 +				interrupts =3D <19>, <20>;
 +				clocks =3D <&gate_clk 12>;
 +				clock-names =3D "internal";
 +				status =3D "disabled";
 +			};
 +
 +			audio1: audio-controller@b4000 {
 +				compatible =3D "marvell,dove-audio";
 +				reg =3D <0xb4000 0x2210>;
 +				interrupts =3D <21>, <22>;
 +				clocks =3D <&gate_clk 13>;
 +				clock-names =3D "internal";
 +				status =3D "disabled";
 +			};
 +
 +			thermal: thermal-diode@d001c {
 +				compatible =3D "marvell,dove-thermal";
 +				reg =3D <0xd001c 0x0c>, <0xd005c 0x08>;
 +			};
 +
 +			gate_clk: clock-gating-ctrl@d0038 {
 +				compatible =3D "marvell,dove-gating-clock";
 +				reg =3D <0xd0038 0x4>;
 +				clocks =3D <&core_clk 0>;
 +				#clock-cells =3D <1>;
 +			};
 +
 +			pmu_intc: pmu-interrupt-ctrl@d0050 {
 +				compatible =3D "marvell,dove-pmu-intc";
 +				interrupt-controller;
 +				#interrupt-cells =3D <1>;
 +				reg =3D <0xd0050 0x8>;
 +				interrupts =3D <33>;
 +				marvell,#interrupts =3D <7>;
  			};
 =20
  			pinctrl: pin-ctrl@d0200 {

--Signature=_Fri__17_Jan_2014_14_08_53_+1100_YBo_8wUFf.az//3o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS2J7KAAoJEMDTa8Ir7ZwVHrwP/0wKrJINmIjVLXeVXsTHnWJv
B2z+z0N0tbRqj+GUg3vmdc5XVlBR/U5Jy1RR4STGaf5C8xucnQUDCASfvjy1mUwi
HaZKBAD5Pi1Z7XCU8RlA9e5BZ9rEpwyHWcDH+lj9AHiUg5J8IfLpJ5AERlFiIMR5
NlhNbwh6HvonnuvLimIbspa40G5lEi5chyZzf9XzRcxtCTafpX8ijsIvtnTJVnz3
nkFTjLs9eR5BCsD6nADAhKPdePMhAZcXzyX/AuT6OZ/aoDHMm4iqe7XqLNa0n4Az
G1ksq/hNbpqyv068IHstzo5DDdzMzyrVWB9gEer9AUJvZXFA7iiqE2zcX0pDGmpQ
BApNI06NvHDRUqgUFzi/9TdqrA7ntKJifIJMqgPjf4SUAyVmZ1hmRZdgMsdsB5+H
cIP8t5HU0i0Fwu214tQkwjDCWopQDD/kMOT6+rjgAD4jEp3ssDLlkd3xxUjA3tLt
tapRZ+cD3qMg+3S1kzh2Ka6DBM0tLAzMEc28EQ6iy6vBsJF13SnwIYmzzJbDbvXu
51XOTRGfsrh0EVLtozUab5jkVWx26OwlpoDsuNxERRey9KcSJbyHgJqkbKCzBMj5
gqLkR6zfa8tOS4o3OKD4bfhy8NgNpK9WJRzrnz3zW4bQLWYSkT6N2w31h0MwtWXW
rC+xBBVM6paZliE1u9Ou
=mPvD
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Jan_2014_14_08_53_+1100_YBo_8wUFf.az//3o--
