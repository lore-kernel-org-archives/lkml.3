Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbaKEJuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:50:17 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:41851 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaKEJuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:50:11 -0500
Date: Wed, 5 Nov 2014 10:50:05 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Sean Paul <seanpaul@google.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?utf-8?B?U3TDqXBoYW5l?= Marchesin <marcheu@google.com>
Subject: Re: [RFC 09/10] drm/tegra: Add IOMMU support
Message-ID: <20141105095003.GA12458@ulmo.nvidia.com>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
 <1403815790-8548-10-git-send-email-thierry.reding@gmail.com>
 <CAOw6vbJy6oy7cibH4f332UM=kS56KUMcnYdUTG0pEYXyQkFDoQ@mail.gmail.com>
 <CAOw6vbLFLrqWYB-4N50G7oucgMD+xd+QtdcMSzX4z7xRiU-vPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <CAOw6vbLFLrqWYB-4N50G7oucgMD+xd+QtdcMSzX4z7xRiU-vPQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 01, 2014 at 11:54:11AM -0400, Sean Paul wrote:
> On Tue, Sep 30, 2014 at 2:48 PM, Sean Paul <seanpaul@google.com> wrote:
> > On Thu, Jun 26, 2014 at 4:49 PM, Thierry Reding <thierry.reding@gmail.c=
om> wrote:
> >> diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
[...]
> >>  static void tegra_bo_destroy(struct drm_device *drm, struct tegra_bo =
*bo)
> >>  {
> >> -       dma_free_writecombine(drm->dev, bo->gem.size, bo->vaddr, bo->p=
addr);
> >> +       if (!bo->pages)
> >> +               dma_free_writecombine(drm->dev, bo->gem.size, bo->vadd=
r,
> >> +                                     bo->paddr);
>=20
> One more thing. If tegra_bo_alloc fails, we'll have bo->vaddr =3D=3D NULL
> and bo->paddr =3D=3D ~0 here, which causes a crash.
>=20
> I posted https://lkml.org/lkml/2014/9/30/659 to check for the error
> condition in the mm code, but it seems like reviewer consensus is to
> check for this before calling free.
>=20
> As such, we'll need to make sure bo->vaddr !=3D NULL before calling
> dma_free_writecombine to avoid this situation.
>=20
> Would you prefer I send a patch up to fix this separately, or would
> you like to roll this into your next version?

I've rolled this check into my series because I touch that area of code
anyway.

Thanks for bringing it up.

Thierry

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUWfLLAAoJEN0jrNd/PrOhGdMP/jgzGHvv3uBF15GkJMhy8wdT
5DdyMqhvriyDDD3JykETF/i2O++tGUIGzZH4fZNwtJE/UGRASu8Qxiuk7e8MecFv
lxEWpRCUiVsDs8HC4Aw2E9s8pKKZ9a9PBTuLcxCoqUj5sIK/ds35Fmnuzsx2usft
H5cQ6Yu4ASajJL3bsTjX9+9BWh5okF6NvfnVqu3xF5QwB8MeJaSg2WIZf9FSLOc5
/TtunrbukX8HjJXygQcNZMYOM8cxhzcBrDGerHhXGPMNRVnprbXDkdN4CrRvHhcu
0kI0ig5DVqYJL2UJfFZodoTHy2fnskvf1QTZRxLtEBcqdR3YN885mKEP0F0Dvdw+
F2SFtj3HB2NwF7fX5omWwYWUa6FwOGbScXApGXQYH6nSvrSfvYfBopOTj9cfsoHb
LCQm1qxQJEIz0B83AYqi7EJ5UsPdaHo7xWOKAPsyYUUD0Gjttv49ICZAH92xyr2G
L1l2SbV6dXctvupjfszn5pkzpH2x2lvUyIooaEbDxr+LFUl+mDZ0RiEYG+hq2GGT
ht2nOR74nr80bq3PhyT/WfPBsm7k2BCTKVk2G/0ozNV8MVD//k8FvmSTXIr7Cgah
tDxrwz8Rg63AIDCbHSgkGERmXAhCCiJa+V2fzXNziRsdVlyBGLs3y8pK3j2Z0U0A
m70Q9GfLzPbbYQ5KpMoe
=bxPN
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
