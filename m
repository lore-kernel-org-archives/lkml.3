Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbbA0PZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:25:49 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33649 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbbA0PZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:25:46 -0500
Date: Tue, 27 Jan 2015 09:25:30 -0600
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: =?utf-8?Q?Micha=C5=82?= Nazarewicz <mina86@mina86.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: ffs: add eventfd notification about ffs
 events
Message-ID: <20150127152530.GD13776@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1422005298-31321-1-git-send-email-r.baldyga@samsung.com>
 <CA+pa1O0nZJ6G1NpPF+qHvchnfSuCvi-f0KMROkOkVq6pNkMX3Q@mail.gmail.com>
 <54C23FE5.9030403@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IDYEmSnFhs3mNXr+"
Content-Disposition: inline
In-Reply-To: <54C23FE5.9030403@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IDYEmSnFhs3mNXr+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 23, 2015 at 01:34:45PM +0100, Robert Baldyga wrote:
> On 01/23/2015 01:21 PM, Micha=C5=82 Nazarewicz wrote:
> > 23 sty 2015 10:28 "Robert Baldyga" <r.baldyga@samsung.com
> > <mailto:r.baldyga@samsung.com>> napisa=C5=82(a):
> >> Add eventfd which notifies userspace about ep0 events and AIO completi=
on
> >> events. It simplifies using of FunctionFS with event loop, because now
> >> we need to poll on single file (instead of polling on ep0 and eventfd's
> >> supplied to AIO layer).
> >>
> >> FunctionFS eventfd is not triggered if another eventfd is supplied to
> >> AIO layer (in AIO request). It can be useful, for example, when we want
> >> to handle AIO transations for chosen endpoint in separate thread.
> >>
> >> Signed-off-by: Robert Baldyga
> >=20
> > I don't know much about eventfd interface bit from ffs point of view:
> >=20
> > Acked-by: Michal Nazarewicz <mina86@mina86.com <mailto:mina86@mina86.co=
m>>
> >=20
> >> @@ -2180,6 +2191,20 @@ static int __ffs_data_got_descs(struct ffs_data
> > *ffs,
> >>                 goto error;
> >>         }
> >>
> >> +       if (flags & FUNCTIONFS_EVENTFD) {
> >> +               if (len < 4)
> >> +                       goto error;
> >> +               ffs->ffs_eventfd =3D
> >> +                       eventfd_ctx_fdget((int)get_unaligned_le32(data=
));
> >> +               if (IS_ERR(ffs->ffs_eventfd)) {
> >> +                       ffs->ffs_eventfd =3D NULL;
> >> +                       ret =3D PTR_ERR(ffs->ffs_eventfd);
> >=20
> > Need to swap those lines.
> >=20
> >> +                       goto error;
> >> +               }
> >> +               data +=3D 4;
> >> +               len  -=3D 4;
> >> +       }
> >> +
> >>         /* Read fs_count, hs_count and ss_count (if present) */
> >>         for (i =3D 0; i < 3; ++i) {
> >>                 if (!(flags & (1 << i))) {
> >=20
>=20
> Good catch, thanks!

Are you sending a new version, or should I fix this myself?

--=20
balbi

--IDYEmSnFhs3mNXr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUx63qAAoJEIaOsuA1yqREYU4QAIapQIE4blRUDKnCa0Mo4fmY
Tsc/06BX5pkA/CL/Cj1GraIPqiR4gwCnqyilMphS+JC3Oo+i+sshh2ZgS2lLdoNz
S3TmPaGPOKRP5NtzzN/YBiYrjNlcTe2DsNBB/xHBQZ29ux85nZqaWBNv/NhzVlK+
oqw2SIeaDmAwhHlW/eEomBwqMSqYpty+kKDoYDPNW3ai0ARsGmY3LNIBP68tpHU8
QsVX3VP7qZt+kDL4rZFXfJg/FeB56Cn+om0WAQfISyooadCJDWqZHHbt7Lg29D7/
9eHFDDAV/tFoLq3eW50dvuCLJV2sVEHdBOAAfk6Hc1sJDxP0JWIkW3cyCdlKcu+a
XXsNcrB22vPwP9a1jBpVc3DZVjcWRskWzOqn5JD3I1lvYDzsWwOGEuapOe11NGNd
oAS5lTFVQVa7pwn6ZNRQfqocEm1rWN6IeycqeogHhyWT5zYuLYr6C13xdQJur/UI
rEutflk4H6iry3WcMVDZ5EepOuWY95ANmOQUq15HDNJ8yMHWRQ7h6GttTvrBm7br
5pRi2OOjdopyWCqubshexBmbhkOo56XMjeX15Ccdzdw8GW+sbD8zQPKOWlS3XOeT
TebwEmh5M9BiTo3nT+GVwZhX7EVnQaVXUKVVBnnnsMZyFmWDprkf00RuP8XBpoFe
qO1BFeaeWt3t8bKEUJpJ
=SIg3
-----END PGP SIGNATURE-----

--IDYEmSnFhs3mNXr+--
