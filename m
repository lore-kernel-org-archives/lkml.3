Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaHDMZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:25:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47328 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaHDMZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:25:41 -0400
Date: Mon, 4 Aug 2014 14:25:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140804122515.GR19379@twins.programming.kicks-ass.net>
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53DEE1CD.4000705@cn.fujitsu.com>
 <20140804074620.GH9918@twins.programming.kicks-ass.net>
 <53DF41ED.2020508@cn.fujitsu.com>
 <20140804115043.GA31903@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RMnrteHbcZy6jON6"
Content-Disposition: inline
In-Reply-To: <20140804115043.GA31903@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RMnrteHbcZy6jON6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 04, 2014 at 04:50:44AM -0700, Paul E. McKenney wrote:
> OK, I will bite...
>=20
> What kinds of tasks are on a runqueue, but neither ->on_cpu nor
> PREEMPT_ACTIVE?

Userspace tasks, they don't necessarily get PREEMPT_ACTIVE when
preempted. Now obviously you're not _that_ interested in userspace tasks
for this, so that might be ok.

But the main point was, you cannot use ->on_cpu or PREEMPT_ACTIVE
without holding rq->lock.

--RMnrteHbcZy6jON6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT33urAAoJEHZH4aRLwOS6WEAQALQaqEOWCoK2lAcUtGNrwmUX
sx6Tjn1GFRfCmBC7D0B9mJn19ehIdFcx1+ZrxcHmsRC4r0eA0XaVCjsnXeEJaYwu
FJFO3x539C7NoDtDOau3h8j/jZDpOxSp4VCGK/8vVzbyaAy25eeteFsMwBJiRyks
AbR+8GoXVOBdMVp7jfqEOCshUf4xtkxbPKW0AEKSJMARghCkULqDRdLgpSx7XyHf
A3nzqQrxdc2Q/ct1TJ0mZF2FPyGDW6v7nYLVov+ZOMOipt2r0/MYVqrzCo0RMUJ4
Nld7HRUjMIItDJ3U12FehxEucHYp7Addx+6qSYHi/yF6w0K1EEQGKPvi+yem6EKb
mdE1fC7h5isV4S7f7RkmzOaDbt1V3EwUn5mS1W/S3T9TISvKAqourzfIhii5mJLl
cwZ7gRja3QTXUy8+BE/xu//oxyESt+h2eUKu61nFzP7u2SpdoaTWSPkoyxurMxd5
TTn8kczNy1whVNI0l9mullpDkm3tg8JO6K2OxZSVMr9gdqp4oEqjEgwx9/ecEZy/
8WG1hbX+/dsHcCxxVmQCT7gPUsZoZjuzXTqTb6z1Km3oBoiTklRiNHp5nfHcXI9z
aK3XWAqlKuYM+PPNqp+AhlGbsrICfdy8b1blSAh78bK+pyqdpQhz1AtUf9Y/H/Fv
h753YMjWnI7bLIZyGlsu
=woGM
-----END PGP SIGNATURE-----

--RMnrteHbcZy6jON6--
