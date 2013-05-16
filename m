Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab3EPMaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 08:30:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44184 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab3EPMaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 08:30:20 -0400
Message-ID: <5194D123.4060403@ti.com>
Date: Thu, 16 May 2013 08:29:23 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2 3/3] arm: dts: add bandgap entry for OMAP4460 devices
References: <1368629928-6723-1-git-send-email-eduardo.valentin@ti.com> <1368629928-6723-4-git-send-email-eduardo.valentin@ti.com> <5193A875.1020000@ti.com> <5193B9AA.7020507@ti.com> <20130515165726.GK22508@game.jcrosoft.org>
In-Reply-To: <20130515165726.GK22508@game.jcrosoft.org>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2VUPFGNDKFBPWOFGDMECU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2VUPFGNDKFBPWOFGDMECU
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 15-05-2013 12:57, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 12:36 Wed 15 May     , Eduardo Valentin wrote:
>> On 15-05-2013 11:23, Benoit Cousson wrote:
>>> Hi Eduardo,
>>>
>>> On 05/15/2013 04:58 PM, Eduardo Valentin wrote:
>>>> Include bandgap devices for OMAP4460 devices.
>>>>
>>>> Cc: "Beno=EEt Cousson" <b-cousson@ti.com>
>>>> Cc: Tony Lindgren <tony@atomide.com>
>>>> Cc: Russell King <linux@arm.linux.org.uk>
>>>> Cc: linux-omap@vger.kernel.org
>>>> Cc: devicetree-discuss@lists.ozlabs.org
>>>> Cc: linux-arm-kernel@lists.infradead.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>>>> ---
>>>>  arch/arm/boot/dts/omap4460.dtsi | 9 +++++++++
>>>>  1 file changed, 9 insertions(+)
>>>>
>>>> diff --git a/arch/arm/boot/dts/omap4460.dtsi b/arch/arm/boot/dts/oma=
p4460.dtsi
>>>> index 2cf227c..e5bfbfe 100644
>>>> --- a/arch/arm/boot/dts/omap4460.dtsi
>>>> +++ b/arch/arm/boot/dts/omap4460.dtsi
>>>> @@ -29,4 +29,13 @@
>>>>  			     <0 55 0x4>;
>>>>  		ti,hwmods =3D "debugss";
>>>>  	};
>>>> +
>>>> +	bandgap {
>>>> +		reg =3D <0x4a002260 0x4
>>>> +			0x4a00232C 0x4
>>>> +			0x4a002378 0x18>;
>>>> +		compatible =3D "ti,omap4460-bandgap";
>>>> +		interrupts =3D <0 126 4>; /* talert */
>>>> +		ti,tshut-gpio =3D <86>;
>>
>>
>>
>>>
>>> Why do you need a custom attribute for GPIO? Cannot you use the stand=
ard
>>> one?
>>
>> I believe it was by your suggestion :-), during the first attempts to
>> send this driver. But could not find the thread link :-( sorry.
>>
>>
>> I guess the reasoning to mark it as a ti specific is because it will b=
e
>> used as IRQ line to treat thermal shutdown (in SW).
> so use interrup-parent


Jean-Christophe,

That will change the controller and break the configuration for the
other IRQ line, coming from GIC.

>>
>>>
>>> Where is the gpio controller phandle?
>>>
>>> Usually it looks like this:
>>>
>>> 	gpios =3D <&gpio1 8 0>;
>>>
>>>
>>> Regards,
>>> Benoit
>>>
>>>
>>>
>>
>>
>=20
>=20
>=20
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>=20
>=20
>=20



------enig2VUPFGNDKFBPWOFGDMECU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGU0SMACgkQCXcVR3XQvP2gQQD/RT0WjwE07dSClLZ5Y4QjFNfW
0ULPhYRmRSBc4xN34jMBALLcOSY5ysTJxjiQWHai8BQL5gl8K/yhkkdaIew1khfk
=3NnZ
-----END PGP SIGNATURE-----

------enig2VUPFGNDKFBPWOFGDMECU--
