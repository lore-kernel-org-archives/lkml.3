Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbbAIJ57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:57:59 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:61880 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbbAIJvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:51:38 -0500
Date: Fri, 9 Jan 2015 10:51:35 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Courbot <gnurou@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>, stable@vger.kernel.org,
        Joseph Lo <josephl@nvidia.com>, linux-tegra@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] ARM: tegra: Use PMC scratch register 40 for
 tegra_resume() location store
Message-ID: <20150109095134.GC27845@ulmo>
References: <1419202392-1159-1-git-send-email-digetx@gmail.com>
 <54984429.8040905@wwwdotorg.org>
 <5498549B.8070101@gmail.com>
 <54985C30.7020605@wwwdotorg.org>
 <20150108105742.GI1987@ulmo.nvidia.com>
 <20150108123709.GX10073@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L6iaP+gRLNZHKoI4"
Content-Disposition: inline
In-Reply-To: <20150108123709.GX10073@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L6iaP+gRLNZHKoI4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 08, 2015 at 02:37:09PM +0200, Peter De Schrijver wrote:
> On Thu, Jan 08, 2015 at 11:57:43AM +0100, Thierry Reding wrote:
> > * PGP Signed by an unknown key
> >=20
> > On Mon, Dec 22, 2014 at 11:00:16AM -0700, Stephen Warren wrote:
> > > On 12/22/2014 10:27 AM, Dmitry Osipenko wrote:
> > > >22.12.2014 19:17, Stephen Warren =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > > >>On 12/21/2014 03:52 PM, Dmitry Osipenko wrote:
> > > >>>Commit 7232398abc6a ("ARM: tegra: Convert PMC to a driver") changed
> > > >>>tegra_resume()
> > > >>>location storing from late to early and as result broke suspend on=
 tegra20.
> > > >>>PMC scratch register 41 was used by tegra lp1 suspend core code fo=
r storing
> > > >>>physical memory address of common resume function and in the same =
time used by
> > > >>>tegra20 cpuidle driver for storing cpu1 "resettable" status, so it=
 implied
> > > >>>strict order of scratch register use. Fix it by using scratch 40 i=
nstead of 41
> > > >>>for tegra_resume() location store.
> > > >>
> > > >>You likely can't simply change the PMC scratch register usage arbit=
rarily;
> > > >>specific registers are designated for specific purposes, and code o=
utside the
> > > >>Linux kernel (bootloaders, LP0 resume code, secure monitors, etc.) =
may depend on
> > > >>those specific values being in those registers. Without significant=
 research,
> > > >>I'd suggest not changing the PMC scratch register usage.
> > > >
> > > >Sure, that's why I asked to verify if scratch register 40 is in use =
in the
> > > >comment after commit message.
> > >=20
> > > Sorry, I didn't notice that.
> > >=20
> > > >I've checked that u-boot doesn't use it (since
> > > >upstream kernel doesn't care about any other bootloader), but no ide=
a about
> > > >secure monitor. It's definitely safer to avoid changing scratch regs=
 usage, I
> > > >thought that proposed solution would be best from the pure code poin=
t of view.
> > > >So, I'm considering your answer as a rejection of the patch (please,=
 let me know
> > > >if I'm wrong) and will prepare another one. Btw, it would be nice to=
 have
> > > >scratch registers usage publicly documented somewhere (on "Tegra Pub=
lic
> > > >Application Notes" webpage for example), if it's possible, of course.
> > >=20
> > > At this stage in Tegra20 development, I think it'd be best to avoid c=
hanging
> > > any scratch register usage if at all possible.
> >=20
> > Sorry, I had completely missed this discussion. When looking at the code
> > it doesn't look like this particular "resettable" status needs to be
> > stored in a PMC scratch register. It can't be stored in RAM because that
> > goes into self-refresh as part of LP1, but how about just putting it
> > into IRAM? That stays on in both LP1 and LP2, so should be suitable for
> > this use-case. It would make the code slightly more complex but using a
> > single scratch register for multiple purposes sounds brittle and easy to
> > break (as evidenced by the offending commit).
> >=20
> > Otherwise it would seem that PMC_SCRATCH40 is only used to store EMC
> > configuration data across LP0 suspend/resume, so I wouldn't think it'd
> > cause problems if we used that instead of PMC_SCRATCH41 to store the
> > "resettable" state.
> >=20
>=20
> No. Usually the scratch registers for EMC config data are setup once by t=
he
> bootloader and never touched by the kernel after that. So I would not
> recommend reusing those registers for different purposes.

Right, I misread the code in the downstream kernel. Though it's not the
bootloader that does it (at least on Tegra20), but some early code in
the kernel.

IRAM sounds like a good candidate still. Or do you know of anything that
would exclude IRAM as storage location for this data?

Thierry

--L6iaP+gRLNZHKoI4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUr6SmAAoJEN0jrNd/PrOhxXgP+waskskvbs0ofYeYrnkPG4df
MF9kVm2KgrEFyOnS4TsIvi26KUqjLHBzNm/e2UdouzmdUj6tB56sUzxBAHb3/2ZB
b0AKsTSuSQrA5QhHxE+7h9KL1wElO4I7W9yAhZoi2ALSzMIThzTD7VS+kQw6vHYQ
ENaqOg9c6K29N/dfULVFCoU3cOl7o1796wcZ4M4M23s5arUyoybqfSSoh3gE2Ugt
gs/h+pfCJJU7vNsH/WGWyQMlCVs5bQU/z0AdCnCTOPmQ8HFKP7vc2YM6IrvJcTgd
C7PMXXJfdV4TnnPIWL8S1XpMflqFF/CpjPR1jzbSuTJOSvj7Mmn7FtKe785qtvHF
KOSb4SkE6wBZS8bJJOXxh55uZ+31jjB13lOjMlGMsCZCVn3VHLwhlxjA4X6xIJCp
XBuDz9h79qlmBzc4v+tPAA0vAMTukpI/UvpG1d9j4chqGAytqY8e6hN5QHad/k64
IwFGTWuXjL02JeNg7sfNqCBKPYBE/up/75n59rHHtEjZP+YnNrmajlyOksP4nzhw
VIrYu9E/3i0Oa/Mgg1W38We411p0quVIploBrH80cUAtUedKlE8nba4LGn97xXQP
yXYfaxUuuXyuNRSr9YCkBl3EZ2hZw+W9V6e0MQyCc+qPZEf44rBrs76/3lBxwPQP
zVJDk37yHcAAUrgNIdK5
=BAQA
-----END PGP SIGNATURE-----

--L6iaP+gRLNZHKoI4--
