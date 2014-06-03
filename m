Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295AbaFCGvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 02:51:11 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52162 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbaFCGvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 02:51:10 -0400
Date: Tue, 3 Jun 2014 08:51:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        nicolas.pitre@linaro.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/8] sched,idle: need resched polling rework
Message-ID: <20140603065101.GF11096@twins.programming.kicks-ass.net>
References: <20140411134243.160989490@infradead.org>
 <CALCETrWJZ1-T+qOY9v=KBOSJkck7YYe7khw_dYPc9Ar8WFgMKw@mail.gmail.com>
 <20140522125818.GV30445@twins.programming.kicks-ass.net>
 <20140522130931.GV13658@twins.programming.kicks-ass.net>
 <CALCETrVBVOjs0EVqEz3qKtSHQg1agJzAyG4Ohqueky-zPF7uKA@mail.gmail.com>
 <20140529064827.GI19143@laptop.programming.kicks-ass.net>
 <CALCETrWnG7fSuinDv+GAHsnTLJ-6xn+_1LB2XdLGVXcC=TQURA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NbUNL4d9A9kY58qh"
Content-Disposition: inline
In-Reply-To: <CALCETrWnG7fSuinDv+GAHsnTLJ-6xn+_1LB2XdLGVXcC=TQURA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NbUNL4d9A9kY58qh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 02, 2014 at 11:40:26PM -0700, Andy Lutomirski wrote:
> Bugs found so far:
>=20
> defined(SMP) should be defined(CONFIG_SMP)
>=20
> You're testing polling on the task being woken, which cannot possibly
> succeed: the only tasks that have any business polling are the idle
> tasks.  Something like this seems to help:

Urgh,. comes from doing too many things at once.. Thanks, I'll go fix
up.

--NbUNL4d9A9kY58qh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjXBQAAoJEHZH4aRLwOS6ugsP/1W8SssrxVdkUb0Q3w8MRtLp
Y/rVgYhFDXADLeIkNOt9B2GQYM6/tkrtM0WmeC3pVtzX/gIhXZH1kwXWRJv8RVFX
lAIHyBOM07HzL2Uk8dOXiaABENjP4imoY72k9Hdiux/vdvcPS0ZADlk6qbrge210
zKwVOTc7nKBBW8kePoFFJbdjG4PhofGsdXzhNwDuK+YLFYTsIkNRKEv7Hp+jx6fk
dZ/pEAv1xirRcjiuM8pN2QCUDIq3fIjfK78jetNwULbkWLRzLbsQlsRdhXt5u3VO
M5uzd80r4wpvTLDGDKDPmJk4HimnI6CS2I76zRrhk6qGhIk8zzK7nZFiZHUCN/bf
UD78SomDb1bpp8MurseNsrJSF8SEQwxs2x/P1QGKQAJ8oIVAUlBUse1FGO56rm07
z5aEZLpGz5+xXLmKrRrtHy1xTKLOTTRVRLZWQLfxzEfIIKnk8tqk9TIC/Bjcw3EC
LBsVyKeSSgpYr820ApnGavoGTvvTn15rkfYEMzIz5hvHwJgikZ/H5TiH6wKifMIn
8qs1AKOAOaF5FB3w1kcRQ0J3hXGVWJD2VcMT0NVRIh3B0b7t6bq4TqbgUSaqVRFF
eUr3NrWCesF28qHAmd2zbrt5c98HN87IqSEHsjfu4zWnjpVIUFmyRmzL3m3t/tNl
+YL9jRcVaMJff8l7Z/t2
=zOU1
-----END PGP SIGNATURE-----

--NbUNL4d9A9kY58qh--
