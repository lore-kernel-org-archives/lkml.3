Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab3LJUZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:25:07 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44499 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751124Ab3LJUZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:25:03 -0500
Date: Tue, 10 Dec 2013 21:23:00 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: srinivas kandagatla <srinivas.kandagatla@st.com>
Cc: Chen-Yu Tsai <wens@csie.org>, Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        netdev <netdev@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 04/10] net: stmmac: sunxi platfrom extensions for GMAC in
 Allwinner A20 SoC's
Message-ID: <20131210202300.GG3651@lukather>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
 <1386350983-13281-5-git-send-email-wens@csie.org>
 <52A5A52C.50605@st.com>
 <CAGb2v67WiCaMpJEzA_X6o7uOu6i3w3FCEz7=N5HY0amQb01SZA@mail.gmail.com>
 <52A72C6D.60100@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j2AXaZ4YhVcLc+PQ"
Content-Disposition: inline
In-Reply-To: <52A72C6D.60100@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--j2AXaZ4YhVcLc+PQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2013 at 02:59:57PM +0000, srinivas kandagatla wrote:
>=20
> On 09/12/13 17:34, Chen-Yu Tsai wrote:
> > Hi,
> >=20
> > On Mon, Dec 9, 2013 at 7:10 PM, srinivas kandagatla
> > <srinivas.kandagatla@st.com> wrote:
> >> Hi Chen,
> >> Good to know that Allwinner uses gmac.
> >=20
> > To my knowledge, Allwinner has never confirmed this.
> >=20
> >> On ST SoC, we have very similar requirements, before we merge any of
> >> these changes I think we need to come up with common way to solve both
> >> Allwinner and ST SOCs use cases.
> >>
> >> I have already posted few patches on to net-dev
> >> http://lkml.org/lkml/2013/11/12/243 to add Glue driver on top of stmmac
> >> driver.
> >>
> >>
> >> There are few reasons for the way I have done it.
> >>
> >> 1> I did not want to modify gmac driver in any sense to when a new SOC
> >> support is added.
> >=20
> > My approach would add one line (compatible strings) each time.
>=20
> This would be a best case, But in reality the defination of the
> configuration register can change per each soc, so the data associated
> with it will also change and hence you will have to change more than
> then just compatible strings.
>=20
>=20
> >=20
> >> 2> As the SOC specific glue logic sits on top of standard GMAC IP, it
> >> makes sense to represent it proper harware hierarchy.
> >=20
> > My feeling is that the SoC specifics are not a glue layer around dwmac,
> > rather an interconnected extension. Arguably I do not have the whole
> > picture. Allwinner has refused to provide us with any specifics beyond
> > the SoC manual and drivers. As such I can only make educated guesses on
> > how the dwmac core interacts with the other modules.
>=20
> I would be good to get actual picture of this hw setup, On ST the
> additional glue logic which sits on top of the GMAC is to resposible for
> selecting the correct retime clock.
>=20
> >=20
> >> 3> Did not want to change any generic gmac bindings for SOC specific
> >> stuff as requirements if SOC glue would be very different in each case.
> >=20
> > We could try to define a standard set of clocks and reset controllers.
> > The dwmac does not have much additional tunables in the driver.
> > Anything else should be SoC specific, put in an extension, and
> > documented as such.
>=20
> I think it will be impossible to standardize SOC specifics as this
> glue/logic keeps changing across SOCs/Vendors.

In our case, it's barely just an additional clock (and a reset line in
the not-yet-submitted A31 GMAC).

So I can't really get what is !standard about that. We already have
defined bindings for such cases, that we can totally make optionnal.

We don't have anything like you seem to have in ST SoCs, where you
actually have some hardware around the GMAC IP. We don't. It's really
only about clocks and reset.

[...]

> >>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> >>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> >>> @@ -35,6 +35,9 @@ static const struct of_device_id stmmac_dt_ids[] =
=3D {
> >>>       { .compatible =3D "snps,dwmac-3.70a"},
> >>>       { .compatible =3D "snps,dwmac-3.710"},
> >>>       { .compatible =3D "snps,dwmac"},
> >>> +#ifdef CONFIG_DWMAC_SUNXI
> >>> +     { .compatible =3D "allwinner,sun7i-gmac", .data =3D &sun7i_gmac=
_data},
> >>> +#endif
> >> ...]
> >>
> >> Personally, I did not want to do this kind of stuff in stmmac, As this
> >> list would keep growing, and this file need to be edited for every new
> >> SOC or every different type of glue logic.
> >>
> >> Please let me know what your opnion on doing Allwinner glue driver in
> >> line with http://lkml.org/lkml/2013/11/12/462
> >=20
> >=20
> > I needed to set some fields in the platform data,
> > as was set in the driver provided by Allwinner, and
> > out of our own needs.
>=20
> >=20
> > 1. .tx_coe
> >    This is not exported in the DT bindings.
> >    Looking at stmmac code, not setting this seems to disable all
> >    checksum offloading.
>=20
> Why cant this go via DT as well?
> I think, this will be overriden by stmmac on MACs > 3.50a.

How is that about hardware? Especially if we can derive it from the
version of the IP, and hence from the compatible, putting it into the
DT would be both redundant and useless.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--j2AXaZ4YhVcLc+PQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSp3gjAAoJEBx+YmzsjxAgrNkQAIcbAET1V4+SOX29gmFs+f9V
KrusqP52YDmDnLFrE9/Aa7X2WEw9/dfl/nnLAok1y5Thr4OFKQdHbEnqp1vpqqQY
lF879Ptu0jJWPniPb1GZdHSQFWFXmsL7s78qfm5St0dNlGlmghMsKLFWxwdOwnxi
SPbg9m/DRwUgMjnxrO7x9gpvPepHxCcLqxgl1ttRPuKef0rhJ5i7VUh1rkFmJ+Ux
cV8VpPLTh5xXZmcuLYQUpsCA2Jai8lvbVcEKr5S8WkQ6GYjs/kbOb0337flsH2Cc
hAdBOzPYD9QXiP1DNXC2hoaw/32JIVgBSxnAluu4gAebhK85B3Q9kYpuoKPhAD10
mQU/xyoVSjKgJSl9O3DIiY+lvvCNwb1EFAG5A/9I+iVBAFJmj8lumaj+RcMVVQbH
Msm/d6OsCntcpIW9t1nSPqEZtkPSidVcipAAsA69u4ZgwRSwfOEGIzmXQbA9MJQ8
Z4aO0C8jb1ZuR1qySgZMVtnwR9m0GGPs3GRcekFpK6bxkb1Zm2YFwWy5b5HjqylO
iKJbYMOwB39b4NqPMiKn2qSPDkHLlznsj7WcgiC8GHRe3q/LsWOfYjAn7ocBDKYc
XoRAZpg9vuvdumDh1ze3zwmaFqQKpYj/habxV5mwRMTp6789x6HXeZxhSEHYRkeM
vbqtIJZ7nyfe48+xkFEh
=OQi3
-----END PGP SIGNATURE-----

--j2AXaZ4YhVcLc+PQ--
