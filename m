Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbaBLNSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 08:18:17 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47500 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaBLNSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 08:18:15 -0500
Message-ID: <52FB748E.6050007@ti.com>
Date: Wed, 12 Feb 2014 15:18:06 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoph Fritz <chf.fritz@googlemail.com>, Tero Kristo <t-kristo@ti.com>
CC: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pali.rohar@gmail.com>, <pavel@ucw.cz>,
        Nishanth Menon <nm@ti.com>
Subject: Re: OMAP: clock DT conversion issues with omap36xx
References: <52E697C0.6000202@gmail.com> <1390848104.4936.62.camel@mars>	 <52E772A3.4090401@ti.com> <1390901735.2963.8.camel@lovely>	 <52E77D03.8090001@ti.com>  <52E7B361.2030601@ti.com>	 <1390928565.4904.88.camel@mars> <1390994505.5023.32.camel@mars>	 <52F10C3D.7000507@ti.com> <1391767923.4937.110.camel@mars>
In-Reply-To: <1391767923.4937.110.camel@mars>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="naJErNOHp52oiM9lXVV8990NTjKkoVllD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--naJErNOHp52oiM9lXVV8990NTjKkoVllD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Tero, Christoph,

On 07/02/14 12:12, Christoph Fritz wrote:
> On Tue, 2014-02-04 at 17:50 +0200, Tero Kristo wrote:
>> On 01/29/2014 01:21 PM, Christoph Fritz wrote:
>>>> Currently I only analyzed sys_clkout2 (see attachments for full
>>>> clk_summary files):
>>>>
>>>> clk_summary__next-20140115__works_as_expected:
>>>>               dpll4_m2_ck        1           1            96000000
>>>>                  dpll4_m2x2_ck   1           1            96000000
>>>>                     omap_192m_alwon_fck 1           1            960=
00000
>>>>                        omap_96m_alwon_fck 1           2            9=
6000000
>>>>                           per_96m_fck 0           6            96000=
000
>>>>                              mcbsp4_fck 0           1            960=
00000
>>>>                              mcbsp3_fck 0           2            960=
00000
>>>>                              mcbsp2_fck 0           2            960=
00000
>>>>                           cm_96m_fck 2           3            960000=
00
>>>>                              clkout2_src_ck 1           1           =
 96000000
>>>>                                 sys_clkout2 1           1           =
 24000000
>>>>
>>>> For real, on pin sys_clkout2 are correctly 24 Mhz measured.
>>>>
>>>> clk_summary__next-20140124__sysclkout2_dss_fails:
>>>>               dpll4_m2_ck        1           1            96000000
>>>>                  dpll4_m2x2_mul_ck 1           1            19200000=
0
>>>>                     dpll4_m2x2_ck 1           1            192000000=

>>>>                        omap_192m_alwon_fck 0           0            =
192000000
>>>>                        omap_96m_alwon_fck 1           2            1=
92000000
>>>>                           per_96m_fck 0           6            19200=
0000
>>>>                              mcbsp4_fck 0           1            192=
000000
>>>>                              mcbsp3_fck 0           2            192=
000000
>>>>                              mcbsp2_fck 0           2            192=
000000
>>>>                           cm_96m_fck 2           3            192000=
000
>>>>                              clkout2_src_ck 1           1           =
 192000000
>>>>                                 sys_clkout2 1           1           =
 24000000
>>>>
>>>> For real, on pin sys_clkout2 are only ~12 Mhz measured.
>>
>> Hey Christoph,
>>
>> I had a chance to look at this in more detail, and it looks like your =

>> patch above was almost the correct one (except that I think you modifi=
ed=20
>> wrong property and also modified the clock node for all omap3 variants=
=2E)=20
>> Can you give this one a shot? Can you also send me the clk-summary dum=
p=20
>> with this patch (with the relevant nodes)?
>=20
>              dpll4_m2_ck        1           1            96000000   0
>                 dpll4_m2x2_mul_ck 1           1            192000000  0=

>                    dpll4_m2x2_ck 1           1            192000000  0
>                       omap_192m_alwon_fck 0           0            1920=
00000  0
>                       omap_96m_alwon_fck 1           2            96000=
000   0
>                          per_96m_fck 0           6            96000000 =
  0
>                             mcbsp4_fck 0           1            9600000=
0   0
>                             mcbsp3_fck 0           2            9600000=
0   0
>                             mcbsp2_fck 0           2            9600000=
0   0
>                          cm_96m_fck 2           3            96000000  =
 0
>                             clkout2_src_ck 1           1            960=
00000   0
>                                sys_clkout2 1           1            240=
00000   0
>=20
> Yes, your patch fixes the issues for sys_clkout2. Thanks! If you want,
> you can add my:
> Tested-by: Christoph Fritz <chf.fritz@googlemail.com>
>=20
> Below is my clock fix for dss:
>=20
> From b90a62128068e1b6b0ba2a11c5cc0c8e587cf301 Mon Sep 17 00:00:00 2001
> From: Christoph Fritz <chf.fritz@googlemail.com>
> Date: Fri, 7 Feb 2014 10:51:15 +0100
> Subject: [PATCH] ARM: dts: omap36xx: fix dpll4_m4_ck tree

Ookay, I finally got Beagle xM working with DSS DT. So, to summarize the
problem: DPLL4 on omap3630 is a Type B DPLL. Type B DPLL does not have
x2 multiplier like other DPLLs. Afaik, DPLL4 on 3630 is the only Type B
DPLL on OMAP3 SoCs.

Tero's patch fixed 96m clock, which comes from dpll4_m2, by adding an
extra /2 divider to that clock path. So the 96m clock first gets
mutiplied by 2, even though the HW doesn't do that, and then divided by
2, even though the HW doesn't do that.

Christoph's patch fixes DSS fclk, which comes from dpll4_m4, by skipping
the x2 clock nodes totally, which is much better. However, it leaves the
old x2 clock nodes there, and when dpll4_m4 clock rate changes (as it
does when omapdss sets the fclk), the unused x2 clocks do recalcs,
breaking everything. This last bit is a bit guesswork, I didn't actually
verify it, but the fact is that if I remove the x2 clocks totally,
omapdss work fine.

Sooo... What should be done is create new DPLL4 clock paths for
OMAP3630, which do not have the x2 clocks at all. I tried to do that,
but it wasn't trivial (at least to me who is not so familiar with the
clock data in DT).

However, I hacked together the patch below, which "fixes" the issue for
96m and dss fclk. It sets the clock parents so that the x2 clocks are
skipped, and makes the x2 clock nodes compatible with "unused", making
them effectively disappear. I only verified dss fclk, so Christoph, can
you verify the 96m clock?

 Tomi

=46rom ab29f9a3a43d95cdf06421bd9f29c4d7418f37de Mon Sep 17 00:00:00 2001
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Date: Wed, 12 Feb 2014 15:07:03 +0200
Subject: [PATCH] HACK: OMAP3630: fix for 96m and dss fclks

---
 arch/arm/boot/dts/omap36xx-clocks.dtsi | 26 ++++++++++++++++++++++++++
 arch/arm/boot/dts/omap36xx.dtsi        |  2 +-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap36xx-clocks.dtsi
b/arch/arm/boot/dts/omap36xx-clocks.dtsi
index 2fcf253b677c..9fe91ebf41fd 100644
--- a/arch/arm/boot/dts/omap36xx-clocks.dtsi
+++ b/arch/arm/boot/dts/omap36xx-clocks.dtsi
@@ -70,6 +70,32 @@
 	};
 };

+/* HACK to skip x2 multiplier for 96m clock */
+&omap_96m_alwon_fck {
+	clocks =3D <&dpll4_m2_ck>;
+};
+
+&dpll4_m2x2_mul_ck {
+	compatible =3D "unused";
+};
+
+&dpll4_m2x2_ck {
+	compatible =3D "unused";
+};
+
+/* HACK to skip x2 multiplier for dss clock */
+&dss1_alwon_fck_3430es2 {
+	clocks =3D <&dpll4_m4_ck>;
+};
+
+&dpll4_m4x2_mul_ck {
+	compatible =3D "unused";
+};
+
+&dpll4_m4x2_ck {
+	compatible =3D "unused";
+};
+
 &cm_clockdomains {
 	dpll4_clkdm: dpll4_clkdm {
 		compatible =3D "ti,clockdomain";
diff --git a/arch/arm/boot/dts/omap36xx.dtsi
b/arch/arm/boot/dts/omap36xx.dtsi
index 7e8dee9175d6..5e1bcd06a996 100644
--- a/arch/arm/boot/dts/omap36xx.dtsi
+++ b/arch/arm/boot/dts/omap36xx.dtsi
@@ -52,7 +52,7 @@
 	};
 };

-/include/ "omap36xx-clocks.dtsi"
 /include/ "omap34xx-omap36xx-clocks.dtsi"
 /include/ "omap36xx-omap3430es2plus-clocks.dtsi"
 /include/ "omap36xx-am35xx-omap3430es2plus-clocks.dtsi"
+/include/ "omap36xx-clocks.dtsi"
--=20
1.8.3.2




--naJErNOHp52oiM9lXVV8990NTjKkoVllD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS+3SOAAoJEPo9qoy8lh717xAP/RaxFictaN8ysTllLEHro2Jf
n1JgIAomibFSMUFKc1BEl+NHcyUUjYOuvyKItAp6K6+rS5QzL1S3Toz1+cetr74e
fTl/WJl7Dr1BUi+CHnxUQAnsvdnqbH0pQFqTVOPEodQfXrbkSbMA2SwqoccKtFMu
gn3ekkG4o4ttM2OvFFB0dr6VIU9UtCYVxdefnITsNx4fbp8VjwjjAFJ2EoDXG6hu
FwAc5yh8UkPbUydp99vzGmBVptaP0uvW/I0EBRVbgcPmuNT6G/ogpantjezSztne
JerlAjGZv2ZKwDyKen8+PxzVwspRea5meRkkw1o2V8YWmaZ20+itwsJ17tpEvao4
wrGF1CqqV2zlrQ9XJZYQyLCrBZsJYtRziacSxVDum+VmeOKaBLvBjitTZCP1Sh2s
R5NNKu/ax603Tj+g+VABLv0Q2VLHS0P9AcdlhHzZ7EFshepqrC3CnISv2rmj+rt0
YkYKHUsWYHMEbS3ueq5Uqo4xJcPlUNBCPaBkQ6S7BtN+9/piMMvIAnGXUZ/6U84g
AyMMOZ70GP8N4w4H0JpHXdFlBO7zpHCTcRWwq5PL9bux1gdvhCsIMceutCJFsP2a
+HGiaftK9xWPUYLC8d6INKt7CqlSivnILnCpX1qsjnQIIB7eODxu8XJAEyKPKyfM
3CVU/cpdaHFlGh8D8v3E
=wHl7
-----END PGP SIGNATURE-----

--naJErNOHp52oiM9lXVV8990NTjKkoVllD--
