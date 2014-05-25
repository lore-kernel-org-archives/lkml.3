Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaEYXGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 19:06:33 -0400
Received: from ozlabs.org ([103.22.144.67]:36808 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbaEYXGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 19:06:31 -0400
Date: Mon, 26 May 2014 09:06:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: David Herrmann <dh.herrmann@gmail.com>,
        Vincent =?UTF-8?B?U3RlaGzDqQ==?= <vincent.stehle@laposte.net>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH linux-next] DRM: Armada: update dma_buf_export use
Message-ID: <20140526090623.77186cdf@canb.auug.org.au>
In-Reply-To: <20140525225435.GZ3693@n2100.arm.linux.org.uk>
References: <1400965544-20092-1-git-send-email-vincent.stehle@laposte.net>
	<CANq1E4QdGeHeuCu9LvPkbGZX5C+ax4fWVqq4kJ5wMUBx5uWZrQ@mail.gmail.com>
	<20140525225435.GZ3693@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/hUaVbygK9B_rEKH.8w2c=w+"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/hUaVbygK9B_rEKH.8w2c=w+
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all,

On Sun, 25 May 2014 23:54:35 +0100 Russell King - ARM Linux <linux@arm.linu=
x.org.uk> wrote:
>
> On Sun, May 25, 2014 at 02:08:48PM +0200, David Herrmann wrote:
> >=20
> > On Sat, May 24, 2014 at 11:05 PM, Vincent Stehl=C3=A9
> > <vincent.stehle@laposte.net> wrote:
> > > The dma_buf_export function was updated in commit 4bcec44ffaf9 'dma-b=
uf: use
> > > reservation objects' to take a reservation object parameter; update A=
rmada
> > > export method accordingly.
> > >
> > > This fixes the following compilation error:
> > >
> > >   drivers/gpu/drm/armada/armada_gem.c: In function =E2=80=98armada_ge=
m_prime_export=E2=80=99:
> > >   drivers/gpu/drm/armada/armada_gem.c:544:16: error: macro "dma_buf_e=
xport" requires 5 arguments, but only 4 given
> > >
> > > Signed-off-by: Vincent Stehl=C3=A9 <vincent.stehle@laposte.net>
> > > Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> > > Cc: David Airlie <airlied@linux.ie>
> > > Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> > > Cc: Sumit Semwal <sumit.semwal@linaro.org>
> >=20
> > Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
>=20
> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
>=20
> Airlied, can you merge this please?  Thanks.

Except that commit 4bcec44ffaf9 'dma-buf: use reservation objects'
comes from the dma-buf tree, so Sumit needs to add this commit to his
tree.

> > > This can be seen with e.g. linux next-20140523 and arm allmodconfig.
> > >
> > > Best regards,
> > >
> > > V.
> > >
> > >  drivers/gpu/drm/armada/armada_gem.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/ar=
mada/armada_gem.c
> > > index 887816f..7adb0c3 100644
> > > --- a/drivers/gpu/drm/armada/armada_gem.c
> > > +++ b/drivers/gpu/drm/armada/armada_gem.c
> > > @@ -541,7 +541,7 @@ armada_gem_prime_export(struct drm_device *dev, s=
truct drm_gem_object *obj,
> > >         int flags)
> > >  {
> > >         return dma_buf_export(obj, &armada_gem_prime_dmabuf_ops, obj-=
>size,
> > > -                             O_RDWR);
> > > +                             O_RDWR, NULL);
> > >  }
> > >
> > >  struct drm_gem_object *
> > > --
> > > 2.0.0.rc2

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/hUaVbygK9B_rEKH.8w2c=w+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTgnd0AAoJEMDTa8Ir7ZwVXnsP/i2y8G1TUTCcvsLS7naVTK58
eKd+2WO1XZEd6eiU12m/Tjcsxn7epFb5A27Mx69G6TahouHMDjNv+BIkmcKBBbFR
VGjcOKVYwFdT/IVOGMl+Tunew67K9Z0tbKx/8ulMyqn/Wot1eosL8DMEGems5pSX
nNpfv59l894j+hTbneswTSLJcuIbkWLJrEIuadlLCoBTQdMG/KEOKy+9KmvLYL58
E3qG0b+x4fewCm9MD1/evw8xd73Q1ZAFWpzr66EL7rjWK9ihr2p2b8yLXx43B3S6
SDWK6+2YeMRhovef5TGCOD9Kf3tydCKT2qpno+qLlSyrUUviw0keP9EAcIJYi6V7
z4NRUmS3uNFUjizZiQ0o1+FUyVF3fXadnZGK9llYm30CEisEDkfpHF7s24Fqmq51
osKNPJKTYcgmlqgvGdnzg77W33k/B1n/C5hgK2jnt9TheUP2x5VWZykdryXyvrpc
i+onrJzqApulj8aCUuICpfcYLGhMKaZLvVNsQhPXSxo7Y1GD2B5hekGjPXJoYDtI
1GUDus52z70uDrcRyjKWawywO8FJr7yLJONpkmP80WL8v3hiiNuv+Sz0Op8g4hO/
BHKuksvlvSkvw7en00Y2OgOpbalfwZB0qkVkN4IC2teQ0r1i0/1B8fPhqBTvH837
+7yS9ZIuulyobhLOWzmp
=8D2z
-----END PGP SIGNATURE-----

--Sig_/hUaVbygK9B_rEKH.8w2c=w+--
