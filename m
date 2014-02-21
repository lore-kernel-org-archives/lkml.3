Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaBUIUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 03:20:55 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39012 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbaBUIU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 03:20:28 -0500
Date: Fri, 21 Feb 2014 09:20:22 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Ilia Mirkin <imirkin@alum.mit.edu>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/radeon: silence GCC warning on 32 bit
Message-ID: <20140221082021.GG22574@ulmo.nvidia.com>
References: <alpine.DEB.2.00.1401300249130.13810@skynet.skynet.ie>
 <1391085212.5170.9.camel@x41>
 <1392930177.15264.5.camel@x220>
 <CAKb7Uvg=U+b0d2uBM3rrXzotdCM=VZsJ0ArPU82Nzy95S=WZRw@mail.gmail.com>
 <1392931493.15264.17.camel@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p7qwJlK53pWzbayA"
Content-Disposition: inline
In-Reply-To: <1392931493.15264.17.camel@x220>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p7qwJlK53pWzbayA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 20, 2014 at 10:24:53PM +0100, Paul Bolle wrote:
> On Thu, 2014-02-20 at 16:07 -0500, Ilia Mirkin wrote:
> > On Thu, Feb 20, 2014 at 4:02 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > > @@ -935,7 +935,7 @@ static ssize_t radeon_ttm_gtt_read(struct file *f=
, char __user *buf,
> > >         while (size) {
> > >                 loff_t p =3D *pos / PAGE_SIZE;
> > >                 unsigned off =3D *pos & ~PAGE_MASK;
> > > -               ssize_t cur_size =3D min(size, PAGE_SIZE - off);
> > > +               ssize_t cur_size =3D min(size, (size_t)(PAGE_SIZE - o=
ff));
> >=20
> > Isn't the usual way of dealing with these to do something like
> >=20
> > ssize_t cur_size =3D min_t(ssize_t, size, PAGE_SIZE - off)
>=20
> I wouldn't know. I did
>     $ git grep -n "(size_t)(PAGE_SIZE"
>     arch/powerpc/mm/dma-noncoherent.c:357:  size_t seg_size =3D min((size=
_t)(PAGE_SIZE - offset), size);
>     arch/tile/kernel/pci-dma.c:176: size_t bytes =3D min(size, (size_t)(P=
AGE_SIZE - offset));
>     arch/tile/kernel/pci-dma.c:192: size_t bytes =3D min(size, (size_t)(P=
AGE_SIZE - offset));
>     drivers/net/wireless/ti/wlcore/main.c:806:      len =3D min(maxlen, (=
size_t)(PAGE_SIZE - wl->fwlog_size));
>     drivers/scsi/libfc/fc_libfc.c:143:                             (size_=
t)(PAGE_SIZE - (off & ~PAGE_MASK)));
>     drivers/target/tcm_fc/tfc_io.c:160:                     tlen =3D min(=
tlen, (size_t)(PAGE_SIZE -
>     drivers/target/tcm_fc/tfc_io.c:311:             tlen =3D min(tlen, (s=
ize_t)(PAGE_SIZE -
>=20
> and concluded my solution was acceptable. Is your alternative considered
> to be better?

Yes, min_t() is specifically meant for this type of situation. On a side
note, I think cur_size should be size_t rather than ssize_t.

Thierry

--p7qwJlK53pWzbayA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBwxFAAoJEN0jrNd/PrOh5Y4P/RxyqJ2uVJ0Y+t0d/R2REVxM
coWeAux709piHEatdm2eXZxTcSTt9G6MJOEpU4GNIcSWV+3PXZgowB0HGZTceZde
MGR2YyZHREXam6UFunWUaHezFAC12CPSFubP9dPzK9gdYsbnE3ss2iXekpgjjzZr
yLTDyg8Jd+jJtmAFm2GLaEMKuuLSMvJcAf2Pveu/+C/aDXkdVthJtfb/hgIG/puk
3f8jDaYe+HfVBiEQxyu3kh8aXtOXAdzsaydqh9940b7YXCYl/WcCN88Z31XRg24V
GMrWpLNx/mLsXCu9/vHo11K/C1aABitxnLDBLVuK+8Mo4q0npqTrIbw9WIO4wxxT
PQO3eyENIvdik5+n2GmhoVafNKLRN2BtKyN6wvfqhpQVJ7njRt0FcbwXvugQTfmm
GDWKQfTKB/DZsFbhefppiUq+BWLxustBboBJJZtUy/Qndn3JNq2k6VOnAFbPtspI
t/HVptKsK2jDmyeF/HTpgV/EpoXzWpo6zx0cWJvMz764CEGnwbrlMR0t49gjNcs3
8W+vdQOawnRLn3o2b16YtWnYdU/Nn/HWnFHCdzj8f+0DgFuGwk0OLQ49a7wEjpE0
qsJDZRf7RP0nhl8vjMEceK0MFInDaz4AttCI1SYPtmFJBUA8wUcufKKe5aa034Uq
E4zWBGSLAXMuKk38FuB1
=qoNA
-----END PGP SIGNATURE-----

--p7qwJlK53pWzbayA--
