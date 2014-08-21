Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbaHULcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:32:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552AbaHULcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:32:50 -0400
Message-ID: <53F5D8D9.7040604@suse.de>
Date: Thu, 21 Aug 2014 13:32:41 +0200
From: =?ISO-8859-1?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] ARM: zynq: DT: Add Ethernet phys
References: <1408550219-19825-1-git-send-email-soren.brinkmann@xilinx.com> <1408550219-19825-3-git-send-email-soren.brinkmann@xilinx.com> <5a7b6f57-b6c0-4fb3-af0d-d403277c0207@BN1AFFO11FD045.protection.gbl>
In-Reply-To: <5a7b6f57-b6c0-4fb3-af0d-d403277c0207@BN1AFFO11FD045.protection.gbl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="9L4BX1wv9299NkAcIqCCEtLo4B9b36p8A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9L4BX1wv9299NkAcIqCCEtLo4B9b36p8A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 21.08.2014 10:41, schrieb Michal Simek:
> On 08/20/2014 05:56 PM, Soren Brinkmann wrote:
>> Add missing Ethernet phys to Zynq DTs.
>>
>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>> ---
>>  arch/arm/boot/dts/zynq-zc702.dts | 6 ++++++
>>  arch/arm/boot/dts/zynq-zc706.dts | 6 ++++++
>>  arch/arm/boot/dts/zynq-zed.dts   | 6 ++++++
>>  3 files changed, 18 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq=
-zc702.dts
>> index 30bcfe20f0bc..fa810505ab8f 100644
>> --- a/arch/arm/boot/dts/zynq-zc702.dts
>> +++ b/arch/arm/boot/dts/zynq-zc702.dts
>> @@ -36,6 +36,12 @@
>>  &gem0 {
>>  	status =3D "okay";
>>  	phy-mode =3D "rgmii-id";
>> +	phy-handle =3D <&ethernet_phy>;
>> +
>> +	ethernet_phy: ethernet-phy@7 {
>> +		compatible =3D "marvell,88e1116r", "ethernet-phy-ieee802.3-c22";
>=20
> c22 is completely unused by the kernel and also c22 is default option a=
nyway.
> Any advantage to have c22 specified here?

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Docum=
entation/devicetree/bindings/net/phy.txt

S=F6ren's marvell,* entries do not seem documented, therefore I used the
documented "ethernet-phy-idAAAA.BBBB" based syntax. The documented
example specifically uses -c22, too.

Either it's okay to prepend unrecognized model strings, then you should
update zynq-parallella.dts as well (I put the model in a comment there)
or use the official strings like I used and keep the readable models as
comments. Documenting all those "marvell,88e1116r", "marvell,88e1518",
"marvell,88e1318" PHY bindings and possibly prepending them to the ID
based strings would be another option, of course.

Regards,
Andreas

--=20
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imend=F6rffer; HRB 16746 AG N=FCrnbe=
rg


--9L4BX1wv9299NkAcIqCCEtLo4B9b36p8A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJT9djeAAoJEPou0S0+fgE/oPgP+gKuEs4L/+0fPvg1CLi0Jsde
rzU48qAHU7/sohFePKyITvpV601dapl7Lc0TtMek8dvC6kjUvtFzHnZEEX+5r4yh
ERW0xqPFQ+SJJyAAGg/0+olpjEx4ARazly49bazll//4iOOuhPCW3Pd0okBtbP32
KN9ynzSHEbXSUwUKQyx15alPAa6CF8C9Du4FXaF0mVGE3Ys4Rucoe15y+EWbPtb8
r3PIwccste+A1vFpUOWljfczJnfhW4wfdTidLUw2+mXAl3GH3yu9fo/jdEI1o00W
gUD+0xnBygLP187ryqXGCvpmGgJPDcnd4h06LMJL3EylLeka2A/nIentdVXTXssl
aEOkbIsSm1mdkY2k3JEaBlUgYxG4K/WxZ1VxIjFFFpFAArr+BNCilRV+kWUMHPbB
9a291A1WBazhnOMf4Yv+DTQ1qb7O0QdSBaHxnyTpvNXzFJJKwQDQ9WgQdx6hds23
mxjXbynfuCp5+DW2ljmnYzhd4mozLiHddcIh0qD4Bs1R5ErJ48GTCzDM3lvhRf9v
nQMzcoNMQmtE135LBSwXOXA2JdVW3gb0d7nMiv0Gk13n7kkhZsJBWPYWtPvGTHgR
Vii+OkehQtQZdMNDJqGs/EWP32oSsxUk666I+4kjv+RLYzfAVHdlDWr5kGKB8rSX
UdNbh3VbvTdBxpdH17E4
=2rWN
-----END PGP SIGNATURE-----

--9L4BX1wv9299NkAcIqCCEtLo4B9b36p8A--
