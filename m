Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964930AbaH0TSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:18:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59489 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935182AbaH0TSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:18:18 -0400
Date: Wed, 27 Aug 2014 14:17:56 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <m.szyprowski@samsung.com>, <andrzej.p@samsung.com>,
        <k.opasiak@samsung.com>
Subject: Re: [PATCH v6 2/3] usb: gadget: f_fs: add ioctl returning ep
 descriptor
Message-ID: <20140827191756.GF6347@saruman.home>
Reply-To: <balbi@ti.com>
References: <1408958189-20611-1-git-send-email-r.baldyga@samsung.com>
 <1408958189-20611-3-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zs/RYxT/hKAHzkfQ"
Content-Disposition: inline
In-Reply-To: <1408958189-20611-3-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Zs/RYxT/hKAHzkfQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Aug 25, 2014 at 11:16:28AM +0200, Robert Baldyga wrote:
> This patch introduces ioctl named FUNCTIONFS_ENDPOINT_DESC, which
> returns endpoint descriptor to userspace. It works only if function
> is active.
>=20
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>  drivers/usb/gadget/function/f_fs.c  | 23 +++++++++++++++++++++++
>  include/uapi/linux/usb/functionfs.h |  6 ++++++
>  2 files changed, 29 insertions(+)
>=20
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/func=
tion/f_fs.c
> index 0dc3552d..6edf7e4 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -1032,6 +1032,29 @@ static long ffs_epfile_ioctl(struct file *file, un=
signed code,
>  		case FUNCTIONFS_ENDPOINT_REVMAP:
>  			ret =3D epfile->ep->num;
>  			break;
> +		case FUNCTIONFS_ENDPOINT_DESC:
> +		{
> +			int desc_idx;
> +			struct usb_endpoint_descriptor *desc;
> +
> +			switch (epfile->ffs->gadget->speed) {
> +			case USB_SPEED_SUPER:
> +				desc_idx =3D 2;
> +				break;
> +			case USB_SPEED_HIGH:
> +				desc_idx =3D 1;
> +				break;
> +			default:
> +				desc_idx =3D 0;
> +			}
> +			desc =3D epfile->ep->descs[desc_idx];
> +
> +			spin_unlock_irq(&epfile->ffs->eps_lock);
> +			ret =3D copy_to_user((void *)value, desc, sizeof(*desc));
> +			if (ret)
> +				ret =3D -EFAULT;
> +			return;

should return a value here. Have you tested this at all ?

--=20
balbi

--Zs/RYxT/hKAHzkfQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/i7kAAoJEIaOsuA1yqREpuMQAJNoRwNaUX/kvncoYM+p5fZP
kahO2N9dUwAKkzv39ynr2AP6qMZ3N5zEsuxlSB81eul1UnjjfRvPpNhqM5sAyioj
J8+bKPvXs0M+VRnugqIqddC5qAOL9WQiQHP9EOWBHoC/Dz9xXnSOJZM6xs03XuEZ
+lLy0/lw+vuUct02APpEdGcNaAIx8IlwTb/fMp8Y18Gnw6DDo08qQW+0h9lxEnCM
QdDC+NnVuGeRJuROzW+Jm4i/grAjrpEM5aHX8TAJOEw+krK0QV4QNdD+mksPGi2L
ETrrWsAmjHcN/Y3TNYmMVhE8IfDAKgivqEC+WH2Ofe/jN1iT2lkB09yknqzk13m8
bd2YZnUWiWGZYQzhSdBVpwTig6TXXEIfqi2egWXCHj1LbZnLaD2BTAtF0bb1JxIp
dxdrDTPyYopicY3Qy/VN1W276daXxeyTKMqoSBCpexIvoQW10P4B6DyZkCZO6AJ0
oJxwXpo8kAW4MkLkqZfhbhX374LifDtqvlWwSQtLCmelqMvgDkRFwckMLdVHb05J
lK8k6aAvClch7xOXEmgunpe/+rbE7/FtmOuh+Usm1q8F6S6qmlwmtolpY5x618ij
G2DTtHlWlmJffM8RlR0VErnHQ2r9bYwR4Slhoa94FdtwwaSzgG8YT09VeXYtcX6o
FjW2PaBLfpiO+6MaTOlp
=3XpJ
-----END PGP SIGNATURE-----

--Zs/RYxT/hKAHzkfQ--
