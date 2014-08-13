Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaHMK4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:56:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:43970 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaHMK4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:56:33 -0400
Date: Wed, 13 Aug 2014 12:56:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v5 tip/core/rcu 14/16] rcu: Remove redundant
 preempt_disable() from rcu_note_voluntary_context_switch()
Message-ID: <20140813105618.GI9918@twins.programming.kicks-ass.net>
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-14-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eZF+V2/LE/RsbcQg"
Content-Disposition: inline
In-Reply-To: <1407797345-28227-14-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eZF+V2/LE/RsbcQg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 11, 2014 at 03:49:03PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>=20
> In theory, synchronize_sched() requires a read-side critical section to
> order against.  In practice, preemption can be thought of as being
> disabled across every machine instruction.  So this commit removes
> the redundant preempt_disable() from rcu_note_voluntary_context_switch().

>  #define rcu_note_voluntary_context_switch(t) \
>  	do { \
> -		preempt_disable(); /* Exclude synchronize_sched(); */ \
>  		if (ACCESS_ONCE((t)->rcu_tasks_holdout)) \
>  			ACCESS_ONCE((t)->rcu_tasks_holdout) =3D 0; \
> -		preempt_enable(); \
>  	} while (0)

But that's more than 1 instruction.

--eZF+V2/LE/RsbcQg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT60RSAAoJEHZH4aRLwOS6nzUP/2peiAl/BMbdCsyLACULCQWD
qftZFkci4j3vdwncLFJabQKO58Xl/NemN/xW96pPTmGaMdY5sXy+z2XDfwW9drrD
iJJ2lkZp5+EXzGdvLJ/fdgynJV/PCgGHtoqUtLIPe4KhBjZXjVPdtRJf54ji9mgI
uae8VlhWpRe6gHeqVELOyiD3dQFic2CTxc4I0tP8PSiOWEwO5jyMgjxMItLGdC6s
XJcHgQatN6Tt10/ERQJRIe3IK81BZwG441s28LRo+sSe/CUJ1vujvrO3g/8Vckzg
H1gzwp0eWTxidDY7pGdR/+BEyhEOb2c6cMljJ8L64N5qD44gewxM6T7P0jUC/uI4
tXEGB9q/gzmk1n7KR3IkfLAvLBRIMUIb6UGKDCmhfzTXUHLEcAl6Qu8WLocrv80H
g1wu543yyfdnvVPKo9hHTpWV3w/EOd2JHgekwRzTaCOoQOWZ2jJqr+bO5cbUHay9
JwGPHoI9HrMoBFc2mLp3WsWBrhczkjo82W8t5CQpMwcmmLzeyk1l7Jb9qEHa8AlO
foGYPogr+qraqjM/Kv03pkuIQ/HmZ1q5huI34IttCW++2CLg7lco46dhQWOn7hIR
9x78VyaYw7zBwsPwFQW+zF+CEoozN7KLZIbYW9NfpOks04NtxZUpQMN4dY5/pEol
VKByrJ9D1zKq1ns8Go4A
=w+kF
-----END PGP SIGNATURE-----

--eZF+V2/LE/RsbcQg--
