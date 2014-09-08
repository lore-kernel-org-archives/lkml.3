Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbaIHLkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 07:40:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40410 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaIHLkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 07:40:16 -0400
Date: Mon, 8 Sep 2014 13:39:58 +0200
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
Message-ID: <20140908113958.GT3588@twins.programming.kicks-ass.net>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
 <1408977943-16594-2-git-send-email-jolsa@kernel.org>
 <20140902105036.GH5806@worktop.ger.corp.intel.com>
 <20140908094348.GB1172@krava.brq.redhat.com>
 <20140908094548.GA6758@twins.programming.kicks-ass.net>
 <20140908094855.GR3588@twins.programming.kicks-ass.net>
 <20140908100122.GS3588@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IIU4lL9vGQnN7Mxl"
Content-Disposition: inline
In-Reply-To: <20140908100122.GS3588@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IIU4lL9vGQnN7Mxl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 08, 2014 at 12:01:22PM +0200, Peter Zijlstra wrote:
> On Mon, Sep 08, 2014 at 11:48:55AM +0200, Peter Zijlstra wrote:
>=20
> > > The thing is; I don't understand those reasons. That commit log doesn=
't
> > > explain.
> >=20
> > Ah wait, I finally see. I think we want to fix that exit path, not
> > disallow the cloning.
> >=20
> > The thing is, by not allowing this optimization simple things like eg.
> > pipe-test say very expensive.
>=20
> So its 179033b3e064 ("perf: Add PERF_EVENT_STATE_EXIT state for events
> with exited task") that introduces the problem. Before that things would
> work correctly afaict.
>=20
> The exit would remove from the context but leave the event in existence.
> Both the fd and the inherited events would have references to it, only
> once those are gone do we destroy the actual event.

I have another 'problem' with 179033b3e064. What if you 'want' to
continue monitoring after the initial task died? Eg. if you want to
monitor crap that unconditionally daemonizes.

So at this point I would suggest we revert both 179033b3e064 and
1f9a7268c67f so that the context switch optimization works again for
simple 2 task things (pipe-test).

If we re-introduce 179033b3e064 (which I think makes sense) we need to
make sure it works with the context switch optimization (we could add
perf_event::task I think, it would clean up a few other things iirc) and
we'd have to make it conditional so we can still monitor daemons.

Or am I totally missing things again?

--IIU4lL9vGQnN7Mxl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDZWOAAoJEHZH4aRLwOS6/W4QAIisRBZMN7g8uNa1eu3OIlPp
vKvyYRKyWZyf+nMqiJCvktcuoMhaOtckqZ91N+owxDPRb/TtJQjhlXLaIBKZ5i8D
jVSqDftgrFLiN+6YqHjH5Yw1NRpOaoAY3cFlC26C8fZt/TFSOlbVgh7pNjmNoVyO
hWiBQ0fwov/tZsIkbRjnqCwXjJQtjePDSDX1X+wRuit8L+nKUEe2oiZ/dWN7I6am
BmX2pFfYlHUxTiEvuxJUs/bRt/JD4jxcXURW8gFhN7SpEDIx0gpBSiowD2PqwrJk
YN6PBpitPv7jFlDS2j5R7b7hGbGcJzwdmbu/vQpiiK/EkezPtSD70oejJ4S588Z1
mwH1tTufuDbTbr9qE7b0ZGwpeuJxg9/Q/Eqt8SOgPPm2FdVV3cGK6Va76kU4K6TE
xfV53Bm6ErUeAJaYPihb0Q0EVWsoNBSj7W6JigeaEsxROhJ6FBIvf5FnsvR2/9q3
aCbno/hH/ws+shcM1cvEEIsx5oYujiiaK2jPHK9rD6qRw3314VkM9SBIxs6SW138
BZhh1hkGXx6MKAK4NsLmK6TGyewjPYqullM7D0Iko8OixwbE4WF3CnF9t1L/DQN6
JXhUPYT16dsZewwo9unRE8aVYtMC1WKNKPPwYxL/gCpvNM0nrVMRhoVXdiB7QPQ4
Uzn4NuKoAya4l8Wg7qmb
=ncKI
-----END PGP SIGNATURE-----

--IIU4lL9vGQnN7Mxl--
