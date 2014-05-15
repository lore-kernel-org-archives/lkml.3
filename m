Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaEOH3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:29:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:56236 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaEOH3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:29:36 -0400
Date: Thu, 15 May 2014 09:29:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 6/6] sched: final power vs capacity cleanup
Message-ID: <20140515072929.GZ30445@twins.programming.kicks-ass.net>
References: <1400101030-17717-1-git-send-email-nicolas.pitre@linaro.org>
 <1400101030-17717-7-git-send-email-nicolas.pitre@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8RzCspYsRAU9V6Ra"
Content-Disposition: inline
In-Reply-To: <1400101030-17717-7-git-send-email-nicolas.pitre@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8RzCspYsRAU9V6Ra
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 04:57:10PM -0400, Nicolas Pitre wrote:
> It is better not to think about compute capacity as being equivalent to
> "CPU power".  The upcoming "power aware" scheduler may create confusion
> with the notion of energy consumption if "power" is used too liberally.
>=20
> This contains the architecture visible changes.  Incidentally, only ARM
> takes advantage of the available pow^H^H^Hcapacity scaling hooks and
> therefore those changes outside kernel/sched/ are confined to one ARM
> specific file.  The default arch_scale_smt_power() hook is not overridden
> by anyone.
>=20
> Replacements are as follows:
>=20
> 	arch_scale_freq_power  --> arch_scale_freq_capacity
> 	arch_scale_smt_power   --> arch_scale_smt_capacity
> 	SCHED_POWER_SCALE      --> SCHED_CAPA_SCALE
> 	SCHED_POWER_SHIFT      --> SCHED_POWER_SHIFT

The patch seems to actually make that CAPA_SHIFT

> The local usage of "power" in arch/arm/kernel/topology.c is also changed
> to "capacity" as appropriate.

For some reason every time I read: 'capa' I think of some south American
monster -- http://en.wikipedia.org/wiki/Chupacabra, I'm not at all sure
why my brain links them.

But yes, once we kill the capacity stuff we have now with some
utilization bound, capacity becomes uniquely the compute capacity.

--8RzCspYsRAU9V6Ra
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdGzZAAoJEHZH4aRLwOS6vcoP/3E9bgNQvO9PCXRU51HSQ29N
m1UvdN1h3+ijLbB0ot0ZrKQ4eFC1bu0Jjkeyq4bFn6Dayda2VVhn/YrIYOqRofiN
z9VXGM3vboHESfVFBsVrY3esXepMbM/wLXuXQIGQU8tNhX3jKiqV82zMA/105VkD
kg+fkuCL/X5q9VeFOD+fmLBV7xuOPDZCZOm0a8+MR+yuony+Q4cpQu0a/gmp/CdV
PDWqEJ4vmuH5eU5l4AIpwtFbqc7p9aTIopMAXsjhByqOWK0714c+GbaXkJb/EwBR
4FtSlYf9fyQ/7wJluNVz6rAKAQIZd6jRWExOWyc/bGOTe8mduBoLRtcuZudGdAzn
+lhI6sYHGPZJiMGX0quY1uvHlG7YT4APexVLCXlwim8OtNfpzaOpOb8k75Xh+Dry
lvr4QN60KAOwkHKn2UocBfbKzRTrY8fpnD69gtOLMYW3NDDUzfS27GH4L4X0FReJ
sWxDxObyGqIjcYzUAio15VR1IeBZsu1/mi4OA2E9esJZrkHqMAtmKgvmj1m7KtYy
66wpGlvmCncAJcvXrm37IDjIR9P/V7eFEmsPB7ts4EJDDWuzbovaB7J2itsx0UgS
E84puvKuMbS7Tbdn13WCNEb9YOTE50YeVNbWIO2IENvlaGUzDsZKQ+VPFb5kHboV
BzocK5BpO6OM909um6Tn
=Qcwq
-----END PGP SIGNATURE-----

--8RzCspYsRAU9V6Ra--
