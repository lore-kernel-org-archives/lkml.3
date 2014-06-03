Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbaFCLQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:16:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57397 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbaFCLQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:16:01 -0400
Date: Tue, 3 Jun 2014 13:15:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 10/11] sched: move cfs task on a CPU with higher
 capacity
Message-ID: <20140603111532.GW11096@twins.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-11-git-send-email-vincent.guittot@linaro.org>
 <20140529095024.GF11074@laptop.programming.kicks-ass.net>
 <CAKfTPtCHhxyugMOCeS0hZoEXWhgRec4uOBexZ2aB2A+Eycgi8w@mail.gmail.com>
 <20140530062937.GA11096@twins.programming.kicks-ass.net>
 <CAKfTPtBXddNFXDuL5YNNtcW7e1Un=LqHU8bgaejJwPObSGoBhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rDr66iUNdD59gODe"
Content-Disposition: inline
In-Reply-To: <CAKfTPtBXddNFXDuL5YNNtcW7e1Un=LqHU8bgaejJwPObSGoBhg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rDr66iUNdD59gODe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 02, 2014 at 07:06:44PM +0200, Vincent Guittot wrote:
> > Could you detail those conditions? FWIW those make excellent Changelog
> > material.
>=20
> I have looked back into my tests and traces:
>=20
> In a 1st test, the capacity of the CPU was still above half default
> value (power=3D538) unlike what i remembered. So it's some what "normal"
> to keep the task on CPU0 which also handles IRQ because sg_capacity
> still returns 1.

OK, so I suspect that once we move to utilization based capacity stuff
we'll do the migration IF the task indeed requires more cpu than can be
provided by the reduced, one, right?

> In a 2nd test,the main task runs (most of the time) on CPU0 whereas
> the max power of the latter is only 623 and the cpu_power goes below
> 512 (power=3D330) during the use case. So the sg_capacity of CPU0 is
> null but the main task still stays on CPU0.
> The use case (scp transfer) is made of a long running task (ssh) and a
> periodic short task (scp). ssh runs on CPU0 and scp runs each 6ms on
> CPU1. The newly idle load balance on CPU1 doesn't pull the long
> running task although sg_capacity is null because of
> sd->nr_balance_failed is never incremented and load_balance doesn't
> trig an active load_balance. When an idle balance occurs in the middle
> of the newly idle balance, the ssh long task migrates on CPU1 but as
> soon as it sleeps and wakes up, it goes back on CPU0 because of the
> wake affine which migrates it back on CPU0 (issue solved by patch 09).

OK, so there's two problems here, right?
 1) we don't migrate away from cpu0
 2) if we do, we get pulled back.

And patch 9 solves 2, so maybe enhance its changelog to mention this
slightly more explicit.

Which leaves us with 1.. interesting problem. I'm just not sure
endlessly kicking a low capacity cpu is the right fix for that.



--rDr66iUNdD59gODe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTja5UAAoJEHZH4aRLwOS6xLoP/1c+kA0yqL8iIMtlXMDUxjpG
MyuQgE7FWwYg39V2ALyzyAv8c75KjJSSRGQJMLxAI/BMAtjlZMLkKAPaLYVDkut4
9vBtAorL18JNQlCEApkPOvVmlPy/CS++Xlvv2Pcm7XdlXyTz/MccxB8xVtucvALh
rLaBPfE7s6agy6j0q608PK7wC1BhQOpvT7y/HN66aNGiktqy+/aGJydXC/+r9AXn
xrxA/ZvmfSw/4+SBh1uDEsF9Aeui3K87+e3TwV7ovD/ybeQSqowI0hVZ+KbADq2A
8G95ZA6NYkylTPggJ66zZZqsq/WTzYyW6XvGn/zCf2SYfvGciMnDOS1GKpLyFLfJ
PdBpXDupQAQ02bhj2qx3GWoA2MvoaCHiY/vu9UhySFTg70UKMY3TVf9O8yNYnQ8g
kfS8puX021V2LS0FtcgfRc2xTA1FcQP9Y5KDUsGBohSHuSLI6G0IWSnq/OrPHYK2
/XhiZ4gED1TKAiUzo9YQIWLyPbmqJOnd6UVI128CrroYSz6twXW3QY9OAHXJ3cUz
kAnC+DyztKilUsMD+rhCTEHt/+dP2mxox8hcD9PaSUqREVxk/rym+VMz1onWJVQF
1xqheRp6iNKxVLFHV9sxmD12NrFX4mI94Xktpa/oyRcWuK4wMm2nhgyhIrLwLSj3
E+PDomMx/sg9p6Mn520Y
=o/yo
-----END PGP SIGNATURE-----

--rDr66iUNdD59gODe--
