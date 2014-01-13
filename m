Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbaAMGRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 01:17:39 -0500
Received: from ozlabs.org ([203.10.76.45]:50541 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbaAMGRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 01:17:37 -0500
Date: Mon, 13 Jan 2014 17:17:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20140113171721.18c5040e97965d3bcb19d515@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_Jan_2014_17_17_21_+1100_=PgCJ83Os0zK/tjN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Jan_2014_17_17_21_+1100_=PgCJ83Os0zK/tjN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
kernel/softirq.c between commit c795eb55e740 ("sched/preempt, locking:
Rework local_bh_{dis,en}able()") from the tip tree and commit  ("softirq:
use const char * const for softirq_to_name, whitespace neatening") from
the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/softirq.c
index e60c41d0087a,527520152ad2..000000000000
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@@ -138,10 -149,9 +138,9 @@@ void _local_bh_enable(void
  	WARN_ON_ONCE(in_irq());
  	__local_bh_enable(SOFTIRQ_DISABLE_OFFSET);
  }
-=20
  EXPORT_SYMBOL(_local_bh_enable);
 =20
 -static inline void _local_bh_enable_ip(unsigned long ip)
 +void __local_bh_enable_ip(unsigned long ip, unsigned int cnt)
  {
  	WARN_ON_ONCE(in_irq() || irqs_disabled());
  #ifdef CONFIG_TRACE_IRQFLAGS
@@@ -155,8 -165,8 +154,8 @@@
  	/*
  	 * Keep preemption disabled until we are done with
  	 * softirq processing:
-  	 */
+ 	 */
 -	preempt_count_sub(SOFTIRQ_DISABLE_OFFSET - 1);
 +	preempt_count_sub(cnt - 1);
 =20
  	if (unlikely(!in_interrupt() && local_softirq_pending())) {
  		/*

--Signature=_Mon__13_Jan_2014_17_17_21_+1100_=PgCJ83Os0zK/tjN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS04T1AAoJEMDTa8Ir7ZwVMFoP/20xaqZnxbIIP3MCpHcPc3vC
ztuDF4/t8SqaPXBpX7O4EwqyoNP5jH2QzvsPW44X7FYE7w2ydHnbt3xX0qHJSreF
a3j7lRSG7SDF0ApiYhQo16XFjIZM+7TQkHLPlC3nHZATNl1scYUDS+/Mqnh+gxo3
k/L5cRDX/Ucf6mrTqxaybrLi9Qn1jo4r6Qd2wOyUhwjTFnBmV5P0Od0OoOFjbVt7
R4qV9jypBqvQ6gtwGZ1NqXbD1L3K2I9omttP0ggQ904BOr7LmbXHOt5gdc3YVdiq
Rw940LEOxZAMVFRsYgY5ckUpdUeMp1VRhtLqZHm7upyYOBjNmAikb52sn0KOWxVd
h4qjx6Q/6dW76bTaoWyuOjDvc0Yn2FN9GrgVrUXQigcuunFXU0ftySzAugDcGWUT
dyMBqFAiCo2z/dix+m4zpyDZLRD61a0MAeDBDWrRz9L+n/A5CV/GQCzHqCpE6pEm
9VdPNEhV5h1VJwzBR73/y9OgreA0Yp4vofhfceItYaqaFsAhumKqHrUo2oY5F/8u
MAfGJvKeIpCkw38BubaejICJWLIJ1kt2yTuhDGDLCSPBdauYBUyKENwSt5DqbFOy
N2eK0Iqwjri7zz5JcUzLs/MbFYDmE1Zi+jr7fTy7hsnC8U/PNH9gDusD5WuwsROw
7vU8WkHr5rqZnYCJcfts
=FIHl
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Jan_2014_17_17_21_+1100_=PgCJ83Os0zK/tjN--
