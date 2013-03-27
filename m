Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218Ab3C0LLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:11:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36564 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab3C0LLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:11:45 -0400
Date: Wed, 27 Mar 2013 22:11:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>, Greg KH <greg@kroah.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (v4l-dvb tree related)
Message-Id: <20130327221128.db6d370b4c06ceaf600b6ab5@canb.auug.org.au>
In-Reply-To: <20130327105234.3396059519ca69f405f703b1@canb.auug.org.au>
References: <20130326171847.18cd41b85d3caee6373d9447@canb.auug.org.au>
	<20130326090452.01550c37@redhat.com>
	<20130327105234.3396059519ca69f405f703b1@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__27_Mar_2013_22_11_28_+1100_lLQO+D24Ab5V1o6f"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Mar_2013_22_11_28_+1100_lLQO+D24Ab5V1o6f
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Wed, 27 Mar 2013 10:52:34 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Tue, 26 Mar 2013 09:04:52 -0300 Mauro Carvalho Chehab <mchehab@redhat.=
com> wrote:
> >
> > Em Tue, 26 Mar 2013 17:18:47 +1100
> > Stephen Rothwell <sfr@canb.auug.org.au> escreveu:
> >=20
> > > After merging the final tree, today's linux-next build (powerpc
> > > allyesconfig) failed like this:
> > >=20
> > > drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c: In function 'solo=
_enc_default':
> > > drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c:1031:7: error: cas=
e label does not reduce to an integer constant
> > > drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c:1035:7: error: cas=
e label does not reduce to an integer constant
> > >=20
> > > I am not sure why this has suddenly appeared, but I have disabled the
> > > driver for now using this patch:
> >=20
> > Well, solo6x10 didn't use to have its own private ioctl's until now.
> > Still, that's strange, as there are other drivers also using vidioc_def=
ault.
> >=20
> > I suspect that those _IO* have its highest bit equal to 1 on powerpc
> > being too big for int. If so, the enclosed patch should fix.=20
> > I'm still wandering why it didn't cause any compilation problems here.
> >=20
> > Ok, I didn't try to compile it on powerpc, but still integers have 32
> > bits on ppc, right?
>=20
> yes.
>=20
> > Anyway, could you please try the enclosed patch?
>=20
> Doesn't help.
>=20
> on powerpc, SOLO_IOC_G_MOTION_THRESHOLDS expands to
>=20
> (((2U) << (((0 +8)+8)+13)) | ((('V')) << (0 +8)) | (((192 +0)) << 0) | ((=
(((sizeof(struct solo_motion_thresholds) =3D=3D sizeof(struct solo_motion_t=
hresholds[1]) && sizeof(struct solo_motion_thresholds) < (1 << 13)) ? sizeo=
f(struct solo_motion_thresholds) : __invalid_size_argument_for_IOC))) << ((=
0 +8)+8)))
>=20
> sizeof(struct solo_motion_thresholds) is 64*64*2 =3D=3D 8192 which is not
> less than 1 << 13

Note that this will also break on alpha and mips.  Sparc seems to have a
tricky workaround (to allow 14 bits for size) - I wonder if that could be
used for these other arches as well?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__27_Mar_2013_22_11_28_+1100_lLQO+D24Ab5V1o6f
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRUtPgAAoJEECxmPOUX5FEizQQAJz/rVFBGnQwDvJAXrWmTFTX
hyN6xfOF6+0Sp920TbbLGG1GEJo17majM5uJhtTOPY2KtYvfa1STi5ILFeZN5Ts9
Zw8zTmeTNEbb1dpADsQhBz/1ABzRmXlRoHhgnUepQ72khjgF8U9lCkDbbNxVamGV
686raNhmGv5qTYPsRs/DFvfRnpxa+d68oFHFb1H16df5nQzWKrMWx90RgM6U1fzU
DAW9S6Ln/ke2Io8VaDoPHrnU9FK/YugqqwaHIse5UjXBwuUMakT7zEByY/2P88br
pQThcbbNIlWx3smTm5A2O6+bQ+LO2iakL317IG0A6QUSWUuKZ22kdtDZOjrQh9ZL
5N5lNySUVIrPNK5uyav6achRQT4d8p4+cyTjqSy7d+pDu6N9tXHOypazZ4cR/yw5
ERGRANqx/O211wWufsGJF83dCWHIfc7YIust1YJCRR0i6knLehUVhYWysWdVj8xh
a8c1lEx9T/PD9rSLbUQGyJVyszyiRi9trO/efSXD6TQkgUu17E0AagJ6VMln9Lco
XusQYRz1wR0jOgi8gFgi6QKScdg++KAKUM2F8SfhaAn3GUCTdHFC5OYDC+oxG1NQ
OnESnmZGGvcBZx4Te13SskKMgGuKw7URiBw1QBuFliGRJnbtUp/7PwyU0XXGu/Wo
Vr8NAwW65UXQhepiBQIT
=Bh1i
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Mar_2013_22_11_28_+1100_lLQO+D24Ab5V1o6f--
