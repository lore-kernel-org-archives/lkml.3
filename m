Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbaGBR0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:26:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:33585 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186AbaGBR0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:26:10 -0400
Date: Wed, 2 Jul 2014 19:26:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC tip/core/rcu] Parallelize and economize NOCB kthread
 wakeups
Message-ID: <20140702172600.GR19379@twins.programming.kicks-ass.net>
References: <20140627142038.GA22942@linux.vnet.ibm.com>
 <20140702123412.GD19379@twins.programming.kicks-ass.net>
 <20140702153915.GQ4603@linux.vnet.ibm.com>
 <20140702160412.GO19379@twins.programming.kicks-ass.net>
 <20140702170838.GS4603@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BnCwdHgQ2ZomtW9r"
Content-Disposition: inline
In-Reply-To: <20140702170838.GS4603@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BnCwdHgQ2ZomtW9r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 02, 2014 at 10:08:38AM -0700, Paul E. McKenney wrote:
> As were others, not that long ago.  Today is the first hint that I got
> that you feel otherwise.  But it does look like the softirq approach to
> callback processing needs to stick around for awhile longer.  Nice to
> hear that softirq is now "sane and normal" again, I guess.  ;-)

Nah, softirqs are still totally annoying :-)

So I've lost detail again, but it seems to me that on all CPUs that are
actually getting ticks, waking tasks to process the RCU state is
entirely over doing it. Might as well keep processing their RCU state
=66rom the tick as was previously done.



--BnCwdHgQ2ZomtW9r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTtECoAAoJEHZH4aRLwOS64v8QAKbkO35TQci9SIbBgt+1AJMz
j40gjV72OVfGKH9DAV7GYqC62PYzvjMdGTpL0zSt2++SzpAoVX0yjI9Ng8RZVMUe
gZsTPDIARljxkcaZJ2hw+w/IHsiSkm7GaiByFrBEySnJStWZLb2Rr+4chQ8N7Vtk
+Wd6nD81pNisxdRJBu20IvfQBvhVCKQMorZ6lB6W/2CcB4Jd7uNeSRNbf8j/P/PT
YyKlJygwYRdDF+32KICJA7Kq5kNbtjN9ErJQC54oJFboZyxKEgEj6+g8uTiuk0AI
yc5VeWbcS4az5nOqL7q+9XaJyDKxd0usC6cDA65u2GZx04BJk7r7gL1/Xk76kyKm
kTOl8Vj7T/ZHaN5MACRWWpl7xodz2L31jPDiMP2gqt8mcSnKNPMF4Ek4cDL5y6tr
+PJGrEyl0zYlgtdl62uiCBxtY2fkI9xn5KBGYff+Gxbck7nnF/KvDmpCQkQWV/5V
otrMPPBPqyxi74CZ8nQtcY1sumlfV9/p821ZjpjmbLr/F6Vv06TOOO7Jj8yuDEW1
UTJb5OA44ftZQEbJDCYFsjd5J38IgPrc4fueTwpvjCVuAI5fYNABLVmrgd87E2JM
aOCsTGXJ89TLRBdnwlKr9xylU6QqBjRMZFwFPtaOCwc2GjkCZ45dtWPx9nrSm4wu
S7RWJgPgfDs3nnr/RhOr
=lQRe
-----END PGP SIGNATURE-----

--BnCwdHgQ2ZomtW9r--
