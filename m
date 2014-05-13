Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760522AbaEMJrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:47:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:40302 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760503AbaEMJrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:47:43 -0400
Date: Tue, 13 May 2014 11:47:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
Message-ID: <20140513094737.GU30445@twins.programming.kicks-ass.net>
References: <537192D3.5030907@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pKNzOuX3zSqsavrh"
Content-Disposition: inline
In-Reply-To: <537192D3.5030907@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pKNzOuX3zSqsavrh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2014 at 11:34:43AM +0800, Michael wang wrote:
> During our testing, we found that the cpu.shares doesn't work as
> expected, the testing is:
>=20

/me zaps all the kvm nonsense as that's non reproducable and only serves
to annoy.

Pro-tip: never use kvm to report cpu-cgroup issues.

> So is this results expected (I really do not think so...)?
>=20
> Or that imply the cpu-cgroup got some issue to be fixed?

So what I did (WSM-EP 2x6x2):

mount none /cgroup -t cgroup -o cpu
mkdir -p /cgroup/a
mkdir -p /cgroup/b
mkdir -p /cgroup/c

echo $$ > /cgroup/a/tasks ; for ((i=3D0; i<12; i++)) ; do A.sh & done
echo $$ > /cgroup/b/tasks ; for ((i=3D0; i<12; i++)) ; do B.sh & done
echo $$ > /cgroup/c/tasks ; for ((i=3D0; i<12; i++)) ; do C.sh & done

echo 2048 > /cgroup/c/cpu.shares

Where [ABC].sh are spinners:

---
#!/bin/bash

while :; do :; done
---

for i in A B C ; do ps -deo pcpu,cmd | grep "${i}\.sh" | awk '{t +=3D $1} E=
ND {print t}' ; done
639.7
629.8
1127.4

That is of course not perfect, but it's close enough.

Now you again.. :-)

--pKNzOuX3zSqsavrh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTceo5AAoJEHZH4aRLwOS6hhkP/1HHcptQvXhAtWlZ7m17r9js
TMzpRjMFso3BUE6ZAzY2MEQIwlLPKkckBimdHEgc+u1QN6qWs9wkmfMI+p1ka7UI
ZYmLVqde5UjhXO3kU63XsCyiuThFYl8tWFRCS3nL8cvGeXI9qsojYvUAx6fmfYtW
r2nZx1tzRmusF/o0uTC4eL4MjHDBEZzkslsMNEqj4ymdf+rlMYcLgbkmmtK3o/kq
h9W6/5eEY+jKGze3YfqUelkfotkGp7STSh4cFJ7Q1ICkcgaAzF+nTa0ofbNtp020
jtW6xSava7iCPQrvXP7uUvspro1QTjwtp91AaQ0aBjUKwn4krcGU9PF2HS9LeiE1
TOtbf+/orZyTsOXGRYUUBY6YV5f+xATKRzTm12d/w0/5X1mpQ/q1Ffl/m9MjBd3q
sjs+fDH9How1autKTbNAjVucLDdbhK+bs5KE4MDU/9V0m30aZqOgQ9s+60YDljEe
THpZjh+/rXnWa7VDGBaortiC+PtZ6E8apJiG5kDxDZVcFNUs4eixpMcOdwLDRmRc
Oigd0qCw2tQIjkY35+w15myVyw8184LIPPhbz9Vts+kZYF1meeYOt0ku2pSVjVDI
/th5EudvdT9ujWPAvLigJ56IFOc6wSFi/WRrI1Q9UoleFD9U44BwdVLgH83DONND
TczOS8BF8MLwPAZNxIUu
=W4D/
-----END PGP SIGNATURE-----

--pKNzOuX3zSqsavrh--
