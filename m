Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbaHHQB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:01:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49302 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbaHHQBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:01:55 -0400
Date: Fri, 8 Aug 2014 18:01:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        bobby.prani@gmail.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140808160128.GE9918@twins.programming.kicks-ass.net>
References: <20140807154907.6f59cf6e@gandalf.local.home>
 <20140807155326.18481e66@gandalf.local.home>
 <20140807200813.GB3935@laptop>
 <20140807171823.1a481290@gandalf.local.home>
 <20140808064020.GZ9918@twins.programming.kicks-ass.net>
 <20140808101221.21056900@gandalf.local.home>
 <20140808143413.GB9918@twins.programming.kicks-ass.net>
 <20140808105858.171da847@gandalf.local.home>
 <20140808151643.GD9918@twins.programming.kicks-ass.net>
 <20140808113949.046522c5@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dAgelbNY+bLbwwMh"
Content-Disposition: inline
In-Reply-To: <20140808113949.046522c5@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dAgelbNY+bLbwwMh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 11:39:49AM -0400, Steven Rostedt wrote:
> > > > Sure, I get that part. What I was getting as is _WHY_ you need
> > > > call_rcu_task(), why isn't synchronize_tasks() good enough?
> > >=20
> > > Oh, because that synchronize_tasks() may take minutes. And that means
> > > we wont be able to return for a long time. The only thing I can really
> > > see using call_rcu_task() is something that needs to free its data. W=
hy
> > > wait around when all you're going to do is call free? It's basically
> > > just a garbage collector.
> >=20
> > Well the waiting has the advantage of being a natural throttle on the
> > amount of memory tied up in the whole scheme.
>=20
> Yeah, but it would suck if you do "echo nop > current_tracer" while
> running something that is preventing a task to unload, and have to wait
> a few minutes for that to return.

> > You said 10e3 order things, I then give you a small 32bit arm system.

> Honestly, to allocate 1000 different callbacks now, requires allocating
> 1000 different ops, which are much larger than a single trampoline.
> Right now, the only way to do that is to create a 1000 ftrace
> instances, and those creates a 1000 directories, would would include
> 1000 event directories, each having its own dentry for each event
> (around 900).
>=20
> I don't think we need to worry about this use to work on a small arm 32
> bit system and it doesn't work now. The difference in memory
> consumption is not that much.

Well, see the _BIG_ difference is that currently, when I do nop >
current_tracer all that memory is instantly freed again.

With the proposed scheme, if I setup state, reconsider, destroy state,
try again, and generally muck about I can tie up unspecified amounts of
memory.

And being the bumbling idiot that I am, that's actually fairly typical
of how I end up tracing. There's no neat and tidy, I trace something,
look at the trace, script a little, muck about with the settings and
goto 1.


In any case, I think I now fully understand what you're trying to do,
just not sure its all win.

--dAgelbNY+bLbwwMh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT5PRYAAoJEHZH4aRLwOS6gCgP+wVDkGAGjHToLI7f8ehCqFk2
EbI6Sn+MU/wX992eidtE7c8NoPNN7Wwzjr2igRGBu+lMkXx8g7ugaLWGzqQEAdYC
pkL33Wxw7JdTyo68DKcjF4vS4a7NrPJ17MA5RoB1h5495nCOsHyCpj6RMMJ6KR3M
KNChpjsr6AJ9YYmUpT5RMNPGd71COXfeNL6oqEqT+Z2TNFzHqSoad+o6V4eYMHP+
kkZAhfX/UrCIlwLROkGCvjBjE7Vv3yY9ESTFH9T/a3WdqTMm4LOBJ85XYtZ7cm1t
x1/q49A4ZSWeelnFQz2C/nwvO4G6y3ct9wLGEicXRaOlhq/js/sHqKL6FxubhRTK
Ghxl3OIt5m6hHdADZfwPZUhizDJOBJFgdLYNq21nmyGzaJkIp0zxWMr+GI6Cl3fd
S6kFwhPwnLfxCXEngJ3sceMeo35r0PwCtUV/YB5TDhFusbO3IE0fGDH2f1oTJx3p
34fIYYJeWZgxJJ6rn3twGYvRupboG65Pdsyo9dA67dmjZeRjf72BixhAMgyOkgpx
jnAxj5RZGVdLeBevlYEynWlJHwCkxTw/C0OZAUlrwAYGfaM/T5oLV4dmLLrHbF7n
0nHTnkslkJ8TzaP/9gA6J6cXzshcwxNiSBuC82QETdxuv8tmaN74L/i8Wq07w83/
pLao51rkvsFVwQv3qnRL
=k6d/
-----END PGP SIGNATURE-----

--dAgelbNY+bLbwwMh--
