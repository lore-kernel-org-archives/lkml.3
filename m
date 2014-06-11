Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbaFKK5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 06:57:40 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54027 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbaFKK5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 06:57:39 -0400
Date: Wed, 11 Jun 2014 12:57:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        tkhai@yandex.ru
Subject: Re: [PATCH 1/2] sched: Rework migrate_tasks()
Message-ID: <20140611105733.GM6758@twins.programming.kicks-ass.net>
References: <20140611093417.27807.2288.stgit@tkhai>
 <1402480330.32126.14.camel@tkhai>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XZn3P0VKTizxZG2b"
Content-Disposition: inline
In-Reply-To: <1402480330.32126.14.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XZn3P0VKTizxZG2b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2014 at 01:52:10PM +0400, Kirill Tkhai wrote:
>=20
> Currently migrate_tasks() skips throttled tasks,
> because they are not pickable by pick_next_task().
>=20
> These tasks stay on dead cpu even after they
> becomes unthrottled. They are not schedulable
> till user manually changes their affinity or till
> cpu becomes alive again.
>=20
> But for user this looks completely untransparent:
> task hangs, but it's not obvious what he has to do,
> because kernel does not report any problem.
>=20
> This situation may easily be triggered intentionally.
> Playing with extremely small cpu.cfs_quota_us causes
> it almost in 100% cases. In usual life it's very rare,
> but still possible for some unhappy user.
>=20

How about fixing the unthrottle code to validate the affinity?

--XZn3P0VKTizxZG2b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTmDYcAAoJEHZH4aRLwOS64PcQAIaOBL7z/KHdYEUbP9SItKGU
L02yisNuIWajFywwwAiZ+q6CHCQTtcJTVvPdwdcj0Frr5xxjOi/a8++oqtE9RBgi
Rab3yviAis8/eTcLMCDOyNQQjkB3MpiUeht2LrwXwUPu1QIAFHTpGRL+8yGdRS5u
MCtV/AEH2EzaGTwrAtL5vnAF1tLpj1aokCpotm1lVy9RBuESZZFIBBqhx0wUGWHU
VGr/cGPtdWwUk+k08iLcEh42FTFdhNCT9WfnDO/7qqRQL951Xpp4iN3ZiXVheA65
GxKzZZiqwJ7LjvnBRGkh29+PUnDGlb9XsFwt4h5FilGImlb4AWY5x4F4jPhaABoK
noQ0qa4VUsaYcQyJ9phvs6ol3cMuJ9yOMX+H52kJNvciakGQtp60VQCLpdjW0QD7
Z5v0DWmr5KG09MPNoc+2jmyl9mqPPQrU6Rp3tkom9aPlEmfF5cEcBlYgFapsxmNg
ON4ujUTrUfzFTh4Og6fcc6VXkGshT2M3mIlFSkzXqp0Al9/h9mvSP+p27Cb1whfb
+zBaAW5ZXKYWkc5KkwSiBUKIbmFaX6+G/EsL0AaN136KfsqGVF6hgiL9q0AAc0DG
zZ0H5d3FvAxBHLTTe56npbnZNloeHXZCcgoH1VjfFoZu9X1PBarVbs2bI3un7Y/U
APk82P1jFjqvE2yaTnl7
=hsKO
-----END PGP SIGNATURE-----

--XZn3P0VKTizxZG2b--
