Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbaJHTBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:01:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51491 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbaJHTBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:01:50 -0400
Date: Wed, 8 Oct 2014 14:01:47 -0500
From: Felipe Balbi <balbi@ti.com>
To: Dmitry Osipenko <digetx@gmail.com>
CC: <swarren@wwwdotorg.org>, <josephl@nvidia.com>, <thierry.reding@gmail.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: Re-add removed SoC id macro to tegra_resume()
Message-ID: <20141008190147.GM22688@saruman>
Reply-To: <balbi@ti.com>
References: <1412794450-9060-1-git-send-email-digetx@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Tnj+unmjHTqEM5y0"
Content-Disposition: inline
In-Reply-To: <1412794450-9060-1-git-send-email-digetx@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Tnj+unmjHTqEM5y0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 08, 2014 at 10:54:10PM +0400, Dmitry Osipenko wrote:
> Commit d127e9c5c5bc1ee22a7b1fe804397cddd132f756 ("ARM: tegra: make tegra_=
resume
> can work with current and later chips") removed tegra_get_soc_id macro le=
aving
> used cpu register unassigned and as result causing execution of unintende=
d code
> on tegra20. Fix it by re-adding macro.

you should add:

Fixes: d127e9c (ARM: tegra: make tegra_resume can work with current and lat=
er chips)
Cc: <stable@vger.kernel.org> # v3.13+

here. With that:

Reviewed-by: Felipe Balbi <balbi@ti.com>

> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> ---
>  arch/arm/mach-tegra/reset-handler.S | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/arm/mach-tegra/reset-handler.S b/arch/arm/mach-tegra/re=
set-handler.S
> index 7b2baab..71be4af 100644
> --- a/arch/arm/mach-tegra/reset-handler.S
> +++ b/arch/arm/mach-tegra/reset-handler.S
> @@ -51,6 +51,7 @@ ENTRY(tegra_resume)
>   THUMB(	it	ne )
>  	bne	cpu_resume			@ no
> =20
> +	tegra_get_soc_id TEGRA_APB_MISC_BASE, r6
>  	/* Are we on Tegra20? */
>  	cmp	r6, #TEGRA20
>  	beq	1f				@ Yes
> --=20
> 2.1.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--Tnj+unmjHTqEM5y0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUNYobAAoJEIaOsuA1yqREP4gQAJIy2cAkwNFnkM+AYTeF3TVd
YLX9xc3p+E2Kt3jlEWcZVFpblBLlvOhh3MrkVv54HxeCw2qaRaKGCAJXfvUfOAUw
HZ0Mv7AhytpBYeF6PD59UrRtoxdE9xMX0hcxcyYdtCETuBkLeL8RJtNZC/LU/Bxe
6zG/C/e+lNGCZmavLNALSnYQZSJi3mO3NNdm2f9F5zY7sZ1+iceMkwGcOS1fLiXe
hxeKEkLV9EJhZrrM9zoawwC/kdnBeMBp9WgaT9auq5tHlIh/WcRBUDdCZu52IXLm
w9qbMlZl1upAilFUTsKQyWUqgZej5lAs1gShG3UhsTNZMSYg+k2eUESWw6pv503/
NgIRDNNBNZS58jDntZS7GbyUTwV7D06hGe3KfS2pSgnNZZljBORB+I9AzikNDHXg
tJpXqqigEyUhFmZ7FmoJ7j4ZMVaPPrSl/EyZdMt2pZaj7I3RAKV44B5BCJJ9obki
HE+KN+chFkXmQMy2OPDncSQ3rxLPOa8tfycwYprNHHadQvp4QWFvQxHszHTFrPd6
+26BveiyFqI3gyuku2zk9M2v7wdR7ULfjUIAqAM69ppkfLR0Brx3CG6h5jTS8eX+
4aTFOYTo19eauhGTTNAB1LbIstOFWaQlT2SYOh/2HEEIua4GLSsClv2SQG/a1/SO
1E57BIeu+4G3yPoKk2Ki
=Gejs
-----END PGP SIGNATURE-----

--Tnj+unmjHTqEM5y0--
