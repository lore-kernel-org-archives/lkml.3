Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab3KRJLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:11:33 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2345 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3KRJLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:11:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 18 Nov 2013 01:05:26 -0800
Date: Mon, 18 Nov 2013 10:10:42 +0100
From: Thierry Reding <treding@nvidia.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
CC: Terje Bergstrom <tbergstrom@nvidia.com>, Dave Airlie <airlied@redhat.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: DRM_TEGRA not buildable as a module
Message-ID: <20131118091042.GB13322@ulmo.nvidia.com>
References: <CA+5PVA7hq9e2twtQ2e24VvF+KHJ_XS4uVskWRQo+g7z3VpmKXw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CA+5PVA7hq9e2twtQ2e24VvF+KHJ_XS4uVskWRQo+g7z3VpmKXw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fba/0zbH8Xs+Fj9o"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Fba/0zbH8Xs+Fj9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 16, 2013 at 03:25:09PM +0100, Josh Boyer wrote:
> Hi All,
>=20
> The commit below seems to have made the Tegra DRM driver a bool option
> instead of tristate:
>=20
> commit dee8268f8fb218c9e9b604a40f7dbdd395e910f9
> Author: Thierry Reding <treding@nvidia.com>
> Date:   Wed Oct 9 10:32:49 2013 +0200
>=20
>     drm/tegra: Move driver to DRM tree
>=20
>     In order to make subsystem-wide changes easier, move the Tegra DRM
>     driver back into the DRM tree.
>=20
>     Signed-off-by: Thierry Reding <treding@nvidia.com>
>=20
> That means you can't build the driver as a module.  Was this intended?
>  The changelog doesn't mention anything about that and the existing
> help text on the option seems to imply it should be buildable as a
> module.

This was intended yes. And it wasn't really a change at all, since prior
to the commit you mention above the DRM driver was always built into the
host1x driver. That's why I didn't think it necessary to mention it in
the commit message.

I have some patches queued for 3.14 to enable the driver to be built as
a module. There are some dependencies such as symbols that need to be
exported so that the modules can be linked, so it'll require some amount
of coordination to make that work out within one release cycle, but I'm
hopeful that we can do it.

Thierry

--Fba/0zbH8Xs+Fj9o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSidmSAAoJEN0jrNd/PrOhDzgQAJqdL6UpeZanE9oe1F6vlFuR
AP6QtLE0MPRxPZxfftC3ZpnNJXuEx5YaxMmT6X59OKOSw7Z+SzsS4fEXymk92AQa
WKsW4RKR8/NN34OTRleG+E9bQE0oxHEPU3/Du6wtOhLjgePx3U/J5L7KU8zhlmMq
Ez/na4jDGo0d1TrCNtEu4xSsQORgdAQAUFPLCRVL6+xzjWXMYcparJ3OIqK9NYbN
L3K6bdb73QCvuaFXn8tS0ELOwZSMohPOnwcWSP6hmF4q8Mm75Hoi3+3zmP+wA1yo
9ru4ddvuGppmtukYXQ4hsPJQc79E1nC9oIfNNzNRae+fDLh74/2Pugde2ShlkSCF
7LBEuc8/af6IG61AfPPtqFtDg7RbEah+u0oyaNG7qabr1+HZYI5sQ8A5ulivG1QV
g83VeqqShSbC5Od6GIM/xiuWDj96ydfze1LH9eUckaBgHL+Wwi+SdtaXtoNbceQt
863ek/L1TAEBotZpn5NRUKtv9Op3KI82HaGDDIpXPRiq9PGp73BRiEMwM/aJXAdt
Y5korjbB41aATS2BywCjARO5gA8nT8iWzNu0UciQ4EBEE7AFDitwU3Gnutng71QK
o3uCvzbOMjHJlzlNzwzsmQhI2FraKmBm03fcozfa8daj5h18vlkqcByo9LL0INPZ
cFaG1R4TvfDMQvBiXKLb
=EvEn
-----END PGP SIGNATURE-----

--Fba/0zbH8Xs+Fj9o--
