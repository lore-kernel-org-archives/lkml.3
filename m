Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbaLKJ2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 04:28:18 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34918 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbaLKJ2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 04:28:15 -0500
Message-ID: <548963AA.6040305@monstr.eu>
Date: Thu, 11 Dec 2014 10:28:10 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [RESENT PATCH] dma-mapping: Add BUG_ON for uninitialized dma_ops
References: <385664132d1ef60c582b0045afaa36a1895685dc.1415965161.git.michal.simek@xilinx.com>
In-Reply-To: <385664132d1ef60c582b0045afaa36a1895685dc.1415965161.git.michal.simek@xilinx.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="1o6H7k67PHOLL2ETS7uodaeObAwM0IQoV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1o6H7k67PHOLL2ETS7uodaeObAwM0IQoV
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

any update on this one?

Thanks,
Michal

On 11/14/2014 12:39 PM, Michal Simek wrote:
> Check that dma_ops are initialized correctly.
>=20
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>=20
> Functions dma_mmap_attrs(), dma_get_sgtable_attrs()
> already have this checking.
>=20
> The whole discussion was originally here:
> https://lkml.org/lkml/2013/6/3/255
>=20
> We have middle solution where some functions have this checking
> and some not. Based on get_maintainer scripts Arnd should do that decis=
ion
> to accept or reject this patch.
>=20
> ---
>  include/asm-generic/dma-mapping-common.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>=20
> diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-gen=
eric/dma-mapping-common.h
> index de8bf89940f8..d430cabd2975 100644
> --- a/include/asm-generic/dma-mapping-common.h
> +++ b/include/asm-generic/dma-mapping-common.h
> @@ -16,6 +16,7 @@ static inline dma_addr_t dma_map_single_attrs(struct =
device *dev, void *ptr,
>  	dma_addr_t addr;
>=20
>  	kmemcheck_mark_initialized(ptr, size);
> +	BUG_ON(!ops);
>  	BUG_ON(!valid_dma_direction(dir));
>  	addr =3D ops->map_page(dev, virt_to_page(ptr),
>  			     (unsigned long)ptr & ~PAGE_MASK, size,
> @@ -33,6 +34,7 @@ static inline void dma_unmap_single_attrs(struct devi=
ce *dev, dma_addr_t addr,
>  {
>  	struct dma_map_ops *ops =3D get_dma_ops(dev);
>=20
> +	BUG_ON(!ops);
>  	BUG_ON(!valid_dma_direction(dir));
>  	if (ops->unmap_page)
>  		ops->unmap_page(dev, addr, size, dir, attrs);
> @@ -49,6 +51,7 @@ static inline int dma_map_sg_attrs(struct device *dev=
, struct scatterlist *sg,
>=20
>  	for_each_sg(sg, s, nents, i)
>  		kmemcheck_mark_initialized(sg_virt(s), s->length);
> +	BUG_ON(!ops);
>  	BUG_ON(!valid_dma_direction(dir));
>  	ents =3D ops->map_sg(dev, sg, nents, dir, attrs);
>  	debug_dma_map_sg(dev, sg, nents, ents, dir);
> @@ -62,6 +65,7 @@ static inline void dma_unmap_sg_attrs(struct device *=
dev, struct scatterlist *sg
>  {
>  	struct dma_map_ops *ops =3D get_dma_ops(dev);
>=20
> +	BUG_ON(!ops);
>  	BUG_ON(!valid_dma_direction(dir));
>  	debug_dma_unmap_sg(dev, sg, nents, dir);
>  	if (ops->unmap_sg)
> @@ -76,6 +80,7 @@ static inline dma_addr_t dma_map_page(struct device *=
dev, struct page *page,
>  	dma_addr_t addr;
>=20
>  	kmemcheck_mark_initialized(page_address(page) + offset, size);
> +	BUG_ON(!ops);
>  	BUG_ON(!valid_dma_direction(dir));
>  	addr =3D ops->map_page(dev, page, offset, size, dir, NULL);
>  	debug_dma_map_page(dev, page, offset, size, dir, addr, false);
> @@ -88,6 +93,7 @@ static inline void dma_unmap_page(struct device *dev,=
 dma_addr_t addr,
>  {
>  	struct dma_map_ops *ops =3D get_dma_ops(dev);
>=20
> +	BUG_ON(!ops);
>  	BUG_ON(!valid_dma_direction(dir));
>  	if (ops->unmap_page)
>  		ops->unmap_page(dev, addr, size, dir, NULL);
> @@ -100,6 +106,7 @@ static inline void dma_sync_single_for_cpu(struct d=
evice *dev, dma_addr_t addr,
>  {
>  	struct dma_map_ops *ops =3D get_dma_ops(dev);
>=20
> +	BUG_ON(!ops);
>  	BUG_ON(!valid_dma_direction(dir));
>  	if (ops->sync_single_for_cpu)
>  		ops->sync_single_for_cpu(dev, addr, size, dir);
> @@ -112,6 +119,7 @@ static inline void dma_sync_single_for_device(struc=
t device *dev,
>  {
>  	struct dma_map_ops *ops =3D get_dma_ops(dev);
>=20
> +	BUG_ON(!ops);
>  	BUG_ON(!valid_dma_direction(dir));
>  	if (ops->sync_single_for_device)
>  		ops->sync_single_for_device(dev, addr, size, dir);
> @@ -126,6 +134,7 @@ static inline void dma_sync_single_range_for_cpu(st=
ruct device *dev,
>  {
>  	const struct dma_map_ops *ops =3D get_dma_ops(dev);
>=20
> +	BUG_ON(!ops);
>  	BUG_ON(!valid_dma_direction(dir));
>  	if (ops->sync_single_for_cpu)
>  		ops->sync_single_for_cpu(dev, addr + offset, size, dir);
> @@ -140,6 +149,7 @@ static inline void dma_sync_single_range_for_device=
(struct device *dev,
>  {
>  	const struct dma_map_ops *ops =3D get_dma_ops(dev);
>=20
> +	BUG_ON(!ops);
>  	BUG_ON(!valid_dma_direction(dir));
>  	if (ops->sync_single_for_device)
>  		ops->sync_single_for_device(dev, addr + offset, size, dir);
> @@ -152,6 +162,7 @@ dma_sync_sg_for_cpu(struct device *dev, struct scat=
terlist *sg,
>  {
>  	struct dma_map_ops *ops =3D get_dma_ops(dev);
>=20
> +	BUG_ON(!ops);
>  	BUG_ON(!valid_dma_direction(dir));
>  	if (ops->sync_sg_for_cpu)
>  		ops->sync_sg_for_cpu(dev, sg, nelems, dir);
> @@ -164,6 +175,7 @@ dma_sync_sg_for_device(struct device *dev, struct s=
catterlist *sg,
>  {
>  	struct dma_map_ops *ops =3D get_dma_ops(dev);
>=20
> +	BUG_ON(!ops);
>  	BUG_ON(!valid_dma_direction(dir));
>  	if (ops->sync_sg_for_device)
>  		ops->sync_sg_for_device(dev, sg, nelems, dir);
> --
> 1.8.2.3
>=20


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--1o6H7k67PHOLL2ETS7uodaeObAwM0IQoV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlSJY6sACgkQykllyylKDCEP2QCdE6y7QFxxnzBGcWHw1XTDytxD
JF8AnRCJsCpuMEGhdBVHIEdwkt8rGfHE
=gPvx
-----END PGP SIGNATURE-----

--1o6H7k67PHOLL2ETS7uodaeObAwM0IQoV--
