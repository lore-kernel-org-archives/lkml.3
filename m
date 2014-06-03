Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbaFCMMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:12:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:41228 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491AbaFCMMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:12:53 -0400
Date: Tue, 3 Jun 2014 14:12:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, arjan.van.de.ven@intel.com,
        len.brown@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        pjt@google.com, bsegall@google.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, rajeev.d.muralidhar@intel.com,
        vishwesh.m.rudramuni@intel.com, nicole.chalhoub@intel.com,
        ajaya.durg@intel.com, harinarayanan.seshadri@intel.com,
        jacob.jun.pan@linux.intel.com, fengguang.wu@intel.com
Subject: Re: [RFC PATCH 03/16 v3] How CC accrues with run queue change and
 time
Message-ID: <20140603121242.GG30445@twins.programming.kicks-ass.net>
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
 <1401431772-14320-4-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MiYnpxbAAMzII6w/"
Content-Disposition: inline
In-Reply-To: <1401431772-14320-4-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MiYnpxbAAMzII6w/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2014 at 02:35:59PM +0800, Yuyang Du wrote:
> It is natural to use task concurrency (running tasks in the rq) as load
> indicator. We calculate CC for task concurrency by two steps:
>=20
> 1) Divide continuous time into periods of time, and average task concurre=
ncy
> in period, for tolerating the transient bursts:
>=20
> a =3D sum(concurrency * time) / period
>=20
> 2) Exponentially decay past periods, and synthesize them all, for hystere=
sis
> to load drops or resilience to load rises (let f be decaying factor, and =
a_x
> the xth period average since period 0):
>=20
> s =3D a_n + f^1 * a_n-1 + f^2 * a_n-2 +, ..., + f^(n-1) * a_1 + f^n * a_0
>=20
> To sum up, CPU CC is 1) decayed average run queue length, or 2) run-queue=
-lengh-
> weighted CPU utilization.

why!? what benefit does it have over utilization.

Also, not a mention of dvfs or how that would impact things.

> Signed-off-by: Yuyang Du <yuyang.du@intel.com>
> ---
>  kernel/sched/fair.c |  255 +++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 255 insertions(+)

And not a single word on why you cannot use the existing per-task
accounting infrastructure and not a single attempt to merge the two.



--MiYnpxbAAMzII6w/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjbu6AAoJEHZH4aRLwOS6zXIQAK1J5cxTiJJb+Gvqo1Sdrzzr
HDGYRXiL7oiuQ1ndt0NgFLQK2MqWeJV4vyUJVSTonnlx5syPIqou26cSb9mcTYUL
T2i4WvwU7IYvH3AfliNHDROIKN7CeCc8cr7xfMwyAhG0mHbS4z+DtXz0PAUUQuwl
ZKWKfSRNAoIn/06am5mrWnmEB9RjTol5VJWao8lmc4BXdKqdWeAbGLWSv0yxW6FF
pTcQW/U+G5djlSgspbHWFIeNShLMigHeCuAw6XYM2svRrYF+HvwcqN8mBY0rHO8N
WM3CfnuAIs0uNzw4T2je+VfbVbo4aFG/UnBPfAxbTGagtItL/WehwEmBOb284Hrw
oEaaOeh/wGcVl99fR7hPWCobKinHkeeGorVpJhvm0ld6RMoqvYl/OKChwvh+nRFr
KYGhmeX3fEMLeZCMCJyqlabRQ7vGWcdEcPeVTj3qfnI1yrxcmWYHkBFkhz7exPV0
YpZjRvCgDr+hkjl5+/ShhHgWT23ZIA8/7LvksAY/HR+agCQYdAiZWPnFVG/BNep+
HtUb7LOCd4LR0CYt2ZXPE06lFbmsUGB9RW0QcAIQOS9NwLZ3bvi99x9SDX+hTzeD
MC8SqoaoQ2iWi/YtBXUErXXgSHPRplr0LIORAzkOlTdkj4Q4TT8gyiGv9rXoC4B0
SfJ9axxYrILy315bBdUV
=GLqW
-----END PGP SIGNATURE-----

--MiYnpxbAAMzII6w/--
