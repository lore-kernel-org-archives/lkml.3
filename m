Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbbA0P0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:26:49 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42638 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932340AbbA0P0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:26:47 -0500
Date: Tue, 27 Jan 2015 09:26:34 -0600
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Robert Baldyga <r.baldyga@samsung.com>,
        =?utf-8?Q?Micha=C5=82?= Nazarewicz <mina86@mina86.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: ffs: add eventfd notification about ffs
 events
Message-ID: <20150127152634.GA14623@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1422005298-31321-1-git-send-email-r.baldyga@samsung.com>
 <CA+pa1O0nZJ6G1NpPF+qHvchnfSuCvi-f0KMROkOkVq6pNkMX3Q@mail.gmail.com>
 <54C23FE5.9030403@samsung.com>
 <20150127152530.GD13776@saruman.tx.rr.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <20150127152530.GD13776@saruman.tx.rr.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ibTvN161/egqYuK8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 27, 2015 at 09:25:30AM -0600, Felipe Balbi wrote:
> On Fri, Jan 23, 2015 at 01:34:45PM +0100, Robert Baldyga wrote:
> > On 01/23/2015 01:21 PM, Micha=C5=82 Nazarewicz wrote:
> > > 23 sty 2015 10:28 "Robert Baldyga" <r.baldyga@samsung.com
> > > <mailto:r.baldyga@samsung.com>> napisa=C5=82(a):
> > >> Add eventfd which notifies userspace about ep0 events and AIO comple=
tion
> > >> events. It simplifies using of FunctionFS with event loop, because n=
ow
> > >> we need to poll on single file (instead of polling on ep0 and eventf=
d's
> > >> supplied to AIO layer).
> > >>
> > >> FunctionFS eventfd is not triggered if another eventfd is supplied to
> > >> AIO layer (in AIO request). It can be useful, for example, when we w=
ant
> > >> to handle AIO transations for chosen endpoint in separate thread.
> > >>
> > >> Signed-off-by: Robert Baldyga
> > >=20
> > > I don't know much about eventfd interface bit from ffs point of view:
> > >=20
> > > Acked-by: Michal Nazarewicz <mina86@mina86.com <mailto:mina86@mina86.=
com>>
> > >=20
> > >> @@ -2180,6 +2191,20 @@ static int __ffs_data_got_descs(struct ffs_da=
ta
> > > *ffs,
> > >>                 goto error;
> > >>         }
> > >>
> > >> +       if (flags & FUNCTIONFS_EVENTFD) {
> > >> +               if (len < 4)
> > >> +                       goto error;
> > >> +               ffs->ffs_eventfd =3D
> > >> +                       eventfd_ctx_fdget((int)get_unaligned_le32(da=
ta));
> > >> +               if (IS_ERR(ffs->ffs_eventfd)) {
> > >> +                       ffs->ffs_eventfd =3D NULL;
> > >> +                       ret =3D PTR_ERR(ffs->ffs_eventfd);
> > >=20
> > > Need to swap those lines.
> > >=20
> > >> +                       goto error;
> > >> +               }
> > >> +               data +=3D 4;
> > >> +               len  -=3D 4;
> > >> +       }
> > >> +
> > >>         /* Read fs_count, hs_count and ss_count (if present) */
> > >>         for (i =3D 0; i < 3; ++i) {
> > >>                 if (!(flags & (1 << i))) {
> > >=20
> >=20
> > Good catch, thanks!
>=20
> Are you sending a new version, or should I fix this myself?

nevermind, found v2 :)

--=20
balbi

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUx64qAAoJEIaOsuA1yqRExZMP/0zPKhhM3PY9MMWJwWgupRsF
ICiOyAPYWCpkVMU7lGWI6xnTCoyu0bN87kWo2k5Ppn8HsAyltLM1eVBu35yKlnKF
3nKL2FfIqLJnpvoLTHi8BjLOzshH7sadFWiO9UPIwOWRK2rLdqNbe0RUPnxt+oFp
LGyCeF0svf71yJWYLV7YYNNVVhCA1ZM3AVVPcrj3XEU6sc9+X8ulRACCk+qLDLYj
kGKSS4wSxC3iwAtwiCkPSdh+VPuQhtZfGYLLz7txHb9qoausuOLfDa8eT+WWp4wT
2uMAM1Mwkds8y7yI/HXyS/X+l5xgou6rhalAFeA/BR+0XxTkwlCo3z6Lzg3M4+dA
Tr1AKvpUIsEKzJC6YlrWR0EEQZhtTUtqaj0su78ypvO2nhzbpoIw7pyQmpbhr04l
W9VWXrZyhvsL7n10xQ2dhYUZQ9YV51SiJnndDniS/4ykYTpR3006fXNythsdGcxb
XgpOEosMpAsUcef65vJ+CUrpVb/8uwDJAu9QLza7DotiFnmE1FlMj0XFXMUtdPK3
0xSeV6LMbHHnQBM66B/W4Qv2VByZYzq6+sh+tYyeKgRW43/oKAdIm319ul1ay8uq
+CG60IDSuRI/y2QuRscq98l740NxFuFJBqbHsLxDgJf2NTDNU0iUqXYvAXVCl7JD
eOMMubNegBU07Cv2gKkK
=CyzI
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
