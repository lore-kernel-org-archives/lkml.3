Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3FJJAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:00:38 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:55908 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab3FJJAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:00:36 -0400
Message-ID: <51B595B1.8050209@monstr.eu>
Date: Mon, 10 Jun 2013 11:00:33 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] dma-mapping: Add BUG_ON for uninitialized dma_ops
References: <f35c5051a207b0a117f2fff27365d0ea892d1610.1370263476.git.michal.simek@xilinx.com>
In-Reply-To: <f35c5051a207b0a117f2fff27365d0ea892d1610.1370263476.git.michal.simek@xilinx.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2VLBRVIWAIOWNXTNARXWI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2VLBRVIWAIOWNXTNARXWI
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

can you please look at this patch?

Thanks,
Michal

On 06/03/2013 02:44 PM, Michal Simek wrote:
> Check that dma_ops are initialized correctly.
>=20
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> Functions dma_mmap_attrs(), dma_get_sgtable_attrs()
> already have this checking.
>=20
> ---
>  include/asm-generic/dma-mapping-common.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>=20
> diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-gen=
eric/dma-mapping-common.h
> index de8bf89..d430cab 100644
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



------enig2VLBRVIWAIOWNXTNARXWI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlG1lbEACgkQykllyylKDCGH9gCdF0fZeLc0bex68zJhRHhaxpo0
hOIAn09nlhFZbCLBrpS6DC1cSMnEQAp0
=5FEU
-----END PGP SIGNATURE-----

------enig2VLBRVIWAIOWNXTNARXWI--
