Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbaFCL7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:59:52 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38208 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823AbaFCLl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:41:58 -0400
Date: Tue, 3 Jun 2014 13:41:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
Message-ID: <20140603114145.GX11096@twins.programming.kicks-ass.net>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <1400869003-27769-7-git-send-email-morten.rasmussen@arm.com>
 <20140530120424.GD30445@twins.programming.kicks-ass.net>
 <20140602141536.GL19967@e103034-lin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eY8wQnuu3RZDiCQc"
Content-Disposition: inline
In-Reply-To: <20140602141536.GL19967@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eY8wQnuu3RZDiCQc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 02, 2014 at 03:15:36PM +0100, Morten Rasmussen wrote:
> >=20
> > Talk to me about this core vs cluster thing.
> >=20
> > Why would an architecture have multiple energy domains like this?

> The reason is that power domains are often organized in a hierarchy
> where you may be able to power down just a cpu or the entire cluster
> along with cluster wide shared resources. This is quite typical for ARM
> systems. Frequency domains (P-states) typically cover the same hardware
> as one of the power domain levels. That is, there might be several
> smaller power domains sharing the same frequency (P-state) or there
> might be a power domain spanning multiple frequency domains.
>=20
> The main reason why we need to worry about all this is that it typically
> cost a lot more energy to use the first cpu in a cluster since you
> also need to power up all the shared hardware resources than the energy
> cost of waking and using additional cpus in the same cluster.
>=20
> IMHO, the most natural way to model the energy is therefore something
> like:
>=20
>     energy =3D energy_cluster + n * energy_cpu
>=20
> Where 'n' is the number of cpus powered up and energy_cluster is the
> cost paid as soon as any cpu in the cluster is powered up.

OK, that makes sense, thanks! Maybe expand the doc/changelogs with this
because it wasn't immediately clear to me.

> > Also, in general, why would we need to walk the domain tree all the way
> > up, typically I would expect to stop walking once we've covered the two
> > cpu's we're interested in, because above that nothing changes.
>=20
> True. In some cases we don't have to go all the way up. There is a
> condition in energy_diff_load() that bails out if the energy doesn't
> change further up the hierarchy. There might be scope for improving that
> condition though.
>=20
> We can basically stop going up if the utilization of the domain is
> unchanged by the change we want to do. For example, we can ignore the
> next level above if a third cpu is keeping the domain up all the time
> anyway. In the 100% + 50% case above, putting another 50% task on the
> 50% cpu wouldn't affect the cluster according the proposed model, so it
> can be ignored. However, if we did the same on any of the two cpus in
> the 50% + 25% example we affect the cluster utilization and have to do
> the cluster level maths.
>=20
> So we do sometimes have to go all the way up even if we are balancing
> two sibling cpus to determine the energy implications. At least if we
> want an energy score like energy_diff_load() produces. However, we might
> be able to take some other shortcuts if we are balancing load between
> two specific cpus (not wakeup/fork/exec balancing) as you point out. But
> there are cases where we need to continue up until the domain
> utilization is unchanged.

Right.. so my worry with this is scalability. We typically want to avoid
having to scan the entire machine, even for power aware balancing.

That said, I don't think we have a 'sane' model for really big hardware
(yet). Intel still hasn't really said anything much on that iirc, as
long as a single core is up, all the memory controllers in the numa
fabric need to be awake, not to mention to cost of keeping the dram
alive.



--eY8wQnuu3RZDiCQc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjbR5AAoJEHZH4aRLwOS6QSwQALNgTrH6huE3jcV6ZlBUQmAw
M1A8e+wbrppB2yT0QhaLq+152NacPBy1KizmR+ooXuqzd+iL6xkOWuheyqhTNYxy
Lmcr2X+qOtrM48v5aWOdUC2gPfOV5PoH7QI3ywCYuojL5Gjee+cfTxYzuiOL2+eB
vmqzjKOBXrwb+Jd8u0Rz1HhkMylGwkNtF9rbCx0gAf1pJHb4Z69OHwpktzozk0Aj
oHUqPhCnp5gjZXDZll/bCwuolbeh5qJEYt9dN5rIhI7ES2iZylugOy9kbglE0//c
5mjCIwa2HE05FGt7un2Ja2uNtjCa2VJDdoPyvCTBuVVKzOjKqF3TC+61Po8NbU2v
w8PLsp6CeoM4alBc96Og1iyb6k6JyLSM4fqopijU9vb+VwIvrQCe/2Ur0SGxsIYN
il2vJszuIOe4SzLWraNehyiV1yWCyOGFP6Y4AlWLcX0BIcPa8M8OKEszzszBT5MM
lP7ZrI+wb/y62+kM/hBb0CuiZTOVdjFVxAc7PBTw0HRPDqhxTflycYbE2IjoqXzd
Br3HfkzpZsce3ChBKpgubVIj+t5erLPoYuFG3CuXw0FihJJhs1wf/kLNel50aTA9
EwDA5rTF3W5F5pDcEXK8SKd3wsq7dOskXNew/8An+CAfebSlBdyqSI1Xf5m41PEi
e9Cqtsyf94nCuuqEePBo
=FsMK
-----END PGP SIGNATURE-----

--eY8wQnuu3RZDiCQc--
