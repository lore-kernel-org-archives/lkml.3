Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbaDXOpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:45:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60024 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757519AbaDXOpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:45:49 -0400
Date: Thu, 24 Apr 2014 09:45:33 -0500
From: Felipe Balbi <balbi@ti.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <myungjoo.ham@samsung.com>, <balbi@ti.com>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>,
        <ckeepax@opensource.wolfsonmicro.com>, <broonie@kernel.org>,
        <k.kozlowski@samsung.com>, <kyungmin.park@samsung.com>
Subject: Re: [PATCHv3 3/9] extcon: max8997: Use devm_extcon_dev_allocate for
 extcon_dev
Message-ID: <20140424144533.GH26661@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
 <1398342897-23670-4-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FUaywKC54iCcLzqT"
Content-Disposition: inline
In-Reply-To: <1398342897-23670-4-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FUaywKC54iCcLzqT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2014 at 09:34:51PM +0900, Chanwoo Choi wrote:
> This patch use devm_extcon_dev_allocate() to simplify the memory control
> of extcon device.
>=20
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/extcon/extcon-max8997.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8=
997.c
> index 804a446..e2ee2f5 100644
> --- a/drivers/extcon/extcon-max8997.c
> +++ b/drivers/extcon/extcon-max8997.c
> @@ -699,8 +699,7 @@ static int max8997_muic_probe(struct platform_device =
*pdev)
>  	}
> =20
>  	/* External connector */
> -	info->edev =3D devm_kzalloc(&pdev->dev, sizeof(struct extcon_dev),
> -				  GFP_KERNEL);
> +	info->edev =3D devm_extcon_dev_allocate(&pdev->dev, max8997_extcon_cabl=
e);
>  	if (!info->edev) {

and here you never check for IS_ERR(info->evdev)

NAK

I suspect all following patches have the same defect.

--=20
balbi

--FUaywKC54iCcLzqT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWSONAAoJEIaOsuA1yqRE36UP/Rl7i8pmm6IkKKql5aje4Qdq
zZUiy3xo7CuVPnWp4E8SWDAOo6T+D2rfzQMxlh9PBfcI//QchCV54ZhaHsVwDjxw
YhQAR9WjMfCF5reXY1rlrWUZbEei3DJpiJXFs9D/z4JtpIvT5qZA7vf21pt94eE9
QLY+PYlU51vecGp3MQF88ka0iBRgQhB3T5uUsV/C36XYf+wYSYqgPLGPO6ULJomV
0LZFv8EMne/LrEZPDEJF8jzF0c7t6nWIxSCdnw1H8wVt/MSbhwfrtlDhXNoB17ej
mqgpKxxJkNTA+ecnx2YnWH2+s6zKXcwDpXmQ3k5gY2UDNlDZAQICKoveeSd+aV41
+Z2M0tuJKkv9snQ3JiU0jE5Kuv/xhJK48V9t/U+9CMJ5w5UmboEBUpDfXplHX/1N
qoWH1NwuzXejNkhsPhHTcMwplvx1+D9Xqs/BSrn4AGaQV0GvXglz5/gsc+YjAwXZ
M7GuiHu8jo47Blq9xLweJiW9s1TgvzcsWzlazbxt+G7ud8r+zgiIcMvbZB2a+w6F
91eAzsce5cTcpOKNsP2HJsvsDQzIng8YaYAs4BRGJgnd3l8/pfDWcVBqVT40B6P/
I9hcDri1zTJJY+8jrnDuSWEreTPswReyEIzsa7mbZ0QdJUJTHBcgRwXXFycxKWyQ
691ME1Z5cAntw6L2icXP
=Bz0l
-----END PGP SIGNATURE-----

--FUaywKC54iCcLzqT--
