Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbaKXPht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:37:49 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:58565 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbaKXPhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:37:48 -0500
Date: Mon, 24 Nov 2014 09:37:54 -0600
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Arjun Sreedharan <arjun024@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <kernel-build-reports@lists.linaro.org>
Subject: Re: [PATCH] usb:phy: propagate __of_usb_find_phy()'s error on failure
Message-ID: <20141124153754.GG20705@saruman>
Reply-To: <balbi@ti.com>
References: <1416498816-3292-1-git-send-email-arjun024@gmail.com>
 <20141124131034.GB4061@ulmo.nvidia.com>
 <20141124143646.GA20705@saruman>
 <20141124151644.GC4061@ulmo.nvidia.com>
 <20141124153621.GF20705@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzX0AQGjRQPusK/O"
Content-Disposition: inline
In-Reply-To: <20141124153621.GF20705@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NzX0AQGjRQPusK/O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again,

On Mon, Nov 24, 2014 at 09:36:21AM -0600, Felipe Balbi wrote:
> > > > > When __of_usb_find_phy() fails, it returns -ENODEV - its
> > > > > error code has to be returned by devm_usb_get_phy_by_phandle().
> > > > > Only when the former function succeeds and try_module_get()
> > > > > fails should -EPROBE_DEFER be returned.
> > > > >=20
> > > > > Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
> > > > > ---
> > > > >  drivers/usb/phy/phy.c | 4 +++-
> > > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > >=20
> > > > This causes a boot regression on at least NVIDIA Dalmore (I boot ov=
er
> > > > NFS using a USB network adapter).
> > > >=20
> > > > The commit message is somewhat insufficient because while it explai=
ns
> > > > what the code does and asserts that it is the right thing to do, it
> > > > fails to explain why.
> > >=20
> > > you also fail to explain it causes a regressions with Dalmore.
> >=20
> > I thought my explanation below was sufficient, but maybe I should say it
> > in other words: __of_usb_find_phy() returns -ENODEV if no PHY was found
> > to be registered for a given phandle. That causes the driver to abort
> > probing with a -ENODEV error and does not trigger the probe deferral
> > that'd be necessary to get the host controller to find the PHY the next
> > time it was triggered.
>=20
> right, and before $subject dev_usb_get_phy_by_phandle() was overwriting
> whatever error code passed by __of_usb_find_phy() to -EPROBE_DEFER.
>=20
> > > This is really the correct patch, we shouldn't be overwritting the
> > > error passed in by upper layers.
> >=20
> > No, it's very obviously not the correct patch if it causes a regression.
>=20
> or it exposes a bug elsewhere :-)

still, if you send your patch as a proper patch, I'll queue it as it
definitely makes sense to not return -ENODEV when we have a phandle.

--=20
balbi

--NzX0AQGjRQPusK/O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUc1DSAAoJEIaOsuA1yqREQHsQAIpEaTWt6MsmgLkUV8joYVQj
oqxGVKkhMfwjaTyr+JYovULDf4EqqJBnDs8I7rPNo1bGM2w4+DDmMcy+9ol5ptFd
s6tRs63MoPSV+ilTx810OaaHL/Vur7ziLvujcoJ/zPjLiPD5YeDDynZPY7YBm50E
UBae5eP67Dz1cMHTrz4s6neYacz3vZ6tQPHsRmpFcQ2GYeK3/ucb6oK0lve1FZiL
YIwEgCHFsJMQ966jBgK5av7SuIQ2hd4m/MnSFpU2ojs9ifAbvg7a9nYvIHUy0hN2
rsj8I4TyCKn5TxW07yeOaou+hzOBeDrdTvYvgERDqqTbuMKS7v4CuzS5YbFp3QvP
vNyTR/YBWiMo01QG4oksrjY0wfIFKgCZ8K4z5q6SnKgUBsWkt9beJUyRQU9W1COI
cc+y4GGswUI69ECNh8FbaFjelVZF3Auw6yd7Hpw8F/UFgSsbrM8aEG+89FAUBn8W
xQROq+ACf7jj9hVcKQsXaY7sDb+WOfR8P86A+vKB7Ks81ABjpPOHN8eRNsO7GqKm
NsmJkRCZZu7eu8qvnKdlErdK483+kiz6ehXwlShMyGbz8f16WfiZNkkf47PxqUq5
VYt4ApBjXD9/Q/SiNi2QnPIzTD2U12P3MmaVlOaSVHlPagEKUY2FX7EnAtIADhxt
PbSU51xuEho0tw8Q6oOT
=dc9c
-----END PGP SIGNATURE-----

--NzX0AQGjRQPusK/O--
