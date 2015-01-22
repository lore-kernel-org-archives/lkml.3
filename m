Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbbAVHhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:37:18 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37654 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbbAVHhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:37:12 -0500
Date: Thu, 22 Jan 2015 08:37:08 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: Re: [PATCH v2] clk: Introduce clk_has_parent()
Message-ID: <20150122073707.GA427@ulmo>
References: <1421750935-4023-2-git-send-email-thierry.reding@gmail.com>
 <1421856780-32103-1-git-send-email-thierry.reding@gmail.com>
 <54C04145.1010906@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <54C04145.1010906@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 21, 2015 at 04:16:05PM -0800, Stephen Boyd wrote:
> On 01/21/2015 08:13 AM, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >
> > This new function is similar to clk_set_parent(), except that it doesn't
> > actually change the parent. It merely checks that the given parent clock
> > can be a parent for the given clock.
> >
> > A situation where this is useful is to check that a particular setup is
> > valid before switching to it. One specific use-case for this is atomic
> > modesetting in the DRM framework where setting a mode is divided into a
> > check phase where a given configuration is validated before applying
> > changes to the hardware.
> >
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Cc: Mike Turquette <mturquette@linaro.org>
> > Cc: Stephen Boyd <sboyd@codeaurora.org>
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
>=20
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
>=20
> This will slightly conflict with Tomeu's  patches for per-user clock
> constraints. It would be best if we can take this through the clk tree
> to fix up any conflicts

I had hoped to take this through the drm tree to resolve the build-time.
Another possibility would be for me to include the clk tree (or a subset
thereof) in my pull-request. That way you can still fix things up in the
clock tree if there are any conflicts with other work. We could make
that work two ways: this patch gets applied to the clk tree and I pull
it, or I provide a stable branch that I base my pull request on and that
branch can be pulled into the clk tree.

Yet another alternative would be to split out the clk_has_parent()
change from the series and not use it for now. That way we're going to
miss this check, but we do that anyway currently and it will only be
temporary until v3.21.

Perhaps given where we are in the release cycle the latter would make
the most sense for now.

> > diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
[...]
> > +	/* Optimize for the case where the parent is already the parent. */
> > +	if (clk->parent =3D=3D parent)
> > +		return true;
>=20
> I worry that we'll need to grab a lock here with Tomeu's patches, but
> maybe I'm wrong.

Why would this need a lock? Worst case somebody concurrently changes the
parent, in which case will not succeed and fallback to the lookup below.

It's been a while since I last looked at Tomeu's series, but I seem to
remember that struct clk was going to be per-user, in which case I guess
the code would have to be modified anyway since ->parent and
->parent_names will likely become properties of the clock structure
shared by all users (was it struct clk_core?).

Thierry

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUwKijAAoJEN0jrNd/PrOhr3QP/jUKgrMOcnyrKfGsHDJuLX3U
aIeOwV8vjX8hUmH0VfNzcVnCTZ33fJeOO8YqHbioVKIQatDrRI6O1rKXZHh7axNR
z+b+exTF6bDsY0JIDn76tkDxrToWwBPTCjxwJ2ZmkqTRFrhE/0/2513QDqIBOhuf
Ko/EkzD/HaVcOOTg2XJCbDJm96n7thQQTinYfijHR152sdMKn42hLc4nmfbBmWz1
3HtvjSaeJQrf+VGvfk+mc6PNAzThfSXWl11tsMd5ZS9/D8ejWV0LnYhd0cZaRgm/
BhHiK+vxiZhsNe/b0F257jKP++P7aaJtwwiTIjzQSBtDoVLRxsHqBT3PF4tgChqW
ATCs2lkykcpxgJzZKnxLEuRyqnMVPgj2Us6+mKb69Ilc8TtntSVAMbRQkpOzq9c7
D2um5TWgWjDrhU7Cy9VabG+lo5GHZF37o38/l5TKjvqlM4QVxPuRhCDiznXtyrU3
5qJtVO7ua5sdYyvZI+LYZOauVjfNxPdbGQpcLtitonAWCPLTx7xVstTtt2sUY+mS
DM904b613NANSN/rEMJYgWrAaDIXT3XlsbMU9DY7u6FO5NrTc0J+YHbKMsAtheEZ
r+5PUalPs4WMv882Dl81j5+BwUI0f5ErxfjepaiFseBj7ieBVhcqH1bbDSEh8fHG
PHl8vg6vah4XYp4WMeBT
=F3BC
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
