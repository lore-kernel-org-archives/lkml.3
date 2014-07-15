Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541AbaGOKlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:41:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45366 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038AbaGOKlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:41:51 -0400
Date: Tue, 15 Jul 2014 12:41:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v2 4/7] perf, x86: large PEBS interrupt threshold
Message-ID: <20140715104139.GA9918@twins.programming.kicks-ass.net>
References: <1405414739-31455-1-git-send-email-zheng.z.yan@intel.com>
 <1405414739-31455-5-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vYzPTKoKRdF40tnF"
Content-Disposition: inline
In-Reply-To: <1405414739-31455-5-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vYzPTKoKRdF40tnF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 04:58:56PM +0800, Yan, Zheng wrote:
> PEBS always had the capability to log samples to its buffers without
> an interrupt. Traditionally perf has not used this but always set the
> PEBS threshold to one.
>=20
> For frequently occuring events (like cycles or branches or load/stores)
> this in term requires using a relatively high sampling period to avoid
> overloading the system, by only processing PMIs. This in term increases
> sampling error.
>=20
> For the common cases we still need to use the PMI because the PEBS
> hardware has various limitations. The biggest one is that it can not
> supply a callgraph. It also requires setting a fixed period, as the
> hardware does not support adaptive period. Another issue is that it
> cannot supply a time stamp and some other options. To supply a TID it
> requires flushing on context switch. It can however supply the IP, the
> load/store address, TSX information, registers, and some other things.
>=20
> So we can make PEBS work for some specific cases, basically as long as
> you can do without a callgraph and can set the period you can use this
> new PEBS mode.
>=20
> The main benefit is the ability to support much lower sampling period
> (down to -c 1000) without extensive overhead.
>=20
> One use cases is for example to increase the resolution of the c2c tool.
> Another is double checking when you suspect the standard sampling has
> too much sampling error.
>=20
> Some numbers on the overhead, using cycle soak, comparing
> "perf record --no-time -e cycles:p -c" to "perf record -e cycles:p -c"
>=20
> period    plain  multi  delta
> 10003     15     5      10
> 20003     15.7   4      11.7
> 40003     8.7    2.5    6.2
> 80003     4.1    1.4    2.7
> 100003    3.6    1.2    2.4
> 800003    4.4    1.4    3
> 1000003   0.6    0.4    0.2
> 2000003   0.4    0.3    0.1
> 4000003   0.3    0.2    0.1
> 10000003  0.3    0.2    0.1
>=20
> The interesting part is the delta between multi-pebs and normal pebs. Abo=
ve
> -c 1000003 it does not really matter because the basic overhead is so low.
> With periods below 80003 it becomes interesting.
>=20
> Note in some other workloads (e.g. kernbench) the smaller sampling periods
> cause much more overhead without multi-pebs,  upto 80% (and throttling) h=
ave
> been observed with -c 10003. multi pebs generally does not throttle.
>=20

And not a single word on the multiplex horror we talked about. That
should be mentioned, in detail.

--vYzPTKoKRdF40tnF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxQVjAAoJEHZH4aRLwOS64hsP/i+WaI87Ip0/ZFBlv0h8Xt/w
4OoPDXgXFg3LRqbDvW55bYkRewR1/37dz4tMtzOKmriut1Y29MFGvFXClFtgXZx9
AOxy4DiZGbuuYOISzbN66p6RbnDHbch3oELB+C5w3/9iFAnILr/QgHD74PiNMDHH
+iIGjoT0mrCuSMf2Db7ElORZKpHL29motVI68qmqpfj3M42ImkGCM96pgu60/GtF
2un1Zgx/fC6qIkhJU3bFAxs8V2r7RJz2bvxXRJyYizMJHeiy44pEI1Yg1fBMjTVs
y0qPvUoOKNQB4Y8cQlPFLzPCD/MAy9cyo7YT4ftYPAbLlFZxmwTDQQuEAtAKGHZ9
biFNTT7kEHUPuSatSWS9/gpaVKOcxkcN2Vw1W7UC6VO+y+SEF56XCSr0+trPZfeK
c6ti4nytg6ajx7THOqfcwSNx2IM/vcbtxET7To8fQbthO5z3eQ7R3KyDPruttjqw
L6duaaW7qNrD53QvfLTk2uyyCRKcqt4Miv9JZu7a5OCcwobmI8eSBJ/hGgJDOmAD
dlTIp+4QVPBmp4ChvK5S/2BWRIhDsIZnqNteT4cQsSF0pWlhTW00VzxSSnoYZr1w
RSxA9hm0amS3x+ys+l9svX6UCEKkBcE/aXfYSFrFYG4+bRrJBs3hAIrW8Ikx0Rlq
FWrlKAqw+dti2Ze8KOI0
=2QNc
-----END PGP SIGNATURE-----

--vYzPTKoKRdF40tnF--
