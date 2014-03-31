Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbaCaTq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 15:46:26 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:48748 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaCaTqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 15:46:23 -0400
Date: Mon, 31 Mar 2014 21:46:22 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: Fix PLLE programming
Message-ID: <20140331194612.GC3431@mithrandir>
References: <1396277142-18292-1-git-send-email-thierry.reding@gmail.com>
 <53399D1A.4070301@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0vzXIDBeUiKkjNJl"
Content-Disposition: inline
In-Reply-To: <53399D1A.4070301@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0vzXIDBeUiKkjNJl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 31, 2014 at 10:51:38AM -0600, Stephen Warren wrote:
> On 03/31/2014 08:45 AM, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > PLLE has M, N and P divider shift and width parameters that differ from
> > the defaults. Furthermore, when clearing the M, N and P divider fields
> > the corresponding masks were never shifted, thereby clearing only the
> > lowest bits of the register. This lead to a situation where the PLLE
> > programming would only work if the register hadn't been touched before.
>=20
> > diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
>=20
> > @@ -730,8 +730,10 @@ static int clk_plle_enable(struct clk_hw *hw)
> >  	if (pll->params->flags & TEGRA_PLLE_CONFIGURE) {
> >  		/* configure dividers */
> >  		val =3D pll_readl_base(pll);
> > -		val &=3D ~(divm_mask(pll) | divn_mask(pll) | divp_mask(pll));
> > -		val &=3D ~(PLLE_BASE_DIVCML_WIDTH << PLLE_BASE_DIVCML_SHIFT);
> > +		val &=3D ~(divp_mask(pll) << PLLE_BASE_DIVP_SHIFT |
> > +			 divn_mask(pll) << PLLE_BASE_DIVN_SHIFT |
> > +			 divm_mask(pll) << PLLE_BASE_DIVM_SHIFT);
>=20
> Shouldn't those shift values also be a macro/inline like
> divm_shift(pll), since ...
>=20
> > +static struct div_nmp pll_e_nmp =3D {
> > +	.divn_shift =3D PLLE_BASE_DIVN_SHIFT,
> > +	.divn_width =3D PLLE_BASE_DIVN_WIDTH,
> > +	.divm_shift =3D PLLE_BASE_DIVM_SHIFT,
> > +	.divm_width =3D PLLE_BASE_DIVM_WIDTH,
> > +	.divp_shift =3D PLLE_BASE_DIVP_SHIFT,
> > +	.divp_width =3D PLLE_BASE_DIVP_WIDTH,
> > +};
>=20
> ... that table contains parameters for both width and shift values, not
> just width values?

Yes, that could be done. At some point I was also thinking about simply
converting the masks to be shifted masks, but then realized that the
patche would become rather intrusive.

Perhaps, though, to make the code slightly more terse, in addition to
div{n,m,p}_shift() macros I could add div{n,m,p}_mask_shifted() macros
as well to combine both.

Thierry

--0vzXIDBeUiKkjNJl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTOcYEAAoJEN0jrNd/PrOhL/8P/1UD+HYO9kAAmD5y5JjU03kG
r89yde9Uae0Dg8k2CRRXdIVpt3IpHuVF3dAS1izokuSpDd029ieK9Sxa6iP1YUDH
788Y6GDdco2j9+Jq1Xn36qLn1QnHdkGpkxdUesSaABKyQxDdrWzHNbtk41GK+A2n
/axZW+5hdSX0ZLveB8dax1PvXXfIU9z+iEHgerjYGLB74yuVHRHIu7zVAnj3cXNu
qWjJKvL/24I8AluAmGBZBAC/YC8RwanYK5b5TMchu1kuydv1mPMZkCo4dkwVb8FP
ngHLsfUDq2yESwHuBF/ZBfELuewgefQqFeBN7Qf0hsQOkkLrfmKvgw0ZYmGf+d+q
tACxUO5xGVtcjfOGPb1dhQpZ6LxHHel7KaUEZg1AKtFyIodi+IsERDLhfUD6db+O
SDyoLEvhvmFYnPn4YSTC43U+JVye9OnWun94A6d8PCciCEWRP7Pr+/R5EuetDCXX
d0kQ0p+Z62jWeU/t+OagURj6Q/fLlh1YU3RT4p74fcTuF6SaX64osYXz9Jg7LoxK
xyWPfqrMPQ6Nqv7EC3aCfeUAGd3CYH7Od9AyoK+c0oSdon5BYF6Pd+hQInyXam60
jcSpLkjMRUw6CLJCxoCDHMTm6oE0X2j2VYpFHcoG+2rpAHWdzRNK4/nXeMPEFKPh
ckI+eK8ARYVrhUUEBRPY
=k7hh
-----END PGP SIGNATURE-----

--0vzXIDBeUiKkjNJl--
