Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934928Ab3E2QEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 12:04:55 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:54587 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3E2QEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 12:04:45 -0400
Message-ID: <51A6271A.5090809@monstr.eu>
Date: Wed, 29 May 2013 18:04:42 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>
CC: linux-kernel@vger.kernel.org, Bill Pemberton <wfp5p@virginia.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 09/11] net: emaclite: Do not use microblaze and ppc IO
 functions
References: <131c9262c3094ee3c664bd729a66e0709ceae82c.1369841519.git.michal.simek@xilinx.com> <146169cddc068c371889e699fde4fe5129f02201.1369841519.git.michal.simek@xilinx.com>
In-Reply-To: <146169cddc068c371889e699fde4fe5129f02201.1369841519.git.michal.simek@xilinx.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2XXQITBHFUCNUDXTXWRNW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2XXQITBHFUCNUDXTXWRNW
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/29/2013 05:33 PM, Michal Simek wrote:
> Emaclite can be used on ARM zynq where in_be32/out_be32 IO
> functions are not present. Use standard __raw_readl/__raw_writel
> IO functions instead.
>=20
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_emaclite.c | 100 +++++++++++++-----=
--------
>  1 file changed, 51 insertions(+), 49 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/ne=
t/ethernet/xilinx/xilinx_emaclite.c
> index 93bb14e..0d8515b 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> @@ -159,34 +159,34 @@ static void xemaclite_enable_interrupts(struct ne=
t_local *drvdata)
>  	u32 reg_data;
>=20
>  	/* Enable the Tx interrupts for the first Buffer */
> -	reg_data =3D in_be32(drvdata->base_addr + XEL_TSR_OFFSET);
> -	out_be32(drvdata->base_addr + XEL_TSR_OFFSET,
> +	reg_data =3D __raw_readl(drvdata->base_addr + XEL_TSR_OFFSET);
> +	__raw_writel(drvdata->base_addr + XEL_TSR_OFFSET,
>  		 reg_data | XEL_TSR_XMIT_IE_MASK);

oou - this is completely wrong.
Will do v2.

Sorry for that.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2XXQITBHFUCNUDXTXWRNW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGmJxoACgkQykllyylKDCEj+gCcD8Yue+quF8Yh3o8tJKie1xZv
7QIAnix9f6HiPT/a5wlpqac2++F8+fbs
=gUyX
-----END PGP SIGNATURE-----

------enig2XXQITBHFUCNUDXTXWRNW--
