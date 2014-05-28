Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaE1K7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:59:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:42217 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaE1K7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:59:06 -0400
Date: Wed, 28 May 2014 12:58:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org
Subject: Re: [PATCH v2 09/11] sched: test the cpu's capacity in wake affine
Message-ID: <20140528105855.GR30445@twins.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-10-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iXtk48AVKREFnTks"
Content-Disposition: inline
In-Reply-To: <1400860385-14555-10-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iXtk48AVKREFnTks
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 05:53:03PM +0200, Vincent Guittot wrote:
> Currently the task always wakes affine on this_cpu if the latter is idle.
> Before waking up the task on this_cpu, we check that this_cpu capacity is=
 not
> significantly reduced because of RT tasks or irq activity.
>=20
> Use case where the number of irq and the time spent under irq is important
> will take benefit of this because the task that is woken up by irq or sof=
tirq
> will not use the same CPU than irq (and softirq) but a idle one which sha=
re
> its LLC.

OK, so I'm having a terrible time parsing the above.

So looking at the patch you make balance false even when this_load=3D=3D0
when the effective power/capacity (nico's patches haven't fully sunk in
yet) of this cpu is less than that of the previous cpu.

Is that right?

Now I'm only struggling to understand the rationale for this, its got
LLC in there somewhere, but I'm failing to comprehend.

--iXtk48AVKREFnTks
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThcFvAAoJEHZH4aRLwOS6kTcP+gPsGimv0pTcXcRX2FfYdWiq
xIMgJWKEjt8yy8DdDvVJVTKuW46u85oUJBXZ2bWbIK0mQyOKCzWYHheR2JP/RauA
8v3OZU8deAkqXDvUqwkKawrScM5+8X+js+EptNLf2TXMxfh01jUQKC7Fbjzd3wNc
opzLXRu5FKePLYOK3mUEf+U0H5D9IbkePV6Oe4M7Zp1cdfY4donyZBHzMF3BIyg6
JzPDpIVBkSjddJ+3yL+zrD6uuqAJ+Ffy9pn47UWfKuuP83s3OysQ5NU9e8OAv7RX
rP9yO1InQ7V5Da/IT5jUGctNjP3rrUQfeQiTeSCHVZW5E3Thq2iykT0+UHAVgl6f
ZTg9iQMkfv7GwUEs1VHKos9aJfu1mLQypK+n7piHmDx1fTQnHsi6Amd7rr+IlOPD
cqbqdo5+KwQAazI2lBqEvYSc0avL2Z1vYGD1YffORoa/3VFo+c3TP+d0XDhbiWzt
mnFWK0dMpSufE/4CtmTnw9hR4Zp7sjBJZxghIW4cpWuRjKe6dpnS75k7sOUtI/T5
/Ldc7oXnHLM+r6zBlU3eIyJsbz5Mrk5g/fWK1l1Sa60ctcr6NUBy8pqOqfonKjod
z6HpOXBCSQthb18rtmz9M0GKFpC3/MuNGmy5YuN1n+5ZjfA+0S2QEzH81ir6++yN
Vyeo69KhpuU/EaDnqiVr
=MgS0
-----END PGP SIGNATURE-----

--iXtk48AVKREFnTks--
