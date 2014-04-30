Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946002AbaD3WDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 18:03:37 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:53456 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaD3WDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 18:03:35 -0400
Date: Thu, 1 May 2014 00:01:55 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [RFC 0/5] drm/tegra: Convert to master/component framework
Message-ID: <20140430220154.GA23950@ulmo>
References: <1398179373-29966-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <1398179373-29966-1-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2014 at 05:09:28PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> Hi,
>=20
> This series converts the Tegra DRM driver to the master/component
> framework. The length of the series and the list of people in Cc is
> mostly due to the fact that Tegra has some special requirements as
> opposed to other drivers and therefore requires some changes outside
> of DRM.
>=20
> Patches 1 and 2 make some changes to the master/component framework
> which are necessary to convert Tegra DRM to use it. Note that since I'm
> looking for early review I haven't converted any of the existing users
> since I'm not sure if these are acceptable changes.
>=20
> Patch 3 adds a new interface framework that supplements the master/
> component framework and can be used in situations where there is no
> struct device * that a driver can bind to.
>=20
> A new function is introduced in patch 4 which can be used to get rid of
> the DRM bus infrastructure in individual drivers. It should be able to
> replace the requirement of having a drm_bus for all USB and platform
> DRM drivers. For backwards-compatibility with legacy PCI drivers some-
> thing different will probably be needed.
>=20
> Finally, patch 5 converts the Tegra DRM driver over to using the master/
> component framework using the above four patches.
>=20
> Each patch has a somewhat more elaborate description of why it is needed
> or what problem it solves. The patchset applies on top of linux-next
> with Daniel's DRM cleanup series applied.
>=20
> I welcome any questions or comments you might have.
>=20
> Thierry
>=20
> Thierry Reding (5):
>   drivers/base: Allow multiple masters per device
>   drivers/base: Allow driver-data to be attached to a master
>   drivers/base: Add interface framework
>   drm: Introduce drm_set_unique()
>   drm/tegra: Convert to master/component framework

Ping. Anyone?

Thierry

>  drivers/base/Makefile          |   2 +-
>  drivers/base/component.c       |  31 ++-
>  drivers/base/interface.c       | 186 ++++++++++++++
>  drivers/gpu/drm/drm_ioctl.c    |  37 ++-
>  drivers/gpu/drm/drm_stub.c     |   1 +
>  drivers/gpu/drm/tegra/Makefile |   1 -
>  drivers/gpu/drm/tegra/bus.c    |  64 -----
>  drivers/gpu/drm/tegra/dc.c     |  58 ++---
>  drivers/gpu/drm/tegra/drm.c    | 171 +++++++++----
>  drivers/gpu/drm/tegra/drm.h    |  27 +-
>  drivers/gpu/drm/tegra/dsi.c    | 144 +++++------
>  drivers/gpu/drm/tegra/gr2d.c   |  78 +++---
>  drivers/gpu/drm/tegra/gr3d.c   |  77 +++---
>  drivers/gpu/drm/tegra/hdmi.c   |  69 ++---
>  drivers/gpu/drm/tegra/sor.c    |  71 ++----
>  drivers/gpu/host1x/Makefile    |   1 -
>  drivers/gpu/host1x/bus.c       | 553 -----------------------------------=
------
>  drivers/gpu/host1x/bus.h       |  29 ---
>  drivers/gpu/host1x/dev.c       |  21 +-
>  drivers/gpu/host1x/dev.h       |   7 +-
>  include/drm/drmP.h             |   3 +
>  include/linux/component.h      |  20 +-
>  include/linux/host1x.h         |  64 +----
>  include/linux/interface.h      |  40 +++
>  24 files changed, 625 insertions(+), 1130 deletions(-)
>  create mode 100644 drivers/base/interface.c
>  delete mode 100644 drivers/gpu/drm/tegra/bus.c
>  delete mode 100644 drivers/gpu/host1x/bus.c
>  delete mode 100644 drivers/gpu/host1x/bus.h
>  create mode 100644 include/linux/interface.h
>=20
> --=20
> 1.9.2
>=20

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYXLSAAoJEN0jrNd/PrOh/j0P/RahdlSEhKqyWD8xUbB3uaNJ
jZSDKBgNJsN7WMDcBv9BjTJAwYj3KY9UQrUxJdGvlQ8ShtU8cB4fPH2oDIFmPHJr
T7PHrwne4P3uIfJI5CJWlvP/PUI5y2MX1rnHNa7Flw1POB5JIyLjoDCjO+XG0tfR
8zReC47nbGWgpdPtglFzS9ymctbBJuxddTBh5+9r8kf7zxag99r7l+NwLjSPXq+x
figasL7pv1TYyoZEQj/tewVin4dk1zLcLw42sPW8Nj8QdLn/cXn28+02C3+2mEiI
qp1G7XUgKZ7F/91vatkpijY0JcZfym1620pD+m514y1aIMUWKcy4dTFjRVE1i8l1
8nko5VKnR5d39qt/9mv2D/G9p8yrlQXYlR2AlIForT8Sy9Dx2/wKJgPxMZHkZbAi
oiKgDMJD8rY3nF7MWgcMnztzVRsOuJYy0FvQX07dRjzKEMICTDrfPg2sdrCU8U0j
ZyUCTVqULVOq9hyLWkrorb49OEp5G/ggslH8roHMfBy9V1/B8r3EbW1ENFBbW3hb
vqAnlk81ZJXfsadGvZVLVZu2oPRF8bE8zVNfiqfA2Ijz3mV0G5eyzhjUfDxdPdnw
YtU5GUUJpwe5Oc8Lkd1LGHpAE8pTtBJ7WvvMPoAUsL00uP+whnoU8/GHcd0JLvcP
/Nx6NhD5B+ON8fG20QEt
=0KGe
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
