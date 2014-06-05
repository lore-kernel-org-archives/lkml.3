Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaFEIww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 04:52:52 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:36916 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaFEIwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 04:52:49 -0400
Date: Thu, 5 Jun 2014 10:50:00 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Rob Clark <robdclark@gmail.com>, linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Bryan Huntsman <bryanh@codeaurora.org>, matwey.kornilov@gmail.com,
        Daniel Walker <dwalker@fifo99.com>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH] gpu: drm: msm: Replace type of paddr to uint32_t.
Message-ID: <20140605084959.GA22966@ulmo>
References: <alpine.LRH.2.00.1406041450310.21286@lnfm1.sai.msu.ru>
 <CAF6AEGvLJeF4QVXkTh2YLLePqQ4h4j+igixeX5HL8o=x4S=CuQ@mail.gmail.com>
 <CAMuHMdUCjC8mceiAJpmEHo1jufa1FXNfBxaP9EiFS+uTO=SJCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <CAMuHMdUCjC8mceiAJpmEHo1jufa1FXNfBxaP9EiFS+uTO=SJCQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 09:24:02AM +0200, Geert Uytterhoeven wrote:
> On Thu, Jun 5, 2014 at 2:05 AM, Rob Clark <robdclark@gmail.com> wrote:
> > On Wed, Jun 4, 2014 at 6:54 AM, Matwey V. Kornilov <matwey@sai.msu.ru> =
wrote:
> >> From e7147352639fd8f92b1cc85cff9bc5046c7a2130 Mon Sep 17 00:00:00 2001
> >> From: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
> >> Date: Mon, 2 Jun 2014 20:17:29 +0400
> >> Subject: [PATCH] Replace type of paddr to uint32_t.
> >>
> >> This patch helps to avoid the following build issue:
> >>
> >> drivers/gpu/drm/msm/msm_fbdev.c:108:2: error: passing argument 3 of
> >> 'msm_gem_get_iova_locked' from incompatible pointer type [-Werror]
> >>   msm_gem_get_iova_locked(fbdev->bo, 0, &paddr);
> >>   ^
> >> In file included from drivers/gpu/drm/msm/msm_fbdev.c:18:0:
> >> drivers/gpu/drm/msm/msm_drv.h:153:5: note: expected 'uint32_t *' but
> >> argument is of type 'dma_addr_t *'
> >>  int msm_gem_get_iova_locked(struct drm_gem_object *obj, int id,
> >>      ^
> >>
> >> Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
> >
> > Reviewed-by: Rob Clark <robdclark@gmail.com>
>=20
> Perhaps the uint32_t should become dma_addr_t instead?
>=20
> drivers/gpu/drm/msm/msm_gem.h has:
>=20
>         struct {
>                 // XXX
>                 uint32_t iova;
>         } domain[NUM_DOMAINS];
>=20
> (note the "XXX").

I agree, dma_addr_t is the proper type for I/O virtual addresses.

Thierry

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTkC83AAoJEN0jrNd/PrOh/SUQAJqBrUJCeQSEkYFSS2VHYdRe
KrmrwVcNd0VEheOOMGvHbDPYSrxnVwSYpMJMNytgpQtPQbP0aeRa6stD3MBYDXl6
+wdFbgHnSBXF5g26k7Lz1wLohcL2xTsnUEvYuNewbUIq/sE7vuDUjyL5ULyjkUXT
Ph2OjcOosn9A7aU5ki8TigQ23kaoBG/2KuroUfzFQDjUa8p6yRl++9YGY2P+Jr4G
qsyVfc6wnG8sK2LfjFu2kECZUMZ1FtN4N0UQL/sZroDyqjKxanPpRKcRjTUsKetA
u+EVRFUp5ra0KHTqb9kbJNjqnVX0K4whWsy03A5X0RQ7GsOV3jCl2Z/PAmaU4ASM
Q+6DkgSVB78BDcR/BO5GRt65/MT2gsLhVwcqIvyp1JiH/wU7r9zlcE4GQdzsLwQ4
O039yb/sdTq3+oWzT+PC6sq6jHiRXmVDZpZekAsxL34aTuNgeu4fiZ8+eOPEzTDU
VjUC1ooj0BHktr9kDu7zC9q8+e1uPmAuq7xKkcMMgMA8m5SliwINUXf7AJZ6+Cii
RelfdC5UR5pQtNoREaT5D/A4tBCyEHSJ18xcAE/DKONVpiPmeVkCvdqHK3dj4viL
GpepvfBEQx/gF+iXCfkiUEEClHTK2SqM5pJjpm3TPr0NuPFRpXpGF4RwwZjVdF/c
/v+xzgAsfaoYR+Fc/Xkv
=uGht
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
