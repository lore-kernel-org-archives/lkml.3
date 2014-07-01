Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbaGAI5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:57:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:54439 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515AbaGAI5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:57:09 -0400
Date: Tue, 1 Jul 2014 10:56:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: select 'idle' cfs_rq per task-group to prevent
 tg-internal imbalance
Message-ID: <20140701085658.GM6758@twins.programming.kicks-ass.net>
References: <53A11A89.5000602@linux.vnet.ibm.com>
 <20140623094251.GS19860@laptop.programming.kicks-ass.net>
 <53A8F1DE.2060908@linux.vnet.ibm.com>
 <20140701082020.GL6758@twins.programming.kicks-ass.net>
 <53B273A2.5050500@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Oaap7OtF9SpYl9KE"
Content-Disposition: inline
In-Reply-To: <53B273A2.5050500@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Oaap7OtF9SpYl9KE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 01, 2014 at 04:38:58PM +0800, Michael wang wrote:
> On 07/01/2014 04:20 PM, Peter Zijlstra wrote:
> [snip]
> >>
> >> Just wondering could we make this another scheduler feature?
> >=20
> > No; sched_feat() is for debugging, BIG CLUE: its guarded by
> > CONFIG_SCHED_DEBUG, anybody using it in production or anywhere else is
> > broken.
> >=20
> > If people are using it, I should remove or at least randomize the
> > interface.
>=20
> Fair enough... but is there any suggestions on how to handle this issue?
>=20
> Currently when dbench running with stress, it could only gain one CPU,
> and cpu-cgroup cpu.shares is meaningless, is there any good methods to
> address that?

So as far as I understood this is because of 'other' tasks; these other
tasks have never been fully qualified, but I suspect they're workqueue
thingies. One solution would be to have work run in the same cgroup as
the task creating it.

The thing is, this is not a scheduler problem, so we should not fix it
in the scheduler.

--Oaap7OtF9SpYl9KE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTsnfaAAoJEHZH4aRLwOS69AUP/2hGAyoJQRpc9Ri+BzqmQc0q
I15CYWZy4M5P4s65ELC3f1OKbp4m0HiuPwjWlwG8NjgrLJ+hEGBMJPzHopqpF1dS
l8x8xPAw4D9k/P2k4WzdzlLnAtMHrwNdzDdgqavwmQio8Zj1DEzxcvuFiriif6Em
Xzb5Rn9KthJhoF2bTdgaEF6YZvol+IMEuOurvnJP+45AqrHB30w3iOsVMBfaR9jy
tL6ndjTEaYrbAwrwI1Ypz/MXeuCSWEZ5pJMqV5v7l4M36zgZabJvxv35qmY/ZC2m
3jhiTes2YufgnO6RFedthJfJ1OW+ugrojJuWTlXpJBSAqdRAErKukpSRsUylRHbZ
PVLAlwuA0DbCbSi+09V27SgueUQEw+cWP6D3zxUnpxkZGe4K5VgAeKVUCJW+qF9B
33hmX5pD8IC52DQB4yOFb2AeGbwNJ1aPnd0YgYclvOyhLFZNuw38gOYk7G476M7S
H6S09Ut3JmMXOHyevnqpdGoGiwvUnuNgVTRDhs5HIqPpSp/wFJG29GYbaWZjlYQ3
zhPYfjP2bpPt/KSKofoMTFh/jZhdcnGfmVuWq/XoY8eus2hGX06uSYI3IANTdKZT
ghPGss5kxtL+FhIK9wl4PV4TLwdPcvFPWbBQun3SbMwaK08zDHcyUhUmUtkZpb/C
wYTjiFZ4aSzi1Ze9I551
=O9BK
-----END PGP SIGNATURE-----

--Oaap7OtF9SpYl9KE--
