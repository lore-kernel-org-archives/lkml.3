Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692AbaDXOnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:43:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59907 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbaDXOnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:43:18 -0400
Date: Thu, 24 Apr 2014 09:42:57 -0500
From: Felipe Balbi <balbi@ti.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <myungjoo.ham@samsung.com>, <balbi@ti.com>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>,
        <ckeepax@opensource.wolfsonmicro.com>, <broonie@kernel.org>,
        <k.kozlowski@samsung.com>, <kyungmin.park@samsung.com>
Subject: Re: [PATCHv3 1/9] extcon: Add extcon_dev_allocate/free() to control
 the memory of extcon device
Message-ID: <20140424144257.GF26661@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
 <1398342897-23670-2-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DO5DiztRLs659m5i"
Content-Disposition: inline
In-Reply-To: <1398342897-23670-2-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DO5DiztRLs659m5i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2014 at 09:34:49PM +0900, Chanwoo Choi wrote:
> This patch add APIs to control the extcon device on extcon provider drive=
r.
> The extcon_dev_allocate() allocates the memory of extcon device and initi=
alizes
> supported cables. And then extcon_dev_free() decrement the reference of t=
he
> device of extcon device and free the memory of the extcon device. This AP=
Is
> must need to implement devm_extcon_dev_allocate()/free() APIs.
>=20
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/extcon/extcon-class.c | 39 +++++++++++++++++++++++++++++++++++++=
++
>  include/linux/extcon.h        | 13 +++++++++++++
>  2 files changed, 52 insertions(+)
>=20
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index f6df689..bec66d4 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -565,6 +565,45 @@ static void dummy_sysfs_dev_release(struct device *d=
ev)
>  {
>  }
> =20
> +/*
> + * extcon_dev_allocate() - Allocate the memory of extcon device.
> + * @supported_cable:	Array of supported cable names ending with NULL.
> + *			If supported_cable is NULL, cable name related APIs
> + *			are disabled.
> + *
> + * This function allocates the memory for extcon device without allocati=
ng
> + * memory in each extcon provider driver and initialize default setting =
for
> + * extcon device.
> + *
> + * Return the pointer of extcon device if success or ERR_PTR(err) if fail
> + */
> +struct extcon_dev *extcon_dev_allocate(const char **supported_cable)
> +{
> +	struct extcon_dev *edev;
> +
> +	edev =3D kzalloc(sizeof(*edev), GFP_KERNEL);
> +	if (!edev) {
> +		pr_err("Failed to allocate the memory for extcon device\n");
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	edev->max_supported =3D 0;
> +	edev->supported_cable =3D supported_cable;
> +
> +	return edev;
> +}
> +
> +/*
> + * extcon_dev_free() - Free the memory of extcon device.
> + * @edev:	the extcon device to free
> + */
> +void extcon_dev_free(struct extcon_dev *edev)
> +{
> +	if (edev)
> +		kfree(edev);

kfree(NULL) is safe

--=20
balbi

--DO5DiztRLs659m5i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWSLxAAoJEIaOsuA1yqREnQsP/R6j6dc4wjmhdYJqDY1adXjE
/SItcf9ja2KWQVcA4pPffIqtTAVVROUSKS0l9O9DaMZyPZcCZclZFwZ4zbvUgR0U
zXFEqNe5iSq21Vak4WyTMreD3dmna4djjhHNXepCujHbbH3PJfDBfhCU/9Eru5vz
Nqz+aHk/nE5X0J+8eLBRGebuuyHHV5W+v9223VWKzzMDw0JcEQZ5dzI816ilJ48f
qEixf43zx+0i55J6puybWb06ntgp1nBW5Y8URUgg2YL7Bsv6kdyyWbvs2CTKbD/5
I1PLSqErqxLtVHbkXr60eHuHDX0K+8PMW5MpokYXwgM+DMs+I8hO5E75hCGYItI9
W7/q2eRNk3etZqyX7NBinPLhVDT+CbrbFCOtk5NDJU3G7+I9cxKuFcLay9x/FNXX
RK0GxboCXX8iY7VWXiYl/MpXnQDhlGkf6voN+uDA6RjUmakAENC8c8QZCFP93aDS
HWvbDN9xpknbqvGeM/mjWR1jc93cSrfzQ+dhPHlAnn2C4uQ8oA9YIv+Z+aC1PsC2
CtyJzxKUpMZuWt42M/2TrcKMxj2rIsds4WnbFjw/DCU1bfIKS82sY4SepkZ/i/z7
MgQgH5IDhwvNDpex78KrCYpOEW3913BKAqO/Amy90V3db8m/cuR/8jXSLZ+tK3m4
vQByfUKkgRoHWPB8UkRb
=IpQG
-----END PGP SIGNATURE-----

--DO5DiztRLs659m5i--
