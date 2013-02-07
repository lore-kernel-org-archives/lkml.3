Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab3BGCvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 21:51:09 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51920 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607Ab3BGCvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 21:51:05 -0500
Date: Thu, 7 Feb 2013 13:50:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: linux-next: manual merge of the tip tree with the s390 tree
Message-Id: <20130207135045.bf4dac00c7f359b70fab7374@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__7_Feb_2013_13_50_45_+1100_VyG3s=Cd4B.6iYFM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Feb_2013_13_50_45_+1100_VyG3s=Cd4B.6iYFM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/s390/Kconfig between commit ad2c429560fc ("s390/Kconfig: sort list
of arch selected config options") from the s390 tree and commit
6147a9d8070e ("irq_work: Remove CONFIG_HAVE_IRQ_WORK") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/s390/Kconfig
index 17775cf,c15ba7d..0000000
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@@ -91,56 -128,17 +91,55 @@@ config S39
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
- 	select HAVE_IRQ_WORK
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
 +	select SYSCTL_EXCEPTION_TRACE
 +	select USE_GENERIC_SMP_HELPERS if SMP
 +	select VIRT_CPU_ACCOUNTING
 =20
  config SCHED_OMIT_FRAME_POINTER
  	def_bool y

--Signature=_Thu__7_Feb_2013_13_50_45_+1100_VyG3s=Cd4B.6iYFM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRExaFAAoJEECxmPOUX5FEq2YP/0e1v+P2UppspNsUdEev24ve
8Ngdrd+dLOFoQSEcmk/2yf6Wr1F/Q14ylmose9AGwACtTn4/uMKZkecYXXU/+U/b
BSrUskfn9WJVJsZgFAsZ9X3ROEimV/I2DoKEbY7WydEBf38EvvUF2gXV9LFobPGv
VXPbeq9f/qCq3tYQmlj5GPuDev0Q7zU6obxGb+Iv/kdXgQFbO9Q5O7Ndgya+L+jq
0o1vUhbUct1WaaGOUiD5IhQeL3zwsCCXEPoHu8KdSFQ7Ncen2Z2z4LY7KJxkL7IG
7AdYz0CqnifEBvIcV+fKMrA4b4H9Ut/ae4NxxylppADQA9W/dh7+8Nc/Wks/qBKe
lXDkf1fsVC0RKANeLRyV+YwKXdFEWHcxHLTq0GvGKpqln5LVEMJUmSQetbxewnXS
xUamTAfyy8U1q+tIe7vDV4pH81WEfVY+s8nY6cfFTAMcIsIjVfY5+bxNYveUa3ja
ANtVbWRVicOu+fQA7udlSI5nWSFIg20RRX7ZNjfmrQyYWjD+4ypzonSThfjKIfNH
8TPUugZyeSsSs+0m4uHpYtUSJ0J4TZrBwlxOVAlL295oMrh+V0eATUBWdT87C8EO
dcuv/U3l7h2P2J2dYPiZr5PsaYLd7NL+FVyukfDiXBZ5029JFp2UpOf/nhIBzUKo
oFkedSRItikg1wk6IDw/
=nJJ1
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Feb_2013_13_50_45_+1100_VyG3s=Cd4B.6iYFM--
