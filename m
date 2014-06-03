Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831AbaFCPlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:41:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:42221 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250AbaFCPlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:41:07 -0400
Date: Tue, 3 Jun 2014 17:40:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 08/11] sched: get CPU's activity statistic
Message-ID: <20140603154058.GY30445@twins.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org>
 <20140528121001.GI19967@e103034-lin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x4FmxR9v8irbgj/B"
Content-Disposition: inline
In-Reply-To: <20140528121001.GI19967@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x4FmxR9v8irbgj/B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 01:10:01PM +0100, Morten Rasmussen wrote:
> The rq runnable_avg_{sum, period} give a very long term view of the cpu
> utilization (I will use the term utilization instead of activity as I
> think that is what we are talking about here). IMHO, it is too slow to
> be used as basis for load balancing decisions. I think that was also
> agreed upon in the last discussion related to this topic [1].
>=20
> The basic problem is that worst case: sum starting from 0 and period
> already at LOAD_AVG_MAX =3D 47742, it takes LOAD_AVG_MAX_N =3D 345 periods
> (ms) for sum to reach 47742. In other words, the cpu might have been
> fully utilized for 345 ms before it is considered fully utilized.
> Periodic load-balancing happens much more frequently than that.

Like said earlier the 94% mark is actually hit much sooner, but yes,
likely still too slow.

50% at 32 ms, 75% at 64 ms, 87.5% at 96 ms, etc..

> Also, if load-balancing actually moves tasks around it may take quite a
> while before runnable_avg_sum actually reflects this change. The next
> periodic load-balance is likely to happen before runnable_avg_sum has
> reflected the result of the previous periodic load-balance.
>=20
> To avoid these problems, we need to base utilization on a metric which
> is updated instantaneously when we add/remove tasks to a cpu (or a least
> fast enough that we don't see the above problems).

So the per-task-load-tracking stuff already does that. It updates the
per-cpu load metrics on migration. See {de,en}queue_entity_load_avg().

And keeping an unweighted per-cpu variant isn't that much more work.

> In the previous
> discussion [1] it was suggested that a sum of unweighted task
> runnable_avg_{sum,period} ratio instead. That is, an unweighted
> equivalent to weighted_cpuload(). That isn't a perfect solution either.
> It is fine as long as the cpus are not fully utilized, but when they are
> we need to use weighted_cpuload() to preserve smp_nice. What to do
> around the tipping point needs more thought, but I think that is
> currently the best proposal for a solution for task and cpu utilization.

I'm not too worried about the tipping point, per task runnable figures
of an overloaded cpu are higher, so migration between an overloaded cpu
and an underloaded cpu are going to be tricky no matter what we do.

> rq runnable_avg_sum is useful for decisions where we need a longer term
> view of the cpu utilization, but I don't see how we can use as cpu
> utilization metric for load-balancing decisions at wakeup or
> periodically.

So keeping one with a faster decay would add extra per-task storage. But
would be possible..


--x4FmxR9v8irbgj/B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjeyKAAoJEHZH4aRLwOS6y4IP/3soDL2n3ihg7ehYk+A7qouA
RnxxeCE0AgorDo4f346fIyonoSmNkGPfE1Y5AnhpvA+ClqheBXQy/gDmu0ojkL1t
t+x7WuHAx04B4B0u9ySbg89bagZyjsr6lx81YLLxxGgkM/oOKhQHlE+GRW5YlPrV
8st0lO6TO/KoqUEaDZIMB837yVZtwwi0n+ykOWZiT8TQH3jh3mFtoayh+YAoMbLD
4ZL8Q33fyO4If8ifWxDBEB9N4aocEh6VbNCccc3ygJANZ7AdmgTUEY7GwONGh0SO
3vT4GQVey3AAZyyWpwDk6Y58J4aZTT2p+N2FRInBXwgmV2OHkZagTW8vafsnyP4D
1MSnXsyvAqiE8V57LUxAjjeK/QoNidrf+0b6DTMLmnWiX9b7BDVScC4MMb3Ohe9g
4lcCd36WMuvdLgSqxooexTXIYD/et99ETWOO9xJeHvTKnFvS5dI5F6JV2jKx/3SD
ko8/5bOLzk0qo9Ki6Y+Me0UjAbtb91MUn1GIDIQaeUgtJkx7HV9Eh37xjaBFbjW7
SPJA+F4RYZVwVjiFOHJWFz7/HIwuC2AA3+VNMgrE9nUAlgyK+o87Akbgrtk2OjGt
39TDc6aFp3PavhlX0YOmmQFA2zONF240ESPuOVKLnsKMfPUPmoX7Q4/JItsZlfUx
AaOGvkjOkRChT1orHJdu
=Likn
-----END PGP SIGNATURE-----

--x4FmxR9v8irbgj/B--
