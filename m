Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbbABSxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 13:53:38 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:44482 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbbABSxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 13:53:36 -0500
Date: Fri, 2 Jan 2015 14:51:22 -0400
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
Subject: Re: [PATCH v2 3/8] hwmon: dts: Doc: Add DTS doc to explain how to
 use PWM FAN as a cooling device
Message-ID: <20150102185120.GA12485@developer>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-4-git-send-email-l.majewski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <1419265668-32283-4-git-send-email-l.majewski@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 22, 2014 at 05:27:43PM +0100, Lukasz Majewski wrote:
> Several new properties to allow PWM fan working as a cooling device have =
been
> combined into this single commit.
>=20

Patch prefix should look something like 'dt-bindings: ...', or better
'Documentation: devicetree: ...', or 'Documentation: bindings: ...'

> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> ---
> Changes for v2:
> - Rename cooling-pwm-values to cooling-levels
> - Remove default-pulse-width property and stick to default hwmon policy
> ---
>  .../devicetree/bindings/hwmon/pwm-fan.txt          | 23 ++++++++++++++++=
++++++
>  1 file changed, 23 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/hwmon/pwm-fan.txt b/Docume=
ntation/devicetree/bindings/hwmon/pwm-fan.txt
> index 610757c..001446a 100644
> --- a/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
> +++ b/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
> @@ -3,10 +3,33 @@ Bindings for a fan connected to the PWM lines
>  Required properties:
>  - compatible	: "pwm-fan"
>  - pwms		: the PWM that is used to control the PWM fan
> +- cooling-levels      : PWM duty cycle values in a range from 0 to 255
> +			which correspond to thermal cooling states
> +
> +Thorough description of the following bindings:
> +		cooling-min-state =3D <0>;
> +		cooling-max-state =3D <3>;
> +		#cooling-cells =3D <2>;
> +		thermal-zone {
> +			cpu_thermal: cpu-thermal {
> +			cooling-maps {
> +				map0 {
> +				     trip =3D <&cpu_alert1>;
> +				     cooling-device =3D <&fan0 0 1>;
> +				};
> +			};
> +		};
> +
> +for PWM FAN used as cooling device can be found at:
> +./Documentation/devicetree/bindings/thermal/thermal.txt
> =20
>  Example:
>  	pwm-fan {
>  		compatible =3D "pwm-fan";
>  		status =3D "okay";
>  		pwms =3D <&pwm 0 10000 0>;
> +		cooling-min-state =3D <0>;
> +		cooling-max-state =3D <3>;
> +		#cooling-cells =3D <2>;
> +		cooling-levels =3D <0 102 170 255>;
>  	};
> --=20
> 2.0.0.rc2
>=20

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUpuifAAoJEMLUO4d9pOJWzgEH/34Ba+sq1rZpk2QU+8F0tSbL
x8ya5ox1Bx+DDezU4fKt0cCLkgzYHdrzCpDs0+ZNKDW2MAJ89DuFbRMNS7245SmI
XjOb4b3XuU/UTgDOiWaIch2igGEFsCwBiCWyANHUzpszxMz5hektNwAF86ElfHE6
BbU/qkuXAyTgxYYfrvXTpUOw1aZ9VZG8kXALYuKKvNemDnzrfBjRQbHL5NIlss6g
RXkOXc1mwJrrigLfU65iMLStVnnbfAMy19/3EN+yn0t5Rq30JBWO5H5vJA5b9H6R
tCT/GDfFqSFTS82TD1Bs6JLyIbZDlLaA4FZ2JX/yU5UnWz3AP/l4u+EkrwGb814=
=7fPb
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
