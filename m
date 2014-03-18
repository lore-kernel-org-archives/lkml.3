Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbaCRGLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 02:11:10 -0400
Received: from ozlabs.org ([203.10.76.45]:39367 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaCRGLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 02:11:07 -0400
Date: Tue, 18 Mar 2014 17:10:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: linux-next: manual merge of the staging tree with the arm-soc tree
Message-Id: <20140318171059.a1134a2c670e1b18847f98d0@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__18_Mar_2014_17_10_59_+1100_YJ_Oe62b8_MZoce8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Mar_2014_17_10_59_+1100_YJ_Oe62b8_MZoce8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
Documentation/devicetree/bindings/iio/adc/at91_adc.txt between commit
b5303ffbcf11 ("Documentation: dt: iio: improve atmel-adc documentation")
from the arm-soc tree and commit 1a5b7d41f8f6 ("iio: at91: document ADC
clock properties") from the staging tree.

[This file is renamed from
Documentation/devicetree/bindings/arm/atmel-adc.txt in the arm-soc tree.]

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/devicetree/bindings/iio/adc/at91_adc.txt
index 82061c7e4fea,9a1175b46f49..000000000000
--- a/Documentation/devicetree/bindings/iio/adc/at91_adc.txt
+++ b/Documentation/devicetree/bindings/iio/adc/at91_adc.txt
@@@ -5,7 -5,10 +5,10 @@@ Required properties
      <chip> can be "at91sam9260", "at91sam9g45" or "at91sam9x5"
    - reg: Should contain ADC registers location and length
    - interrupts: Should contain the IRQ line for the ADC
+   - clock-names: tuple listing input clock names.
+ 	Required elements: "adc_clk", "adc_op_clk".
+   - clocks: phandles to input clocks.
 -  - atmel,adc-channels-used: Bitmask of the channels muxed and enable for=
 this
 +  - atmel,adc-channels-used: Bitmask of the channels muxed and enabled fo=
r this
      device
    - atmel,adc-startup-time: Startup Time of the ADC in microseconds as
      defined in the datasheet
@@@ -41,14 -44,19 +44,16 @@@ Optional trigger Nodes
 =20
  Examples:
  adc0: adc@fffb0000 {
 +	#address-cells =3D <1>;
 +	#size-cells =3D <0>;
  	compatible =3D "atmel,at91sam9260-adc";
  	reg =3D <0xfffb0000 0x100>;
 -	interrupts =3D <20 4>;
 +	interrupts =3D <20 IRQ_TYPE_LEVEL_HIGH 0>;
+ 	clocks =3D <&adc_clk>, <&adc_op_clk>;
+ 	clock-names =3D "adc_clk", "adc_op_clk";
 -	atmel,adc-channel-base =3D <0x30>;
  	atmel,adc-channels-used =3D <0xff>;
 -	atmel,adc-drdy-mask =3D <0x10000>;
 -	atmel,adc-num-channels =3D <8>;
  	atmel,adc-startup-time =3D <40>;
 -	atmel,adc-status-register =3D <0x1c>;
 -	atmel,adc-trigger-register =3D <0x08>;
 -	atmel,adc-use-external;
 +	atmel,adc-use-external-triggers;
  	atmel,adc-vref =3D <3300>;
  	atmel,adc-res =3D <8 10>;
  	atmel,adc-res-names =3D "lowres", "highres";

--Signature=_Tue__18_Mar_2014_17_10_59_+1100_YJ_Oe62b8_MZoce8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJ+N3AAoJEMDTa8Ir7ZwVwaIQAIkmgkAPlpGxDsn/CaWlisl6
g3qxxDYbyWaInlxSmVUFusXIejeyfmJdLNxr7qa6jXO8PWEFrg68CNN4kPgukYse
8CidKcSjBq7adbkozAsbPFNcDxh4XdOU869uoMXD85UMSzM6nC4Bq42b+WcA/qLE
V4eh22WRX3iFeuIQSWAlCPsVQ3AmLpbSEOpoe0GlhyxxpcDsqMlo8q0ikTeg19NE
5HuLW0VxdYysrIGwNdzyrM7S4yoyyJclIKG/Qyi3phGoF2aEEeWghv1acGfJyCz+
G+lPcfsgs66YKMJ5996ZvFbCAamrv8IQ+V9qZ9+dKoPmS7n9K9xK1HNS7F/wAiiz
HcF/nvMTu7+ymZDq+C4+xJRrPWKZEO7dyUSYHZMlBCVu52MwsOmK0IxG2AqD8WYA
esurYhrqCVi0zorNI/cictI0YoXRqDHmajv5/yDzzo8sjJBZ8y+Uu1EA7GZWBQDm
CB6TRJbZq31Rb1/ySqKrnQI5rlpZfMx4a4ogV295wsgFHc9S7iR7K6utVkEW7K8E
nBg/ZUrqtvc99cdGvkotHaf5AdZIwaY+ISDXaoD4wsZMJmNpwuduEyzo7u+u1667
piP7L0PrbLhtwB5AR0HO60Aq+Pzu2jLEu4VCLL8MesLdsN2zNQ/pQM/nDLvoqGZL
KSwhKUQocctBUT+BQZ1z
=/JqS
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Mar_2014_17_10_59_+1100_YJ_Oe62b8_MZoce8--
