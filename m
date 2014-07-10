Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaGJNtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:49:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44704 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbaGJNtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:49:31 -0400
Date: Thu, 10 Jul 2014 08:48:59 -0500
From: Felipe Balbi <balbi@ti.com>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] USB: PHY: tegra: Call tegra_usb_phy_close only on
 device removal
Message-ID: <20140710134859.GM15340@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404436179-10745-1-git-send-email-ttynkkynen@nvidia.com>
 <1404436179-10745-5-git-send-email-ttynkkynen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EOHJn1TVIJfeVXv2"
Content-Disposition: inline
In-Reply-To: <1404436179-10745-5-git-send-email-ttynkkynen@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--EOHJn1TVIJfeVXv2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jul 04, 2014 at 04:09:39AM +0300, Tuomas Tynkkynen wrote:
> tegra_usb_phy_close() is supposed to undo the effects of
> tegra_usb_phy_init(). It is also currently added as the USB PHY shutdown
> callback, which is wrong, since tegra_usb_phy_init() is only called

you could just make tegra_usb_phy_init() be called as u_phy->init().
That way you even delay enabling clocks and regulators to the point
where they are more likely to be needed. Also, if EHCI is never loaded,
you won't power up the PHY for no reason.

> during probing wheras the shutdown callback can get called multiple
> times. This then leads to warnings about unbalanced regulator_disable if
> the EHCI driver is unbound and bound again at runtime.
>=20
> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>

I suppose this has no dependencies with the rest of the series ?

--=20
balbi

--EOHJn1TVIJfeVXv2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTvpnLAAoJEIaOsuA1yqREJxcP/A9JLCAOpspUWYp+jTJnY+kz
f3UKdp/1M2Phrs7YWdjoJb+INYErWCCOqR8dBfoSXetU8ZVV/gVf8Tp958kaYXsn
mIOeP9Tc/YSD+hTJvgTkFvuVh9dFtSpREJz/1Au5SKOsGPlW+sr9Oih9pvIvhzLB
shnKeAb0i5XheYxkLbc18/RvoRj4u4u0yAXz4H0DTnbnzsfMgDxtJM2uYL2jddkP
/7Hg7A8Esl2D+wWvUkxTiNdRlocCK8BQKqVD4qgiAGiqxI8RDe+8A3D4QqHwlr1Y
AMKCdf1i+MdyrVNUETGOvHj59WkIUTeTLPZYV+Xv/NM3Cvq1SRD033ynCsKokjC5
sjVSdh3fmsHtgu0g3aBg5pkuB5+7rX8QFeZLe2TRwzT745M7or3he2Jx47ZkCwBM
BEhTyauaumRLxr16xdvJB0Cz98famlgMuCJRHOHjoQzFvhAvB+/Mt1vNL+/OGeCC
pDI96a/P0CsLV5vUcMpuMinG2rIkdxeZuwCXO+1VaOt1BHi7IoKHylE+nYMb1wOd
gxnwVfJVdYS19rXanV9SHulVW/Ylt8RJEy0KwWFZtXIBtOXu1E3MtaY3xUc38Qb2
LZeKC+RzV42t7m4xMcNMQI/BD5RGfzSPWjjlEKuRnDjRMT00tV/FXDX7KwEfL05o
qVztcGO41cC7px//u0uB
=HY2Z
-----END PGP SIGNATURE-----

--EOHJn1TVIJfeVXv2--
