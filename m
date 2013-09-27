Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab3I0NWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:22:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41480 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab3I0NWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:22:15 -0400
Message-ID: <5245861F.7000109@ti.com>
Date: Fri, 27 Sep 2013 09:20:31 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <swarren@wwwdotorg.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>,
        <devicetree@vger.kernel.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        <grant.likely@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4 11/18] arm: dts: add omap4430 thermal data
References: <1380251605-3804-1-git-send-email-eduardo.valentin@ti.com> <1380251605-3804-12-git-send-email-eduardo.valentin@ti.com> <20130927122439.GA8360@kahuna>
In-Reply-To: <20130927122439.GA8360@kahuna>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="1XmnBH6bta5Fi7w00RPEclm3IM4nH8DtB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1XmnBH6bta5Fi7w00RPEclm3IM4nH8DtB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 27-09-2013 08:24, Nishanth Menon wrote:
> On 23:13-20130926, Eduardo Valentin wrote:
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
>> @@ -25,9 +25,15 @@
>>  		};
>>  	};
>> =20
>> -	bandgap {
>> +	thermal-zones{
>> +		#include "omap4-cpu-thermal.dtsi"
>> +	};
>> +
>> +	bandgap: bandgap {
>>  		reg =3D <0x4a002260 0x4
>>  		       0x4a00232C 0x4>;
>>  		compatible =3D "ti,omap4430-bandgap";
>> +
>> +		#thermal-sensor-cells =3D <0>;
> 2 cents:
> we might want to move bandgap under ocp?
>=20

Yes, agreed. But I don't think this change is related to this patch or
to this series.

Tks Nishanth

>>  	};
>>  };
>> --=20
>> 1.8.2.1.342.gfa7285d
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--1XmnBH6bta5Fi7w00RPEclm3IM4nH8DtB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJFhh8ACgkQCXcVR3XQvP3I1gD/TM2JMQH3snFBp+F3rhhYaI0c
cL1CsA6w/FXgJ/kznzUA/12a9HkHD8gpc6UrCJ4T3MvGlhN5+1vzL+xY9UQ3W7+o
=iERc
-----END PGP SIGNATURE-----

--1XmnBH6bta5Fi7w00RPEclm3IM4nH8DtB--
