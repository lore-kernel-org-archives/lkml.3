Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab3IZKDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:03:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36287 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304Ab3IZKD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:03:29 -0400
Message-ID: <5244065A.8010408@ti.com>
Date: Thu, 26 Sep 2013 13:03:06 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mike Dunn <mikedunn@newsguy.com>, <thierry.reding@gmail.com>
CC: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, <linux-pwm@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Robert Jarzmik <robert.jarzmik@free.fr>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v2] pwm-backlight: allow for non-increasing brightness
 levels
References: <1379869196-19377-1-git-send-email-mikedunn@newsguy.com>
In-Reply-To: <1379869196-19377-1-git-send-email-mikedunn@newsguy.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="JqSkcjUv5CLi83pO8sp6jknfCsQTtpieH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--JqSkcjUv5CLi83pO8sp6jknfCsQTtpieH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 22/09/13 19:59, Mike Dunn wrote:
> Currently the driver assumes that the values specified in the
> brightness-levels device tree property increase as they are parsed from=

> left to right.  But boards that invert the signal between the PWM outpu=
t
> and the backlight will need to specify decreasing brightness-levels.
> This patch removes the assumption that the last element of the array is=

> the maximum value, and instead searches the array for the maximum value=

> and uses that in the duty cycle calculation.
>=20
> Signed-off-by: Mike Dunn <mikedunn@newsguy.com>
> ---
> Changelog:
> v2:=20
> - commit message reworded; correct line wrap used
> - 'max_level' variable renamed to 'scale'
> - loop counter variable type changed to unsigned int
> - value held in scale changed from array index to actual maximum level
> - blank lines added around loop for readability

As you said in a previous mail, the code is rather confusing. And, at
least to me, "scale" sounds an odd name there, especially as it's then
assigned to "max" local var. But if you and Thierry think this version
is good, I'll take it.

 Tomi



--JqSkcjUv5CLi83pO8sp6jknfCsQTtpieH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSRAZaAAoJEPo9qoy8lh71H08QAKOqfKF3tAuk7+T0YqErRBXH
vU+QWetDC/7ZFyBWjIp2GwLgliq66G+vW8l7OLvKMlvIrtjGbBb69eJXrwS/LPkc
scneOyl1qpNPb8LiJE+ST+kflZFK8DSHLk7TUCeqCIW95RV8Sgf1ydLpGei/Rska
Vy281SkbeyP0wnF6DjH3yOihpcBLSe95+kBznZJPQZ9AYlwE/VvcLocUIIfE8Ifp
6X6SDUPyx6ln+K/L8Baw3OFT28j3QwN4qedT5Ld467pf0W2JzIcyu04sbjDXqOin
sk/1tSsbafy4/oj1LJdD1PTUSlTxT9sBrYeU5omR+MlHuanPN22mHdIw+e5yrlHw
La3BOwshljs+Gis2/USN3E8l+ZA47EX+4YzAr0mB7n6nsAMIa+i0w58enydXr31G
5ALMqIzkmPIMxRUl0FY1R+PEMDm3kcXuoE2LTi0UTMsp+xhgsbALYjXlX75YizU2
gA9LYygHOcvBORRJLNci5owoBHBxXQYmb/pLzlO9WrOEu9ex2ZFGjQ8K7X+Vdu08
JoWxk8idj2lqm1ibr2AxZo/npDjwzDyukT7Ct1vbYyvdY2KcBli9Kyi0CzYKj0Z7
k5yN9hvURgTZ3Xl2QLUH6FIflc30pfdIkigzIKdf/ADyvT1nt97K9Ak6cQhQ8H4K
SgzQ7+4s+mA6kinZL1pG
=TM7+
-----END PGP SIGNATURE-----

--JqSkcjUv5CLi83pO8sp6jknfCsQTtpieH--
