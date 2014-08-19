Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbaHSOQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:16:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47747 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbaHSOQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:16:29 -0400
Date: Tue, 19 Aug 2014 09:16:13 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Robert Baldyga <r.baldyga@samsung.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <m.szyprowski@samsung.com>, <andrzej.p@samsung.com>,
        <k.opasiak@samsung.com>
Subject: Re: [PATCH v3 2/3] usb: gadget: f_fs: add ioctl returning ep
 descriptor
Message-ID: <20140819141613.GD16085@saruman.home>
Reply-To: <balbi@ti.com>
References: <1406713423-32472-1-git-send-email-r.baldyga@samsung.com>
 <1406713423-32472-3-git-send-email-r.baldyga@samsung.com>
 <53D90F18.3050709@cogentembedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eheScQNz3K90DVRs"
Content-Disposition: inline
In-Reply-To: <53D90F18.3050709@cogentembedded.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--eheScQNz3K90DVRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2014 at 07:28:24PM +0400, Sergei Shtylyov wrote:
> On 07/30/2014 01:43 PM, Robert Baldyga wrote:
>=20
> >This patch introduces ioctl named FUNCTIONFS_ENDPOINT_DESC, which
> >returns endpoint descriptor to userspace. It works only if function
> >is active.
>=20
> >Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> >---
> >  drivers/usb/gadget/f_fs.c           | 17 +++++++++++++++++
> >  include/uapi/linux/usb/functionfs.h |  6 ++++++
> >  2 files changed, 23 insertions(+)
>=20
> >diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> >index 6b806be..7f16c5a 100644
> >--- a/drivers/usb/gadget/f_fs.c
> >+++ b/drivers/usb/gadget/f_fs.c
> >@@ -1031,6 +1031,23 @@ static long ffs_epfile_ioctl(struct file *file, u=
nsigned code,
> >  		case FUNCTIONFS_ENDPOINT_REVMAP:
> >  			ret =3D epfile->ep->num;
> >  			break;
> >+		case FUNCTIONFS_ENDPOINT_DESC:
> >+		{
> >+			int desc_idx;
> >+			struct usb_endpoint_descriptor *desc;
> >+
> >+			if (epfile->ffs->gadget->speed =3D=3D USB_SPEED_SUPER)
> >+				desc_idx =3D 2;
> >+			else if (epfile->ffs->gadget->speed =3D=3D USB_SPEED_HIGH)
> >+				desc_idx =3D 1;
> >+			else
> >+				desc_idx =3D 0;
>=20
>    I think the above is asking to be a *switch* statement instead.

agreed.

--=20
balbi

--eheScQNz3K90DVRs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT81wtAAoJEIaOsuA1yqRE41wP+wdnf1M8DsUFb/GGIC8DO/fV
mym2U74tTDc/xbUJHdPw4Gk40WidUlrlmW7rPwbaNJRGj4hh26u56L29+AUZLmm9
f6Wj1v6UoR+2e7l/Uz47npA6xw4hIVtp3on2IaI1cpgZST7PiynPurLTeYKE/aqM
0/GPWAk3FLyg1IFX3eJ0x7B3yZRj8AaEg+TqaHq3/0EGUlfZLUz9MTMkqwUaKXD3
S3t4ny1Cx4pr5dKR+582RRRGT1Ceht+bJaSz/r5FdBbwLknTxsAoWZfx6fQETCO1
iGCWrpHJkFyeS9QhM1d5EfqazCndlMTzEbZ+032Jg2Pz0UcoO83QezkXwJRnMB2v
kfX1fHH5SRR/OqxACjEg21tEhUS+uPMOpohTob9u+ZwxGflnQ3R/pW970Ux1B/aI
XEF7qRJNp6+FLyFy0Wv9urlZfhMPQTqSRDc2MJn7u9jMAYiygeeTxfd8lPfVlJ3r
7FAbhrJv2D2B8tEqQbsF2cYfQxj8OJXBOirkLsiUZhA5pLO4o6/aAomsdlTth4d1
lbq+EOs/2WHepxBZUmQB2/SLvK9zk9WXpHagqXnZhxCm3A30nk36/oQewibL+C3U
BUbXiQof8My9aFMDghSSFuzqprRvpzJj8JDSXnItDJkddj7qOirQ5TaSqgG7TgUd
kcDcGwEnQbPiZcsa3MaL
=OC4d
-----END PGP SIGNATURE-----

--eheScQNz3K90DVRs--
