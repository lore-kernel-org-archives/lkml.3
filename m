Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbaESIgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:36:16 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:48776 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbaESIgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:36:11 -0400
Date: Mon, 19 May 2014 10:33:56 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Lucas Stach <dev@lynxeye.de>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH 2/4] drm/ttm: introduce dma cache sync helpers
Message-ID: <20140519083355.GA7138@ulmo>
References: <1400483458-9648-1-git-send-email-acourbot@nvidia.com>
 <1400483458-9648-3-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <1400483458-9648-3-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2014 at 04:10:56PM +0900, Alexandre Courbot wrote:
> From: Lucas Stach <dev@lynxeye.de>
>=20
> On arches with non-coherent PCI,

I guess since this applies to gk20a

> we need to flush caches ourselfes at

"ourselves". Or perhaps even reword to something like: "..., caches need
to be flushed and invalidated explicitly", since dma_sync_for_cpu() does
invalidate rather than flush.

> the appropriate places. Introduce two small helpers to make things easy
> for TTM based drivers.
>=20
> Signed-off-by: Lucas Stach <dev@lynxeye.de>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpu/drm/ttm/ttm_tt.c    | 25 +++++++++++++++++++++++++
>  include/drm/ttm/ttm_bo_driver.h | 28 ++++++++++++++++++++++++++++
>  2 files changed, 53 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
[...]
> +void ttm_dma_tt_cache_sync_for_device(struct ttm_dma_tt *ttm_dma,
> +				      struct device *dev)
> +{
> +	int i;

This should probably be unsigned long to match the type of
ttm_dma->ttm.num_pages.

Thierry

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTecHzAAoJEN0jrNd/PrOhs64QAJmQ2CT6oDeq4Ig7cALmuUxj
75XqOdye052fXH1fNIZlxGVugxW5bRoroIw+yn22YfTADHQU4OxBPt2MTd7nmpYx
mGFdVs6Agg7WtrHHHNboHah/7fd0yacz/fcEtLVWbFqkWXKjY2f0FtUbpuTeLUrm
axaLgPIQlb4Kp38Pf69Uu+brklnQfkFZxoe03Tcc4PnsHfuwWTaI7fEWc80Bmu+p
900DkmisIXUmzpgF3rJKt3NgYaeJTr/jCdH587vDkGlT2z95dwGsVP06BUnPpLK/
Gg6x92ihh3CI0A+lBD7YtmL5JzhwlUKIhSCZRw21dvNSj8dOuJxRmPa5oCFMMYeU
9PD/0LpKw+QEN1IOpYNT0GPuKM4DspGkcfQoTFBL3j+U1OVMFk71WZRmj8caVd4Z
oDgQAt7/xTbIr7IPOSuVOUM+Ol1FltA5c5xlYAoLqeaQK17/UQCzis6t1XEVYv2R
GUwCT6WPygoeUIhX8/K4iIrYQWXCynoRw+9Q4H8AziTvlPzU/DUBddcQab5a2/Lt
VUfKjRKZzzllDLuy66MvnIFxk7eNRZvJB9L9R3R/OTXUH582Y4c64TOYIcA30ayn
u4P+CWvrA4wL/WphfS3dfKlVLofqbXTNo0WaRW7+qnOxs9iil4YMnKoD+Btg/zix
Zr1zwluXSNdWioEaJTas
=l6bB
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
