Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbbAZQYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:24:10 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55823 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480AbbAZQYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:24:04 -0500
Date: Mon, 26 Jan 2015 17:23:58 +0100
From: Markus Pargmann <mpa@pengutronix.de>
To: Paul Clements <paul.clements@us.sios.com>
Cc: "nbd-general@lists.sourceforge.net" 
	<nbd-general@lists.sourceforge.net>,
        kernel list <linux-kernel@vger.kernel.org>, kernel@pengutronix.de
Subject: Re: [RFC 2/4] nbd: Split 'DO_IT' into three functions
Message-ID: <20150126162358.GE32082@pengutronix.de>
References: <1421156665-27318-1-git-send-email-mpa@pengutronix.de>
 <1421156665-27318-3-git-send-email-mpa@pengutronix.de>
 <CAECXXi5GcAbBzS+ATr2BRryJPvAUPCTMkmVT2TKWESG6anWuWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jKBxcB1XkHIR0Eqt"
Content-Disposition: inline
In-Reply-To: <CAECXXi5GcAbBzS+ATr2BRryJPvAUPCTMkmVT2TKWESG6anWuWw@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:17:36 up 5 days,  6:24, 89 users,  load average: 0.81, 1.60, 1.55
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jKBxcB1XkHIR0Eqt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Mon, Jan 26, 2015 at 11:16:12AM -0500, Paul Clements wrote:
> Markus,
>=20
> This refactor looks OK with the exception of one thing...
>=20
> On Tue, Jan 13, 2015 at 8:44 AM, Markus Pargmann <mpa@pengutronix.de> wro=
te:
>=20
> >  /* Must be called with tx_lock held */
> >
> >  static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *n=
bd,
> > @@ -684,61 +773,8 @@ static int __nbd_ioctl(struct block_device *bdev, =
struct nbd_device *nbd,
> >                 set_capacity(nbd->disk, nbd->bytesize >> 9);
> >                 return 0;
> >
> > -       case NBD_DO_IT: {
> > -               struct task_struct *thread;
> > -               struct socket *sock;
> > -               int error;
> > -
> > -               if (nbd->pid)
> > -                       return -EBUSY;
> > -               if (!nbd->sock)
> > -                       return -EINVAL;
> >
>=20
> You seem to have done away with these checks. Was that inadvertent or
> was there a reason for that? The pid check is necessary to prevent two
> instances of NBD_DO_IT from running. Without the sock check you'll get
> a null pointer deref in nbd_do_it.

Thanks, no there is no reason, it got dropped somewhere. These checks
should defenitely be there. Will fix it for the next version.

I also fixed a lot of error handling, style, format and documentation in
the other patches. Will send the patch series soon, but thanks for the
review so far.

Best regards,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--jKBxcB1XkHIR0Eqt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUxmoeAAoJEEpcgKtcEGQQYX8P/iPbi+CSDiVWDIvH0YIYVtPT
gEUQVdUR/6BIiFxBIKTfcb1GZs00VJd36y/pJQIEw+DnUSGS+xN9Gpdbc0e6nE7l
q7wUFGLoNBqO+JcT1cCMO/oRhZP1XdW6H9Mi3QF4xjWLTUQqy1HEKDFNgZ2e1Ch2
SGLIVBMMqWwkzbWSZ3LnsRuItW9n2fcM1w8gne3yBfdrKmBZtZM7325Ozj9AR1U1
/lWCWOLLIHrC6yFj5ePaEnUdmUWAHtbYVdfnIBXLwqMFMZBQY5RD25IItoVLxDKG
IkTSf3eoL/k0nxFhmrNqPuPjWHfmV4GDT9ENR5kGC7JnT13nbEcfBgl2vU7sHLYe
9OlehYfqhj1O17+km/8pcrbVvOhTF6yPb7Xy3tgxKtRywahwArRJdhy5R5iNqYDk
xSqSp4lKI2WHFoX4OAN8RXi1ssJgZ7KiLKs0jeZuValG/wWuX5kfZ7qYrBAuNCqh
ruIekvRX/FL8mUQJeMJdlmZb8EhaVOKm2WKp5eO3UvcDQDg2fGi6Zuc9DLxL5Pt8
LAoDunkNt3zyiUZ7xvhvvEn6PZtXQHtSfCSRlzDC8qG3uV+sNwAc/Sz8I8bTvWkf
rJMAqCm8qXEbc+CiiDVhgZ6CL3cHj1VtMKNEjM/kUeyHsc9ScmB/S2vaOIliRjpm
dG5i4E2veni7Ew9fwJ7u
=na74
-----END PGP SIGNATURE-----

--jKBxcB1XkHIR0Eqt--
