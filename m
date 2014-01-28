Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbaA1X5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:57:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36708 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaA1X5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:57:41 -0500
Date: Tue, 28 Jan 2014 15:57:14 -0800
Message-Id: <201401282357.s0SNvEBA031682@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x32 additional bits for v3.14
Cc: "H. Peter Anvin" <hpa@zytor.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 28 Jan 2014 15:57:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Despite the branch name, **most of these changes are to generic
code**.  They change types so that they make an increasing amount of
the exported uapi kernel headers usable for libc.

The ARM64 people are also interested in these changes for their ILP32
ABI.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

The following changes since commit 79dbbc60493f357912d5f1da5a23147ba0c01c7a:

  x86, x32: Use __kernel_long_t for __statfs_word (2013-12-20 16:06:21 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-x32-for-linus

for you to fetch changes up to 63159f5dcccb3858d88aaef800c4ee0eb4cc8577:

  uapi: Use __kernel_long_t in struct mq_attr (2014-01-20 14:45:33 -0800)

----------------------------------------------------------------
H.J. Lu (8):
      uapi: Use __kernel_long_t in struct timex
      uapi: Use __kernel_long_t/__kernel_ulong_t in <linux/resource.h>
      uapi, asm-generic: Use __kernel_ulong_t in uapi struct ipc64_perm
      uapi: Use __kernel_long_t in struct msgbuf
      uapi: Use __kernel_ulong_t in struct msqid64_ds
      x86, uapi, x32: Use __kernel_ulong_t in x86 struct semid64_ds
      uapi: Use __kernel_ulong_t in shmid64_ds/shminfo64/shm_info
      uapi: Use __kernel_long_t in struct mq_attr

 arch/x86/include/uapi/asm/sembuf.h | 10 +++++-----
 include/uapi/asm-generic/ipcbuf.h  |  4 ++--
 include/uapi/asm-generic/msgbuf.h  | 10 +++++-----
 include/uapi/asm-generic/shmbuf.h  | 24 ++++++++++++------------
 include/uapi/linux/mqueue.h        | 10 +++++-----
 include/uapi/linux/msg.h           |  4 ++--
 include/uapi/linux/resource.h      | 32 ++++++++++++++++----------------
 include/uapi/linux/shm.h           | 10 +++++-----
 include/uapi/linux/timex.h         | 34 +++++++++++++++++-----------------
 9 files changed, 69 insertions(+), 69 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sembuf.h b/arch/x86/include/uapi/asm/sembuf.h
index ee50c801f7b7..cc2d6a3aeae7 100644
--- a/arch/x86/include/uapi/asm/sembuf.h
+++ b/arch/x86/include/uapi/asm/sembuf.h
@@ -13,12 +13,12 @@
 struct semid64_ds {
 	struct ipc64_perm sem_perm;	/* permissions .. see ipc.h */
 	__kernel_time_t	sem_otime;	/* last semop time */
-	unsigned long	__unused1;
+	__kernel_ulong_t __unused1;
 	__kernel_time_t	sem_ctime;	/* last change time */
-	unsigned long	__unused2;
-	unsigned long	sem_nsems;	/* no. of semaphores in array */
-	unsigned long	__unused3;
-	unsigned long	__unused4;
+	__kernel_ulong_t __unused2;
+	__kernel_ulong_t sem_nsems;	/* no. of semaphores in array */
+	__kernel_ulong_t __unused3;
+	__kernel_ulong_t __unused4;
 };
 
 #endif /* _ASM_X86_SEMBUF_H */
diff --git a/include/uapi/asm-generic/ipcbuf.h b/include/uapi/asm-generic/ipcbuf.h
index 76982b2a1b58..3dbcc1e771c0 100644
--- a/include/uapi/asm-generic/ipcbuf.h
+++ b/include/uapi/asm-generic/ipcbuf.h
@@ -27,8 +27,8 @@ struct ipc64_perm {
 	unsigned char		__pad1[4 - sizeof(__kernel_mode_t)];
 	unsigned short		seq;
 	unsigned short		__pad2;
-	unsigned long		__unused1;
-	unsigned long		__unused2;
+	__kernel_ulong_t	__unused1;
+	__kernel_ulong_t	__unused2;
 };
 
 #endif /* __ASM_GENERIC_IPCBUF_H */
diff --git a/include/uapi/asm-generic/msgbuf.h b/include/uapi/asm-generic/msgbuf.h
index aec850d9159e..f55ecc43c60f 100644
--- a/include/uapi/asm-generic/msgbuf.h
+++ b/include/uapi/asm-generic/msgbuf.h
@@ -35,13 +35,13 @@ struct msqid64_ds {
 #if __BITS_PER_LONG != 64
 	unsigned long	__unused3;
 #endif
-	unsigned long  msg_cbytes;	/* current number of bytes on queue */
-	unsigned long  msg_qnum;	/* number of messages in queue */
-	unsigned long  msg_qbytes;	/* max number of bytes on queue */
+	__kernel_ulong_t msg_cbytes;	/* current number of bytes on queue */
+	__kernel_ulong_t msg_qnum;	/* number of messages in queue */
+	__kernel_ulong_t msg_qbytes;	/* max number of bytes on queue */
 	__kernel_pid_t msg_lspid;	/* pid of last msgsnd */
 	__kernel_pid_t msg_lrpid;	/* last receive pid */
-	unsigned long  __unused4;
-	unsigned long  __unused5;
+	__kernel_ulong_t __unused4;
+	__kernel_ulong_t __unused5;
 };
 
 #endif /* __ASM_GENERIC_MSGBUF_H */
diff --git a/include/uapi/asm-generic/shmbuf.h b/include/uapi/asm-generic/shmbuf.h
index 5768fa60ac82..7e9fb2f0853b 100644
--- a/include/uapi/asm-generic/shmbuf.h
+++ b/include/uapi/asm-generic/shmbuf.h
@@ -39,21 +39,21 @@ struct shmid64_ds {
 #endif
 	__kernel_pid_t		shm_cpid;	/* pid of creator */
 	__kernel_pid_t		shm_lpid;	/* pid of last operator */
-	unsigned long		shm_nattch;	/* no. of current attaches */
-	unsigned long		__unused4;
-	unsigned long		__unused5;
+	__kernel_ulong_t	shm_nattch;	/* no. of current attaches */
+	__kernel_ulong_t	__unused4;
+	__kernel_ulong_t	__unused5;
 };
 
 struct shminfo64 {
-	unsigned long	shmmax;
-	unsigned long	shmmin;
-	unsigned long	shmmni;
-	unsigned long	shmseg;
-	unsigned long	shmall;
-	unsigned long	__unused1;
-	unsigned long	__unused2;
-	unsigned long	__unused3;
-	unsigned long	__unused4;
+	__kernel_ulong_t	shmmax;
+	__kernel_ulong_t	shmmin;
+	__kernel_ulong_t	shmmni;
+	__kernel_ulong_t	shmseg;
+	__kernel_ulong_t	shmall;
+	__kernel_ulong_t	__unused1;
+	__kernel_ulong_t	__unused2;
+	__kernel_ulong_t	__unused3;
+	__kernel_ulong_t	__unused4;
 };
 
 #endif /* __ASM_GENERIC_SHMBUF_H */
diff --git a/include/uapi/linux/mqueue.h b/include/uapi/linux/mqueue.h
index 8b5a79615fbf..d0a2b8e89813 100644
--- a/include/uapi/linux/mqueue.h
+++ b/include/uapi/linux/mqueue.h
@@ -23,11 +23,11 @@
 #define MQ_BYTES_MAX	819200
 
 struct mq_attr {
-	long	mq_flags;	/* message queue flags			*/
-	long	mq_maxmsg;	/* maximum number of messages		*/
-	long	mq_msgsize;	/* maximum message size			*/
-	long	mq_curmsgs;	/* number of messages currently queued	*/
-	long	__reserved[4];	/* ignored for input, zeroed for output */
+	__kernel_long_t	mq_flags;	/* message queue flags			*/
+	__kernel_long_t	mq_maxmsg;	/* maximum number of messages		*/
+	__kernel_long_t	mq_msgsize;	/* maximum message size			*/
+	__kernel_long_t	mq_curmsgs;	/* number of messages currently queued	*/
+	__kernel_long_t	__reserved[4];	/* ignored for input, zeroed for output */
 };
 
 /*
diff --git a/include/uapi/linux/msg.h b/include/uapi/linux/msg.h
index 22d95c6854e0..a70375526578 100644
--- a/include/uapi/linux/msg.h
+++ b/include/uapi/linux/msg.h
@@ -34,8 +34,8 @@ struct msqid_ds {
 
 /* message buffer for msgsnd and msgrcv calls */
 struct msgbuf {
-	long mtype;         /* type of message */
-	char mtext[1];      /* message text */
+	__kernel_long_t mtype;          /* type of message */
+	char mtext[1];                  /* message text */
 };
 
 /* buffer for msgctl calls IPC_INFO, MSG_INFO */
diff --git a/include/uapi/linux/resource.h b/include/uapi/linux/resource.h
index e0ed28477f48..36fb3b5fb181 100644
--- a/include/uapi/linux/resource.h
+++ b/include/uapi/linux/resource.h
@@ -23,25 +23,25 @@
 struct	rusage {
 	struct timeval ru_utime;	/* user time used */
 	struct timeval ru_stime;	/* system time used */
-	long	ru_maxrss;		/* maximum resident set size */
-	long	ru_ixrss;		/* integral shared memory size */
-	long	ru_idrss;		/* integral unshared data size */
-	long	ru_isrss;		/* integral unshared stack size */
-	long	ru_minflt;		/* page reclaims */
-	long	ru_majflt;		/* page faults */
-	long	ru_nswap;		/* swaps */
-	long	ru_inblock;		/* block input operations */
-	long	ru_oublock;		/* block output operations */
-	long	ru_msgsnd;		/* messages sent */
-	long	ru_msgrcv;		/* messages received */
-	long	ru_nsignals;		/* signals received */
-	long	ru_nvcsw;		/* voluntary context switches */
-	long	ru_nivcsw;		/* involuntary " */
+	__kernel_long_t	ru_maxrss;	/* maximum resident set size */
+	__kernel_long_t	ru_ixrss;	/* integral shared memory size */
+	__kernel_long_t	ru_idrss;	/* integral unshared data size */
+	__kernel_long_t	ru_isrss;	/* integral unshared stack size */
+	__kernel_long_t	ru_minflt;	/* page reclaims */
+	__kernel_long_t	ru_majflt;	/* page faults */
+	__kernel_long_t	ru_nswap;	/* swaps */
+	__kernel_long_t	ru_inblock;	/* block input operations */
+	__kernel_long_t	ru_oublock;	/* block output operations */
+	__kernel_long_t	ru_msgsnd;	/* messages sent */
+	__kernel_long_t	ru_msgrcv;	/* messages received */
+	__kernel_long_t	ru_nsignals;	/* signals received */
+	__kernel_long_t	ru_nvcsw;	/* voluntary context switches */
+	__kernel_long_t	ru_nivcsw;	/* involuntary " */
 };
 
 struct rlimit {
-	unsigned long	rlim_cur;
-	unsigned long	rlim_max;
+	__kernel_ulong_t	rlim_cur;
+	__kernel_ulong_t	rlim_max;
 };
 
 #define RLIM64_INFINITY		(~0ULL)
diff --git a/include/uapi/linux/shm.h b/include/uapi/linux/shm.h
index ec36fa1a83a4..78b69413f582 100644
--- a/include/uapi/linux/shm.h
+++ b/include/uapi/linux/shm.h
@@ -68,11 +68,11 @@ struct	shminfo {
 
 struct shm_info {
 	int used_ids;
-	unsigned long shm_tot;	/* total allocated shm */
-	unsigned long shm_rss;	/* total resident shm */
-	unsigned long shm_swp;	/* total swapped shm */
-	unsigned long swap_attempts;
-	unsigned long swap_successes;
+	__kernel_ulong_t shm_tot;	/* total allocated shm */
+	__kernel_ulong_t shm_rss;	/* total resident shm */
+	__kernel_ulong_t shm_swp;	/* total swapped shm */
+	__kernel_ulong_t swap_attempts;
+	__kernel_ulong_t swap_successes;
 };
 
 
diff --git a/include/uapi/linux/timex.h b/include/uapi/linux/timex.h
index a7ea81f13711..92685d826444 100644
--- a/include/uapi/linux/timex.h
+++ b/include/uapi/linux/timex.h
@@ -63,27 +63,27 @@
  */
 struct timex {
 	unsigned int modes;	/* mode selector */
-	long offset;		/* time offset (usec) */
-	long freq;		/* frequency offset (scaled ppm) */
-	long maxerror;		/* maximum error (usec) */
-	long esterror;		/* estimated error (usec) */
+	__kernel_long_t offset;	/* time offset (usec) */
+	__kernel_long_t freq;	/* frequency offset (scaled ppm) */
+	__kernel_long_t maxerror;/* maximum error (usec) */
+	__kernel_long_t esterror;/* estimated error (usec) */
 	int status;		/* clock command/status */
-	long constant;		/* pll time constant */
-	long precision;		/* clock precision (usec) (read only) */
-	long tolerance;		/* clock frequency tolerance (ppm)
-				 * (read only)
-				 */
+	__kernel_long_t constant;/* pll time constant */
+	__kernel_long_t precision;/* clock precision (usec) (read only) */
+	__kernel_long_t tolerance;/* clock frequency tolerance (ppm)
+				   * (read only)
+				   */
 	struct timeval time;	/* (read only, except for ADJ_SETOFFSET) */
-	long tick;		/* (modified) usecs between clock ticks */
+	__kernel_long_t tick;	/* (modified) usecs between clock ticks */
 
-	long ppsfreq;           /* pps frequency (scaled ppm) (ro) */
-	long jitter;            /* pps jitter (us) (ro) */
+	__kernel_long_t ppsfreq;/* pps frequency (scaled ppm) (ro) */
+	__kernel_long_t jitter; /* pps jitter (us) (ro) */
 	int shift;              /* interval duration (s) (shift) (ro) */
-	long stabil;            /* pps stability (scaled ppm) (ro) */
-	long jitcnt;            /* jitter limit exceeded (ro) */
-	long calcnt;            /* calibration intervals (ro) */
-	long errcnt;            /* calibration errors (ro) */
-	long stbcnt;            /* stability limit exceeded (ro) */
+	__kernel_long_t stabil;            /* pps stability (scaled ppm) (ro) */
+	__kernel_long_t jitcnt; /* jitter limit exceeded (ro) */
+	__kernel_long_t calcnt; /* calibration intervals (ro) */
+	__kernel_long_t errcnt; /* calibration errors (ro) */
+	__kernel_long_t stbcnt; /* stability limit exceeded (ro) */
 
 	int tai;		/* TAI offset (ro) */
 
