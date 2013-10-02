Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab3JBBdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 21:33:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35475 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172Ab3JBBdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 21:33:37 -0400
Message-ID: <524B77AF.3000308@ti.com>
Date: Tue, 1 Oct 2013 21:32:31 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <swarren@wwwdotorg.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <grant.likely@linaro.org>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] arm: dts: add tmp102 i2c sensor node on dra7-evm
References: <1380652344-18819-1-git-send-email-eduardo.valentin@ti.com> <1380652344-18819-7-git-send-email-eduardo.valentin@ti.com> <20131001225108.GA11885@kahuna>
In-Reply-To: <20131001225108.GA11885@kahuna>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="W3ikvTtrxxa4tqqrJ3NBl0Buo7LudFqAd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--W3ikvTtrxxa4tqqrJ3NBl0Buo7LudFqAd
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01-10-2013 18:51, Nishanth Menon wrote:
> On 14:32-20131001, Eduardo Valentin wrote:
>> On dra7-evm there is an tmp102 temperature sensor on i2c bus 1.
>> This patch adds its device tree node.
>>
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>  arch/arm/boot/dts/dra7-evm.dts | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-e=
vm.dts
>> index 21fe16b..3b6c16a 100644
>> --- a/arch/arm/boot/dts/dra7-evm.dts
>> +++ b/arch/arm/boot/dts/dra7-evm.dts
>> @@ -7,6 +7,8 @@
>>   */
>>  /dts-v1/;
>> =20
>> +#include <dt-bindings/thermal/thermal.h>
>> +
>=20
> ^^ needed?

In  fact this is left over from previous local versions and can be
removed from this patch.

However, depending on how patch 7 evolves, it could be needed, yes.

>=20
>>  #include "dra7.dtsi"
>> =20
>>  / {
>> @@ -93,6 +95,12 @@
>>  	pinctrl-names =3D "default";
>>  	pinctrl-0 =3D <&i2c1_pins>;
>>  	clock-frequency =3D <400000>;
> could you add an EOL here?
>> +	tmp102: tmp102@48{
> 	a space before the {?

ok for both cosmetic comments.

>> +		compatible =3D "ti,tmp102";
>> +		reg =3D <0x48>;
>> +
>> +		#thermal-sensor-cells =3D <0>;
>> +	};
>>  };
>> =20
>>  &i2c2 {
>> --=20
>> 1.8.2.1.342.gfa7285d
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pm" in=

>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--W3ikvTtrxxa4tqqrJ3NBl0Buo7LudFqAd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJLd68ACgkQCXcVR3XQvP2KfgEAltgysEAGI49iyk3AHtGGIuj7
u+qmlLyq0CeTb9OVPp4A/i/znxhH6sq6nWKlDw00ZDTMY8tWdM0DNCB9NhhzVeNE
=0zIH
-----END PGP SIGNATURE-----

--W3ikvTtrxxa4tqqrJ3NBl0Buo7LudFqAd--
