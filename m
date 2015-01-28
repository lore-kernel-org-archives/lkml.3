Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762723AbbA2Cnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:43:31 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:52999 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760205AbbA2Cn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:43:29 -0500
Date: Wed, 28 Jan 2015 13:29:31 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v2] thermal: Fix examples in DT documentation
Message-ID: <20150128172929.GA27003@developer.hsd1.ca.comcast.net>
References: <1422465215-12716-1-git-send-email-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <1422465215-12716-1-git-send-email-srinivas.kandagatla@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 28, 2015 at 05:13:35PM +0000, Srinivas Kandagatla wrote:
> There are various issues with the examples in this documentation, some
> of the DT labels are invalid and one of the macro THERMAL_NO_LIMITS
> referenced is not available as well.
>=20
> This patch attempts to fix such errors in the documentation.
>=20
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
> Changes Since v1:
> 	- Fixed few more typo's as suggested by Eduardo Valentin

Looks like there are still occurencies of adc-dummy after your patch.
But I am amending myself, no need to resend.

>=20
>  .../devicetree/bindings/thermal/thermal.txt        | 66 +++++++++++-----=
------
>  1 file changed, 33 insertions(+), 33 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/Docu=
mentation/devicetree/bindings/thermal/thermal.txt
> index f5db6b7..91c77da 100644
> --- a/Documentation/devicetree/bindings/thermal/thermal.txt
> +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
> @@ -251,24 +251,24 @@ ocp {
>  };
> =20
>  thermal-zones {
> -	cpu-thermal: cpu-thermal {
> +	cpu_thermal: cpu-thermal {
>  		polling-delay-passive =3D <250>; /* milliseconds */
>  		polling-delay =3D <1000>; /* milliseconds */
> =20
>  		thermal-sensors =3D <&bandgap0>;
> =20
>  		trips {
> -			cpu-alert0: cpu-alert {
> +			cpu_alert0: cpu-alert0 {
>  				temperature =3D <90000>; /* millicelsius */
>  				hysteresis =3D <2000>; /* millicelsius */
>  				type =3D "active";
>  			};
> -			cpu-alert1: cpu-alert {
> +			cpu_alert1: cpu-alert1 {
>  				temperature =3D <100000>; /* millicelsius */
>  				hysteresis =3D <2000>; /* millicelsius */
>  				type =3D "passive";
>  			};
> -			cpu-crit: cpu-crit {
> +			cpu_crit: cpu-crit {
>  				temperature =3D <125000>; /* millicelsius */
>  				hysteresis =3D <2000>; /* millicelsius */
>  				type =3D "critical";
> @@ -277,17 +277,17 @@ thermal-zones {
> =20
>  		cooling-maps {
>  			map0 {
> -				trip =3D <&cpu-alert0>;
> -				cooling-device =3D <&fan0 THERMAL_NO_LIMITS 4>;
> +				trip =3D <&cpu_alert0>;
> +				cooling-device =3D <&fan0 THERMAL_NO_LIMIT 4>;
>  			};
>  			map1 {
> -				trip =3D <&cpu-alert1>;
> -				cooling-device =3D <&fan0 5 THERMAL_NO_LIMITS>;
> +				trip =3D <&cpu_alert1>;
> +				cooling-device =3D <&fan0 5 THERMAL_NO_LIMIT>;
>  			};
>  			map2 {
> -				trip =3D <&cpu-alert1>;
> +				trip =3D <&cpu_alert1>;
>  				cooling-device =3D
> -				    <&cpu0 THERMAL_NO_LIMITS THERMAL_NO_LIMITS>;
> +				    <&cpu0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
>  			};
>  		};
>  	};
> @@ -298,13 +298,13 @@ used to monitor the zone 'cpu-thermal' using its so=
le sensor. A fan
>  device (fan0) is controlled via I2C bus 1, at address 0x48, and has ten
>  different cooling states 0-9. It is used to remove the heat out of
>  the thermal zone 'cpu-thermal' using its cooling states
> -from its minimum to 4, when it reaches trip point 'cpu-alert0'
> +from its minimum to 4, when it reaches trip point 'cpu_alert0'
>  at 90C, as an example of active cooling. The same cooling device is used=
 at
> -'cpu-alert1', but from 5 to its maximum state. The cpu@0 device is also
> +'cpu_alert1', but from 5 to its maximum state. The cpu@0 device is also
>  linked to the same thermal zone, 'cpu-thermal', as a passive cooling dev=
ice,
> -using all its cooling states at trip point 'cpu-alert1',
> +using all its cooling states at trip point 'cpu_alert1',
>  which is a trip point at 100C. On the thermal zone 'cpu-thermal', at the
> -temperature of 125C, represented by the trip point 'cpu-crit', the silic=
on
> +temperature of 125C, represented by the trip point 'cpu_crit', the silic=
on
>  is not reliable anymore.
> =20
>  (b) - IC with several internal sensors
> @@ -329,7 +329,7 @@ ocp {
>  };
> =20
>  thermal-zones {
> -	cpu-thermal: cpu-thermal {
> +	cpu_thermal: cpu-thermal {
>  		polling-delay-passive =3D <250>; /* milliseconds */
>  		polling-delay =3D <1000>; /* milliseconds */
> =20
> @@ -338,12 +338,12 @@ thermal-zones {
> =20
>  		trips {
>  			/* each zone within the SoC may have its own trips */
> -			cpu-alert: cpu-alert {
> +			cpu_alert: cpu-alert {
>  				temperature =3D <100000>; /* millicelsius */
>  				hysteresis =3D <2000>; /* millicelsius */
>  				type =3D "passive";
>  			};
> -			cpu-crit: cpu-crit {
> +			cpu_crit: cpu-crit {
>  				temperature =3D <125000>; /* millicelsius */
>  				hysteresis =3D <2000>; /* millicelsius */
>  				type =3D "critical";
> @@ -356,7 +356,7 @@ thermal-zones {
>  		};
>  	};
> =20
> -	gpu-thermal: gpu-thermal {
> +	gpu_thermal: gpu-thermal {
>  		polling-delay-passive =3D <120>; /* milliseconds */
>  		polling-delay =3D <1000>; /* milliseconds */
> =20
> @@ -365,12 +365,12 @@ thermal-zones {
> =20
>  		trips {
>  			/* each zone within the SoC may have its own trips */
> -			gpu-alert: gpu-alert {
> +			gpu_alert: gpu-alert {
>  				temperature =3D <90000>; /* millicelsius */
>  				hysteresis =3D <2000>; /* millicelsius */
>  				type =3D "passive";
>  			};
> -			gpu-crit: gpu-crit {
> +			gpu_crit: gpu-crit {
>  				temperature =3D <105000>; /* millicelsius */
>  				hysteresis =3D <2000>; /* millicelsius */
>  				type =3D "critical";
> @@ -383,7 +383,7 @@ thermal-zones {
>  		};
>  	};
> =20
> -	dsp-thermal: dsp-thermal {
> +	dsp_thermal: dsp-thermal {
>  		polling-delay-passive =3D <50>; /* milliseconds */
>  		polling-delay =3D <1000>; /* milliseconds */
> =20
> @@ -392,12 +392,12 @@ thermal-zones {
> =20
>  		trips {
>  			/* each zone within the SoC may have its own trips */
> -			dsp-alert: gpu-alert {
> +			dsp_alert: dsp-alert {
>  				temperature =3D <90000>; /* millicelsius */
>  				hysteresis =3D <2000>; /* millicelsius */
>  				type =3D "passive";
>  			};
> -			dsp-crit: gpu-crit {
> +			dsp_crit: gpu-crit {
>  				temperature =3D <135000>; /* millicelsius */
>  				hysteresis =3D <2000>; /* millicelsius */
>  				type =3D "critical";
> @@ -457,7 +457,7 @@ ocp {
>  };
> =20
>  thermal-zones {
> -	cpu-thermal: cpu-thermal {
> +	cpu_thermal: cpu-thermal {
>  		polling-delay-passive =3D <250>; /* milliseconds */
>  		polling-delay =3D <1000>; /* milliseconds */
> =20
> @@ -508,7 +508,7 @@ with many sensors and many cooling devices.
>  	/*
>  	 * An IC with several temperature sensor.
>  	 */
> -	adc-dummy: sensor@0x50 {
> +	adc_dummy: sensor@0x50 {
>  		...
>  		#thermal-sensor-cells =3D <1>; /* sensor internal ID */
>  	};
> @@ -531,7 +531,7 @@ thermal-zones {
>  		};
>  	};
> =20
> -	board-thermal: board-thermal {
> +	board_thermal: board-thermal {
>  		polling-delay-passive =3D <1000>; /* milliseconds */
>  		polling-delay =3D <2500>; /* milliseconds */
> =20
> @@ -548,22 +548,22 @@ thermal-zones {
> =20
>  		trips {
>  			/* Trips are based on resulting linear equation */
> -			cpu-trip: cpu-trip {
> +			cpu_trip: cpu-trip {
>  				temperature =3D <60000>; /* millicelsius */
>  				hysteresis =3D <2000>; /* millicelsius */
>  				type =3D "passive";
>  			};
> -			gpu-trip: gpu-trip {
> +			gpu_trip: gpu-trip {
>  				temperature =3D <55000>; /* millicelsius */
>  				hysteresis =3D <2000>; /* millicelsius */
>  				type =3D "passive";
>  			}
> -			lcd-trip: lcp-trip {
> +			lcd_trip: lcp-trip {
>  				temperature =3D <53000>; /* millicelsius */
>  				hysteresis =3D <2000>; /* millicelsius */
>  				type =3D "passive";
>  			};
> -			crit-trip: crit-trip {
> +			crit_trip: crit-trip {
>  				temperature =3D <68000>; /* millicelsius */
>  				hysteresis =3D <2000>; /* millicelsius */
>  				type =3D "critical";
> @@ -572,17 +572,17 @@ thermal-zones {
> =20
>  		cooling-maps {
>  			map0 {
> -				trip =3D <&cpu-trip>;
> +				trip =3D <&cpu_trip>;
>  				cooling-device =3D <&cpu0 0 2>;
>  				contribution =3D <55>;
>  			};
>  			map1 {
> -				trip =3D <&gpu-trip>;
> +				trip =3D <&gpu_trip>;
>  				cooling-device =3D <&gpu0 0 2>;
>  				contribution =3D <20>;
>  			};
>  			map2 {
> -				trip =3D <&lcd-trip>;
> +				trip =3D <&lcd_trip>;
>  				cooling-device =3D <&lcd0 5 10>;
>  				contribution =3D <15>;
>  			};
> --=20
> 1.9.1
>=20

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUyRxwAAoJEMLUO4d9pOJW5R0H/3r+kjBarskXEbUyBtDstf20
1cipftzdyk1ezVmIi77Jl19LO3U5xhaG3nniTLy8f6eKF3wRowaaWA0p5WvMr2sL
wfzlsbaRLHYznLnaCo/PClCaoZZ6eTZ/zR4DrXU/XoOqRZAvynwlvhxlZE2Fv4T+
xYticLwKR5dkD1+20PkYQGU2PcTvts4M43ANyBLHdOzaKZ9XVQ5lXOVStS1nDSkm
PjREhOlM7zYMXwdcRVbzrZu52mogwEvUQmvo7njRQSsndF3c5zGe6S3xOUTGha92
FA0WAUQSQpm49ET0MP0kYt+eLKFDenpNChQ6I7t36z9CCYx6GE/JDxXPMXjzSI4=
=3yke
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
