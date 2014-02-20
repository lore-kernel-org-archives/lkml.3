Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaBTKN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:13:29 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:58687 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaBTKNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:13:25 -0500
Date: Thu, 20 Feb 2014 18:12:40 +0800
From: Kevin Hao <haokexin@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v4 0/4] Bugfix for of_match_node ordering
Message-ID: <20140220101240.GA3745@pek-khao-d1.corp.ad.wrs.com>
References: <1392819290-1044-1-git-send-email-grant.likely@linaro.org>
 <CAK9yfHwwmZkFMRvxsxjBAfUbVXU3V+iPFDZO=DwQsFvJ3NQyKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <CAK9yfHwwmZkFMRvxsxjBAfUbVXU3V+iPFDZO=DwQsFvJ3NQyKA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 20, 2014 at 02:09:08PM +0530, Sachin Kamat wrote:
> Hi Grant,
>=20
> I observe the following boot failure with today's (next-20140220) linux-n=
ext
> tree on Exynos based boards with the default exynos_defconfig.

Does this help?

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 8a27fc907ab6..9cc893530b9a 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -381,12 +381,16 @@ static int __of_device_is_compatible(const struct dev=
ice_node *device,
=20
 	/* Compatible match has highest priority */
 	if (compat && compat[0]) {
-		of_property_for_each_string(device, "compatible", prop, cp) {
+		prop =3D __of_find_property(device, "compatible", NULL);
+		if (!prop)
+			return 0;
+
+		for (cp =3D of_prop_next_string(prop, NULL); cp;
+				cp =3D of_prop_next_string(prop, cp), index++) {
 			if (of_compat_cmp(cp, compat, strlen(compat)) =3D=3D 0) {
 				score =3D INT_MAX/2 - (index << 2);
 				break;
 			}
-			index++;
 		}
 		if (!score)
 			return 0;


Thanks,
Kevin

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAEBAgAGBQJTBdUYAAoJEJNY7TDerrFxGIIH/j6nTq5k3QJJdqpPeokBFEhQ
G0nt02MLeaYQkL1rvf0geRlq8UJUefbu+BR6BQsbUn9hnZ7XQVJkzKqtzMi380w6
HhEWLc2fhkcf/CG7ZhEzN8A0D+88PVe09DRa9aoYzuscEA3/LZIiHa0X+Yrd9ouy
JvToiN8lLmCR6rplNHR1ZvLdTGDEupafpx/T8OzZ7sKpAuu+n2XchEY62jeWLjFs
MGJogds8AjtR5Sram61EiFd5MkVXEDsMm9FPsGk9e5hgkTF/wqDqlK+KDXbqpn1c
r3RJkmbL/N4FAjf6gtJrCD/IPUQEyeS+dR9mfDu8CHQ5pMGgCxUslILq20cf168=
=YSCa
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
