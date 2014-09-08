Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaIHKLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 06:11:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49516 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbaIHKLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 06:11:41 -0400
Date: Mon, 8 Sep 2014 12:11:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/9] perf: Deny optimized switch for events read by
 PERF_SAMPLE_READ
Message-ID: <20140908101119.GB6758@twins.programming.kicks-ass.net>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
 <1408977943-16594-3-git-send-email-jolsa@kernel.org>
 <20140902105244.GI5806@worktop.ger.corp.intel.com>
 <20140908100018.GC1172@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uHr6nJLCB5hydKEi"
Content-Disposition: inline
In-Reply-To: <20140908100018.GC1172@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uHr6nJLCB5hydKEi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 08, 2014 at 12:00:19PM +0200, Jiri Olsa wrote:

> > no.. so the value of the counter is the sum of all the inherited events.
> > It doesn't matter if you flip it or not the sum is not affected.
> >=20
> > PERF_SAMPLE_READ should return the value.
>=20
> so I want to be able to do the leader sampling over child processes
> that means:
>   - have event group with sampling leader, and the rest
>     of the group events' periods being read on leader's sample
>     via PERF_SAMPLE_READ sample_type
>   - for each child process created I want it to do the
>     same thing as the parent - sample on leader, read
>     values of other events in group via PERF_SAMPLE_READ

The thing is, PERF_SAMPLE_READ should return the exact same thing as an
actual read(), and for read() the value reported is the sum of all
events.

I _think_ I know what you want, and I think I see why you'd want that,
but I'm not sure how to best do that.. Hmm.. maybe look at
'perf_event_attr::inherit_stat' that appears to be similar.

At which point read() vs inherit_stat might be 'broken'. Hard to know if
anybody uses that :-(

--uHr6nJLCB5hydKEi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDYDHAAoJEHZH4aRLwOS6LNoP/jFs66dp6qUDfwbHfXn7d55k
b3ykb8rTN7W5kF1KQI8xj+ANOXscO4s1eNAOwsW0T0J8XzGNl8+f2lr96F6pxlTo
Jk38xMmdREI89W9xgK+iBg4OMIZjcnvMYoZJUPwGxCwOExn6k5kSjj6pF3q5eIvP
1xt/6AYkYzQtd/lNs8niztTkhmpytkcavfQiVO3WD33fLtpgdQ40O4Z/Nw/GhbrM
hEGdcx3OxLonloY4wXA/W6GbrHZBHjOOt9hE7r52vIZCV+nXhypi1Ko57Nzf5zDC
8AWSt2P76kTWvX017kdMldM0goNsfguFzMUE9NT1jO2OeI9kfBnh3pX/6yUxgTOU
U1zzpJ4w6QYA2RC5ZmQ8Qt9FrVRjQ43xgwKi/556VB+fR6Sv+e7hrjJt7rivd2Zm
20BCHEU3dye01Wn42upO8050cF3Zsr+/dQvZ5O84QNpV7USykj6RihaAXRkKx/3s
7uEQKqDlGyFsB/RFnmgSBUZOGg0LAprsA+LAUViJduqPuU1DyZK0gwsVC78W14Zu
R8wlJPeHtjZmdCw1v4MlGWZcY8ZfjkqtYOdv66iGUNTUJZJ5mWqp4N+6G7YXU0Bi
4hvF2VlnNa0kBdkF/lCNcoYIYcDORfq+X6Ef1gaR9tCmrqPRiU0Z2TXLhxbZBqok
cPxL7lAUPZNB2CfBfe2M
=muzv
-----END PGP SIGNATURE-----

--uHr6nJLCB5hydKEi--
