Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaIHKBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 06:01:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:38282 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbaIHKB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 06:01:28 -0400
Date: Mon, 8 Sep 2014 12:01:22 +0200
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
Message-ID: <20140908100122.GS3588@twins.programming.kicks-ass.net>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
 <1408977943-16594-2-git-send-email-jolsa@kernel.org>
 <20140902105036.GH5806@worktop.ger.corp.intel.com>
 <20140908094348.GB1172@krava.brq.redhat.com>
 <20140908094548.GA6758@twins.programming.kicks-ass.net>
 <20140908094855.GR3588@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3m6VNgM56Nljn+Yv"
Content-Disposition: inline
In-Reply-To: <20140908094855.GR3588@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3m6VNgM56Nljn+Yv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 08, 2014 at 11:48:55AM +0200, Peter Zijlstra wrote:

> > The thing is; I don't understand those reasons. That commit log doesn't
> > explain.
>=20
> Ah wait, I finally see. I think we want to fix that exit path, not
> disallow the cloning.
>=20
> The thing is, by not allowing this optimization simple things like eg.
> pipe-test say very expensive.

So its 179033b3e064 ("perf: Add PERF_EVENT_STATE_EXIT state for events
with exited task") that introduces the problem. Before that things would
work correctly afaict.

The exit would remove from the context but leave the event in existence.
Both the fd and the inherited events would have references to it, only
once those are gone do we destroy the actual event.



--3m6VNgM56Nljn+Yv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDX5yAAoJEHZH4aRLwOS65ywP/0hHItVm5W+AGTpF0DYPHnJ7
T59WCQMpRDCCVE0Oy+JwRo0dFYjwKy8hcTYmKFUz15fdx7e7DkirJt/Wj3R4y4X5
9AnsGSyvn9iAVvCWaz0lq64IEKH9xIOhesVHnRVvOj4T+sAxRGw7zP1lAJRGit+7
4DQ8exzZ//C1tVhIgXFy0jTILw31W6bag4Q3v2WQXPrzPpp5lvuJeAOXEEnwOBx4
6jgW8aEVpLlr+9zqGQYDcFsuJWqrFbLty9V7u+tSVx/F1jAfKtgmzONe0eWG1TSX
u2lWhriQ+wCDHTe4aq7ipLCCM9Nwt9j/Bt9xlNsOLn0gd6VMiKOcbkA4koJmvC/K
7khaOodXDcZr1dzCjrJu0rLLCmsT8fW0KaW5mTI4agzFIDXMsUjW0qC7FuhKKBf6
3gRlyHFrk/4Z73DiUfl2wQJQjY6BPt+PBJlTsYpSuDy2oxBJ/vpOMrwgNpZXEguj
Vr4VVcHaMdNS9VfbMZFHrS+u0ziJ7taVxvi+typAkcJtIR/zYz36SfNUcPmfXmUr
kg7nF5jc3UiF2Qfz0UB9HwPinFtbuh5jt4yEyCCWLWfvc3aeRlsPW8cqsYxBoBIZ
Hjr9gjpWcjW5sYLR+SxOTcVPDs4QL3DlhNR0IDaJEINtTL82ipUAqiVFv7FijSwy
JtdRieXPoCnZLGxDOW0M
=aLYe
-----END PGP SIGNATURE-----

--3m6VNgM56Nljn+Yv--
