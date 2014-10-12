Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaJLT7P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 15:59:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38019 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbaJLT7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 15:59:13 -0400
Date: Sun, 12 Oct 2014 14:58:57 -0500
From: Felipe Balbi <balbi@ti.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: David Cohen <david.a.cohen@linux.intel.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <mina86@mina86.com>,
        <r.baldyga@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: Re: [PATCH v2] usb: ffs: fix regression when
 quirk_ep_out_aligned_size flag is set
Message-ID: <20141012195857.GA5153@saruman>
Reply-To: <balbi@ti.com>
References: <1412727486-479-1-git-send-email-david.a.cohen@linux.intel.com>
 <1412802738-28839-1-git-send-email-david.a.cohen@linux.intel.com>
 <20141012191228.GR7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <20141012191228.GR7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 12, 2014 at 08:12:28PM +0100, Al Viro wrote:
> On Wed, Oct 08, 2014 at 02:12:18PM -0700, David Cohen wrote:
> >  		use_mm(io_data->mm);
> >  		for (i =3D 0; i < io_data->nr_segs; i++) {
> > +			size_t len =3D min_t(size_t, ret - pos,
> > +					io_data->iovec[i].iov_len);
> > +			if (!len)
> > +				break;
> >  			if (unlikely(copy_to_user(io_data->iovec[i].iov_base,
> > -						 &io_data->buf[pos],
> > -						 io_data->iovec[i].iov_len))) {
> > +						 &io_data->buf[pos], len))) {
> >  				ret =3D -EFAULT;
> >  				break;
> >  			}
> > -			pos +=3D io_data->iovec[i].iov_len;
> > +			pos +=3D len;
>=20
> Hmm...  This is really asking for something like
> 	if (copy_to_iter(io_data->buf, ret, <something>) !=3D ret)
> 		ret =3D -EFAULT;
> with <something> being an iov_iter instead of iovec.  It would be really
> nice to have that thing switched to ->read_iter/->write_iter, dropping
> ->read/->write/->aio_read/->aio_write; I'm not familiar enough with that
> code to do it on my own, though, so it would require some help from
> maintainers...

cool, Michal, if you're too busy lately, I can look at that one myself.
I suppose the test application we have under tool/usb is good enough for
validation ?

cheers

--=20
balbi

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOt2BAAoJEIaOsuA1yqREcTkP/1fO3KpVlg7Inj8Kaey6APxj
mAiVPGcmr3XBij0aNia2GdUsyf1YtKbd25C/gyzsPlRhBLx0inN4uUfawFyS2CcU
vHdITeJdY6dykUXmCLaVCl1mG696rKKcs2T7pyYOP1Qp9gcwlrlIiFTDN3O+1GWd
4xQ/A31LJpYH6XzAaXFgJrksQ5oEul3cLGNUlf8KMoRPPbxwWv8YhgCCsG2slGCI
OmCs62xemsr67XSUsIuu8RE2VKKrKsxMGl4OXpxKl+YALKhBLcwOCXTEvVIGilHK
6pRhXVyMwkE6ZwWB316XVfSCqL+cocP2D7V9HaNHQdoJVNla4ikQNuYTK2fouucN
Y/CUgrZ8FYAFQEju994UeJeO+MmIe7eADUvxx2qXlrDFHkCnsTVcUbVbqpJZ9naH
eMM0dPzAElCV1AOrdzf78mdnnHk1iIclewdQtXQIGvvQox3AkX90N2FvN52FITX8
RJWywcyYYBWzNLz1QS/f8+dLEpqf+WGODNwnymbYFgGP27uRzwYf/x5bX69mMfdL
LYN53RSPmIoEgDOk3pbq+In0KuCk9IjPyEz5SpqZ8xl3hwHXmiYFuEIszMREV4Xk
KrHCxWAXlHa/kbD3sBMMWo+y3r/flfPCNaaQ7wMwdY5XtseJ0IqEc0xs/z2sHZbd
HecqQX13Frm+DbDkK8ju
=l/AO
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
