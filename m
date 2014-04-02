Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbaDBAr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:47:27 -0400
Received: from ozlabs.org ([203.10.76.45]:55498 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756913AbaDBArW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 20:47:22 -0400
Date: Wed, 2 Apr 2014 11:47:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the tip tree with the arm-soc tree
Message-Id: <20140402114715.471bcdb0962ef38c17120530@canb.auug.org.au>
In-Reply-To: <20140320143603.a2f82d77be61c09a7852cfe9@canb.auug.org.au>
References: <20140320143603.a2f82d77be61c09a7852cfe9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__2_Apr_2014_11_47_15_+1100_sBqhvVvxE3=Cvsx."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Apr_2014_11_47_15_+1100_sBqhvVvxE3=Cvsx.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 20 Mar 2014 14:36:03 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the tip tree got a conflict in
> arch/arm/mach-imx/pm-imx6q.c between commit 9cdde7217e92 ("ARM: imx6:
> rename pm-imx6q.c to pm-imx6.c") from the arm-soc tree and commit
> 8435cf757632 ("arm: Replace various irq_desc accesses") from the tip tree.
>=20
> I fixed it up (by applying the tip tree patch to the renamed file -
> arch/arm/mach-imx/pm-imx6.c - see patch below) and can carry the fix as
> necessary (no action is required).

The below merge fixup is now needed when the arm-soc tree is merged with
Linus' tree (as well as removing arch/arm/mach-imx/pm-imx6q.c).

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 20 Mar 2014 14:33:26 +1100
> Subject: [PATCH] arm: Replace various irq_desc accesses fix for file move
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/arm/mach-imx/pm-imx6.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/arm/mach-imx/pm-imx6.c b/arch/arm/mach-imx/pm-imx6.c
> index 16f0d249f6a7..9392a8f4ef24 100644
> --- a/arch/arm/mach-imx/pm-imx6.c
> +++ b/arch/arm/mach-imx/pm-imx6.c
> @@ -241,7 +241,7 @@ static void imx6q_enable_wb(bool enable)
> =20
>  int imx6q_set_lpm(enum mxc_cpu_pwr_mode mode)
>  {
> -	struct irq_desc *iomuxc_irq_desc;
> +	struct irq_data *iomuxc_irq_data =3D irq_get_irq_data(32);
>  	u32 val =3D readl_relaxed(ccm_base + CLPCR);
> =20
>  	val &=3D ~BM_CLPCR_LPM;
> @@ -288,10 +288,9 @@ int imx6q_set_lpm(enum mxc_cpu_pwr_mode mode)
>  	 * 3) Software should mask IRQ #32 right after CCM Low-Power mode
>  	 *    is set (set bits 0-1 of CCM_CLPCR).
>  	 */
> -	iomuxc_irq_desc =3D irq_to_desc(32);
> -	imx_gpc_irq_unmask(&iomuxc_irq_desc->irq_data);
> +	imx_gpc_irq_unmask(iomuxc_irq_data);
>  	writel_relaxed(val, ccm_base + CLPCR);
> -	imx_gpc_irq_mask(&iomuxc_irq_desc->irq_data);
> +	imx_gpc_irq_mask(iomuxc_irq_data);
> =20
>  	return 0;
>  }
> --=20
> 1.9.0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__2_Apr_2014_11_47_15_+1100_sBqhvVvxE3=Cvsx.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTO14XAAoJEMDTa8Ir7ZwVbPcP/25mNUHzl7yJ/mdrBhkmMngO
demraJgI0hX+6kvvgbBekDTOdRo5cQVuASsSaCgWDxQxS6ntwTN0BKm0eERFYCmo
xKi+xu9g6GlBJV92Ht/H6o4fQznUPoXtAXOGkByius/z36lV5XypLv7bRqQnuVaI
TycwHJxVkLvCPUcIccddrjPnxd4WUGbYsqKcFOlrwtDjntPk7C8//+Qe9yJyTEaY
wDPcZCq/DdGtrmfQ2LTCLGEsIoBRzqa4w1lADcypBmoOhL6f6l8ZcC6J6yy/vm9A
dWswKPzmaFKnjS3eFYW+VizKAn7U0Yeo1Uw6e5GdB5dCbrxr1rm7btEzwMvotkiN
cxMmawWfUwIse1ZWkJwPUoPQ4nwF1Y7S91HHkqjTA5H5LhFgm497G1O4Z0vPJY+y
OB4uHDV9ePyboZSayVYd0t+0nS+O6JrGmTnVEkW9IFR0WUZr2BKyRUIRnU91J9OF
pkncogk1ZYR3xsUctm11ESEpNhINaFIgaHuUNAIPeToZbRbei/5MRqHC71wnm7yD
PLa75/+N6XnBGJ++72QSsWYdFfTmwfyy0Vwc3ETrf5+F+lQk2Wo4Hi8L7ScHjeMx
NG1/JAxo0o+3Gc3IZHTwJTMi02rcMELA2UUUP7H3Sxel1VA0WS7HqZbnxauKbemf
RjXI9nWvPGw7RczWlYf6
=fWTN
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Apr_2014_11_47_15_+1100_sBqhvVvxE3=Cvsx.--
