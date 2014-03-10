Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbaCJUAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:00:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41213 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbaCJUAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:00:42 -0400
Date: Mon, 10 Mar 2014 14:58:55 -0500
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>
CC: Robert Baldyga <r.baldyga@samsung.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <m.szyprowski@samsung.com>,
        <andrzej.p@samsung.com>
Subject: Re: [PATCH] usb: gadget: f_fs: add missing spinlock and mutex unlock
Message-ID: <20140310195855.GC4476@saruman.home>
Reply-To: <balbi@ti.com>
References: <1394440417-6100-1-git-send-email-r.baldyga@samsung.com>
 <xa1ty50icifo.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JgQwtEuHJzHdouWu"
Content-Disposition: inline
In-Reply-To: <xa1ty50icifo.fsf@mina86.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--JgQwtEuHJzHdouWu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 10, 2014 at 02:05:47PM +0100, Michal Nazarewicz wrote:
> On Mon, Mar 10 2014, Robert Baldyga <r.baldyga@samsung.com> wrote:
> > This patch adds missing spin_unlock and mutex_unlock calls in
> > error handling code.
> >
> > Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
>=20
> Acked-by: Michal Nazarewicz <mina86@mina86.com>

Greg, here's another one you can pick. It's also a coccicheck fix.

Acked-by: Felipe Balbi <balbi@ti.com>

> > ---
> >  drivers/usb/gadget/f_fs.c |    8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> > index b7d273a..d6bd0a3 100644
> > --- a/drivers/usb/gadget/f_fs.c
> > +++ b/drivers/usb/gadget/f_fs.c
> > @@ -802,7 +802,7 @@ static ssize_t ffs_epfile_io(struct file *file, str=
uct ffs_io_data *io_data)
> >  		if (io_data->aio) {
> >  			req =3D usb_ep_alloc_request(ep->ep, GFP_KERNEL);
> >  			if (unlikely(!req))
> > -				goto error;
> > +				goto error_lock;
> > =20
> >  			req->buf      =3D data;
> >  			req->length   =3D io_data->len;
> > @@ -817,7 +817,7 @@ static ssize_t ffs_epfile_io(struct file *file, str=
uct ffs_io_data *io_data)
> >  			ret =3D usb_ep_queue(ep->ep, req, GFP_ATOMIC);
> >  			if (unlikely(ret)) {
> >  				usb_ep_free_request(ep->ep, req);
> > -				goto error;
> > +				goto error_lock;
> >  			}
> >  			ret =3D -EIOCBQUEUED;
> > =20
> > @@ -863,6 +863,10 @@ static ssize_t ffs_epfile_io(struct file *file, st=
ruct ffs_io_data *io_data)
> > =20
> >  	mutex_unlock(&epfile->mutex);
> >  	return ret;
> > +
> > +error_lock:
> > +	spin_unlock_irq(&epfile->ffs->eps_lock);
> > +	mutex_unlock(&epfile->mutex);
> >  error:
> >  	kfree(data);
> >  	return ret;
> > --=20
> > 1.7.9.5
> >
>=20
> --=20
> Best regards,                                         _     _
> .o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
> ..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz =
   (o o)
> ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--





--=20
balbi

--JgQwtEuHJzHdouWu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTHhl/AAoJEIaOsuA1yqREflkP/1go+D9ySwE3K1PiZaJG0d/T
Df+LaO8A2Pfc71k2baLTr0fWSjMAcwO7D6gT2IXJ5khVacdmvE8NjsSINJL+sn3F
/X/qkAtgLt2XZRY1pCVDxF+nmh4C1/zLmyLfr1fnHglPvVvnID78tbxHwPPDDROl
2q/BRkTzhHdt4iSr88hqhNwY2LbLtgdJJwyMKWDBpQM+UiZKKw11T9efWwDmY1jI
QSv60PaMoK/akWeREFEcbzjV/VnecxtmIfEnoyJ3hloTSeXCEVTgDOG7DKvXfCbv
lBYNNQuIU7F6iYzJLWxK+nOFuxH2yaKfBxQSn0OPYrU7GpcnNgfI5XGblCbh02mc
HPeq7vyWfAQIpeU5td5yvoqud4+uCF7AEMHAruM3X0nnCXZfAL31DSwm3+9mkcZJ
VVQI/Dxgwx6gER037U/vKF9e0QZViAwFwQYeSGEz2WBzTLZdrjv6tR8D8hdNMwrU
ePY8Y8slRK4IhMY+CMsNfJ2D/532ArlXfXxPSvwbKlviSPcRWRC/SEzyaEpL3jvK
f56KCMZl3FwypJbyJcdQSvbO9HMfgSu1LrNlkXjUKiO5nQPBHDttgFSyNWpvp4jJ
CEalwxXe/ec6CVmD+jxMzBRAGwbJgoUioLKtUmQZdboURUneXDlqRH0GTkaBKDzs
yud3yYGpaJ2FlxyN8Dnb
=sL+j
-----END PGP SIGNATURE-----

--JgQwtEuHJzHdouWu--
