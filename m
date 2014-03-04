Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaCDQIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:08:02 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47688 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbaCDQIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:08:00 -0500
Date: Tue, 4 Mar 2014 10:06:20 -0600
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Chuansheng Liu <chuansheng.liu@intel.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH v2] usb: gadget: return the right length in
 ffs_epfile_io()
Message-ID: <20140304160620.GH15233@saruman.home>
Reply-To: <balbi@ti.com>
References: <n>
 <1393918497-30916-1-git-send-email-chuansheng.liu@intel.com>
 <531606DB.4010601@cogentembedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7SrMUQONj8Rl9QNG"
Content-Disposition: inline
In-Reply-To: <531606DB.4010601@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7SrMUQONj8Rl9QNG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 04, 2014 at 08:01:15PM +0300, Sergei Shtylyov wrote:
> Hello.
>=20
> On 03/04/2014 10:34 AM, Chuansheng Liu wrote:
>=20
> >When the request length is aligned to maxpacketsize, sometimes
> >the return length ret > the user space requested len.
>=20
> >At that time, we will use min_t(size_t, ret, len) to limit the
> >size in case of user data buffer overflow.
>=20
> >But we need return the min_t(size_t, ret, len) to tell the user
> >space rightly also.
>=20
> >Acked-by: Michal Nazarewicz <mina86@mina86.com>
> >Reviewed-by: David Cohen <david.a.cohen@linux.intel.com>
> >Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> >---
> >  drivers/usb/gadget/f_fs.c | 14 ++++++++------
> >  1 file changed, 8 insertions(+), 6 deletions(-)
>=20
> >diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> >index 42f7a0e..780f877 100644
> >--- a/drivers/usb/gadget/f_fs.c
> >+++ b/drivers/usb/gadget/f_fs.c
> >@@ -845,12 +845,14 @@ static ssize_t ffs_epfile_io(struct file *file, st=
ruct ffs_io_data *io_data)
> >  			 * we may end up with more data then user space has
> >  			 * space for.
> >  			 */
> >-			ret =3D ep->status;
> >-			if (io_data->read && ret > 0 &&
> >-			    unlikely(copy_to_user(io_data->buf, data,
> >-						  min_t(size_t, ret,
> >-						  io_data->len))))
> >-				ret =3D -EFAULT;
> >+				ret =3D ep->status;
>=20
>    Why the indentation jumped suddenly to the right?

because it was wrong before ;-)

--=20
balbi

--7SrMUQONj8Rl9QNG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTFfn8AAoJEIaOsuA1yqRE8fUP/ileq+YFz6TkcGK6Iy3AYgQx
LzWAUK/R7FTurf28Hp4a9O23Z/4Lqyde/WtzjTpX25UzZ0V4dwRLXxAc2lkU/LFk
U0qgjC3Z5LPUB1+hId7aHI8X5WCP4xsoM/2U4QR5H58VT4gYYfF+QpebGQGcSzhj
E0YlC+vOE6yq/cTLUdcSiNAfjTjb1rWHYZUznqlZjU/AH2hPKaHE/bLHaI17GLKX
WF3eRkXKetPPYkv36MrFN9r1yJF7lv7jRo/gVUSzHMyl92mRbzSwgn7nwEqNnxjm
22x1/9U19gOsDNInZW+81aoDugDoFJ33/Mo8xHKTW/pccjq9SPA28qPLZfworNPF
NSikEg1BjyxyRrRCX6BuBMS+voP8b34XxoX+HrnHY1FVhL3WdbuQaCpPrfBqjgOL
sy3j1Fp4kgEk3cY2e9aJ9ei5VMpPgONWxwdfuOjhAMJxOrDzQ7dhkL7cATM+vQdm
tnglx4uBhH10ULns3Bw8W1UjZaWDk+BGDM4HW2ApR08cpHuIi0FFEjemThAMKcdd
b2oZCbRG+ZVrerLa3KauUiKB5DxzC8KxAR9hBPoOP4j59ctT2/3f5BHbebFw3PQx
QglGBrgHANEJVO7cXVErX96M1RF9hHGj/ga5zSUJurbDI6a7K0LqWhK0S0oZ8diX
9i9lJXrttZlyXRs7UPyJ
=ucSG
-----END PGP SIGNATURE-----

--7SrMUQONj8Rl9QNG--
