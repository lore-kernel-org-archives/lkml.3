Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaHMIMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:12:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:43152 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbaHMIM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:12:29 -0400
Date: Wed, 13 Aug 2014 10:12:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v5 tip/core/rcu 15/16] rcu: Make RCU-tasks wait for idle
 tasks
Message-ID: <20140813081215.GB9918@twins.programming.kicks-ass.net>
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-15-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aObkNgyNMtBQZ80/"
Content-Disposition: inline
In-Reply-To: <1407797345-28227-15-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aObkNgyNMtBQZ80/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 11, 2014 at 03:49:04PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>=20
> Because idle-task code may need to be patched, RCU-tasks need to wait
> for idle tasks to schedule.  This commit therefore detects this case
> via context switch.  Block CPU hotplug during this time to avoid sending
> IPIs to offline CPUs.
>=20
> Note that checking for changes in the dyntick-idle counters is tempting,
> but wrong.  The reason that it is wrong is that a interrupt or NMI can
> increment these counters without necessarily allowing the idle tasks to
> make any forward progress.

I'm going to NAK this.. with that rcu_idle patch I send there's
typically only a single idle function thats out of bounds and if its
more it can be made that with a bit of tlc to the cpuidle driver in
question.

This needs _FAR_ more justification than a maybe and a want.

--aObkNgyNMtBQZ80/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6x3fAAoJEHZH4aRLwOS6YH4QAJXyxCbJY+mYDmTj/v6pFWKI
5syBZ0kG/fqCGw5ZAlwUYCcb2dlGmU9K2p52bwtX8RdTbKvA5qWdxhhs0oFoqWc4
DPo8fiP9MDeKMIDzPrx5YdmYORcSpC1LM/2CgBIaOLaJUn/49Cd4S+CHsqDJvT4o
EqzgV7ROKijSmG+rKb1imdJynlH5fWCgyemyBIiGou0OLKh4zPB7TwiPBaYjmvbT
dVWy5YXPJjSBHpWLJoKj/Gmv7dCoNoi5CBH0pawSHlNcvBhrdJgL5C3unXMW6r1o
jppzZQkBhW0/9HWMa7DYlZfiIzCukHsEJznqr5BtUkVwDuAVQ7XookXYkEkjY4BC
U8IBvGe39jYisGOHOcVgie4JqEhPB8W0H0dx6B6LNjX/yeRl0PyNBKb6CJvOKTz0
fz3Be2OjcdwnGWZFinRN3qKGxfZFNKsNC/zUM/JkGwoTlf0iuHhWIQinM47eX9B9
k8VdeXvg5TejXRBYcOClZ73MUWb0GtlkBD6oDCwIBjvcuGnIYM29lJyAGQcym35i
mffrKRLJDDhm2XF8VRglsoCWOI5lbXlzvYjDbnoVrFdb+WF08ie+cCpW9B+sfGWZ
Jcw+B7XiQbw9wAahd72OZXY9I2AplYHR0xP+hyiMUCPGBz3ssnLNSS4mPI6ijKik
QqLR5H7hBZV5kEvrg+GC
=zxKp
-----END PGP SIGNATURE-----

--aObkNgyNMtBQZ80/--
