Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbaFCIIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 04:08:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54992 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaFCIIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 04:08:35 -0400
Date: Tue, 3 Jun 2014 10:08:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mtk.manpages@gmail.com, torvalds@linux-foundation.org,
        mingo@kernel.org
Subject: Re: sched: Disallow sched_attr::sched_policy < 0
Message-ID: <20140603080826.GK11096@twins.programming.kicks-ass.net>
References: <20140602021319.9A5F9660C19@gitolite.kernel.org>
 <20140602202204.GA26649@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1lNKaBMh+XZLvvpk"
Content-Disposition: inline
In-Reply-To: <20140602202204.GA26649@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1lNKaBMh+XZLvvpk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 02, 2014 at 04:22:04PM -0400, Dave Jones wrote:
> On Mon, Jun 02, 2014 at 02:13:19AM +0000, Linux Kernel wrote:
> =20
>  >     sched: Disallow sched_attr::sched_policy < 0
>  >    =20
>  >     The scheduler uses policy=3D-1 to preserve the current policy stat=
e to
>  >     implement sys_sched_setparam(), this got exposed to userspace by
>  >     accident through sys_sched_setattr(), cure this.
>  >    =20
>  > ---
>  >  kernel/sched/core.c |    3 +++
>  >  1 files changed, 3 insertions(+), 0 deletions(-)
>  >=20
>  > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>  > index f2205f0..cdefcf7 100644
>  > --- a/kernel/sched/core.c
>  > +++ b/kernel/sched/core.c
>  > @@ -3662,6 +3662,9 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pid, struc=
t sched_attr __user *, uattr,
>  >  	if (retval)
>  >  		return retval;
>  > =20
>  > +	if (attr.sched_policy < 0)
>  > +		return -EINVAL;
>  > +
>  >  	rcu_read_lock();
>  >  	retval =3D -ESRCH;
>  >  	p =3D find_process_by_pid(pid);
> =20
> Todays coverity run picked up..
>=20
> 3687
> >>>     CID 1219934:  Unsigned compared against 0  (NO_EFFECT)
> >>>     This less-than-zero comparison of an unsigned value is never true=
=2E "attr.sched_policy < 0U".
> 3688            if (attr.sched_policy < 0)
> 3689                    return -EINVAL;
>=20

Once upon a time GCC also did warns like that, but my compiler is silent
:-(

Yes, that needs fixing..

--1lNKaBMh+XZLvvpk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjYJ6AAoJEHZH4aRLwOS6ga4QAJYtMl/sqW4WgnXwMZ7kEAgO
MyoM9hwo4lyH9q+rLieEChyykoiRfy1MH1S9X0x0zqxmu276iqG60aV9GcSQkMXE
VQZH1gY8XI1Ma/y0cYOsuyQ4jTQRxfftJmFd+vEaIQiql4fGFwkz6ImaLO43L97S
IR1jJkyWhAKyndzDE06/tCCzHoN6IAexpkDeHZ4KDbzt3o8cXB6y9Ylci5Dm6va+
c6S0uYOu8yDK/JPA6hMS4UJzAcbEw6/llYvnZmxyRXxuh5EE9TO0EtetEFtT1yrS
GkBPuC8KMVpFaPhaBKovnuGUSvBiMjQoYo0jkviJD6ts241pAs5oMuj7K4chLDuN
jJt4MiVfWnmZCzfuiLCElk07P0Np4GFvxH2uNVpvoU0rktWqZuhKNtMW38wNYQ7h
mLEa6PWdkTMI7Nagv8Ll/UMLCA020IVuQ5SCmrFhs/mmKVlSY50+MjAjelX2XME/
bBLWauiNvVzo0Zi65zgzM6slbhSCfKX3uobCPOxVZa+fOnsnI4tdX64FiOokJ3v9
S2YI85esd4qMj3octwda5K28T0FxVb2Kht2VtkNsc4ZSDotG7KzJEqotoWa2H/L9
N9h3yUTldWLoH4QhSBm/5yByTk4OWI9ESeP2ViaPc8wzbciMTxkoZpcPmL1b6UfR
PciR0NalSV+igtWSxsah
=4nwG
-----END PGP SIGNATURE-----

--1lNKaBMh+XZLvvpk--
