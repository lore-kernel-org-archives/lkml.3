Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227Ab3IDVzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 17:55:17 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:46795 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104Ab3IDVzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 17:55:13 -0400
Date: Wed, 4 Sep 2013 23:55:09 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mikko Perttunen <mperttunen@nvidia.com>, tbergstrom@nvidia.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] host1x: hdmi: Add Tegra114 support
Message-ID: <20130904215508.GA4661@mithrandir>
References: <1377704922-2824-1-git-send-email-mperttunen@nvidia.com>
 <1377704922-2824-2-git-send-email-mperttunen@nvidia.com>
 <52277E7F.5050609@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <52277E7F.5050609@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 04, 2013 at 12:39:59PM -0600, Stephen Warren wrote:
> On 08/28/2013 09:48 AM, Mikko Perttunen wrote:
> > Add Tegra114 TMDS configuration, add new peak_current field and
> > use new place for drive current override bit on Tegra114 platform.
>=20
> > diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
>=20
> >  static struct of_device_id host1x_of_match[] =3D {
> > +	{ .compatible =3D "nvidia,tegra114-host1x", .data =3D &host1x01_info,=
 },
>=20
> We should add that value to the host1x DT binding documentation.

That should be superseeded by a patch from my Tegra114 DSI series. Note
that Tegra114 also uses a slightly updated version of host1x.

> > diff --git a/drivers/gpu/host1x/drm/hdmi.c b/drivers/gpu/host1x/drm/hdm=
i.c
>=20
> >  static const struct tegra_hdmi_audio_config *
> >  tegra_hdmi_get_audio_config(unsigned int audio_freq, unsigned int pclk)
> >  {
> > @@ -593,8 +673,20 @@ static void tegra_hdmi_setup_tmds(struct tegra_hdm=
i *hdmi,
> >  	tegra_hdmi_writel(hdmi, tmds->pll1, HDMI_NV_PDISP_SOR_PLL1);
> >  	tegra_hdmi_writel(hdmi, tmds->pe_current, HDMI_NV_PDISP_PE_CURRENT);
> > =20
> > -	value =3D tmds->drive_current | DRIVE_CURRENT_FUSE_OVERRIDE;
> > -	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_LANE_DRIVE_CURRENT);
> > +	if (of_device_is_compatible(hdmi->dev->of_node,
> > +		"nvidia,tegra114-hdmi")) {
>=20
> We shouldn't do this at run-time. Rather, set tegra_hdmi_of_match[]'s
> .data field to a structure that represents the various features of the
> HW, and then make this code conditional upon a feature flag in that
> structure.

I'll take a look at how this could be done. There are a few other places
where we do this check at runtime, so that should be converted at the
same time.

Thierry

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJ6w8AAoJEN0jrNd/PrOhlyEQALqP3RdPIv0zd9oKoZNyQQlB
cb2otx/kQOuveeMzw3OP5OOvXlS7UDlUlgp7MZST7Ou4BElu+TYS5BG86g3Nxy+z
Wm6vEMbryrp8X79lp+JwXLe5n1NLz8prmQsQPszZCe1rJDt6JOW7JvC5PPsyxg8m
FdnsOzmIPevJLynsr7OS8xevNc8gNDaCxKn9OF8soqxSNThxR5UaZ7PXdYsHDMX7
ADQ1/kMiuozX8LgK9163PVomTCwfnnWLfDBZOgQ7KRSJfDr8G+5FC1WsbxGOJXk5
z2NZQ3dhaXW74ZfBE/s1Xtn/iq5+IsJQAkZQSlEK4RjSvUUhhVqADcC9ObwGKEv4
qEHuqYNTmmvilFJMMEN44BX3BzWB1wZChODaGSYLQQKvxbbwyrC0RTZBglPLY0DW
YYxSG/FP+d/2B8ed+JQYhbyoBLiSEbP8y9B1QhowbTO4K8PFR5pQl4WvpWw7qQdV
1CXHtbZPbd/UMlyLqMMGLMZtCman/Yojlm1x+nQWdjD4xFursob5MLSQ6BLeQP/Y
jHogaSREN+fmxTOvd/kEnAlZ93s04Eycox9Q+qVRvXtIaeMIzll+o3TGlcit4tBu
xQ5DhUGupO979um4WZ+uByrG2K4m+JQFFixMc3TTOJa1bBmI0R8EVgZbm+heu8ke
PAs9EElVOvIbpDzVsA/n
=nr1Q
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
