Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbbABSyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 13:54:44 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39801 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbbABSym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 13:54:42 -0500
Date: Fri, 2 Jan 2015 14:52:27 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, Lukasz Majewski <l.majewski@majess.pl>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>
Subject: Re: [PATCH v2 5/8] hwmon: thermal: dts: Add properties to use
 pwm-fan device as a cooling device in Odroid U3
Message-ID: <20150102185225.GB12485@developer>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-6-git-send-email-l.majewski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
Content-Disposition: inline
In-Reply-To: <1419265668-32283-6-git-send-email-l.majewski@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Patch subject should use a prefix like:
'arm: dts:....'

On Mon, Dec 22, 2014 at 05:27:45PM +0100, Lukasz Majewski wrote:
> With those bindings it is possible to use pwm-fan device available in
> Odroid U3 as a cooling device.
>=20
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> ---
> Changes for v2:
> - Rename cooling-pwm-values property to cooling-levels
> ---
>  arch/arm/boot/dts/exynos4412-odroidu3.dts | 33 +++++++++++++++++++++++++=
+++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/arm/boot/dts/exynos4412-odroidu3.dts b/arch/arm/boot/dt=
s/exynos4412-odroidu3.dts
> index 60bd1e4..380035d 100644
> --- a/arch/arm/boot/dts/exynos4412-odroidu3.dts
> +++ b/arch/arm/boot/dts/exynos4412-odroidu3.dts
> @@ -32,11 +32,42 @@
>  		};
>  	};
> =20
> -	pwm-fan {
> +	fan0: pwm-fan {
>  		compatible =3D "pwm-fan";
>  		pwms =3D <&pwm 0 10000 0>;
> +		cooling-min-state =3D <0>;
> +		cooling-max-state =3D <3>;
> +		#cooling-cells =3D <2>;
> +		cooling-levels =3D <0 102 170 255>;
>  		status =3D "okay";
>  	};
> +
> +	thermal-zones {
> +		cpu_thermal: cpu-thermal {
> +			cooling-maps {
> +				map0 {
> +				     trip =3D <&cpu_alert1>;
> +				     cooling-device =3D <&cpu0 7 7>;
> +				};
> +				map1 {
> +				     trip =3D <&cpu_alert2>;
> +				     cooling-device =3D <&cpu0 13 13>;
> +				};
> +				map2 {
> +				     trip =3D <&cpu_alert0>;
> +				     cooling-device =3D <&fan0 0 1>;
> +				};
> +				map3 {
> +				     trip =3D <&cpu_alert1>;
> +				     cooling-device =3D <&fan0 1 2>;
> +				};
> +				map4 {
> +				     trip =3D <&cpu_alert2>;
> +				     cooling-device =3D <&fan0 2 3>;
> +				};
> +			};
> +		};
> +	};
>  };
> =20
>  &pwm {
> --=20
> 2.0.0.rc2
>=20

--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUpujhAAoJEMLUO4d9pOJWJBcH/1WUDbik9QiZ70pi003w53De
tZOiPqf04sCvCd7at9UEzYepjE+/P7VlsPyTva7GLVqNwdwKUJGRAJRJ/Z5Efc7O
FL+ZsZyIh52V2Zn9fHsxTy8YhrFAcxeQiLOE+GNlg0ULORXAKfzShSwJ3kVmRfY+
OawSGP8Ng0+ZT6Wdyk0kTWe63DIsE7abWUsL+dm8aPkQWqJDrk5QA2ugo5x7DR9/
9QNK2/NViSEU3guxkoFOZKNHDLr75pMz7gMVXIrIv/DwJW3dpfWnvpVFIeJx8nWn
7yRy1JxojsSTBGNkP2F0+zikYl/tz5pM0dplUyQWwqurstDrxesm3OV3sQMAal0=
=yyiU
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--
