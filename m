Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaFDJXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 05:23:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55964 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaFDJX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 05:23:29 -0400
Date: Wed, 4 Jun 2014 11:23:13 +0200
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
Message-ID: <20140604092313.GB11096@twins.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org>
 <20140528121001.GI19967@e103034-lin>
 <CAKfTPtDxeBfZK1AxCRqEG91pi--Ti1RYFoQPDhvMVnGTCspQ-g@mail.gmail.com>
 <20140528154703.GJ19967@e103034-lin>
 <20140603155007.GZ30445@twins.programming.kicks-ass.net>
 <CAKfTPtDUvH--WxFATTW6YRAvLuohzyNHDUq6DRdfxc7gRKCX6Q@mail.gmail.com>
 <20140604080809.GK30445@twins.programming.kicks-ass.net>
 <20140604085542.GH29593@e103034-lin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HFmY1QOi3uof3bwe"
Content-Disposition: inline
In-Reply-To: <20140604085542.GH29593@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HFmY1QOi3uof3bwe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2014 at 09:55:42AM +0100, Morten Rasmussen wrote:
> Both running_avg and runnable_avg are affected by other tasks on the
> same cpus, but in different ways. They are equal if you only have one
> task on a cpu. If you have more, running_avg will give you the true
> requirement of the tasks until the cpu is fully utilized. At which point
> the task running_avg will drop if you add more tasks (the unweighted sum
> of task running_avgs remains constant).
>=20
> runnable_avg on the other hand, might be affected as soon as you have
> two task running on the same cpu if they are runnable at the same time.
> That isn't necessarily a bad thing for load-balancing purposes, because
> tasks that are runnable at the same time are likely to be run more
> efficiently by placing them on different cpus. You might view as at sort
> of built in concurrency factor, somewhat similar to what Yuyang is
> proposing. runnable_avg increases rapidly when the cpu is over-utilized.

Agreed.

> > I'm not sure I see how 100% is possible, but yes I agree that runnable
> > can indeed be inflated due to this queueing effect.
>=20
> You should only be able to get to 75% worst case for runnable_avg for
> that example. The total running_avg is 50% no matter if the tasks
> overlaps or not.

Yes, 75% is what I ended up with.

> f you had five tasks on one cpu that each have a 25% requirement you can
> get individual task runnable_avgs of up to 100% (cpu unweighted
> runnable_load_avg can get up 500%, I think), but the task running_avgs
> would be 20% each (total of 100%).=20

Yeah, more or less so indeed. I had not considered the queueing effects
on runnable_avg yesterday, so good that that got raised.

That does indeed invalidate my: runnable - running :=3D extra cpu required
thing. It ends up being the extra cpu required for 0 latency but gobs of
idle time, which is something else entirely.

--HFmY1QOi3uof3bwe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjuWBAAoJEHZH4aRLwOS6zR0P+wfWRse7YquVDMzIkbs0rk8V
8D/xDBj1WITTUYqyMviYimENIivXGssloKikXvUd6Dl4OCT+qRm4k+XVfVtV2zwo
E0zu8wQnojCUsBuSHx9Ws/q54vi+OVFzqSKweE/pGmlaXkpglg0upIP1vP7AdGbf
FlI8HSVshOUfDGDKr0o2Q9d3QaOC/PGxbshNj4YCJiuZ0yOIk8k+QOuaPfItv2Yv
9B2vxORqCO91omAkwMnLwvTKlJ3iYE1vDUB9Aof5GUdM/wyV5kRmfsQ1jixLXUfQ
qoP9ZsC7D45a92EH40jGTx/qFYrsvWmizMiK22G70JaZJPF5mQJKP2XkVcF/1SfP
1PdrjSUnmtsVPllEw6bxm1ngRABmz0AGxqKNKbeQLt8kwVLV0eqJs6E5vcdCTyNu
ihdSmsd3dqJK1rMPuIQwhP7ptvaUgJUb10xotzYzTBFaWIFs/OOYZCrcYGJH4a71
wxFhcXRKgRGFaRM6Hg/5uLLVsh+OB32tjRbc8yI/kcCFNIk2FP/eGrcsD7Uscqmp
L7BJq8SXH4kZh448mJDzFJODxe3liMBIIoD/ABgKSOVctqpyEct6Nxc1lSSDwU4r
oR4WAU+HoZ9s81R9kDAJKDhZ5Gn4Uty30hCmPdGafvlqSG4Ji0mMHGHcrwibzfnU
ymRSuL9GyRFu3wd1pTYm
=Uwnw
-----END PGP SIGNATURE-----

--HFmY1QOi3uof3bwe--
