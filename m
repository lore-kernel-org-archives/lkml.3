Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760621AbaEMKDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:03:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:40417 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759837AbaEMKDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:03:39 -0400
Date: Tue, 13 May 2014 12:03:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf,tools: Remove usage of trace_sched_wakeup(.success)
Message-ID: <20140513100333.GW30445@twins.programming.kicks-ass.net>
References: <20140512181946.GG13467@laptop.programming.kicks-ass.net>
 <20140513072208.GB7980@gmail.com>
 <5371BCF8.7030708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cs2w6Z3FJD+b2LjO"
Content-Disposition: inline
In-Reply-To: <5371BCF8.7030708@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cs2w6Z3FJD+b2LjO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2014 at 03:34:32PM +0900, Dongsheng Yang wrote:
> On 05/13/2014 04:22 PM, Ingo Molnar wrote:
> >* Peter Zijlstra <peterz@infradead.org> wrote:
> >
> >>trace_sched_wakeup(.success) is a dead argument and has been for ages,
> >Always 0, or random value?
>=20
> Hi Ingo,
>=20
> It is always 1 currently.
>=20
> Peter believe that .success is not useful and I pointed that perf sched
> latency
> is using it now. Then he post this patch to remove the usage here.
>=20
> Please go to the following link for more about this issue.

It is _not_ usable. You're proposing to abuse the existing parameter. A
wakeup doing an enqueue or not has nothing _WHAT_SO_EVER_ to do with
success.

Now what I think you wanted to do is make it easier to match
trace_sched_switch() statements with trace_sched_wakeup() statements.
And since you only get the trace_sched_switch() on dequeue, you want to
know which trace_sched_wakeup() calls did an enqueue.

But that's completely and utterly unrelated to success.

--cs2w6Z3FJD+b2LjO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTce31AAoJEHZH4aRLwOS6cngP/iHaM7Y0NhcYARQKUAbJ3HwI
JVEXitZIa8By++QIkdVgD8PXYH/uSi4ChNyBbSX4c4QX8a6CBw8YdZGx2nH9Egy6
cmJ3bAH3ZOlOqS3pxFteyGVbPH1odFfLqct3MVurkdBkfy4XBHaLGgFH4R9Gku6t
YlnRb8VW4Tr4X5ACLBcCZsQoUYA48ZDufva4y/0BtvVnZ+EdzncESKxtE9bgnvot
ulDKQ8VzG+jnfbwUoAIOzMXHv3bYl5oJcA5AiAxxYCymjTkQcLY/o/yqMiOyazK7
aJEeNLLp/BtvyYiOk4BTLzXDMroQNAh5teKw+Z3PwZcYh6kJH32805S+aAp8Bfzn
b9YI95JugrPCPm5I23wa550RZOhWWynVJgIZ7Xgr60cCgP1mBS+th7WPwE0KZwT/
crwnWOJoA3qpWoKYSLGr4C6d4ATV+jFj9mUst9JsLP8aletg8h/Dve4Q2SbYSGgc
/gIKYysRvO80S8RwXMUrmSG3pU9gVEx2cXs7gvephiYMWa+zNWtLG1gMpY1pBfN1
FGdn1O/4l2uVe7be1rAy5w61PIjpOZwHItIF/6cHMJMLuN7wWNB55W5wNNVo4/BL
Xsw/+FX1ZNNU70slpuktAIm5de0qLQeuDA08RbNj0G0OsP5yEJL6sp3doxVnIWyj
dBN4LcFRI60PWvzhcElJ
=9Jgy
-----END PGP SIGNATURE-----

--cs2w6Z3FJD+b2LjO--
