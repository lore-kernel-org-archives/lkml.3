Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab3AXQA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 11:00:57 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44589 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab3AXQAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 11:00:55 -0500
Date: Thu, 24 Jan 2013 18:00:39 +0200
From: Felipe Balbi <balbi@ti.com>
To: BVG Rao <venubyravarasu@gmail.com>
CC: <balbi@ti.com>, Venu Byravarasu <vbyravarasu@nvidia.com>,
        <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>
Subject: Re: [PATCH v2] usb: host: tegra: make use of PHY pointer of HCD
Message-ID: <20130124160039.GA4424@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359023223-13751-1-git-send-email-vbyravarasu@nvidia.com>
 <20130124140504.GA2609@arwen.pp.htv.fi>
 <CAH7OJZsL2akgaU5qQo=gykVAcFkYyCbP4f1WuBDePd5o788o4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <CAH7OJZsL2akgaU5qQo=gykVAcFkYyCbP4f1WuBDePd5o788o4A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 24, 2013 at 09:28:32PM +0530, BVG Rao wrote:
> On Thu, Jan 24, 2013 at 7:35 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Thu, Jan 24, 2013 at 03:57:03PM +0530, Venu Byravarasu wrote:
> >> As pointer to PHY structure can be stored in struct usb_hcd
> >> making use of it, to call Tegra PHY APIs.
> >>
> >> Call to usb_phy_shutdown() is moved up in tegra_ehci_remove(),
> >> so that to avoid dereferencing of hcd after its freed up.
> >>
> >> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> >> ---
> >> First version of patch can be found at
> >> http://marc.info/?l=3Dlinux-kernel&m=3D135581479020213&w=3D2. As it wa=
s not
> >> yet applied, sending v2 of the patch.
> >>
> >> delta from v1:
> >> Modified all Tegra PHY APIs to use standard 'structu usb_phy *' as
> >> their parameter instead of proprietary parameter of type 'struct tegra=
_usb_phy *'.
> >
> > I would like to see those tegra-specific functions vanish from the
> > driver. Can that be done for v3.10 merge window ?
>=20
> Deleting these functions may not be possible because of the way,
> Tegra20 USB PHY and controllers are designed.
> Hence I'm trying to remove tegra specific structure pointers as
> function parameter
> and use generic USB PHY structure pointers instead.

yes, you need to use generic function pointers, that's what I meant.

--=20
balbi

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRAVqnAAoJEIaOsuA1yqREL6cP/036jx2Gb1UP2dhRXXZj1+Jl
A7HCgQEpPPJcvM57tfkhN6FWcIQbATfI1pFZLlj9bxpVLrwIDXWfUleQyDfRaTKt
G8/N7VSwYyBShWobrG51TcCtMA/GtRE8/TNhbyzn3vGqrdrnIQXUGKo1Pnulyfw2
K93pyX7M+FGa5EJutAdpSu4YWBnLkq/rpeCEMcQJmh3d/XWIXwf7bTsVkWNkzacN
DhBJokDl30uniE6XNrhfxUQES59gBB7iiCs9fmf5cgK/+D5cZ8goNFY7qm/nObvF
HpcftYZGCLIkMuooYgNm/E+zAhl+ZV2sima5paSD94rTzJLEar25CSrhHV48Zzk+
mUv1L2nw3l1ke4c/XCj8bnw4Is+38Yeezoa2OJSZe1Kqa7Rijmb0wH5PKr0sRVzl
pbETke+/InOk2BCOjO+tqMYdbnuji4aDsHkNPH36yuYgPRZumeUj7Njjt46sCF1O
JpyJi4DaItZjtEI2IG+/26DZHlUJvX6zrltibuBBMrX/18J7QGzd8uWdTwiFuASi
xxYxRO7nIeXIqg1PA2q6v4exmtZeyiF1LpryO9FRy0kSrjfAnGqYLXq7eCkIORuy
2Wes7gqvQ3G1vtg1jZqhvXZja8ymJEs2rkAOy19RVZTQtZ9QBgcLjG4cI14x+tym
KZogRSaUIIO4TyZMMW9t
=mmUf
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
