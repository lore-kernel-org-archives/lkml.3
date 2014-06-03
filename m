Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540AbaFCH4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:56:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:40127 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbaFCH4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:56:23 -0400
Date: Tue, 3 Jun 2014 09:56:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: John David Anglin <dave.anglin@bell.net>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, jejb@parisc-linux.org,
        deller@gmx.de, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, chegu_vinod@hp.com,
        paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com, tglx@linutronix.de,
        riel@redhat.com, akpm@linux-foundation.org, davidlohr@hp.com,
        hpa@zytor.com, andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH] fix a race condition in cancelable mcs spinlocks
Message-ID: <20140603075616.GJ11096@twins.programming.kicks-ass.net>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
 <20140601192026.GE16155@laptop.programming.kicks-ass.net>
 <BLU0-SMTP387BD0AE22A4EAD432D65F97210@phx.gbl>
 <20140601213003.GG16155@laptop.programming.kicks-ass.net>
 <1401739000.12939.34.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3nbTfX4V9Gs/5Yhz"
Content-Disposition: inline
In-Reply-To: <1401739000.12939.34.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3nbTfX4V9Gs/5Yhz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2014 at 12:56:40PM -0700, James Bottomley wrote:
> Architecturally, there is a way we could emulate the atomic exchange
> instructions.  We could have a special section of memory that always
> triggers a page trap.  In the Q state dtlb trap handlers we could
> recognise the "atomic" section of memory and wrap the attempted
> modification in a semaphore.  This would add a bit of overhead, but not
> a huge amount if we do it in the trap handlers like the TMPALIAS
> flushes.  This involves a lot of work for us because we have to decode
> the instructions in software, recognise the operations and manually
> apply the hashed semaphores around them.  If we did it like this, all
> we'd need by way of mainline support is that variables treated as
> atomically exchangeable should be in a separate section (because it's a
> page fault handler effectively, we need them all separated from "normal"
> code).  This would probably require some type of variable marker and if
> we ever saw a xchg or cmpxchg on a variable without the marker, we could
> break the build.

Cute, but I don't think that's entirely feasible given how these things
can be embedded in other structures (some dynamically allocated etc..).



--3nbTfX4V9Gs/5Yhz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjX+gAAoJEHZH4aRLwOS6ux4P+gKgWsCBL126J4OGdL6sRbOu
0dg/ShhoNJJaX4J7hZYkH1IVhzcSJMC0qOj0aHXGxs2DaaPDdL4b9VjPBwLW5GSK
ZmF4mvwf2sRbib2RcKSugWSdnuMRMOp71xN1CigAa6if3bEm342m+XXdZcNxigMJ
yoR4tjTwSSKgCwGDcI75PjBo9VPMc6S04a+kDDcKdSz28s2fwKR0HE6DaWcAiqOa
8P4Czm0pGkX8uohYf0e98FBDhj/Q9j9uJqMCL3TcfR1yjfxFnJTXZp+963JROFay
cxRjN40zDJHEZlyvJDjRv0zFsCeuozf0exAwfXqvUY5tK9TcnCBLdkj9tic7w7TO
iU6kQWTTCsUnG209L9cI5zrNkLl7N0uB0W1pC6SoBwCSCMBWraDLGoKKFPyNEgX7
aqrdMD/8eEWNTWCapF01sEV776XVR8QNiAlsHKN0S2Sp1RpOEHOFq3Iuh/eUWIMx
Cbox2pjEUwQ/wcuJMA2Reomjg51aAjqAzg9sKAYnA5FCaUm4yDpG+6reYUgc4KUd
SatcSq/UC+pb/kxShnTXDmqCLoR24F2LAvpdeACFZjJE3W7bgyw3tAP/bwypJNNo
xLr4A9Hvya3cqiYKvjdKnrbhi9x1VsWVtnqC+0sBjdVrOoCsNuoViKdoUWBDB75C
Zz0pMusI7A19MGRlfrNC
=cgFT
-----END PGP SIGNATURE-----

--3nbTfX4V9Gs/5Yhz--
