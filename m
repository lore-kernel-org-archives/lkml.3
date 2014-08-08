Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbaHHJld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:41:33 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:62613 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaHHJl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:41:29 -0400
Date: Fri, 8 Aug 2014 11:41:25 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH 1/3] of: Add of_match_machine helper
Message-ID: <20140808094123.GC5387@ulmo>
References: <1407452515-2390-1-git-send-email-ttynkkynen@nvidia.com>
 <1407452515-2390-2-git-send-email-ttynkkynen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jy6Sn24JjFx/iggw"
Content-Disposition: inline
In-Reply-To: <1407452515-2390-2-git-send-email-ttynkkynen@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jy6Sn24JjFx/iggw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 02:01:53AM +0300, Tuomas Tynkkynen wrote:
> Add of_match_machine function to test the device tree root for an
> of_match array. This can be useful when testing SoC versions at runtime,
> for example.
>=20
> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> ---
>  drivers/of/base.c  | 21 +++++++++++++++++++++
>  include/linux/of.h |  3 +++
>  2 files changed, 24 insertions(+)
>=20
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index d8574ad..37798ea 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -977,6 +977,27 @@ struct device_node *of_find_matching_node_and_match(=
struct device_node *from,
>  EXPORT_SYMBOL(of_find_matching_node_and_match);
> =20
>  /**
> + * of_match_machine - Tell if root of device tree has a matching of_matc=
h struct
> + *	@matches:	array of of device match structures to search in
> + *
> + *	Returns the result of of_match_node for the root node.
> + */

I was going to say that this kerneldoc is weirdly formatted, but when I
looked at the other kerneldoc comments in this file it seems that they
use similarly weird formatting...

> +const struct of_device_id *of_match_machine(const struct of_device_id *m=
atches)
> +{
> +	const struct of_device_id *match;
> +	struct device_node *root;
> +
> +	root =3D of_find_node_by_path("/");
> +	if (!root)
> +		return NULL;
> +
> +	match =3D of_match_node(matches, root);
> +	of_node_put(root);
> +	return match;
> +}
> +EXPORT_SYMBOL(of_match_machine);

I wonder if of_find_node_by_path("/") is somewhat overkill here. Perhaps
simply of_node_get(of_allnodes) would be more appropriate here since the
function is implemented in the core?

Thierry

--jy6Sn24JjFx/iggw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT5JtDAAoJEN0jrNd/PrOhAMoQAJmn0fEnb/b1lt3a+d+kS0JT
Ll8hWzjUy3/C6wH7enSRF+IuishkYq9GBdQhd5sEuNxOw3IQBvNOfFUYOa8VF+ps
1/wOVmviYU0gyK8PTdtGJnXuFChG8kxuGq01hnOnue0UZ2KD+o+0Ihl5wHdXOpBW
O+NiddN24l33kcR6KoMTU95R+xOozKuUjiRHQGZDiSUbwN4u+vUcyptVv/lQlwtv
P0zrREqb8GNiGg5CLeTr38E7SY10NY4ZxGmy5rxNTazxgai2wNFy+kzV3e509t4b
GN53vmkeB/hwOafE5lLSn1LV7IWggCHnAC86mb+E6f3NctEdQstXlwZuag6ATX0g
p0AtabEJD6JnGO2R5PKL33RfeWQB3J1ozIhNRnDe+ajcsYVAOKjAGpjyx3q3D5M+
R68r7SIPr/kox0d+BaAhh9+xnZnEX2y+3lCEJIUTDCY0k9W/OjUl64LWRDs3cb7H
zQeYbErtDjrmoIps6Btaask6tlKtLoVOCTnijuOW38Xg5UX4ZrGGjFfbTX6eM02l
gMYQdhAvrVD9vFiq7l6J5FyLwZv7KXbdreMT2SLK96JK4muyzyYDGBOGeFA4Nr3x
cVqeS8OOPh8cVTaTrwiuvGC/VFzTq6wGu0OM6Ws+t7gJV9b/6XNUAsyW2ST4xpky
f94msh57NEoPl3XGM8Rt
=hWNI
-----END PGP SIGNATURE-----

--jy6Sn24JjFx/iggw--
