Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaFYFMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:12:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43926 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaFYFMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:12:48 -0400
Date: Wed, 25 Jun 2014 07:12:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH 2/6] irq_work: Implement remote queueing
Message-ID: <20140625051234.GD6758@twins.programming.kicks-ass.net>
References: <1402413309-3415-1-git-send-email-fweisbec@gmail.com>
 <1402413309-3415-3-git-send-email-fweisbec@gmail.com>
 <53A9E0A5.5040402@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yHgig3XI5r20tkjN"
Content-Disposition: inline
In-Reply-To: <53A9E0A5.5040402@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yHgig3XI5r20tkjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2014 at 02:33:41PM -0600, Stephen Warren wrote:
> On 06/10/2014 09:15 AM, Frederic Weisbecker wrote:
> > irq work currently only supports local callbacks. However its code
> > is mostly ready to run remote callbacks and we have some potential user.
> >=20
> > The full nohz subsystem currently open codes its own remote irq work
> > on top of the scheduler ipi when it wants a CPU to reevaluate its next
> > tick. However this ad hoc solution bloats the scheduler IPI.
> >=20
> > Lets just extend the irq work subsystem to support remote queuing on top
> > of the generic SMP IPI to handle this kind of user. This shouldn't add
> > noticeable overhead.
>=20
> I'm running next-20140624 on an ARM system, and this patch causes CPU
> hot(un)plug to Oops for me; the following fires:
>=20
> void irq_work_run(void)
> {
> 	BUG_ON(!in_irq());
>=20
> I found that Linus's master (8b8f5d971584 "Merge tag 'compress-3.16-rc3'
> of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core")
> works fine. I found that this commit inside the tip(?) tree works fine
> (478850160636 "irq_work: Implement remote queueing"). However, if I
> merge the two together, I hit that BUG_ON.
>=20
> I think the issue is:
>=20
> This commit adds a call from
> generic_smp_call_function_single_interrupt() to irq_work_run().
>=20
> Srivatsa's patch adds a call from hotplug_cfd() to
> flush_smp_call_function_queue() to, which I imagine happens in
> non-interrupt context. Note that this patch moves most of the body of
> generic_smp_call_function_single_interrupt() into
> flush_smp_call_function_queue().

Right you are.. I think I'll just remove the BUG_ON(), Frederic?

--yHgig3XI5r20tkjN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTqlpCAAoJEHZH4aRLwOS6AmUP/iSldcTeGrqUOOgoc790ZxB5
O+lhuOkXPnwBjAcSyq7cw5l8Fh9WsIzwFWcJLyUp+c3O9eFSjwbFRG/lZQ9mPCGl
deTtT2rGDT2W75UkpEGsrZRkkCRTCA1cUXcdiOmchi68oHB2GxUT6pas3U5QRtRC
FH+fx2GDqCaejmvNMfriOPJ5ByDnH9tQxTnkZcrmbIWJShU8qNA6E1nfwe75VYZG
TOUCeMVvAZF0OmDTfksvnYuM4gLOEo/idZeYbh0SC0HUsIegnPhOQyskfLmew/+T
x4IZJgvWf2vV2eHF28FcMvtIxO9mqVMmv68ajxu94iJAdNKzEplxhQf3HaZCU0bZ
JVEITW/mVyM9J50ajjKq/AJM4xBJtZGZoJTYUHGat5pth6ttNmf+t1qC/2Rlh6qC
xu+4jOk2a2OKSXgR9qODoesOIOYTY94Kg2CbNvyn9WsSyywnzgsg2WEOWMJDlzyS
Cm0GgPTlOJoQejL/YX00CG/ftKSnttwmaimdNpp07Mh4SKC4FL574Njx/W8JOwzh
fCzv0FO2mutJ6Yjjy6f3cvcujiyRtXL6O1n3xYnt0/Mh//rq74B4g0Q8jBLui/9l
VpRLZQZhjGMTRvr66xISlpR/aVQk5fFn8OEeRpng42C4DUobCzmaPGJ6H3fo7+hw
TZIyLPsOSrU5AKleTr2F
=BfeC
-----END PGP SIGNATURE-----

--yHgig3XI5r20tkjN--
