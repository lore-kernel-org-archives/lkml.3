Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174AbaFJKX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 06:23:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:48392 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaFJKX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 06:23:57 -0400
Date: Tue, 10 Jun 2014 12:23:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Henrik Austad <henrik@austad.us>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [RFC PATCH 02/16] sched: Introduce CONFIG_SCHED_ENERGY
Message-ID: <20140610102353.GC6758@twins.programming.kicks-ass.net>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <1400869003-27769-3-git-send-email-morten.rasmussen@arm.com>
 <20140608060316.GA18179@austad.us>
 <20140609102027.GA29593@e103034-lin>
 <20140610093943.GA6758@twins.programming.kicks-ass.net>
 <20140610100641.GB1581@e103034-lin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TCH5zSpbvKOKdCih"
Content-Disposition: inline
In-Reply-To: <20140610100641.GB1581@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TCH5zSpbvKOKdCih
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 10, 2014 at 11:06:41AM +0100, Morten Rasmussen wrote:
> How would you like to disable the energy stuff for users for whom
> latency is everything?
>=20
> I mean, we are adding some extra load/utilization tracking. While I
> think we should do everything possible to minimize the overhead, I think
> it is unrealistic to assume that it will be zero. Is a some extra 'if
> (energy_enabled)' acceptable?
>=20
> I'm open for other suggestions.

We have the jump-label stuff to do self modifying code ;-) The only
thing we need to be careful with is data-layout.

So I'm _hoping_ we can do all this without more CONFIG knobs, because
{PREEMPT*SMP*CGROUP^3*NUMA^2} is already entirely annoying to
build and run test, not to mention that distro builds will have no other
option than to enable everything anyhow.

--TCH5zSpbvKOKdCih
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTlty5AAoJEHZH4aRLwOS66xEP/Ru/QFVrwW9QzSFBB21RaEWg
jiGy4mGP3a8LxpXiYqb18hti7bONnpJeokH1gVXxidwICARbcoXhnbxy8sTpo1A1
sZ2JnWXKbRcgLqCd52RnGOWQxTpPY2qBIntS2WR/HYhfoekltqtCr3/EgjzE7kxj
gjOo3y5r5iTupd6EnzzEf5Ghv4IhC1ecBn8sMhVpBvEqB1OWSWy5qeBXD+HUWCGQ
DWQqhSNan0XToadzwUprKTZaM/8zf+KJ8DKFyc0m2GXM64PFXBWs4SWy5AWmTFXn
9Xoola+LkgSsjEI59qD3a2q+qwxsg7saKa78onbDmsvu5Nl42gBqO409yrKx7d9B
pewDmaTl0Rb5ZJn4mla3wath5WZnL/me4CVmK/a4PVGoLsv0w+BTiiMHZLWtOU4S
yk397Zq78vEf0XYNSkuMlLi7Da8U4+NAx4KWOG9Ddb7HuL1UdJqcYATiUtRpGGLQ
zkvKHjIsDMPYNFpxOjlN1nBoIM0a4/gy0zHUk2NPlnuDcBusnqZNS6gl9rXxAUa6
AG/7cgNj4WJdtvqVhGmDDwG16gyov+eSCqiHtYEM+STj0+5L+p4fsilv+0RoAGoR
sOu6RxEaYE38+cZKaHMjAB0ekOJhakt/JWooTbTZepxRfG+9FdQM2mL0ZlOcgNMY
DAcn1iA5uDg4lqOsGCoi
=7xrz
-----END PGP SIGNATURE-----

--TCH5zSpbvKOKdCih--
