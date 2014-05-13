Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805AbaEML1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:27:06 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47274 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaEML1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:27:04 -0400
Date: Tue, 13 May 2014 13:26:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf,tools: Remove usage of trace_sched_wakeup(.success)
Message-ID: <20140513112658.GX11096@twins.programming.kicks-ass.net>
References: <20140512181946.GG13467@laptop.programming.kicks-ass.net>
 <20140513072208.GB7980@gmail.com>
 <5371BCF8.7030708@cn.fujitsu.com>
 <20140513100333.GW30445@twins.programming.kicks-ass.net>
 <5371EF7A.7060908@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B0ZU/rjo5v6h4DpE"
Content-Disposition: inline
In-Reply-To: <5371EF7A.7060908@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B0ZU/rjo5v6h4DpE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2014 at 07:10:02PM +0900, Dongsheng Yang wrote:
> On 05/13/2014 07:03 PM, Peter Zijlstra wrote:

> >Now what I think you wanted to do is make it easier to match
> >trace_sched_switch() statements with trace_sched_wakeup() statements.
> >And since you only get the trace_sched_switch() on dequeue, you want to
> >know which trace_sched_wakeup() calls did an enqueue.
>=20
> Ha, yes, indeed. In perf sched latency, we need to know the timestamp
> when a task enqueue and then we can calculate the delay time.
> So I want to take the use of success parameter in trace_sched_wakeup()
> to indicate that *this* wakeup did an enqueue.
>=20
> But now I think it is okey if you really mind adding more tracepoints in
> scheduler. And I posted a patch after your patch in this thread to make
> perf sched latency work well.

I don't mind adding them per-se, as long as there's a reasonable effort
showing it doesn't slow down the wakeup-path.

--B0ZU/rjo5v6h4DpE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTcgGCAAoJEHZH4aRLwOS6mGcP/AnYO4sZCSc9vp9rCH/xL0oA
F/nXVVAVxFfduP/oNwmQnq+8o4nF7iRvokF4Tt3Jf6/2k2wWc/oyIETb38Yxuo0S
KcI7kN+Maby2mZeOeZ+Uyi76bZCJtHRbYZmF45bm+zbMO9+YJ3ZA8GHs+u2rcysm
lkN0IXyq/5ls2Y5kZb+v665W7AMkeAgItD3r+jnwrc12yBibgv9dmbryoc+eOo0Q
ZXeC14lys2p68ycEoFr8YntXkWqpetsae5VXuDGysQE1Scxcgfh/WdoFZ4+GP7bx
TsIrxKpYPBUZhYEfQ4oqJ58UruwlJAr+ycDQcd6ZOxWjK7xo83Rmv81p6wIJfKha
5fvaq6ynL3zj9zff7ya0FYQgdSIuBrg9kl0i7yFmQWcUgtkysFA69KjhW8alQQNe
fSV76YWgacoew4NcxCr+i5vYqIw1Wjuk7gGpkmV0itAYc7qgGsVTLqpbJLVm/SQS
riodDlyQwfNHoOEhk1oiO8fgZAxS4iafbDOyT82TQBB9fIljrSRkWT6EKzf+CiRr
JAd4eJbsIRbM6EBwmzOBDhdG+/u+hlZ0PbosQu9ECEIDdVh4Tryip4k6CBNBHM/b
Y3F9AQCLnoKXPka17IfbTbhnEkPn6GQd9Xc6g8Tz7+ru1p3RBVLPLPqfrwhfZ3C1
bRK92dSnna5xkmCise7m
=DdrT
-----END PGP SIGNATURE-----

--B0ZU/rjo5v6h4DpE--
