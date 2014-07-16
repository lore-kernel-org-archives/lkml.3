Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030634AbaGPHZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 03:25:48 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:37937 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372AbaGPHZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 03:25:44 -0400
Date: Wed, 16 Jul 2014 09:25:40 +0200
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
Subject: Re: [PATCH 3/6] clk: tegra: Update binding doc Tegra132
Message-ID: <20140716072539.GD7978@ulmo>
References: <1405437890-6468-1-git-send-email-pdeschrijver@nvidia.com>
 <1405437890-6468-4-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HWvPVVuAAfuRc6SZ"
Content-Disposition: inline
In-Reply-To: <1405437890-6468-4-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HWvPVVuAAfuRc6SZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 06:24:33PM +0300, Peter De Schrijver wrote:
> Tegra132 has almost the same clock structure than Tegra124. This patch
> documents the missing clock IDs.
>=20
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>  .../bindings/clock/nvidia,tegra124-car.txt         |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.=
txt b/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
> index ded5d62..28129a9 100644
> --- a/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
> +++ b/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
> @@ -1,4 +1,4 @@
> -NVIDIA Tegra124 Clock And Reset Controller
> +NVIDIA Tegra124 and Tegra132 Clock And Reset Controller
> =20
>  This binding uses the common clock binding:
>  Documentation/devicetree/bindings/clock/clock-bindings.txt
> @@ -7,14 +7,16 @@ The CAR (Clock And Reset) Controller on Tegra is the HW=
 module responsible
>  for muxing and gating Tegra's clocks, and setting their rates.
> =20
>  Required properties :
> -- compatible : Should be "nvidia,tegra124-car"
> +- compatible : Should be "nvidia,tegra124-car" or "nvidia,tegra132-car"
>  - reg : Should contain CAR registers location and length
>  - clocks : Should contain phandle and clock specifiers for two clocks:
>    the 32 KHz "32k_in", and the board-specific oscillator "osc".
>  - #clock-cells : Should be 1.
>    In clock consumers, this cell represents the clock ID exposed by the
>    CAR. The assignments may be found in header file
> -  <dt-bindings/clock/tegra124-car.h>.
> +  <dt-bindings/clock/tegra124-car.h>. The following clocks do not exist
> +  in the nvidia,tegra132-car binding: TEGRA124_CLK_CCLK_G,
> +  TEGRA124_CLK_CCLK_LP, TEGRA124_CLK_PLL_X and TEGRA124_CLK_PLL_X_OUT0.

Perhaps it would be useful to split up the common clocks and the
Tegra124-only clocks into separate header files and then provide
tegra132-car.h which includes only the ones in common with Tegra124.

In other words: tegra124-car-common.h would have all except the ones
above, then tegra124-car.h includes tegra124-car-common.h and defines
those that are Tegra124-only (the ones you listed above) and
tegra132-car.h can include tegra124-car-common.h.

That's somewhat extreme, but it has the benefit of giving us compile-
time checks as to whether the correct clocks are being used.

Thierry

--HWvPVVuAAfuRc6SZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxijzAAoJEN0jrNd/PrOhFN0P/A3B7zYsiC028WGDI52iVrgC
AQn7n/NFjThVdLh/gH9YNJDFReJZ0vUVkXoKMroMgI2tNPJPj39KS5P2vK2eS5y9
eAzKYl344v4gMpMoWcJ/wB0K7C2kLGx2jhI6yUoZQ1xzsqV7AU4NQpZi7qg0kVyz
/eNeeKhSfaZzSvbS8zcyXcoXM9TzUqUjvucWoxCAG07Vb42CCR8cgyr0947k6sVP
Q6wohze8NVNQQnc0y3Eo1kJ3xthKQBrrQzV+GR4mnPn08aytZ8cT/eFatVcP9+bM
wj6Xkrcxs94DODZGbQQJQdHbEHC6cBYF4mnTpqj4adtoaIduPN3PO3M88Mssw8pZ
Nxyp16UsYMSVOBbar904OFG8VOrLtJLAT0lysYFfyphGi2fMk81MK8DZCuHv48Ao
7/TmmDKZ+wT/tZq6y6T00An6ot+7CWobSHYGlwT420wK3FcG3EIUJ/9gKXuBPyAN
YfNJ/gsquszf55Xs9wAOzY3zf7YXtWTx3yTM6rbCF7EpZus58Hmfi47Gj47sOmKt
/mMZq+pUMc+7M/zUu4ZIKFkpwBVaS7laVfbcFLB6Wh98DlvAIw+Lrq2fyspR9IEg
rKVsn/XLHFDXqn/KgI1iir5vwRLsrWNh0YvbJ/X8GUCBO20VEWIZHC8DAWRlqCZe
xqnhvoIsBOqGXlg99ze/
=Dbr2
-----END PGP SIGNATURE-----

--HWvPVVuAAfuRc6SZ--
