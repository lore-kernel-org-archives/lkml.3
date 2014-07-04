Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbaGDHxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:53:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35578 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbaGDHxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:53:05 -0400
Date: Fri, 4 Jul 2014 09:52:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Dave Chinner <david@fromorbit.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [regression, 3.16-rc] rwsem: optimistic spinning causing
 performance degradation
Message-ID: <20140704075247.GZ19379@twins.programming.kicks-ass.net>
References: <1404413420.8764.42.camel@j-VirtualBox>
 <20140704010147.GY4453@dastard>
 <1404438366.8764.121.camel@j-VirtualBox>
 <1404438890.8764.125.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i6WX/W6h5xa4jqsd"
Content-Disposition: inline
In-Reply-To: <1404438890.8764.125.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i6WX/W6h5xa4jqsd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 03, 2014 at 06:54:50PM -0700, Jason Low wrote:
> Subject: [PATCH] rwsem: In rwsem_can_spin_on_owner(), return false if no =
owner
>=20
> It was found that the rwsem optimistic spinning feature can potentially d=
egrade
> performance when there are readers. Perf profiles indicate in some worklo=
ads
> that significant time can be spent spinning on !owner. This is because we=
 don't
> set the lock owner when readers(s) obtain the rwsem.
>=20
> In this patch, we'll modify rwsem_can_spin_on_owner() such that we'll ret=
urn
> false if there is no lock owner. The rationale is that if we just entered=
 the
> slowpath, yet there is no lock owner, then there is a possibility that a =
reader
> has the lock. To be conservative, we'll avoid spinning in these situation=
s.
>=20
> Dave Chinner found performance benefits with this patch in the xfs_repair
> workload, where the total run time went from approximately 4 minutes 24 s=
econds,
> down to approximately 1 minute 26 seconds with the patch.
>=20
> Tested-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Jason Low <jason.low2@hp.com>

Davidlohr, you'll be running this through your AIM and other benchmarks,
I suppose?

--i6WX/W6h5xa4jqsd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTtl1PAAoJEHZH4aRLwOS6IiIP/0WcZ9ADUHTVOmSbT7LY2ROu
0BTRY+qgLlHLwQVp5aQquBprmGKLOn+9Q4WA/2uXOWqmWg7MgX+vk1iN89alsIrz
UHBOctcmFjuin/tBLen9huD3discUiLTLt0B9wOCEc7VrwLAGCgK1ovzgu/XQLec
+D1+CwDKcWQfVs7E2Jk6CQ6hJdn0tQr9wXDNDYyay+JWgT5v0sv2DywMGLazlhTV
ddAe8xR45pMZDMFJ38wvjXrdzRmkpksW8SiNKqi5+jeDe/OEyiZBNIK/cXfDR5NQ
6kTm/NmcBRHJpOLuJY6wbLnBX3GgRV572D2XunERLGdczmxU0SlQ5gM0xBL05xom
xJZEnfjx6o6At8VDdPROa0TBjhLvyG/HSn/bpGxarY21TJXxlPmpXdj78j3pd6Q/
n2hnXYacAiluxgG4yMGUazkb5lhfg55S9+6+qEMfTOeM7eU/Ft/Z/iQPIveJ1ds8
uwPEwv9WgdVHR6JD/mdDG4M8MFslOoEWdq6YIx/Pqt+j3AV6f3nUg/T6ad9RBPpP
yzylq6wdB8lfHbl7NFfaqAu2knPckpqkmoE4gJKHNf58ixCzNdwQdxnPHFVerMyz
kvPE2Kvdwlfddnpld7HpGeWfGzKUDA0CkjuNdUQ1BLkt0H2OJysiKf7muS1Qt7W0
kJdpqpSi+9vesbby5wok
=BynN
-----END PGP SIGNATURE-----

--i6WX/W6h5xa4jqsd--
