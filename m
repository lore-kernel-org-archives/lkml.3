Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbaG2HvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 03:51:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:34882 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaG2HvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 03:51:10 -0400
Date: Tue, 29 Jul 2014 09:50:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140729075055.GY19379@twins.programming.kicks-ass.net>
References: <20140728225556.GA19493@linux.vnet.ibm.com>
 <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pUwoXgeCGnTlVt9x"
Content-Disposition: inline
In-Reply-To: <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pUwoXgeCGnTlVt9x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2014 at 03:56:12PM -0700, Paul E. McKenney wrote:
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index bc1638b33449..a0d2f3a03566 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2762,6 +2762,7 @@ need_resched:
>  		} else {
>  			deactivate_task(rq, prev, DEQUEUE_SLEEP);
>  			prev->on_rq =3D 0;
> +			rcu_note_voluntary_context_switch(prev);
> =20
>  			/*
>  			 * If a worker went to sleep, notify and ask workqueue
> @@ -2828,6 +2829,7 @@ asmlinkage __visible void __sched schedule(void)
>  	struct task_struct *tsk =3D current;
> =20
>  	sched_submit_work(tsk);
> +	rcu_note_voluntary_context_switch(tsk);
>  	__schedule();
>  }

Yeah, not entirely happy with that, you add two calls into one of the
hotest paths of the kernel.

And I'm still not entirely sure why, your 0/x babbled something about
trampolines, but I'm not sure I understand how those lead to this.

--pUwoXgeCGnTlVt9x
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT11JaAAoJEHZH4aRLwOS6eegP/i9+m/Z6v6AjqABf6hRG511U
avXZBfWx7bmcKKa5OcVV9EdKfNeWty2XrEO8u+QJhDidIAOUZ7S0xDJIrCMw7+DL
oS8tWKxdDAKhMxDZkBmtV/Of8grHAcBm8j1+yVwq53vhS5nmOdtr7c0AE3keF2r5
b9w6HqC0mmeg/C3Cpk+FhkIhCmAX561ffAKARdn6hcLmgU8C8/uEu0XaHZJZ+o++
lXCZsGhvVr2bp+a6y7ERS62R7L445WzJ/g39oEyu/IgJ9az/GHDsbLudyWnxRYoV
1NDIh9deCzXAE4ranQcTxPb4H5Ajs4lSe1U5GODqBnKp7hXWioaeTSxRc7oYQL0M
gOWa4SaADrFhgnp6YvTOULj9f32Zqdj81QnW6vrAa24hREx1/NaTS0zEwJmMBqXZ
TQGmrGjp0Q6dHzBUIEAIUlo3oTfkfGTWF/GyzlKjDjPpIEbj8jLUgAqenb+056GH
0lU+RGKEAGdKZUirrUZMIGZhMB55j9J7+o0J30xCkGxLVlUD9G3/xE8rgstUXxLF
ge+MhXKXIiyObsJFThRSSNmck1SrOoutZJleThktfKxOPZf1PWpqOr1Hy28SDcFH
PgA4Evd6fTEYkINyRddDNhuZxmydRhQV5q9V6ZJ15JlI9kFwpl30blvUunJu7KXX
7M4uazN+0RmQ1uqO0/Ii
=xcO9
-----END PGP SIGNATURE-----

--pUwoXgeCGnTlVt9x--
