Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaGBN3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:29:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53958 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbaGBN3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:29:07 -0400
Date: Wed, 2 Jul 2014 15:28:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH V4 10/16] perf, core: simplify need branch stack check
Message-ID: <20140702132856.GF19379@twins.programming.kicks-ass.net>
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
 <1404118253-19532-11-git-send-email-zheng.z.yan@intel.com>
 <20140702105737.GC6758@twins.programming.kicks-ass.net>
 <CABPqkBT2ZTC4Q3L9KwNfAs05qQvRFUZYvQ4QXJmiFeL-jwWSSw@mail.gmail.com>
 <20140702122757.GB19379@twins.programming.kicks-ass.net>
 <CABPqkBRUSjwfMbdapcq0hMJgVMfAqe9fFcCuvdPWV4iqZBbpTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QNDPHrPUIc00TOLW"
Content-Disposition: inline
In-Reply-To: <CABPqkBRUSjwfMbdapcq0hMJgVMfAqe9fFcCuvdPWV4iqZBbpTw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QNDPHrPUIc00TOLW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 02, 2014 at 03:00:52PM +0200, Stephane Eranian wrote:
> He is probably talking about precise=2 for non HSW PMU.
> But it is true,  you need to look at x86_pmu_hw_config()
>  *br_type = PERF_SAMPLE_BRANCH_ANY;

Ah! indeed. And that is why I didn't find it, I was looking:
"branch_sample_type[[:space:]]*=" and we've obscured it with that
br_type thing.

--QNDPHrPUIc00TOLW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTtAkXAAoJEHZH4aRLwOS6UFQQAJBlGgAGMF9fDbcWvRcIBpU8
iJnczPYe37qh0YJSc0nU/NfyTNG5yM7YWSr1y6/4ViEBDDFSjLti7bFRdX661IIU
FGArxATpF++5fzbIMZ25QT+4poUnhKpDR2pMEfQy0Na//88ZEuWTT1flkgMATpjE
rI4QVjhfCM+xfCoPD48QBrWgU+Id13wrW81BKD40fki0nUyhdusInlh6zIWfPf7w
0U4mJ9RjUv/DlQ5bTU0rL7OxR2KUefiF4aPH10G4k7Iq/z7GZNnT0lb3U0h4LB7b
6IIFDz5IQ6+vtpL3WxH8OjMB4ODJp1q864aLWnD2xqCwUe5ZpoDCACOdfbn7EMED
9kAGNcKApnnwqJ0he/+pN11BTG0Gl2KypdHb6R5ibD85D8B18VKzcM5QTkScUanz
KzivBA5TIkV9imw3zEWE1MHGEz6HSKcmGuceGHCCJUe6Jf6bJL5t2KeVKuBJpl36
hTcpxyiDw87hed6w7Gvllf7NIFfimCKtP1XD/7YS39IIh5Ek/BDDL1uBtRIhyOij
G/NwFN/q1AOqC1iKJPZ32mP6O4bYh20W7ialTU81zAetmyyV14PWs3NAJiHitL8V
SSEEwDCMhTYEvubsfe3qVwkD4U5IjOwP597Rh039pOaNO+Su7jmmauHnG9C7Ws9m
7t71n4NnXMQbBKIdMTJT
=dyOi
-----END PGP SIGNATURE-----

--QNDPHrPUIc00TOLW--
