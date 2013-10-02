Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab3JBB1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 21:27:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53752 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3JBB1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 21:27:44 -0400
Message-ID: <524B7647.9050208@ti.com>
Date: Tue, 1 Oct 2013 21:26:31 -0400
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
Subject: Re: [PATCH 2/7] arm: dts: add dra7 IVA thermal data
References: <1380652344-18819-1-git-send-email-eduardo.valentin@ti.com> <1380652344-18819-3-git-send-email-eduardo.valentin@ti.com> <20131001223337.GA11451@kahuna>
In-Reply-To: <20131001223337.GA11451@kahuna>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="6pqVNbPwKseJBULfT3TQs8lHgS5ktBjh2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6pqVNbPwKseJBULfT3TQs8lHgS5ktBjh2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01-10-2013 18:33, Nishanth Menon wrote:
> On 14:32-20131001, Eduardo Valentin wrote:
> minor comments follow
>> This patch changes a dtsi file to contain the thermal data
> s/changes/introduces?
>> for IVA domain on DRA7 and later SoCs. This data will
>> enable a thermal shutdown at 125C.
>>
>> This thermal data can be reused across TI SoC devices.
> is'nt it just DRA7 that reuses this - based on dtsi name?

For now, yes, but the file is intended to be reusable. just like the
file with cpu thermal zone is reusable on omap4/5/dra devices.

>>
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>  arch/arm/boot/dts/dra7-iva-thermal.dtsi | 28 ++++++++++++++++++++++++=
++++
>>  1 file changed, 28 insertions(+)
>>  create mode 100644 arch/arm/boot/dts/dra7-iva-thermal.dtsi
>>
>> diff --git a/arch/arm/boot/dts/dra7-iva-thermal.dtsi b/arch/arm/boot/d=
ts/dra7-iva-thermal.dtsi
>> new file mode 100644
>> index 0000000..fea0cea
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/dra7-iva-thermal.dtsi
>> @@ -0,0 +1,28 @@
>> +/*
>> + * Device Tree Source for DRA7 SoC IVA thermal
>> + *
>> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.=
com/
>> + * Contact: Eduardo Valentin <eduardo.valentin@ti.com>
>> + *
>> + * This file is licensed under the terms of the GNU General Public Li=
cense
>> + * version 2.  This program is licensed "as is" without any warranty =
of any
>> + * kind, whether express or implied.
>> + */
>> +
>> +#include <dt-bindings/thermal/thermal.h>
>> +
>> +iva_thermal: iva_thermal {
>> +	polling-delay-passive =3D <250>; /* milliseconds */
>> +	polling-delay =3D <1000>; /* milliseconds */
>> +
>> +		/* sensor       ID */
> ^^ double tab here?
>> +	thermal-sensors =3D <&bandgap     4>;
> space after bandgap is good enough?

Those tabulation were intentional, to hint that 4 means sensor id.

>> +
>> +	trips {
>> +		iva_crit: iva_crit {
>> +			temperature =3D <125000>; /* milliCelsius */
>> +			hysteresis =3D <2000>; /* milliCelsius */
>> +			type =3D THERMAL_TRIP_CRITICAL;
>> +		};
>> +	};
>> +};
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--6pqVNbPwKseJBULfT3TQs8lHgS5ktBjh2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJLdkcACgkQCXcVR3XQvP0h9gD+MOsSs0efkzK+Eml5snVILD76
7scvGupqFQv89A61pzIBAOGPCcZA0bSemUhIBUxx97q3cs3GWtzd0wscYcVKlHRg
=9IZC
-----END PGP SIGNATURE-----

--6pqVNbPwKseJBULfT3TQs8lHgS5ktBjh2--
