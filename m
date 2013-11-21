Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab3KUPik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:38:40 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40221 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab3KUPih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:38:37 -0500
Message-ID: <528E286D.50100@ti.com>
Date: Thu, 21 Nov 2013 11:36:13 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <swarren@wwwdotorg.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>,
        <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv5 10/20] arm: dts: add omap4430 thermal data
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com> <1384285582-16933-11-git-send-email-eduardo.valentin@ti.com> <20131120123245.GA3242@amd.pavel.ucw.cz>
In-Reply-To: <20131120123245.GA3242@amd.pavel.ucw.cz>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="OQGHXilJNQEKWhIDtwI8TunGQ1jD8Fk8k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OQGHXilJNQEKWhIDtwI8TunGQ1jD8Fk8k
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 20-11-2013 08:32, Pavel Machek wrote:
> HI!
>=20
>> This patch changes the dtsi entry on omap4430 to contain
>> the thermal data. This data will enable the passive
>> cooling with CPUfreq cooling device at 100C and the
>> system will do a thermal shutdown at 125C.
>>
>> Cc: "Beno=EEt Cousson" <bcousson@baylibre.com>
>> Cc: Tony Lindgren <tony@atomide.com>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: linux-omap@vger.kernel.org
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>  arch/arm/boot/dts/omap443x.dtsi | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/omap443x.dtsi b/arch/arm/boot/dts/omap4=
43x.dtsi
>> index bcf455e..e9c97d6 100644
>> --- a/arch/arm/boot/dts/omap443x.dtsi
>> +++ b/arch/arm/boot/dts/omap443x.dtsi
>> @@ -12,7 +12,7 @@
>> =20
>>  / {
>>  	cpus {
>> -		cpu@0 {
>> +		cpu0: cpu@0 {
>>  			/* OMAP443x variants OPP50-OPPNT */
>>  			operating-points =3D <
>>  				/* kHz    uV */
>=20
> I see you also add labels to various other entries...

I think I didn't quite get your point here. Can you please elaborate?

This label has been added because it will be used in thermal zone while
referencing the cooling device.

>=20
>> @@ -25,9 +25,15 @@
>>  		};
>>  	};
>> =20
>> -	bandgap {
>> +	thermal-zones{
>=20
> You may want to include space here.

OK.

>=20
>> +		#include "omap4-cpu-thermal.dtsi"
>> +	};
>> +
>> +	bandgap: bandgap {
>>  		reg =3D <0x4a002260 0x4
>>  		       0x4a00232C 0x4>;
>>  		compatible =3D "ti,omap4430-bandgap";
>> +
>> +		#thermal-sensor-cells =3D <0>;
>>  	};
>>  };
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--OQGHXilJNQEKWhIDtwI8TunGQ1jD8Fk8k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlKOKG0ACgkQCXcVR3XQvP2npgEAxbfIMuRDvRE62RLB0vNNBJZi
h70ppZC7HXSQYLS9an4A/1/i5UmTN/9oMYPgz4cCiwNsCLAgWpwHm44gDmu7sspq
=ysce
-----END PGP SIGNATURE-----

--OQGHXilJNQEKWhIDtwI8TunGQ1jD8Fk8k--
