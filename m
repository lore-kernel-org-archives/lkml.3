Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbbAHIti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 03:49:38 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:35433 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbbAHItg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 03:49:36 -0500
Date: Thu, 8 Jan 2015 09:49:31 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Dmitry Osipenko <digetx@gmail.com>
Cc: Paul Walmsley <paul@pwsan.com>, linux-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Thierry Reding <treding@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH] soc: tegra: pmc: restrict compilation of suspend-related
 support to ARM
Message-ID: <20150108084929.GA1987@ulmo.nvidia.com>
References: <alpine.DEB.2.02.1412092224050.31750@utopia.booyaka.com>
 <20150107143354.GD1621@ulmo>
 <54AD4FB7.20600@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <54AD4FB7.20600@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 07, 2015 at 06:24:39PM +0300, Dmitry Osipenko wrote:
> 07.01.2015 17:33, Thierry Reding =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > On Tue, Dec 09, 2014 at 10:36:50PM +0000, Paul Walmsley wrote:
> >>
> >> Tegra SoCs with 64-bit ARM support don't currently support deep CPU
> >> low-power states in mainline Linux.  When this support is added in the
> >> future, it will probably look rather different from the existing
> >> 32-bit ARM support, since the ARM64 maintainers' strong preference is
> >> to use PSCI to implement it.
> >>
> >> So, for the time being, prevent the CPU suspend-related code and data
> >> in the Tegra PMC driver from compiling on ARM64.
> >>
> >> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> >> Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
> >> Cc: Thierry Reding <treding@nvidia.com>
> >> Cc: Allen Martin <amartin@nvidia.com>
> >> Cc: Stephen Warren <swarren@nvidia.com>
> >> Cc: Alexandre Courbot <gnurou@gmail.com>
> >> ---
> >> Applies on next-20141209.
> >> Intended for v3.20.
> >> Boot-tested on Tegra124 Jetson TK1 on next-20141209.
> >> Also boot-tested on Tegra132 Norrin FFD on next-20141209 + some unrela=
ted=20
> >> patches.
> >>
> >>  drivers/soc/tegra/pmc.c | 7 +++++--
> >>  include/soc/tegra/pm.h  | 2 +-
> >>  2 files changed, 6 insertions(+), 3 deletions(-)
> >=20
> > On second thought, I decided to apply this as-is.
> >=20
> > Thanks,
> > Thierry
> >=20
>=20
> Oh, I haven't noticed this patch before...
>=20
> I sent patch fixing tegra20 suspend bug [
> http://patchwork.ozlabs.org/patch/423778/ ] and it will obviously conflic=
t with
> this one.
> For now there is no feedback for my suspend bug patch (other than for V1)=
, but,
> if it's fine, I think it would be easier to rebase Paul's patch on top of=
 it.
> Any other suggestions?

I don't like changing this back to syscore_ops since it makes things
less easier to follow. I also don't think that using PMC_SCRATCH41 for
two different purposes is a good thing. There are a couple of
suggestions in my reply to your original patch. Could you investigate
whether any of those can be used to fix this instead?

Thierry

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUrkSZAAoJEN0jrNd/PrOh1/gP/AojUL2RvEZfbh49WCfbDu7t
r1BBwO7d3bhQVWBljJLnF8/f95/kKyusCKwfc4QT12grz7Or76XWiKJPj/WK4/XX
g8l5yK8ybH/oCcQ+DmZey7GLHHjH1ZYnc5hhA9pLAuaFyCdHyLDe9mwBBqTNu+bc
3KZI/wFUpfdMkLAPQyswvaU6hsMdrQptAR/I1JqO/wN9tDl/eh8LRjSc2aC9rRzK
pU2XLJpAt4m3xLFQYiHz5wZmMBJpFiLHzhZ8jQrNGh6QlSrA4aUxYlw5kIdmuYjz
prxXi0D+0n9mna1TrPZYdU09ucazd60Eg7XDJKY8Ash4j7Z2+5t6I1lO/4/1XaUN
dMHTGZ/T4n3TxUitUt6Y1ajcANdtUYKsBaIHimrn8EiFuIRk3BR5FZjBSNwAxKoz
HjL3hiixGntPKiOAHhEGhGOBbgHwmx7Ovm0pr/vIO2ZPC71b1a+DwynOwoeHwUS4
EQQByDc2Hg2O83K+R+DY+SYpt5AYh2lp52m5BLP5RP+E5IIpzzaDXF2P0LPhKvhB
FQB3UFaJIauVV4JI012wj7sL2Z1fAAAz7TVRRIs+dlswHNBQzVh4rcSCu42r8jWn
utr1+ZoYfP4KR61UKEfZsPXp48C0TJi4XRwNLn01kDW80tDnPYoGpi+eJckgFjd3
QwryIabbWAFSxAQq+/n4
=mrmc
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
