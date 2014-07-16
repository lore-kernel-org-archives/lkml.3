Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030651AbaGPH0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 03:26:18 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62722 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372AbaGPH0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 03:26:15 -0400
Date: Wed, 16 Jul 2014 09:20:52 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6] clk: tegra: don't abort clk init on error
Message-ID: <20140716072051.GC7978@ulmo>
References: <1405437890-6468-1-git-send-email-pdeschrijver@nvidia.com>
 <1405437890-6468-2-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Izn7cH1Com+I3R9J"
Content-Disposition: inline
In-Reply-To: <1405437890-6468-2-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Izn7cH1Com+I3R9J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 06:24:31PM +0300, Peter De Schrijver wrote:
> Just continue initializing clocks if there's an error on one of them. This
> is useful if there's a mistake in the inittable, because the system could
> hang if clk_disable_unused() disables some of the critical clocks in this
> table.
>=20
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>  drivers/clk/tegra/clk.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
> index c0a7d77..d081732 100644
> --- a/drivers/clk/tegra/clk.c
> +++ b/drivers/clk/tegra/clk.c
> @@ -207,7 +207,7 @@ void __init tegra_init_from_table(struct tegra_clk_in=
it_table *tbl,
>  	for (; tbl->clk_id < clk_max; tbl++) {
>  		clk =3D clks[tbl->clk_id];
>  		if (IS_ERR_OR_NULL(clk))
> -			return;
> +			continue;

Perhaps rather than silently ignoring, should this at least print out an
error? I'd even go as far as make it a full-blown WARN to make sure
people notice and this gets fixed early.

Thierry

--Izn7cH1Com+I3R9J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxifTAAoJEN0jrNd/PrOhAoMQAJo8x1CgTmnx6VlXJFwII8MR
5iE6e+OmuZjN9T08d7UX01NkMYN/45TDZPRgbFdxvIN+e5XXT56jhKuSC4Wi/5pn
G9GSMzpR6ugYlNaiYHexElBZFUF4wP7RXRA9VGhtjhxlP9xqEkZDKkp+rLiBZr6V
HGZAirb5i+1Hm3gF25a2BCXZ3t6Blgann4UhiPwNIPoz3rbIifWnUYHQyQ7Ice0k
f9gq+GqjieXpMx83VLrRy7G5PQJ7VC2PDG0EL2hQCzmvFSaZl0RgkqWYQj2IOapE
50IpQOMU68oG+yH4+Ev3tEzwG+sAZINVSLzIAB383YH4SFDVpC/r02Ng/whltqiO
028tlON2fgKg3NCMhtovUxjBAZfh1xRZQSl+5cvOWeMbaIkVEXM+PCrKiwd47Rxg
DBLsop48NF6Bklna27F/pHs09aF433Lu4qLc1pCM3IpE0Gnps785Kf+6tZTuwyBz
AwRC1ezNuUTZ8KqT5/aBjKIYLJIMAPWo5ZVKWAc2/z3uK2rzgNnQE311uSSMu1fv
+xY5etDbW/8HEwiBuhGnRrOWQ58dOOB1fAPG60oIKFAByb7MnSVSPbMhdjsjNpGS
9vSldKX6OxudK2QCHquTQWiJ8O6W5QuwRohdKGAXWsg3vvApDU5r09eAs5GaIH/C
TrlfSM+ANTO6P5Gwe+BL
=l2PI
-----END PGP SIGNATURE-----

--Izn7cH1Com+I3R9J--
