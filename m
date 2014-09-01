Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbaIAXl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 19:41:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:3522 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbaIAXl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 19:41:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,445,1406617200"; 
   d="asc'?scan'208";a="474504796"
Message-ID: <1409614914.2384.3.camel@jtkirshe-mobl>
Subject: Re: [PATCH] semaphore: Resolve some shadow warnings
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, Mark Rustad <mark.d.rustad@intel.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 01 Sep 2014 16:41:54 -0700
In-Reply-To: <20140901120244.GI27892@worktop.ger.corp.intel.com>
References: <1409228366-7027-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <20140901120244.GI27892@worktop.ger.corp.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-IlTSsz24CSROd4Ghw3EH"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IlTSsz24CSROd4Ghw3EH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-09-01 at 14:02 +0200, Peter Zijlstra wrote:
> On Thu, Aug 28, 2014 at 05:19:26AM -0700, Jeff Kirsher wrote:
> > From: Mark Rustad <mark.d.rustad@intel.com>
> >=20
> > Resolve some shadow warnings resulting from using the name
> > jiffies, which is a well-known global. This is not a problem
> > of course, but it could be a trap for someone copying and
> > pasting code, and it just makes W=3D2 a little cleaner.
> >=20
> > Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>=20
> Why isn't Mark sending this email?

Mark sent me several patches like this, for me to push upstream.  So, I
am making sure the appropriate owner is the receives the patch versus
blindly sending to LKML.

>=20
> > ---
> >  kernel/locking/semaphore.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/kernel/locking/semaphore.c b/kernel/locking/semaphore.c
> > index 6815171..7782dbc 100644
> > --- a/kernel/locking/semaphore.c
> > +++ b/kernel/locking/semaphore.c
> > @@ -36,7 +36,7 @@
> >  static noinline void __down(struct semaphore *sem);
> >  static noinline int __down_interruptible(struct semaphore *sem);
> >  static noinline int __down_killable(struct semaphore *sem);
> > -static noinline int __down_timeout(struct semaphore *sem, long jiffies=
);
> > +static noinline int __down_timeout(struct semaphore *sem, long njiffie=
s);
> >  static noinline void __up(struct semaphore *sem);
>=20
> So what's wrong with calling it "timeout" instead? That's what most
> other sites do.

Timeout would work as well to resolve the shadow warnings.

--=-IlTSsz24CSROd4Ghw3EH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUBQRCAAoJEOVv75VaS+3Od6EQAIcs2wwtuPQGVLrzDW8JOSlA
CarjUhqrPi2MERqeFPZS0nGWv8BqhcvSp4BT+/u/w/w6Qsjn+CKtO842B2wW5YSX
RV3vnTkoqfo6H4G42BbDDjTTy1MmC9ZJVKdNDIeHlJU6XwNgz1obfmy+bUEd704g
fagow5lw37RuccnVRKjdIg9aZgj92eIgK55OUoE87U9oBPWziOT3LtcYft7T5FSU
kam60Acd5+QBrYqQciqIidBpTUfhR9SaWF5VdNVi/boxe5nE5lqriLVdPm3Atixk
5siH+rx2ASpftj0RV+8IwlwAWy3ZUeYK6UKCFJHHyCbTi4c5PCDXundY6R0k1mhT
f+BS6Jc0hQ/jHSnjT2gnwEFjTN3UjWSh5SnbZVt/aNMrCuZV4W31cr+qkRSnAlHl
X7vtDv2+AYI4X6pbTjx/74z/4knFSYyGJzQkTz3N1LMKNeMOR3C8IVSq9AcfrXsT
vlppKmrYk0bBeQXyUWYVJDuMCqew5ba5Eqhif3q4031ynfbRWLbBIpUx92mLjLyW
+Xsw2naewvNsn1nE2AgO4PI+TAOeNZF4fdG30cvdDLFm+fQ4L3tgEIbYVxBMkbzT
0mtvRR8qM7yOn1Bpwu6Ub8E6DcrErf8K66MJDEk03MEE2Uq9XlwTrGlgYxPY5JvB
hY17ZqBORK3hnCi5fIGL
=3i4z
-----END PGP SIGNATURE-----

--=-IlTSsz24CSROd4Ghw3EH--

