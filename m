Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaGaQVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:21:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45950 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaGaQVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:21:02 -0400
Date: Thu, 31 Jul 2014 18:20:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v2 tip/core/rcu 01/10] rcu: Add call_rcu_tasks()
Message-ID: <20140731162030.GY19379@twins.programming.kicks-ass.net>
References: <20140731003914.GA3872@linux.vnet.ibm.com>
 <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53D9F084.7000706@cn.fujitsu.com>
 <20140731160924.GR11241@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VR+dwSycRMUSiZE+"
Content-Disposition: inline
In-Reply-To: <20140731160924.GR11241@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VR+dwSycRMUSiZE+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 31, 2014 at 09:09:24AM -0700, Paul E. McKenney wrote:
> Well, that is one of the questions in the 0/10 cover letter.  If it turns
> out to be necessary to worry about idle-task trampolines, it should be
> possible to avoid hammering all idle CPUs in the common case.  Though maybe
> battery-powered devices won't need RCU-tasks.

So do we really need this to be a full blown RCU implementation? Could
we not live with something like a task_barrier() function that
guarantees the same as this rcu_task_synchronize() or somesuch?

So for rostedt's case he could patch out all trampolines, call
task_barrier() and then free them.

We can make task_barrier() force each cpu to resched once -- which, if
we do that after the task's have all scheduled once, could be the empty
set.

It also pushes the cost of this machinery into the caller of
task_barrier() and not in some random kthread (yet another one).

Now, if only task_work would work for kernel threads, then we could do
something far nicer...

--VR+dwSycRMUSiZE+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2mzOAAoJEHZH4aRLwOS69nsQAJVSsvCfvTbRs5lAqvc+JFDs
ncsvukZ1Uv+8LnVI0Sc74rztZoyaYBM39r3efMSGNK1KQWOxRIEp1IoXioZyjgqv
1+aZ7WuTAPZ7iPVEuDkjaQ0O2VE+4MioM4bCdUaPgc76ASjVQFQK3mGlEaoOPEfM
HlB489XayzQQC2KdRM2H4BFCRnY6+5TrXNuhBiKKvDq4J8ZJr0gJkxQs1tvFkLg9
SSn5GVfIpl9FetWxSNO082A77m3aak5KL/Gt/IoxAtGriI3nd4FZRPUp2JJf2tM6
rY/PsVzXyMgVRm+KfMwYkkNk5A42PIr/22lVUo9VssWQ8taSzVxSGEUIJCDtbnk5
kRKE8kiZDr3kl3qzUtn1vRWjy1tlAo3tHPO/7DXPU28hWMQKy1zxkGzypoNX+Ocj
8eNTBNqQLzDRzciJSmpJf2ODbnWZ80nha+dfriePlfZtWzl/MgACPRamm/r/RdpL
R4GOvYKg0kH0RGDFNjFMN+tBy1SHcnwDfAhuxSF2arY/2bW41Kdj7Jk/8uU+2TwE
GljhZ7Mjsay1VTzXs030Mx4Zc68WyHsq+2+zvVO0NywM3jtyWHr+Ls8ce20mgrYS
Qd90pDXHk/uLycSFJK0+wWlnmbNFxQfYVZisnLjbNZnLiS63cFczL01MOPh/jCFQ
sOYffgdSdtSZv4qSCM7t
=3LT6
-----END PGP SIGNATURE-----

--VR+dwSycRMUSiZE+--
