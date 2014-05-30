Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaE3Oqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:46:52 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59241 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162AbaE3Oqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:46:51 -0400
Date: Fri, 30 May 2014 16:46:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 04/11] sched: Allow all archs to set the power_orig
Message-ID: <20140530144635.GE30445@twins.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-5-git-send-email-vincent.guittot@linaro.org>
 <53888FF0.4020403@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FUBn+A0X9P+7IcSo"
Content-Disposition: inline
In-Reply-To: <53888FF0.4020403@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FUBn+A0X9P+7IcSo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2014 at 03:04:32PM +0100, Dietmar Eggemann wrote:
> On 23/05/14 16:52, Vincent Guittot wrote:
> > power_orig is only changed for system with a SMT sched_domain level in =
order to
> > reflect the lower capacity of CPUs. Heterogenous system also have to re=
flect an
> > original capacity that is different from the default value.
> >=20
> > Create a more generic function arch_scale_cpu_power that can be also us=
ed by
> > non SMT platform to set power_orig.
> >=20
> > The weak behavior of arch_scale_cpu_power is the previous SMT one in or=
der to
> > keep backward compatibility in the use of power_orig.
> >=20
> > Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>=20
> As you know, besides uarch scaled cpu power for HMP, freq scaled cpu
> power is important for energy-aware scheduling to achieve freq scale
> invariance for task load.
>=20
> I know that your patch-set is not about introducing freq scaled cpu
> power, but we were discussing how this can be achieved w/ your patch-set
> in place, so maybe you can share your opinion regarding the easiest way
> to achieve freq scale invariance with us?
>=20
> (1) We assume that the current way (update_cpu_power() calls
> arch_scale_freq_power() to get the avg power(freq) over the time period
> since the last call to arch_scale_freq_power()) is suitable
> for us. Do you have another opinion here?
>=20
> (2) Is the current layout of update_cpu_power() adequate for this, where
> we scale power_orig related to freq and then related to rt/(irq):
>=20
>   power_orig =3D scale_cpu(SCHED_POWER_SCALE)
>   power =3D scale_rt(scale_freq(power_orig))
>=20
> or do we need an extra power_freq data member on the rq and do:
>=20
>   power_orig =3D scale_cpu(SCHED_POWER_SCALE)
>   power_freq =3D scale_freq(power_orig))
>   power =3D scale_rt(power_orig))
>=20
> In other words, do we consider rt/(irq) pressure when calculating freq
> scale invariant task load or not?

I don't think you should. The work done depends on the frequency, not on
other tasks present on the cpu. The same is true for an over-utilized
cpu, a task will run less than the desired amount of time, this is no
different from a RT/irq preempting the task and taking its time.

--FUBn+A0X9P+7IcSo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTiJnHAAoJEHZH4aRLwOS6fGMP/34qNHFYeKs5A/VRq6Syo7KZ
FyUJHXPO6PjROwAiLzTTQLJOXXy61cUjr0jjogpqqEWpHcGmijDFMeA0bI4Z/mWQ
zib6QLxOabp14lChPrvBpQTK/sKdwiLvQcGMfw1n1paYs1ikfgu1FP7C6nE5L7dB
xnN7WvctvfHDLR6ynityZp4rwi7nHVni2L83PFORPo+MEEIdAxeSjm7B3lt9he8t
hMAytyM7ux/KXAvwbAfRYCxo+ewaxUi2tNkSalhXsscIUyrIiYCPjJT0FxRXpKV+
ZKjLIZlO9y5gU50YlCn1u6U3ZriST3kpo1AIdS2NV5O72/YWBXYmCxFQQAfxi9FV
KM3HXhPiD3q/jDc4ixfbyspyXnFItXn4CGeHGNZixwG9+9dXbM3KCLUM2/g/WOcH
OQexPTQRrS2XKyeDf1rHhEfJkzwn9eqMgsf+Lw9PVeDsrWYS20SsljmW/PgvcbS0
P0yljycKihrAUJWmddh+5etBuVftN+JQzDrhD56aie20KdoloGiqtHvXH7maHr2X
hC6low1Co1hn02bQ9/6GEkVmLHjMBJICP+kUtzVGCONBeVzPBJWOks46GxoUr65z
mEFGhQdypJ3WD2IhUNtIQFrHciBK1vplhpBfGXbQp+WBcCQ630l2iwBxcAbkLCZv
0mxUAINyhMEux5PP5uF/
=7c+Z
-----END PGP SIGNATURE-----

--FUBn+A0X9P+7IcSo--
