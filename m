Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaHMOoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:44:19 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55025 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbaHMOoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:44:14 -0400
Date: Wed, 13 Aug 2014 16:43:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: Re: [PATCH v5 tip/core/rcu 15/16] rcu: Make RCU-tasks wait for idle
 tasks
Message-ID: <20140813144342.GR9918@twins.programming.kicks-ass.net>
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-15-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140813081215.GB9918@twins.programming.kicks-ass.net>
 <20140813124818.GQ4752@linux.vnet.ibm.com>
 <20140813134025.GN9918@twins.programming.kicks-ass.net>
 <20140813095132.56d288f2@gandalf.local.home>
 <20140813140705.GO9918@twins.programming.kicks-ass.net>
 <20140813101301.08019895@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tXjKu8zC63dF7Z1t"
Content-Disposition: inline
In-Reply-To: <20140813101301.08019895@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tXjKu8zC63dF7Z1t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 10:13:01AM -0400, Steven Rostedt wrote:
> On Wed, 13 Aug 2014 16:07:05 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> > On Wed, Aug 13, 2014 at 09:51:32AM -0400, Steven Rostedt wrote:
> >=20
> > > I still need to look at the patches, but if this is just for the idle
> > > case, then we don't need it. The idle case can be solved with a simple
> > > sched_on_each_cpu(). I need a way to solve waiting for processes to
> > > finish from a preemption point.
> > >=20
> > > That's all I want, and if we can remove the "idle" case and document =
it
> > > well that it's not covered and a sched_on_each_cpu() may be needed,
> > > then I'm fine with that.
> > >=20
> > > 	sched_on_each_cpu(dummy_op);
> > > 	call_rcu_tasks(free_tramp);
> >=20
> > Sure, but why not dtrt and push rcu_idle hooks all the way down into the
> > idle drivers if and where appropriate?
> >=20
> > There isn't _that_ much idle driver code. Also, some stuff should be
> > cleaned up; we're already calling stop_critical_timings() in the generic
> > idle code, and then calling it again in the cpuidle drivers.
> >=20
> >=20
>=20
> True, perhaps the rcu code should hook into the stop_critical_timings
> code?

Not sure; the current proposal would have rcu_idle code be far narrower
than the critical_timings thing, not sure if that's an accident or
desired.

If they have similar requirements we could indeed merge them.

--tXjKu8zC63dF7Z1t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT63meAAoJEHZH4aRLwOS6smgP/3Z21aUJSyOxfcVA+64XWEvx
Dy7mBk3KCyrbVBtLEGuwXwck6c853QMKk6Yb8Y8o+zvCOABS4bPMVXAcEOEcuQTj
ZNv355vVq+sc62XtRqsTX3sfEZHp+XkWrYgCAT1vbRdvIr5NqqzBvVcRB3s+ctXZ
xldsCoJUxRFCceS6qReoqzFbcvmoX8mV/MYv56Qvueg3FcS3Ly+bIeU3elGrt20T
qdGPGXqn0ZqaWF6UgEKpX3A4CxthkxO+EroAGFoTPh2mUWQIVjBeZ5IbQu+EDQIq
99IjMde18HS5XhioO2K3DKrll3E3j4Rv4QNQMn6hEXzHiyyzlRFartynb8dm4Lii
gFPjO5ybFnOc+O/7hq4I4p7a4ygOCkGn2qiVe2rsqWQ4HlgdngYk0c8BtRGatpJ2
P7NC/L+izo+Ag0uThSDDyjQFHd4yx+a8aZc0qxj0evfKourqoIkk9xM9SjD73Giu
XE8PofcVGcM21w0IeSIfNE6MoFFEAffa1sUfQ9OnG0ULjSqu95g/GDBf2GeYhZAU
7X5sMD/tA4TKwH9zistvAGWuvh8I/uXcC4UVAOC1PSk636iG+GDMbZmIDxTPFgbD
xSF5mt/9bwhdq9qwDNGf8CxB2VoS0W07pSxdfT+xRBsItCVEyRcu9oCZp0eReKWJ
AwKKBKIOuVC0N6wypq42
=xmb7
-----END PGP SIGNATURE-----

--tXjKu8zC63dF7Z1t--
