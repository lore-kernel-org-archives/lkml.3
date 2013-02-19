Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab3BSFbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 00:31:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27197 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab3BSFar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 00:30:47 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=RTtc58_2J5QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=m73QEpYNExAA:10 a=VwQbUJbxAAAA:8 a=P3vMpniSKFg0jnI0z7IA:9 a=QEXdDO2ut3YA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=4HihIYjQhJrrn8PUYq0A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130219053045.159201564@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 19 Feb 2013 00:30:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, <stable-rt@vger.kernel.org>
Subject: [PATCH 1/4] x86/32: Use kmap switch for non highmem as well
References: <20130219053021.721159211@goodmis.org>
Content-Disposition: inline; filename=0001-x86-32-Use-kmap-switch-for-non-highmem-as-well.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Thomas Gleixner <tglx@linutronix.de>

Even with CONFIG_HIGHMEM=3Dn we need to take care of the "atomic"
mappings which are installed via iomap_atomic.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/process_32.c |    2 +-
 include/linux/sched.h        |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 95f2630..4a0d37f 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -336,7 +336,7 @@ __switch_to(struct task_struct *prev_p, struct task_str=
uct *next_p)
 		     task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT))
 		__switch_to_xtra(prev_p, next_p, tss);
=20
-#if defined CONFIG_PREEMPT_RT_FULL && defined CONFIG_HIGHMEM
+#ifdef CONFIG_PREEMPT_RT_FULL
 	/*
 	 * Save @prev's kmap_atomic stack
 	 */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8772834..285ab45 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1602,9 +1602,11 @@ struct task_struct {
 	struct rcu_head put_rcu;
 	int softirq_nestcnt;
 #endif
-#if defined CONFIG_PREEMPT_RT_FULL && defined CONFIG_HIGHMEM
+#ifdef CONFIG_PREEMPT_RT_FULL
+# if defined CONFIG_HIGHMEM || defined CONFIG_X86_32
 	int kmap_idx;
 	pte_t kmap_pte[KM_TYPE_NR];
+# endif
 #endif
=20
 #ifdef CONFIG_DEBUG_PREEMPT
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRIw4FAAoJEOdOSU1xswtM5nMH/3CxaZJTIQPgH1mBvOtYEvBF
1UF4kxaErZIsuX7AxtHk8TiA3v6ssl2+4mc2srmGMQryjkUNHXTT+6o/z7xy+t2j
sGI9iURiRULODEtT4xk9i7QIFtZqPijII/PzSHYcrHTHtsymFV9gQn+YMWNEzUKa
EFYMa+tRHoKT6NEabxfNX39OnwVXLq5KAAHv6J8b9m0iYHHnetrHrcXBepUfek/k
tde6Nhae5Zi/yN0qCmyWf5ovGQyT341NhQjUBDcvUaQu2u6tm0qmvRlorC+gF3Sg
NYtLu7WUIczNsDmjUJgTTZeKfBLQ57KkKOyhqZvKr45vfqSBwcPRJXqyfeP6Vko=
=Yhyt
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
