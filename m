Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab3FZNPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:15:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58355 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab3FZNPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:15:51 -0400
Message-ID: <51CAE967.7080704@ti.com>
Date: Wed, 26 Jun 2013 16:15:19 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 9/9] radeon: use pdev->pm_cap instead of pci_find_capability(..,PCI_CAP_ID_PM)
References: <1372209221-16492-1-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1372209221-16492-1-git-send-email-wangyijing@huawei.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="----enig2JXSOVFUTAXMWMIWJXHUX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2JXSOVFUTAXMWMIWJXHUX
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 26/06/13 04:13, Yijing Wang wrote:
> Pci core has been saved pm cap register offset by pdev->pm_cap in pci_p=
m_init()
> in init path. So we can use pdev->pm_cap instead of using
> pci_find_capability(pdev, PCI_CAP_ID_PM) for better performance and sim=
plified code.
>=20
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: linux-fbdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/video/aty/radeon_pm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/video/aty/radeon_pm.c b/drivers/video/aty/radeon_p=
m.c
> index 92bda58..f7091ec 100644
> --- a/drivers/video/aty/radeon_pm.c
> +++ b/drivers/video/aty/radeon_pm.c
> @@ -2805,7 +2805,7 @@ static void radeonfb_early_resume(void *data)
>  void radeonfb_pm_init(struct radeonfb_info *rinfo, int dynclk, int ign=
ore_devlist, int force_sleep)
>  {
>  	/* Find PM registers in config space if any*/
> -	rinfo->pm_reg =3D pci_find_capability(rinfo->pdev, PCI_CAP_ID_PM);
> +	rinfo->pm_reg =3D rinfo->pdev->pm_cap;
> =20
>  	/* Enable/Disable dynamic clocks: TODO add sysfs access */
>  	if (rinfo->family =3D=3D CHIP_FAMILY_RS480)

I couldn't find the rest of this series, and I'm not familiar with PCI.
So: is this patch and "aty128fb: use pdev->pm_cap instead of
pci_find_capability(..,PCI_CAP_ID_PM)" safe to apply for fbdev-3.11
without anything else? I.e. has the PCI core changes been merged in 3.10
or ealier?

 Tomi



------enig2JXSOVFUTAXMWMIWJXHUX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRyulnAAoJEPo9qoy8lh718/oP/2XD7of+91CgVPfoHau5k5Rh
1yYejwTq0PW4g+mygzGXJ6Ce+FAg5QQHbck20wNiJ0MyFHrZJjok5V1zkMNZMwol
ZftKhgleQ+TcfgyY4cIXDwP0Zsd4Cdker3z7ChDan/t/VhUspM3BMXoSccxhSrO2
2RtEE6f+FH1IIVAr8Bw7eiyekkMhMjP/3vBALwmwxHkGSAyvs7Wx07yjH/1/BcXW
gMs7ZprU+faSlI1S3BGzovEqks1/GbSVBf5yI7unnORs5TPKPXuIEXaoZM1e1KVT
DyGMJI4NhC0eVV8LvG4pcOvLXnDbUC7JUDDKfEJ9DRPw8WirMOfjmN1qbdZeG6vx
b0HJsg4XdEKIw8El2QIWF+04ygLNyeHHu94e1Aw/KWRlYJE0otzdNKdfUGO1M+MW
DkncDUuc8qNfuQNJ7/Q7tJVqVUI7CklRZiRz1dgHGVGdU/ZrvjzI6Iq4CpckrFK3
S7LifuGcJwfzsa01r5PE7SFLr+2ttEFV/OhIXNynOh5ANhhYBExdJ2rNVZ6rRRFG
szDdLPcWAYtJj3NytJ+eo4F5oH2cS9azRBBNf9eW2QktL33y6dtU0/ZD+YEW3ZUp
VGWZUvFBlv89CD32p5IHJ64IoD6ZVRQ2lULTyVX0ZbhpjwVijlBSfPgH83NHBxJj
QHYcko4aI7TgBNJyNHtI
=fg/V
-----END PGP SIGNATURE-----

------enig2JXSOVFUTAXMWMIWJXHUX--
