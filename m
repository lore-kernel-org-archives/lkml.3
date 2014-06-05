Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaFEH0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:26:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:50595 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaFEH0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:26:40 -0400
Date: Thu, 5 Jun 2014 09:26:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, fweisbec@gmail.com, tglx@linutronix.de,
        hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smp, ipi: Speed up IPI handling by invoking the
 callbacks in reverse order
Message-ID: <20140605072637.GF3213@twins.programming.kicks-ass.net>
References: <20140604193934.21321.19185.stgit@srivatsabhat.in.ibm.com>
 <20140604194731.GO13930@laptop.programming.kicks-ass.net>
 <538F7C7D.9040606@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ni93GHxFvA+th69W"
Content-Disposition: inline
In-Reply-To: <538F7C7D.9040606@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ni93GHxFvA+th69W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 01:37:25AM +0530, Srivatsa S. Bhat wrote:
> On 06/05/2014 01:17 AM, Peter Zijlstra wrote:
> > On Thu, Jun 05, 2014 at 01:09:35AM +0530, Srivatsa S. Bhat wrote:
> >> The current implementation of lockless list (llist) has a drawback: if=
 we
> >> want to traverse the list in FIFO order (oldest to newest), we need to
> >> reverse the list first (and this can be expensive if the list is large,
> >> since this is an O(n) operation).
> >=20
> > Have you actually looked at the queue depth of this thing? Large queues
> > are a problem for interrupt latency.
> >=20
>=20
> Actually, I wrote this patch just by looking at the code and realizing
> that we don't need to reverse the list. In practice, I haven't actually
> seen any noticeable interrupt latencies or large queues so far. So I think
> this patch is just a very tiny optimization, that's all.

So conceptually it makes sense to service in FIFO because the first
entry is waiting longest, by servicing them in LIFO order you get far
more variance in latency.

And if the list is small, the cost isn't high.

Then again, we don't have any good numbers one way or the other.

--ni93GHxFvA+th69W
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkButAAoJEHZH4aRLwOS6fCsQAKI6lCQ625Ol7KCPPQ+zXjju
chEKk6m4LLfn4/SX9ez4m95u1jJM7rXiq3foTvZZc5q1m0Xk22Qa4AXRH6rrLVzZ
wHfZpsXk0b15/b1oDipM2IMEqvfHCHZ0+1qI48v29MRhwXynt44Ay+XyfkJIgOf+
z9YUgF9lfPDx2vfC+PC6f+YFSoZZ2rp55kTIMN1Gb654Y8jBRTrzF4C0FTyxpr5S
mm6t4fLrHvinOCYq1FxQj2c/27ZjivMed/8oRU7gtwxd9aPNk1Zpeo28Cb/ovXnS
87VrLpOTd5ID/BfqDll39q8tMO/+Hx2xQQ+AqnvXakPLXJEa/FwUbEVPe6wJkpCK
M0B7gsY1LpCLZWGtf1XGHeE9ruJvVSVBtAx6HPjmn8yrBjm0Aw3mNu/yTHtDR9fw
kzV/AHU1gh1sIy3pUlzZVN3fpNZ4Qx2arVJ6tSnS/rEmXm190tQysY8uanh23fj4
neeXQhuaCGkBsqX5CpHt2aKYqJ831qsaHEKU5+lvrPKYpq0aXpGcLZ5jOMWYA+9A
7xarssoOHzNs9YDZBQ03oqV1/OBveJGdWVQbLSOMYJyeQzFWvDaexG+RKArrSxJx
TMkXW4ld8kevPHqbQyRR3VQLvWXV7gyyUtGEsD3Xeq/DxCGOf+MOv5ckt9ttEWTr
yi2WVDG+gMI9jzD/cbRt
=Fnhe
-----END PGP SIGNATURE-----

--ni93GHxFvA+th69W--
