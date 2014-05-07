Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaEGQ4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:56:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:39299 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaEGQ4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:56:47 -0400
Date: Wed, 7 May 2014 18:56:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 3/4 v2] nohz: Fix idle/iowait counts going backwards
Message-ID: <20140507165638.GU30445@twins.programming.kicks-ass.net>
References: <1399470094-8070-1-git-send-email-dvlasenk@redhat.com>
 <1399470094-8070-3-git-send-email-dvlasenk@redhat.com>
 <20140507142321.GA2844@laptop.programming.kicks-ass.net>
 <536A642B.7080309@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yaap9KN+GmBP785v"
Content-Disposition: inline
In-Reply-To: <536A642B.7080309@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yaap9KN+GmBP785v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2014 at 06:49:47PM +0200, Denys Vlasenko wrote:
> On 05/07/2014 04:23 PM, Peter Zijlstra wrote:
> > On Wed, May 07, 2014 at 03:41:33PM +0200, Denys Vlasenko wrote:
> >> With this change, "iowait-ness" of every idle period is decided
> >> at the moment it starts:
> >> if this CPU's run-queue had tasks waiting on I/O, then this idle
> >> period's duration will be added to iowait_sleeptime.
> >>
> >> This fixes the bug where iowait and/or idle counts could go backwards,
> >> but iowait accounting is not precise (it can show more iowait
> >> that there really is).
> >>
> >=20
> > NAK on this, the thing going backwards is a symptom of the bug, not an
> > actual bug itself.
>=20
> This patch does fix that bug.

Which bug, there's two here:

 1) that NOHZ and !NOHZ iowait accounting aren't identical
 2) that iowait accounting in general is a steaming pile of crap

Those are the only two bugs around. If you want easy, you get to fix 1,
if you want to do hard you try and fix 2.

iowait going backwards is a symptom of NOHZ iowait accounting being
broken -- as compared to !NOHZ.

Just stopping it from going backwards is not a fix for anything except
papering over symptoms, and if you thing that's a good approach to
software engineering then I'll welcome you to my killfile.

--yaap9KN+GmBP785v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTamXFAAoJEHZH4aRLwOS6/PYP/RmHRuPvxKiJ0V28LXGtG+uB
02Cu9SQ5ek8pzC4jvomuF3GiyhHvpYPXA/ZEKugkRyGfUDI6QpTpKzOoxB3wwc54
Z2NUbeSwg8c6T4ZmWWM78u2BP4ZF8+K7R/TBSco7wL3e4QLh6BjfJkoZ09/537Eb
x3ZG5nY6NgosGploPsY0dU5bi44VTsTrNpBXw7f8S/c7HorIx2QBMcUN3G5+gpEq
LR321DsKlX4EHPhH/NVleTRe9jzQAcE37XYOXisRYejKPDSras2LJeK8G63mhqX7
nUObMm9kg1+E6/b3f6PGiV7RcpVjOMoF4MS6eU1MriZEye14iP8q6CcmRmMaw4xQ
Of10ghfIJ7Ai2o8RCPSKKVsrvoXUVGxFgAf57mRhHqPRFhbJstZusJ3fjjYE/fp0
VTyGTNckENOMAq8h/HpY7gZw/fTIyXz3maj81DJug9q4Tvw2bwNoYk7ADYRZOuE1
tkmpel6U0sIIxQ4xtH9kWHTEuNpRsKqbt/EWh+ZHbkhTlezHBH3ZsRH9juhBG2hi
PaCc6vGwdRFLLIzYFYJdGTqDecj+kY1t2ZBph131qmAqZ7W9JU8L8w1GlJKw8hbC
Y2HaoNAUAJg70z22jXXDs05glOS3YJFZyXG+nVZ6DcL6UWiA0CPeGvVTT68lqoJn
JNn7kNNYTIuhBUCcUfZZ
=MmYA
-----END PGP SIGNATURE-----

--yaap9KN+GmBP785v--
