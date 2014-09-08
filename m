Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaIHGL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 02:11:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:37308 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaIHGL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 02:11:57 -0400
Date: Mon, 8 Sep 2014 08:11:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Catalin Iacob <iacobcatalin@gmail.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/9] irq_work: Force raised irq work to run on irq
 work interrupt
Message-ID: <20140908061151.GP19379@twins.programming.kicks-ass.net>
References: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
 <1408632777-3348-4-git-send-email-fweisbec@gmail.com>
 <20140904061137.GB3190@worktop.ger.corp.intel.com>
 <20140906133513.GA1471@lerouge>
 <20140906154556.GO19379@twins.programming.kicks-ass.net>
 <20140906171223.GB1471@lerouge>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SHdUoswF6B01XDUc"
Content-Disposition: inline
In-Reply-To: <20140906171223.GB1471@lerouge>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SHdUoswF6B01XDUc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 06, 2014 at 07:12:26PM +0200, Frederic Weisbecker wrote:
> On Sat, Sep 06, 2014 at 05:45:56PM +0200, Peter Zijlstra wrote:
> > On Sat, Sep 06, 2014 at 03:35:15PM +0200, Frederic Weisbecker wrote:
> > > You have a script that does that arch/*/include/asm/Kbuild edit for y=
ou right?
> > > Is this something in scripts/ ?
> >=20
> > See commit b119fa61d440 ("locking/mcs: Order the header files in Kbuild
> > of each architecture in alphabetical order")
> >=20
> > That script is a little buggy, but should work in the current case. So
> > first do something like:
> >=20
> > 	for i in arch/*/include/asm/Kbuild; do
> > 		echo "generic-y +=3D foo.h" >> $i;
> > 	done
> >=20
> > Then run that script.
> >=20
> > IIRC the bug was where a single line contained multiple headers and/or a
> > continuation. I should have a better version somewhere, but this one was
> > easier to find.
>=20
> I see. Meanwhile I've applied your suggestion as a separate patch in
> the series. May I use your SOB?

Sure.

--SHdUoswF6B01XDUc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDUihAAoJEHZH4aRLwOS6I/IP/jIag7VnU9B3Ee/WFyIN51xI
PP0G7ZrtrGuWSjgiycRq0QdDxgnO9VWrVSDB6cwPfsLtwT4+NE34v7ZN6+FOCsLb
8YlVh2Wpmb2f4WnOllaEvu3snKcyKx/gGtiEhCdALvMPiBPKIEsN6yCSsUBw3nBD
HfiRC+qpklx204b6RSvLON+8TcmQxEenMT4l5sXQk2LgsjjtaXF0V0eT3VuhRTsg
tG4IIbVQwJvd7WiaeSE6VKhDTJPjbANR2370iwszHBn8ZglXj00rjeG9ZQLzv25m
V6B/8sFanZbTx+OmitI6elxArWbtst2jZhHzUnDo0GJXIzhxwizViRLQ8xpIV0qy
xAv5jW23fpDJg6PMyI19kMvfaBnexAeKZteXu7wff7OqkZbrA77B576h6NPLp64q
n725u46wQmr1QWr4lO1BtP5hPjh9qwGHmKY79FmSrTPNTtzlMsO53Fbud90Bs7UU
VARLdF1A27Rh5lH8UzzRBSihuNBUbi5mxzagKVnUCw0slGofu3wsTR84Z3a2ydAW
tPLw1P+9lVBN7a1hd1v9gFaYSDAH4f/xgVrnpgEolxhBzg1mef0IV+CPGEHL/P4K
PFLRhdbAnqNpZMtgste1aaBHXHd6eqbT7gM6ROwpKJEVNAG0DhH8q4lfzD0yBSrs
Ml9dHXmZFvMN3w8ltuui
=RIHH
-----END PGP SIGNATURE-----

--SHdUoswF6B01XDUc--
