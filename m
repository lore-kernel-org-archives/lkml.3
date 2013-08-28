Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab3H1NSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:18:51 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:43513 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3H1NSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:18:49 -0400
Date: Wed, 28 Aug 2013 15:18:15 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: Terje Bergstrom <tbergstrom@nvidia.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] ARM: tegra: Add host1x, dc and hdmi to Tegra114
 device tree
Message-ID: <20130828131815.GB604@ulmo>
References: <1377686459-16634-1-git-send-email-mperttunen@nvidia.com>
 <1377686459-16634-5-git-send-email-mperttunen@nvidia.com>
 <20130828122529.GB32254@ulmo>
 <521DEFFF.90507@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5/uDoXvLw7AC5HRs"
Content-Disposition: inline
In-Reply-To: <521DEFFF.90507@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2013 at 03:41:35PM +0300, Mikko Perttunen wrote:
> On 08/28/2013 03:25 PM, Thierry Reding wrote:
[...]
> >>Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> >>---
> >>  arch/arm/boot/dts/tegra114.dtsi | 43 ++++++++++++++++++++++++++++++++=
+++++++++
> >>  1 file changed, 43 insertions(+)
> >>
> >>diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra1=
14.dtsi
> >>index 2905145..ce5a95c 100644
> >>--- a/arch/arm/boot/dts/tegra114.dtsi
> >>+++ b/arch/arm/boot/dts/tegra114.dtsi
> >>@@ -27,6 +27,49 @@
> >>  			(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
> >>  	};
> >>
> >>+	host1x {
> >>+		compatible =3D "nvidia,tegra114-host1x", "nvidia,tegra30-host1x",
> >
> >I don't think that's correct. The Tegra114 host1x is not backwards
> >compatible with the Tegra30 host1x.
> >
> >That said, I have a local patch that is a bit more complete in that it
> >adds other host1x devices as listed in the TRM as well. But I'll leave
> >it up to Stephen how he prefers to handle that. It should be fine to
> >defer adding nodes for additional hardware blocks when the supporting
> >drivers are merged. We've done it for other devices as well.
>=20
> Ok. Will need to add tegra114-host1x to the host1x driver compat
> strings, then, but I guess that's better than having it wrong in the
> DT.

I think that's not all. I have local patches that also introduce a v2 of
host1x, because the number of syncpoints is different. There may also be
other differences, but Terje might be more qualified to answer that.

> >>+		hdmi {
> >>+			compatible =3D "nvidia,tegra114-hdmi";
> >>+			reg =3D <0x54280000 0x00040000>;
> >>+			interrupts =3D <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
> >>+			clocks =3D <&tegra_car TEGRA114_CLK_HDMI>,
> >>+				    <&tegra_car TEGRA114_CLK_PLL_D_OUT0>;
> >
> >Any reason why we can't use pll_d2_out0 here, like we do on Tegra30?
>=20
> I have this set to PLL_D because I don't have panel support so disp1
> will be the HDMI DC. However, it doesn't seem to matter which one is
> specified here. I have also tested HDMI with disp2 and that works
> too.

Well eventually we'll add panel support and I think it'd be good to stay
consistent as to what clocks are used for the internal and external
displays.

Thierry

--5/uDoXvLw7AC5HRs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIbBAEBAgAGBQJSHfiXAAoJEN0jrNd/PrOha6cP+NwKrhZkiwZ7d1bLkd6YS/JU
xBsWP+7RZJ7peQYmJxlDVDjV3wo4Yw4jDGGySATYs/1jvW2xAKmMRRoxUwKUPfKQ
jrl/e4hxUajcHMJoRDkekqLh1ga4ehqtCJmAJir0xxYeb4BVAL/f+f6gRfLaQ9g/
iGyayJLLOhxNgbGAC4xpG1cOiTzPbusxDiNxgxAPxqV7eVivn0KGRQM6Zs/GNrA/
2bomrCNas8rP4urHRmlgfOtP1DEBWhOMLVqKc5qGmUB5jv8uE+x2muavcz0dTg7s
5THTOo7IBGmpBIO9Sj7uuZSk6alvbOqBJZQ7rqgNt3xkS4okvdadC4ubokVRQ9XZ
mLuf+RnoyzK/AOUJtN/DJBNrZyVRIux1b7uq9JT4Z1g3I4IeGb+nItBW+RUZ+Zo9
ONho8V8rqECqIeXbJQf/QyKXKG5RgW1ZOdgn35CihVtVhMLKIFBNwfNHxOEHCQYx
f90+PU73Xl+BNd9m+2xWlypnqhPWKa3IWSUtk0Mhy8E4sv1wvFjcvj0HnI/Oq7rz
lrTuBSkRxajsefiAZtZBmvS+/EaZ+0HscYhrKfNTlymO62kH4CvJHx2fUVP60iv5
+mt8hBZ4anIwI80sHewOJ2zo9ARQkp/iV5WQ7WejbuSVhUFR8pAzADbfBECYPjfd
QILDRo16YCXSbH+0U5g=
=PCCV
-----END PGP SIGNATURE-----

--5/uDoXvLw7AC5HRs--
