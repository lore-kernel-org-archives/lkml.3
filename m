Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbaEHQNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:13:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:44571 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbaEHQNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:13:40 -0400
Date: Thu, 8 May 2014 18:13:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: minyard@acm.org
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH] sched: Initialize rq->age_stamp on processor start
Message-ID: <20140508161337.GF30445@twins.programming.kicks-ass.net>
References: <1399405857-14056-1-git-send-email-minyard@acm.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yKmnPmKxJBqIz68t"
Content-Disposition: inline
In-Reply-To: <1399405857-14056-1-git-send-email-minyard@acm.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yKmnPmKxJBqIz68t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 06, 2014 at 02:50:57PM -0500, minyard@acm.org wrote:
> From: Corey Minyard <cminyard@mvista.com>
>=20
> If the sched_clock time starts at a large value, the kernel will spin
> in sched_avg_update for a long time while rq->age_stamp catches up
> with rq->clock.
>=20
> The comment in kernel/sched/clock.c says that there is no strict promise
> that it starts at zero.  So initialize rq->age_stamp when a cpu starts up
> to avoid this.
>=20
> I was seeing long delays on a simulator that didn't start the clock at
> zero.  This might also be an issue on reboots on processors that don't
> re-initialize the timer to zero on reset, and when using kexec.
>=20
> Signed-off-by: Corey Minyard <cminyard@mvista.com>

This patch made my cris-defconfig build fail.

--yKmnPmKxJBqIz68t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTa60wAAoJEHZH4aRLwOS6YxIP/3EmOvvP1+1mNNhOl4wIU/n/
t7E9ztjkqEu2qiJ4XN9MaI/bDJmmYDIKPkFK6CEY4FnfYkZsY6c8CYnr5CYX0Wu1
maCrZXNstkYr0LQvXw+nH8ZqzabKtyFAUcTB0m3Pc+ouIyNeis+cWHPSQmNHv97O
B6clDgRV8v2LdyY4fcewgHj2RJPeoRopf45htb2Ks1Xig0yGJldhDi6dxWX2LYLU
bteRmZrFUnNEhUa8gnIA0vQghJ1zTosR0ZAg+SY+iafpnVdemCPPQ2V5vztfFxLW
ixC+U+UWc+8iw+fYcCfsob0X7XeA4FYMk7PT6+XMC0cTSIf+W/OpdXA2qrOuaMg8
tvMSVAoI+OR8b3YBsBMOH38/uBxRTFHuuLfF6rE/Ne9DmskVC7E1wdMi2mBSfGX3
s3/Uk/sbO4FZqjEVBWZT9e3ybcDtZoEam0NbMyyg/0uyVrrIdk6QLIGgtfAOZaXJ
jxsFfUwc//x0MhkzLXA0AYKL5sjnMQq3ODNCpaKLJXAo5tkMbAQn9SKV5JYee9K0
TEGOOyL1Hyu/eUQsHIpGvF6KfaOjEnu9OZB4zey78C3Qf7BKJPBd/CRq+rFE7TrG
Fhw0pde9qATNJXd+aoOrt495rO4nuUZMpJvLwNkn6bc0g4PthRnhSMlEjpR7eUST
9QkJOkLHG4kv/1FGX+E+
=1Wrk
-----END PGP SIGNATURE-----

--yKmnPmKxJBqIz68t--
