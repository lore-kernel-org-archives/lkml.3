Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbaGIM4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:56:22 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64668 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbaGIM4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:56:18 -0400
Date: Wed, 9 Jul 2014 14:56:14 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 6/9] ARM: tegra: Export tegra_powergate_power_on
Message-ID: <20140709125613.GA3262@ulmo>
References: <53A3096B.1040409@wwwdotorg.org>
 <20140623101441.GU3407@tbergstrom-lnx.Nvidia.com>
 <20140708130501.GC9516@ulmo>
 <20140708141135.GC23218@tbergstrom-lnx.Nvidia.com>
 <20140709063130.GA3170@ulmo>
 <20140709083311.GE23218@tbergstrom-lnx.Nvidia.com>
 <20140709102551.GA19357@ulmo>
 <20140709110816.GF23218@tbergstrom-lnx.Nvidia.com>
 <20140709120400.GA3819@ulmo>
 <20140709124344.GK23218@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <20140709124344.GK23218@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 09, 2014 at 03:43:44PM +0300, Peter De Schrijver wrote:
> On Wed, Jul 09, 2014 at 02:04:02PM +0200, Thierry Reding wrote:
> > > For those 2 domains we can find the necessary clocks and resets by pa=
rsing
> > > the relevant existing DT nodes for PCIe and gr3d. For clocks, this is=
n't
> > > even needed as we can always register some extra clkdev's to get them=
=2E There
> > > is no equivalent for resets so we have to parse the gr3d and pcie DT =
nodes,
> > > but that's not too bad I think.
> >=20
> > Even if we could really do this, at this point I don't see an advantage.
> > All that it would be doing is move to some subsystem that doesn't quite
> > match what we need just for the sake of moving to that subsystem. Having
> > a Tegra-specific API doesn't sound so bad anymore.
> >=20
>=20
> The advantage would be that we can use LP0/SC7 as a cpuidle state.

How is that going to work? And why does it need powergates to be
implemented as power domains? If we switch off power gates, then we need
to restore context in the drivers anyway, therefore I assume .suspend()
and .resume() would need to be called, in which case powergate handling
can surely be done at that stage, can't it?

> Also system
> resume from LP0 can be faster as we potentially don't have to resume all
> domains at once.

I don't understand what that's got to do with anything. If we call into
the PMC driver explicitly via tegra_powergate_*() functions from driver
code, then we have full control over suspend/resume in the drivers, and
therefore don't need to resume all at once either.

Thierry

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTvTvtAAoJEN0jrNd/PrOhDuMP/iZGLpO01QcQ00MTPtb/CHWb
oxQV435smEj7tBrjc7se3k8hEgaOEF1GFPKOQ9eCQlL0JysBGPnlGJOFD13Tp+EU
H8vJnrSU1zpI/fCmSLmjAnvazwMrVlJtbzD+GgM9bn4zOMsLn9rMaKcfU7GOzky8
6uIim7Qwp2icvp2ici9HHz5fTZ+a2/VVSgj88b/EtQlOhsMDXpbzJ5Tgaooc2RzR
iG27JG/sI5ZILXrtZjt9Pjz+U2QWe7zE5tmyhiKGIHKpEoYoS8KeZh7HKdlS9R+D
t9eNJoyqxD/v4R4h2lgVfcj88pCGhWZ9V1qf/S5z/cdc/3bZra4fzeFyQFVShZ1h
d6AgY/FJf5PRnWne8aiIMNzTLfzU9tst/yJpv2TMaNZWMR5STxQ5az9zE93ABC3c
KBxGlUTk277nxYebmj+S2Qveb1PApFktJbLnsu3yLq0TtA8zr9bMiH5TibJz9IBR
M3jNyo3+RTPYiGwfr6oMbYm7kd6PtnVqxD6tY9Ql5slxyz29x3xEaeyj2D+gggjA
lkxUBjP0aAErp0Gl4pzpMIxEegaNQK5+qtfKDg7bySuWjRrg8sbIioOwHmeu4TmT
kq8TkBbQMdgT7RUG1Xr2GEwGq0PM1BXhk3+u9OE2vE5jCxSdwzPpC49O3M2WCFl9
jYKa66a/gUP5s+X/E31t
=1Xoq
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
