Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaHMOHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:07:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:44679 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbaHMOHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:07:18 -0400
Date: Wed, 13 Aug 2014 16:07:05 +0200
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
Message-ID: <20140813140705.GO9918@twins.programming.kicks-ass.net>
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-15-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140813081215.GB9918@twins.programming.kicks-ass.net>
 <20140813124818.GQ4752@linux.vnet.ibm.com>
 <20140813134025.GN9918@twins.programming.kicks-ass.net>
 <20140813095132.56d288f2@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zvbl/8tVKAFcMeVq"
Content-Disposition: inline
In-Reply-To: <20140813095132.56d288f2@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zvbl/8tVKAFcMeVq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 09:51:32AM -0400, Steven Rostedt wrote:

> I still need to look at the patches, but if this is just for the idle
> case, then we don't need it. The idle case can be solved with a simple
> sched_on_each_cpu(). I need a way to solve waiting for processes to
> finish from a preemption point.
>=20
> That's all I want, and if we can remove the "idle" case and document it
> well that it's not covered and a sched_on_each_cpu() may be needed,
> then I'm fine with that.
>=20
> 	sched_on_each_cpu(dummy_op);
> 	call_rcu_tasks(free_tramp);

Sure, but why not dtrt and push rcu_idle hooks all the way down into the
idle drivers if and where appropriate?

There isn't _that_ much idle driver code. Also, some stuff should be
cleaned up; we're already calling stop_critical_timings() in the generic
idle code, and then calling it again in the cpuidle drivers.



--zvbl/8tVKAFcMeVq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT63EJAAoJEHZH4aRLwOS6sTcQAK4N7zGLEdN1WowgESfGdnko
LWBVt9pqWNfRcb2VFtP3lj0eWClUsuVNLQWwLIc2LcWepmy3CE8Bg8hmGTSXNFMR
z3ii0C6TiwX3PzakKseMuE62lK3n5oHLMIZmg92NrPL4BSrutFR1/11kIhN83fpE
GFL3/frC0M28V2Qfe0BQovqmQsA/942A4ABKyGo8FOCk4LoJj+gPzgUtQsgc696t
XLg1zvTsxP7O5qGt7CGJjrdkykwr2troWjVGZOkLYcczLNLVqxChZK7rmT+Sezp1
DfDqfAb0U07HutVYHwE9loTPfnqeAbxEPz5/Cwd5+Y2qsWSHLYFkxHqflVeCgKwP
Zdz0BinHqBl7Wy4qXaTHP7uxERPOLZSUpymdDk/sOQ9wPG+y2O73GmW7EobdrZ1Y
NabQaZHym/BPZyF1jgZP+YRbgNYzVD2a0sv5GFGeI/2LkwRIsgWfn3P97AOfE0ay
4p7ykOERWmae02gtV9Vjy0i3RUjEbrtq+jvzs/EoJ6GzNkAIVUkphf17ZU2jVA/6
WxPU9gZm8LPy3o1LoP1LTuP3Wgu5YV1+geqsqvyFVqGEc2xdpyE/D9So2HM82uGL
s2R+cEmBZzNQRJolcYx9zHLScir+fqmqfc0xKvK6mAWCNvyhZ9//8gMV2ZF0alAn
rIKunSJ9/RGtNK71PLeo
=gzwU
-----END PGP SIGNATURE-----

--zvbl/8tVKAFcMeVq--
