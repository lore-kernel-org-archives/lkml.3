Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbaCCQbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:31:51 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36606 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbaCCQbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:31:50 -0500
Date: Mon, 3 Mar 2014 10:30:13 -0600
From: Felipe Balbi <balbi@ti.com>
To: Chuansheng Liu <chuansheng.liu@intel.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <mina86@mina86.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <david.a.cohen@intel.com>, <jin.can.zhuang@intel.com>,
        <yu.y.wang@intel.com>
Subject: Re: [PATCH] usb: gadget: return the right length in ffs_epfile_io()
Message-ID: <20140303163013.GC2759@saruman.home>
Reply-To: <balbi@ti.com>
References: <n>
 <1393483771-24623-1-git-send-email-chuansheng.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V88s5gaDVPzZ0KCq"
Content-Disposition: inline
In-Reply-To: <1393483771-24623-1-git-send-email-chuansheng.liu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--V88s5gaDVPzZ0KCq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Feb 27, 2014 at 02:49:31PM +0800, Chuansheng Liu wrote:
> When the request length is aligned to maxpacketsize, sometimes
> the return length ret > the user space requested len.
>=20
> At that time, we will use min_t(size_t, ret, len) to limit the
> size in case of user data buffer overflow.
>=20
> But we need return the min_t(size_t, ret, len) to tell the user
> space rightly also.
>=20
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> ---
>  drivers/usb/gadget/f_fs.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index 2b43343..31ee7af 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -687,10 +687,12 @@ static ssize_t ffs_epfile_io(struct file *file,
>  			 * space for.
>  			 */
>  			ret =3D ep->status;
> -			if (read && ret > 0 &&
> -			    unlikely(copy_to_user(buf, data,
> -						  min_t(size_t, ret, len))))
> -				ret =3D -EFAULT;
> +			if (read && ret > 0) {
> +				ret =3D min_t(size_t, ret, len);
> +
> +				if (unlikely(copy_to_user(buf, data, ret)))
> +					ret =3D -EFAULT;
> +			}

please rebase on my "testing/next" branch

--=20
balbi

--V88s5gaDVPzZ0KCq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTFK4VAAoJEIaOsuA1yqRE0Q0QAJ09W+PMrs+R6PvnnBEdIxSN
m33QObaiX/7UJMGur61J3wqgkdaVNMbhfCBcQxXF2yqgYppBp4usf3vzopWWVLUO
qSrATBDPxEv96w9rjvKdEFW4HPmPlBFJfUCJyhqPweKWfWfNPFOODCjUls0L+SLo
VUsoPdaF5pdMqNh9yUPnXFdAIZmAuuFYIK0Kg//y+UlqTk8ii6jhWR0L+33c6vBI
l3P99C3Itbw53WfF4E4LaeAj/hGSoaPIYI01yIsSGxtoz0JCI52zAQLanXWosJNe
76AlQAp8V9qenNnvolbrHvnp8E0ol/CuY/wgiD4USQ76n0uTUYrBQ1zpJPsTj4Hh
yDxGaW9caq27FGuIhsXl22aE49/gJZZRdqPkAl8GP76q6fM0AhLO9oZyIO9/5YYx
yKvWqK6HPS2UO30zMigSZB4uQ49qnOpwNY/DxivaK4k7aoD0Q02ZWHZ/b9o8fZgX
+gStwXjidBW0wVuQIBrWx2IL42KUEimPsFPPj+CxmGtBzIbUBVDLt6BaEMDqix2y
Dp+qanQfWNUUiv1XgETlKmF5fojUzCtAc7+rYl5jLOI4P1jeoix2QCIdIEM0COAi
IbRZxY9Zy3gg5/camxBt/w2YPr3qv+qZhKdPvLMya0PhmYmwsiKnW+wl6LA4/Xax
xvpGMamJBb6ZALGjfmDK
=6+2z
-----END PGP SIGNATURE-----

--V88s5gaDVPzZ0KCq--
