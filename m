Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751061Ab3BGFWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 00:22:19 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:37981 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3BGFWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 00:22:16 -0500
Date: Thu, 7 Feb 2013 16:22:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: linux-next: manual merge of the signal tree with the s390 tree
Message-Id: <20130207162205.cf749e433ad1ca45410d0aa7@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__7_Feb_2013_16_22_05_+1100_1BnAJfFpQ+gwryhr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Feb_2013_16_22_05_+1100_1BnAJfFpQ+gwryhr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/s390/Kconfig between commit ad2c429560fc ("s390/Kconfig: sort list
of arch selected config options") from the s390 tree and commits
e181ee4cd7e5 ("s390: switch to generic old sigsuspend") and 7eddd99c289a
("s390: switch to generic old sigaction()") from the signal tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/s390/Kconfig
index b220e15,ec12a35..0000000
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@@ -91,55 -129,19 +91,57 @@@ config S39
  	select ARCH_INLINE_WRITE_UNLOCK_BH
  	select ARCH_INLINE_WRITE_UNLOCK_IRQ
  	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
 -	select HAVE_UID16 if 32BIT
 +	select ARCH_SAVE_PAGE_KEYS if HIBERNATION
  	select ARCH_WANT_IPC_PARSE_VERSION
 -	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if 64BIT
 +	select BUILDTIME_EXTABLE_SORT
 +	select CLONE_BACKWARDS2
 +	select GENERIC_CLOCKEVENTS
 +	select GENERIC_CPU_DEVICES if !SMP
 +	select GENERIC_KERNEL_THREAD
  	select GENERIC_SMP_IDLE_THREAD
  	select GENERIC_TIME_VSYSCALL_OLD
 -	select GENERIC_CLOCKEVENTS
 -	select KTIME_SCALAR if 32BIT
 +	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
 +	select HAVE_ARCH_JUMP_LABEL if !MARCH_G5
 +	select HAVE_ARCH_MUTEX_CPU_RELAX
  	select HAVE_ARCH_SECCOMP_FILTER
 +	select HAVE_ARCH_TRACEHOOK
 +	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if 64BIT
 +	select HAVE_BPF_JIT if 64BIT && PACK_STACK
 +	select HAVE_CMPXCHG_DOUBLE
 +	select HAVE_CMPXCHG_LOCAL
 +	select HAVE_C_RECORDMCOUNT
 +	select HAVE_DEBUG_KMEMLEAK
 +	select HAVE_DYNAMIC_FTRACE
 +	select HAVE_FTRACE_MCOUNT_RECORD
 +	select HAVE_FUNCTION_GRAPH_TRACER
 +	select HAVE_FUNCTION_TRACER
 +	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 +	select HAVE_KERNEL_BZIP2
 +	select HAVE_KERNEL_GZIP
 +	select HAVE_KERNEL_LZMA
 +	select HAVE_KERNEL_LZO
 +	select HAVE_KERNEL_XZ
 +	select HAVE_KPROBES
 +	select HAVE_KRETPROBES
 +	select HAVE_KVM if 64BIT
 +	select HAVE_MEMBLOCK
 +	select HAVE_MEMBLOCK_NODE_MAP
  	select HAVE_MOD_ARCH_SPECIFIC
 +	select HAVE_OPROFILE
 +	select HAVE_PERF_EVENTS
 +	select HAVE_REGS_AND_STACK_ACCESS_API
 +	select HAVE_SYSCALL_TRACEPOINTS
 +	select HAVE_SYSCALL_WRAPPERS
 +	select HAVE_UID16 if 32BIT
 +	select HAVE_VIRT_CPU_ACCOUNTING
 +	select INIT_ALL_POSSIBLE
 +	select KTIME_SCALAR if 32BIT
  	select MODULES_USE_ELF_RELA
 -	select CLONE_BACKWARDS2
 -	select OLD_SIGSUSPEND3
+ 	select OLD_SIGACTION
++	select OLD_SIGSUSPEND3
 +	select SYSCTL_EXCEPTION_TRACE
 +	select USE_GENERIC_SMP_HELPERS if SMP
 +	select VIRT_CPU_ACCOUNTING
 =20
  config SCHED_OMIT_FRAME_POINTER
  	def_bool y


--Signature=_Thu__7_Feb_2013_16_22_05_+1100_1BnAJfFpQ+gwryhr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJREzn9AAoJEECxmPOUX5FESrMP/iRNCc64B3tsDKTrN0pR0R75
B6zRkbfTEm63MiV25Qr3qiWbpQ7o+gPZUmhNIiDdEJBNys04MT5fCXcjVWlNqZGm
EJOWVGW35rx3MJrYB+VfiW2GSj/7sMrFFV6bDuauKa1aV2VBwedDmKqIXpg3T/Yd
p5D2jMcazmlkKwTHWEVcnsGSciDA/KDG0vD1jyveOux6X4UTomHUiiH9QL7jlboR
u4bYckuC1BnEsnZpORHE0nj616/KjsIsCzenSyOpw2kM1Ry8uRRWS9hfBGrTT61L
6Kd/L7qgwtiMgTPNv1NOzxJK2olLgNSY116ShlxSLYZA2kqWTRySFp3SK2DA8Xet
0Y99Z0Bz0bizkZzSpv+wBBKlTrx98YWZbiMM1w6xZzKn03lii3ZBuRHYOWrYNIE2
W4orspv85Gn5aonCTewsVNzs2dRQ5F45GKbUKJBlnP90I5eqkHysp5nhbYGavxRz
6r5Pasc3qyM6Oz1UScYSTVQc7d3o1AqquZbiiIm78X50LccLkGSKS4QbXGD4Jjox
OXP8u7QSMOY7PYbOafEwzcF42T5QsTmbPDFkr03ZwyT7GgqgBRMmGP7Lrvj/SH5H
8PIRn2icO5X//CXt5Nxk+zj3JkE1owxzUzBs67zfrlRX50oKEN7OPpsJ2l4YlVjU
uyGuSsIttXLvW22c+2XL
=bMla
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Feb_2013_16_22_05_+1100_1BnAJfFpQ+gwryhr--
