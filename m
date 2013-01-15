Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab3AOLbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 06:31:01 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:65432 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab3AOLa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 06:30:59 -0500
Date: Tue, 15 Jan 2013 12:30:49 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        Arto Merilainen <amerilainen@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
Message-ID: <20130115113049.GB18119@avionic-0098.adnet.avionic-design.de>
References: <50CAC2AC.1010704@nvidia.com>
 <50CB5205.1030303@wwwdotorg.org>
 <50CB850F.9090704@nvidia.com>
 <20121216121603.GA31780@avionic-0098.adnet.avionic-design.de>
 <50D2D792.1050401@nvidia.com>
 <50D34775.5010606@wwwdotorg.org>
 <50D42486.7080901@nvidia.com>
 <50D4D25B.7030506@wwwdotorg.org>
 <50E6AA69.4030001@nvidia.com>
 <50E73AA2.7090500@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Content-Disposition: inline
In-Reply-To: <50E73AA2.7090500@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:c1dOo7g75t6MUFKzUxme/acyzl3cmU8KPI64M6lvdfT
 gwIsLSZvy1k+5z15qqY1Wihq5QzKKrpGSQJ3nA6WLnDb/YDMQ2
 fGqjEhIGo6oNJrlMRYGM6WyycDtSqBJKr2AXn30giI9WCk6xhE
 1RhCD2Wf+1AYSf3nPtKLPUJqI4D8wkcKQ7KWmsWvarRw88Bm+U
 lJpODtkZFOQy0xP6/DEYOjCTRLsUxa1s6zzZyCFdmFC+s5wPps
 92N5c4slMgbALn9h9UbuOhQmwMQykQKVlHmUgVKga9KuLuMmOI
 ePpOs1ck51T3X+9pI8wnDPtjdYKBUnjuLs3uNeEE/93QRJRpHz
 nZf6A8Iic1uC+c0VMRQ2OsztcdT0k4RdrB1C94Qu9mXgLAbjjN
 ITJin1aQaSOgUXE+XaujdSdM/kcQU2Hruo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 04, 2013 at 01:25:06PM -0700, Stephen Warren wrote:
> On 01/04/2013 03:09 AM, Terje Bergstr=C3=B6m wrote:
> ...
> > I think we have now two ways to go forward with cons and pros:
> >  1) Keep host1x and tegra-drm as separate driver
> >    + Code almost done
> >    - we need dummy device and dummy driver
> >    - extra code and API when host1x creates dummy device and its passed
> > to tegra-drm
>=20
> Just to play devil's advocate:
>=20
> I suspect that's only a few lines of code.
>=20
> >    - tegra-drm device would need to be a child of host1x device. Having
> > virtual and real devices as host1x children sounds weird.
>=20
> And I doubt that would cause problems.
>=20
> >  2) Merge host1x and tegra-drm into one module. drm is a subcomponent,
> > and whatever other personalities we wish would also be subcomponents of
> > host1x. host1x calls tegra-drm directly to handle preparation for drm
> > initialization. As they're in the same module, circular dependency is o=
k.
> >    + Simpler conceptually (no dummy device/driver)
> >    + Less code
> >    - Proposal doesn't yet exist
>=20
> But that said, I agree this approach would be very reasonable; it seems
> to me that host1x really is the main HW behind a DRM driver or a V4L2
> driver or ... As such, it seems quite reasonable for a single struct
> device to exist that represents host1x, and for the driver for that
> device to register both a DRM and a V4L2 driver etc. The code could
> physically be organized into separate modules, and under different
> Kconfig options for configurability etc.
>=20
> But either way, I'll let you (Thierry and Terje) work out which way to go.

Sorry for not getting back to you on this earlier. I just remembered
this thread when I saw Terje's latest patch series.

I agree that having everything in one location will make things a lot
easier, even if it means we have to add the tegra-drm driver to a new
location. In the long run I think this will pay off, though.

That said, I see that Terje has chosen this approach in his latest
series, so it's all good.

Thierry

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ9T3pAAoJEN0jrNd/PrOh2AwP/jcRl9vA4MiadUIQfzW4NtKT
GQwhUilcNgU3HeCgOCLVT8jzQMrxSExDTYFbSuiEjyieiAVDJil6TBJk7yOMq0+2
/2fc/xcHFpZwkiKHYmEv7FmHs6p3JogLSIx/TqdFWKV0/CVQHp1nzQ4edBeBxl/d
1gJR+YTPIQZIaCp/66JzWAuxISdv2tBC4euqzvaXPmYLdhNXyIiXVjCLFKsq+sJN
cotedrfXgVFpePwC/c/lp+i1uSql1KHLdGq6B1Qs/3OJFDvpZFUSVg38Qyew1F8E
q62vcNRFwkgnUKN6pDmezZjf+Riidsl/ExrmeVuDR4NvFlkosp24a+VymFFs4Iw/
afenWyA0nFD3T6795Ve8bXEogUWHZulGldnW86piPvg4iAfdunLG0PmQ8oTdwByt
EXIQoSt9Py+jX8J7ZYd6ZsF3ApAiUlVejdd8xiZpWjfkFK07aGBDMMvwSCyumAYi
d+fCFR6VVgYo8dVWFO6AogoAL7sOqO0Kc4m+z9XgHwzW16DWkPfjXpqyVn+mXpx5
/WqO0oNsYma88N5HGLxl8Ut/4BuXbTjfonRnuKBoIXMzEczk7hmzgwWer5O2saa4
hxjau/PZGefQYDAH0EwFDYmDuaVhcRAi7fmlmt3NhSBK0XC+lLuZvqlFokODxxzz
8Lwfothqji6QV0Wg5PEU
=8mTo
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--
