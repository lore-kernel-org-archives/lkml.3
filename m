Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbaIHPN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:13:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35300 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbaIHPN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:13:28 -0400
Date: Mon, 8 Sep 2014 17:13:05 +0200
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
Subject: Re: [PATCH 1/9] perf: Remove redundant parent context check from
 context_equiv
Message-ID: <20140908151305.GU3588@twins.programming.kicks-ass.net>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
 <1408977943-16594-2-git-send-email-jolsa@kernel.org>
 <20140902105036.GH5806@worktop.ger.corp.intel.com>
 <20140908094348.GB1172@krava.brq.redhat.com>
 <20140908094548.GA6758@twins.programming.kicks-ass.net>
 <20140908094855.GR3588@twins.programming.kicks-ass.net>
 <20140908100122.GS3588@twins.programming.kicks-ass.net>
 <20140908120140.GA17728@krava.brq.redhat.com>
 <20140908133428.GG6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FC8SlEHQ+Zonp6pC"
Content-Disposition: inline
In-Reply-To: <20140908133428.GG6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FC8SlEHQ+Zonp6pC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 08, 2014 at 03:34:28PM +0200, Peter Zijlstra wrote:
> On Mon, Sep 08, 2014 at 02:01:41PM +0200, Jiri Olsa wrote:
> > On Mon, Sep 08, 2014 at 12:01:22PM +0200, Peter Zijlstra wrote:
> > > On Mon, Sep 08, 2014 at 11:48:55AM +0200, Peter Zijlstra wrote:
> > >=20
> > > > > The thing is; I don't understand those reasons. That commit log d=
oesn't
> > > > > explain.
> > > >=20
> > > > Ah wait, I finally see. I think we want to fix that exit path, not
> > > > disallow the cloning.
> > > >=20
> > > > The thing is, by not allowing this optimization simple things like =
eg.
> > > > pipe-test say very expensive.
> > >=20
> > > So its 179033b3e064 ("perf: Add PERF_EVENT_STATE_EXIT state for events
> > > with exited task") that introduces the problem. Before that things wo=
uld
> > > work correctly afaict.
> >=20
> > hum, I dont think so.. because the perf_remove_from_context set event
> > to PERF_EVENT_STATE_OFF state anyway.. thus making any new cloned events
> > disabled
>=20
> Urgh, see I knew I was missing something.
>=20
> Can't we fix that? Lemme check to see what relies on this.

2e2af50b1fab ("perf_events: Disable events when we detach them")

Seems to be about it. And I think we should solve that differently, but
the best I can come up with ties into the event->ctx mess we have in
that other thread.

The thing is, IOC_ENABLE/DISABLE and read() and such should act
(sanely and) independent from the attached state.

Its just that the whole event->ctx migration mess is making this
somewhat hard atm.

So things like perf_event_read() should not only check ctx->is_active
but also worry about event->attach_state & PERF_ATTACH_CONTEXT.

Now the biggest problem is that we cannot tell if its a temporary state
(move_group / migrate_context) or permanent (exit)...=20

Urgh

--FC8SlEHQ+Zonp6pC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDceAAAoJEHZH4aRLwOS6rOIQAJsgLvCdbpxeiuxDNJUcTxiL
exTKFa8iviiG1o5LPox0/URbQxLjGdDr8RIJbIErLtal1cz83bWLF1xcFX/afNhq
uEt4bXRFTOdbIKZ5myv3hk5o1Wil7MiOmQTL3cEwMLs9nsF4CkiXoBg1yGqiTWzU
0mfh/aT2xDjgcC2Mwhum6kHiTgXzo10PrCGRwlcAcf8Jm2a6vSQxOYHzDM/wVvnw
Atn56fzI7TK+5o6WzOisuuGbUa6lSOhYuv5pbBkihoxRIVJC3wqNCmp/yoss8onx
ZUZPoGmpSH1FazNQsK6qYkrPbtP0OzddzviI3dqQwaSYj9VJGrDk9JyRwDLMTcSY
/M04fMGsr6dAsBk4nEiTL7NW6FyCswRG1BtwTEbywJEf9ODsa9nbRSNNPTBlJ5yD
waS5P0F2w6M8awtjneQOyoPoZM0NwTt3pysPZc5A+MuKrjcIE5NT/H3euL4xICqb
CgjG8mT0DW1JSkqvjcVj8c9P5gLeobqsJi3TSquUu5cNo6WyBh2VIugEy2d+rELG
6PYTjUg/3PgT06Uj54Wk54T8pWj/0+QhxK91Ja2OtT7NeoHb5MuDefCk35fjSPJp
m3CqZcEc3kHRdC7Rl8WsyLoS8Wowm3NUYsIav+RkHjOlMOZB9rP2II/blUMUTgw1
FoHH4V7kK/LYPogfZw9c
=i51j
-----END PGP SIGNATURE-----

--FC8SlEHQ+Zonp6pC--
