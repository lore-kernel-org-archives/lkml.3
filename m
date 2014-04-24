Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751AbaDXOpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:45:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43002 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756570AbaDXOpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:45:17 -0400
Date: Thu, 24 Apr 2014 09:44:58 -0500
From: Felipe Balbi <balbi@ti.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <myungjoo.ham@samsung.com>, <balbi@ti.com>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>,
        <ckeepax@opensource.wolfsonmicro.com>, <broonie@kernel.org>,
        <k.kozlowski@samsung.com>, <kyungmin.park@samsung.com>
Subject: Re: [PATCHv3 2/9] extcon: Add devm_extcon_dev_allocate/free to
 manage the resource of extcon device
Message-ID: <20140424144458.GG26661@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
 <1398342897-23670-3-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j2AXaZ4YhVcLc+PQ"
Content-Disposition: inline
In-Reply-To: <1398342897-23670-3-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--j2AXaZ4YhVcLc+PQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2014 at 09:34:50PM +0900, Chanwoo Choi wrote:
> This patch add device managed devm_extcon_dev_{allocate,free} to automati=
cally
> free the memory of extcon_dev structure without handling free operation.
>=20
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/extcon/extcon-class.c | 70 +++++++++++++++++++++++++++++++++++--=
------
>  include/linux/extcon.h        | 11 +++++++
>  2 files changed, 69 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index bec66d4..f369168 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -604,6 +604,64 @@ void extcon_dev_free(struct extcon_dev *edev)
>  }
>  EXPORT_SYMBOL_GPL(extcon_dev_free);
> =20
> +static int devm_extcon_dev_match(struct device *dev, void *res, void *da=
ta)
> +{
> +	struct extcon_dev **r =3D res;
> +
> +	if (!r || !*r) {
> +		WARN_ON(!r || !*r);
> +		return 0;
> +	}
> +
> +	return *r =3D=3D data;
> +}
> +
> +static void devm_extcon_dev_release(struct device *dev, void *res)
> +{
> +	extcon_dev_free(*(struct extcon_dev **)res);
> +}
> +
> +/**
> + * devm_extcon_dev_allocate - Allocate managed extcon device
> + * @dev:		device owning the extcon device being created
> + * @supported_cable:	Array of supported cable names ending with NULL.
> + *			If supported_cable is NULL, cable name related APIs
> + *			are disabled.
> + *
> + * This function manages automatically the memory of extcon device using=
 device
> + * resource management and simplify the control of freeing the memory of=
 extcon
> + * device.
> + *
> + * Returns the pointer memory of allocated extcon_dev if success or NULL=
 if fail
> + */
> +struct extcon_dev *devm_extcon_dev_allocate(struct device *dev,
> +					    const char **supported_cable)
> +{
> +	struct extcon_dev **ptr, *edev;
> +
> +	ptr =3D devres_alloc(devm_extcon_dev_release, sizeof(*ptr), GFP_KERNEL);
> +	if (!ptr)
> +		return NULL;

if this fails you return NULL;

> +
> +	edev =3D extcon_dev_allocate(supported_cable);

if this fails, you return -ENOMEM. Not very nice, if you ask me.

--=20
balbi

--j2AXaZ4YhVcLc+PQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWSNqAAoJEIaOsuA1yqRERcUP/AtKMGf6wvRLiUTIOXr35Aod
1f/s0Gs/SjqmqckbymXC+OWorxl0lGfP7skqZF0NhWyPOEhmfJjGFb5b225071xK
ARpftRHw+3QvjB7/Q3ZUxUbg0GzpP+Dh8vLby7qjRC5BJcQGvP5phC8NFSfbKG7v
BwZxaUU76W7OAWzxb9J/yXJw601TIDo7EZ+n5MLqXRUmFppaGiYYr2NzncwWlvuf
h3ATxEANph4UJ85hEjjbrSDEWIsTJACnG8TkHQHNwkjto4+HoiO9ypJpU05W9T0I
aRCTVPpVRWoP3X+O2808ywBGtEpxcNKWd+Qf7Ry62t3ABm+DszB80vMsfLRvt1th
Xk0Mf3pMTJps4NZCyJq1M2a8sUSyrEtIQf+sFWmjEG2K847wk6lL3sN3kETT+ZQK
Y8yEtNSwoYHkTcwN2oZRSOWeN0RVACzWOlOZxJIx89+dKrIB9p5PFae8XlbE5bEh
Ijjf7GNruEOceZ1GiCAUYtXutgyhGt1jOa1hBFn2BStdY8S5zHWTCayYzf9oIZmb
S++Fz2TLy1vG0B05aVzUkvWf02cguhjJeqiIORtvyKXHuoN/1oOeSyeH2OTmYsgq
rGim/HVE15CFUqaKyCpbbvrRvr4i9MKpIlPS1prg19SwBk4WhSH+rL5USUV5ISEx
puyNLbjot9ecT33059+a
=56T4
-----END PGP SIGNATURE-----

--j2AXaZ4YhVcLc+PQ--
