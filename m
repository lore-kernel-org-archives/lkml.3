Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbaGYIZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:25:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34809 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbaGYIZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:25:07 -0400
Message-ID: <53D21458.3060403@suse.de>
Date: Fri, 25 Jul 2014 10:24:56 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: monstr@monstr.eu,
        =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 06/11] ARM: dts: zynq: Add DMAC for Parallella
References: <1406242820-20140-1-git-send-email-afaerber@suse.de> <1406242820-20140-7-git-send-email-afaerber@suse.de> <bc390439-9a5b-43a1-a70c-a4c6517a6cb6@BN1AFFO11FD005.protection.gbl> <53D20F2A.5020209@monstr.eu>
In-Reply-To: <53D20F2A.5020209@monstr.eu>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="bNn3waVKE2oPMQrASwt2Ex7jJpIplHmh6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bNn3waVKE2oPMQrASwt2Ex7jJpIplHmh6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 25.07.2014 10:02, schrieb Michal Simek:
> On 07/25/2014 01:28 AM, S=C3=B6ren Brinkmann wrote:
>> On Fri, 2014-07-25 at 01:00AM +0200, Andreas F=C3=A4rber wrote:
>>> Signed-off-by: Andreas F=C3=A4rber <afaerber@suse.de>
>>> ---
>>>  v2: New
>>> =20
>>>  arch/arm/boot/dts/zynq-7000.dtsi      | 17 +++++++++++++++++
>>>  arch/arm/boot/dts/zynq-parallella.dts |  4 ++++
>>>  2 files changed, 21 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zyn=
q-7000.dtsi
>>> index eed3df0..1a70277 100644
>>> --- a/arch/arm/boot/dts/zynq-7000.dtsi
>>> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
>>> @@ -223,6 +223,23 @@
>>>  			};
>>>  		};
>>> =20
>>> +		dmac_s: dmac@f8003000 {
>>> +			compatible =3D "arm,pl330", "arm,primecell";
>>> +			reg =3D <0xf8003000 0x1000>;
>>> +			status =3D "disabled";
>> I think for this IP we can omit the 'status' property since it is alwa=
ys
>> enabled. I don't see a reason to override it in each board DT.
>=20
> Done this change myself

Fine with me, but allow me to point out that the TRM documents the DMAC
being mapped as DMAC S at the above address, and as DMAC NS at F800_4000
(secure vs. non-secure, ch. 4.6, p. 116). Not sure how this would be
handled driver-wise if not through alternative dt nodes?

>>> +			interrupt-parent =3D <&intc>;
>>> +			interrupts =3D <0 13 4>,
>>> +			             <0 14 4>, <0 15 4>,
>>> +			             <0 16 4>, <0 17 4>,
>>> +			             <0 40 4>, <0 41 4>,
>>> +			             <0 42 4>, <0 43 4>;
>>> +			#dma-cells =3D <1>;
>>> +			#dma-channels =3D <8>;
>>> +			#dma-requests =3D <4>;
>>> +			clocks =3D <&clkc 27>;
>>> +			clock-names =3D "apb_pclk";
>>> +		};
>>> +
>>
>> Acked-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>=20
>=20
> Applied to zynq/dt branch.
> https://github.com/Xilinx/linux-xlnx/commits/zynq/dt

Thanks,
Andreas

--=20
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imend=C3=B6rffer; HRB 16746 AG N=C3=BC=
rnberg


--bNn3waVKE2oPMQrASwt2Ex7jJpIplHmh6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJT0hRbAAoJEPou0S0+fgE/MoYP/1OohCtpcJ04S1kEq6U5/fHO
+Ol+e6CgP93xZNF6g9OYXOflV2NyaDZXJS53EsV0lmzDaj9RsRJy4BQoivaDLoR/
zA2idki/x6SHbSvUzEqjLdOS9wnzdX1DVhkLFh+Y1N35knowRra9yDnG7Ky5h7f9
RAKHXPDgxpetWholtx+Gfas35fZU06fjwzsCK4zA/WUDfyAl674Wkle5+3JTHcD7
Scw/JevImZCfU/QuF9y0UGdjNzu9yK0U4sfDulgDBLkz7887vL6Dfz8BC1a5fAwS
ooyPqcP4ZvX2Cmf+2zEmXa/r1Vm6uHj93741tcvCdJUzVBZF8hlRs9+2iZwnjBDF
jKS/nk02CJ72/g30O8FQZe4lG5grPRgHEvCaFnlq/O9vQQYrYGeO00bHed8lyZh1
f5orljd/MSMSvll7LlDI1ehxAji24+t7UPndRpYlW3n+k6FGkIIUVBKwWPM2pl0y
2tb+YTblbR2x0lpwgV9if8qmvG7G0o4G9tvusI7f4+W8JLLJIhidrHaEBV79MQsW
BeSzKSfE/ePNTTpmt50vseayE68RJrM3ny1cHUxlMVfehFbsZgfU9+9ROd0tQTzc
XGn/w+tI9NsF0nQ/gHpQQrgJ8oCPyJrjLchYQjyWS4o9PfMCF3L1sIOZAsvYir1E
mOhLafH40aBzPmLpMC/6
=REdR
-----END PGP SIGNATURE-----

--bNn3waVKE2oPMQrASwt2Ex7jJpIplHmh6--
