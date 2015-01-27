Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbbA0PHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:07:44 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:52874 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbbA0PHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:07:42 -0500
Date: Tue, 27 Jan 2015 11:07:39 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH] thermal: Fix examples in DT documentation
Message-ID: <20150127150737.GC29600@developer.hsd1.ca.comcast.net>
References: <1422355847-23549-1-git-send-email-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mJm6k4Vb/yFcL9ZU"
Content-Disposition: inline
In-Reply-To: <1422355847-23549-1-git-send-email-srinivas.kandagatla@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mJm6k4Vb/yFcL9ZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Srinivas,

On Tue, Jan 27, 2015 at 10:50:47AM +0000, Srinivas Kandagatla wrote:
> There are various issues with the examples in this documentation, some
> of the DT labels are invalid and one of the macro THERMAL_NO_LIMITS
> referenced is not available as well.
>=20
> As Its highly likely that people would pick some samples from the
> documentation, I though fixing these would be best rather than giving
> starter a challenge to figure out whats going wrong with examples.
>=20
> This patch attempts to fix such errors in the documentation.
>=20
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Thanks for doing this. It's been a while that I want to make these small
fixes in the of thermal example section and I always forget.

Just a minor request in the end:

> ---
>  .../devicetree/bindings/thermal/thermal.txt        | 44 +++++++++++-----=
------
>  1 file changed, 22 insertions(+), 22 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/Docu=
mentation/devicetree/bindings/thermal/thermal.txt
> index f5db6b7..97ed14e 100644
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
> @@ -392,12 +392,12 @@ thermal-zones {
> =20
>  		trips {
>  			/* each zone within the SoC may have its own trips */
> -			dsp-alert: gpu-alert {
> +			dsp_alert: gpu-alert {

I suppose the original text has a typo, it should be:

+			dsp_alert: dsp-alert {

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

While here, can you please include in your patch fixes for remaining
examples? From quick look, 'board-thermal', 'adc-dummy', and
'dsp-thermal' are occurrences of the same problem you fixing in other
parts of the file.=20

> --=20
> 1.9.1
>=20

--mJm6k4Vb/yFcL9ZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUx6mxAAoJEMLUO4d9pOJWWZUIAIXo7Cjp+THFJpc7H4Yxl6yv
YFavesqG11a6ZEQZyp2LpgGakl0i3IMLSVTjJwe8JZamtAxsDUIR9hb8DxtmdwFG
56Xt+LOqP8XNtjYqD/UMxL2wRYhEdM+TDfgz5cMqyG91iF9eypNcFC75Pue6UlqZ
9LzwFO7i4mK4NEomF8ObH4DJuKogVn8qt08o0qOUR+GHzNtJBS4FZJUo+vLAcgxy
EAZCeoz4fj94E6eBvnygF24rj2xHPmwP8NElvUOTP3BI9+qAWAAPM1xx1dj6f9Cp
hrSIVr+Ua8qNfuYMt4hRNuIZI2BriTaUhqgEAsXq11/C4Uc3A+9GZBB138RVvGY=
=a8n6
-----END PGP SIGNATURE-----

--mJm6k4Vb/yFcL9ZU--
