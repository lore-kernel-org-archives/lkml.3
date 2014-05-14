Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbaENJJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:09:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:48300 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaENJJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:09:07 -0400
Date: Wed, 14 May 2014 11:09:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/3] nohz: Use IPI implicit full barrier against
 rq->nr_running r/w
Message-ID: <20140514090903.GD30445@twins.programming.kicks-ass.net>
References: <1400019956-25511-1-git-send-email-fweisbec@gmail.com>
 <1400019956-25511-4-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GaDTZZn2ADWB060d"
Content-Disposition: inline
In-Reply-To: <1400019956-25511-4-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GaDTZZn2ADWB060d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 12:25:56AM +0200, Frederic Weisbecker wrote:
> @@ -670,10 +670,11 @@ bool sched_can_stop_tick(void)
> =20
>         rq =3D this_rq();
> =20
> -       /* Make sure rq->nr_running update is visible after the IPI */
> -       smp_rmb();
> -
> -       /* More than one running task need preemption */
> +       /*
> +	* More than one running task need preemption.
> +	* nr_running update is assumed to be visible
> +	* after IPI is sent from wakers.
> +	*/
>         if (rq->nr_running > 1)
>                 return false;

Looks like whitespace damage on that comment's indenting.

--GaDTZZn2ADWB060d
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTczKvAAoJEHZH4aRLwOS6zpUP/jOEN7ZcCRk9jvKs+bc7ZWar
a4G/I7/NtdR0ZYeqGBOAjpmrdVNdWCYbbqQJ87fTghikXNjuMYc7O3rIZO7Dcqpy
HbjE2dO1mNPyc/MB5Cr9xMUDbIsGIp1nSjeQG9YZYMCXmPHdUAg0f7mVPshw/vaJ
Bn1Z96KxFKdVpaPJsGQdcbA3eRCAY0u4Wwf5D73C2SQJGezG8jDzlLijxb+WT8Ok
PqVgAGwaBjVu0z7ASOY8uFZaSrkcDI0Z8SrXCvpxMRLqsvRm4BaUu6DE8R/1B0Ng
aZm/mnYuvxPPwBaBW0sDbG+XTJf7U2OWZhJfdH6/IsFhHvJs5h3nVLQiRIWU2VB1
P267A1pCI4FkA8bdw6B9vdpURxR8P+pttjztwZTjYOfEDGXuzLV7jELK90p9x3Cd
jNJ5sCIWMXHbb2dkpxmhNFpGmNWLupNiniGr0XhPbbe286kcjDx/G9V5dmmd4qKW
iUpp2w5gy43xJrPqVP1Aq4NHF49G1Em/RMlfBXodJ68Fboiht3WXPzMDzNtsxCK6
26K5OfR/oL8AO6xhxSC1O8Gbuo6vuwHf9U92SRXdRhIchcs9Ut0I2DVB4j4igDLR
73hnsN4des2FtDe0ZGChm8vMN9uhDe9LuHoGMN8/cg4b2zFEzjovQ+t8sAzQn78H
wNVl9usICIeQDpTGvUiL
=CvlI
-----END PGP SIGNATURE-----

--GaDTZZn2ADWB060d--
