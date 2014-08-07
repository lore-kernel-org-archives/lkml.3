Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbaHGQdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:33:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37134 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414AbaHGQdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:33:08 -0400
Date: Thu, 7 Aug 2014 18:32:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140807163228.GX9918@twins.programming.kicks-ass.net>
References: <53DEE1CD.4000705@cn.fujitsu.com>
 <20140804074620.GH9918@twins.programming.kicks-ass.net>
 <53DF41ED.2020508@cn.fujitsu.com>
 <20140804115043.GA31903@linux.vnet.ibm.com>
 <20140804122515.GR19379@twins.programming.kicks-ass.net>
 <20140804145648.GE3588@twins.programming.kicks-ass.net>
 <53E029BB.2010200@cn.fujitsu.com>
 <20140805215510.GT8101@linux.vnet.ibm.com>
 <20140807084921.GK19379@twins.programming.kicks-ass.net>
 <20140807154358.GC5821@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qX8MxFb8mpDOGzgu"
Content-Disposition: inline
In-Reply-To: <20140807154358.GC5821@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qX8MxFb8mpDOGzgu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 07, 2014 at 08:43:58AM -0700, Paul E. McKenney wrote:
> On Thu, Aug 07, 2014 at 10:49:21AM +0200, Peter Zijlstra wrote:
> > On Tue, Aug 05, 2014 at 02:55:10PM -0700, Paul E. McKenney wrote:
> > > +/* Check for nohz_full CPUs executing in userspace. */
> > > +static void check_no_hz_full_tasks(void)
> > > +{
> > > +#ifdef CONFIG_NO_HZ_FULL
> > > +	int cpu;
> > > +	struct task_struct *t;
> > > +
> > > +	for_each_online_cpu(cpu) {
> > > +		cond_resched();
> > > +		rcu_read_lock();
> > > +		t =3D rcu_dynticks_task_cur(cpu);
> > > +		if (t =3D=3D NULL || is_idle_task(t)) {
> > > +			rcu_read_unlock();
> > > +			continue;
> > > +		}
> > > +		if (ACCESS_ONCE(t->rcu_tasks_holdout))
> > > +			ACCESS_ONCE(t->rcu_tasks_holdout) =3D 0;
> > > +		rcu_read_unlock();
> > > +	}
> > > +#endif /* #ifdef CONFIG_NO_HZ_FULL */
> > > +}
> >=20
> > That's not hotplug safe afaict, and I've no idea if someone pointed that
> > out already because people refuse to trim email and I can't be arsed to
> > wade through pages and pages of quoting.
>=20
> Hmmm...  That does look a bit suspicious, now that you mention it.
> After all, if a CPU is offline, its idle tasks cannot be on a
> trampoline.

But what about a CPU that in the process of getting on-line, it started
when there still were trampolines but hasn't quite made it to full
'online' status when you do this check.

Similar for going offline I suppose, we start to go offline when there
were still trampolines and got missed in that check because we already
cleared the 'online' bit but we're not quite dead yet.

I couldn't find any serialization against either on or off lining of
CPUs.


--qX8MxFb8mpDOGzgu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT46ocAAoJEHZH4aRLwOS6aU8P/2FPAuP5h1ZZRAribNGsaKX8
nIpsrNPT3RzW1OAi2BPVFcESBEMW/HZcKz5QPBbbYSo96XKYL57PdzafvUuUi8q7
s6Lk6VV+qztWT4WVMbRtRlWlhjDYm3eu5k891fxuOazGpbZH58E3curEvAmES6VU
xQu6ewA5g9I0tm1Eg+IpyfwD4SIHa12ze+Y3Cf5Sn3ep2EgdrbJwT7gv+ZUbsGV+
Lhebr00DglhTCCHtphxXq1qV+EbcVF/vD03F/P9Po/yg9fgNgfoujTs4B+fcdmPd
NkCKXS0VQFJ+bF/oIS2SxSIlooncfmAObHM/y9APiQt3xLKRdXKhFdn+3WAmxWmy
MRLpP5Kw8ArqiQkl948HVloVUxbIxqiXFJ8WiRjgKvHWYoLFBLbSA3v/6U4qRmuC
BJ81X9YdBeot40vZplDUXYHWI0qJb626cOsmT2Cm5uHTvgsJdAntC3g4WpvVlGXs
bEdJYdaQN8YZMvzGjV0rzTPOgeigfG5+95FbCM5OmIHKWCj/5k36h/An4IHWDxln
BD083Atmy906JedPznx44DdfCRVORY/wJNANPAaJ9jn5QAfQhJGBfB++bvKFe07e
VRD8k5pt/1369b8BgIKoe3s8+NyuWKMXpOHCtVOPiYc/6dKLdeUJV0OPds8bXDIi
ia06u5nI2TqygnNOQ0MW
=ZS8n
-----END PGP SIGNATURE-----

--qX8MxFb8mpDOGzgu--
