Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3EIUwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 16:52:55 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:41632 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab3EIUwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 16:52:54 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] h8300: Fill the system call table using a CALL() macro
Date: Thu,  9 May 2013 22:52:49 +0200
Message-Id: <1368132769-21898-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CALL() macro abstracts (a.o.) the underscore symbol prefix.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
This depends on "h8300: Hardcode symbol prefixes in asm sources"

 arch/h8300/kernel/syscalls.S |  642 +++++++++++++++++++++---------------------
 1 files changed, 322 insertions(+), 320 deletions(-)

diff --git a/arch/h8300/kernel/syscalls.S b/arch/h8300/kernel/syscalls.S
index 7497001..c55e0ed 100644
--- a/arch/h8300/kernel/syscalls.S
+++ b/arch/h8300/kernel/syscalls.S
@@ -3,6 +3,8 @@
 #include <asm/linkage.h>
 #include <asm/unistd.h>
 
+#define CALL(x)	.long _ ## x
+
 .globl _sys_call_table
 
 #if defined(CONFIG_CPU_H8300H)
@@ -14,323 +16,323 @@
 	.section .text
 	.align	2
 _sys_call_table:
-	.long _sys_ni_syscall		/* 0  -  old "setup()" system call*/
-	.long _sys_exit
-	.long _sys_fork
-	.long _sys_read
-	.long _sys_write
-	.long _sys_open			/* 5 */
-	.long _sys_close
-	.long _sys_waitpid
-	.long _sys_creat
-	.long _sys_link
-	.long _sys_unlink		/* 10 */
-	.long _sys_execve
-	.long _sys_chdir
-	.long _sys_time
-	.long _sys_mknod
-	.long _sys_chmod		/* 15 */
-	.long _sys_chown16
-	.long _sys_ni_syscall		/* old break syscall holder */
-	.long _sys_stat
-	.long _sys_lseek
-	.long _sys_getpid		/* 20 */
-	.long _sys_mount
-	.long _sys_oldumount
-	.long _sys_setuid16
-	.long _sys_getuid16
-	.long _sys_stime		/* 25 */
-	.long _sys_ptrace
-	.long _sys_alarm
-	.long _sys_fstat
-	.long _sys_pause
-	.long _sys_utime		/* 30 */
-	.long _sys_ni_syscall		/* old stty syscall holder */
-	.long _sys_ni_syscall		/* old gtty syscall holder */
-	.long _sys_access
-	.long _sys_nice
-	.long _sys_ni_syscall		/* 35 old ftime syscall holder */
-	.long _sys_sync
-	.long _sys_kill
-	.long _sys_rename
-	.long _sys_mkdir
-	.long _sys_rmdir		/* 40 */
-	.long _sys_dup
-	.long _sys_pipe
-	.long _sys_times
-	.long _sys_ni_syscall		/* old prof syscall holder */
-	.long _sys_brk			/* 45 */
-	.long _sys_setgid16
-	.long _sys_getgid16
-	.long _sys_signal
-	.long _sys_geteuid16
-	.long _sys_getegid16		/* 50 */
-	.long _sys_acct
-	.long _sys_umount		/* recycled never used phys() */
-	.long _sys_ni_syscall		/* old lock syscall holder */
-	.long _sys_ioctl
-	.long _sys_fcntl		/* 55 */
-	.long _sys_ni_syscall		/* old mpx syscall holder */
-	.long _sys_setpgid
-	.long _sys_ni_syscall		/* old ulimit syscall holder */
-	.long _sys_ni_syscall
-	.long _sys_umask		/* 60 */
-	.long _sys_chroot
-	.long _sys_ustat
-	.long _sys_dup2
-	.long _sys_getppid
-	.long _sys_getpgrp		/* 65 */
-	.long _sys_setsid
-	.long _sys_sigaction
-	.long _sys_sgetmask
-	.long _sys_ssetmask
-	.long _sys_setreuid16		/* 70 */
-	.long _sys_setregid16
-	.long _sys_sigsuspend
-	.long _sys_sigpending
-	.long _sys_sethostname
-	.long _sys_setrlimit		/* 75 */
-	.long _sys_old_getrlimit
-	.long _sys_getrusage
-	.long _sys_gettimeofday
-	.long _sys_settimeofday
-	.long _sys_getgroups16		/* 80 */
-	.long _sys_setgroups16
-	.long _sys_old_select
-	.long _sys_symlink
-	.long _sys_lstat
-	.long _sys_readlink		/* 85 */
-	.long _sys_uselib
-	.long _sys_swapon
-	.long _sys_reboot
-	.long _sys_old_readdir
-	.long _sys_old_mmap		/* 90 */
-	.long _sys_munmap
-	.long _sys_truncate
-	.long _sys_ftruncate
-	.long _sys_fchmod
-	.long _sys_fchown16		/* 95 */
-	.long _sys_getpriority
-	.long _sys_setpriority
-	.long _sys_ni_syscall		/* old profil syscall holder */
-	.long _sys_statfs
-	.long _sys_fstatfs		/* 100 */
-	.long _sys_ni_syscall		/* ioperm for i386 */
-	.long _sys_socketcall
-	.long _sys_syslog
-	.long _sys_setitimer
-	.long _sys_getitimer		/* 105 */
-	.long _sys_newstat
-	.long _sys_newlstat
-	.long _sys_newfstat
-	.long _sys_ni_syscall
-	.long _sys_ni_syscall		/* iopl for i386 */ /* 110 */
-	.long _sys_vhangup
-	.long _sys_ni_syscall		/* obsolete idle() syscall */
-	.long _sys_ni_syscall		/* vm86old for i386 */
-	.long _sys_wait4
-	.long _sys_swapoff		/* 115 */
-	.long _sys_sysinfo
-	.long _sys_ipc
-	.long _sys_fsync
-	.long _sys_sigreturn
-	.long _sys_clone		/* 120 */
-	.long _sys_setdomainname
-	.long _sys_newuname
-	.long _sys_cacheflush		/* modify_ldt for i386 */
-	.long _sys_adjtimex
-	.long _sys_ni_syscall		/* 125 sys_mprotect */
-	.long _sys_sigprocmask
-	.long _sys_ni_syscall		/* sys_create_module */
-	.long _sys_init_module
-	.long _sys_delete_module
-	.long _sys_ni_syscall		/* 130 sys_get_kernel_syms */
-	.long _sys_quotactl
-	.long _sys_getpgid
-	.long _sys_fchdir
-	.long _sys_bdflush
-	.long _sys_sysfs		/* 135 */
-	.long _sys_personality
-	.long _sys_ni_syscall		/* for afs_syscall */
-	.long _sys_setfsuid16
-	.long _sys_setfsgid16
-	.long _sys_llseek		/* 140 */
-	.long _sys_getdents
-	.long _sys_select
-	.long _sys_flock
-	.long _sys_ni_syscall		/* sys_msync */
-	.long _sys_readv		/* 145 */
-	.long _sys_writev
-	.long _sys_getsid
-	.long _sys_fdatasync
-	.long _sys_sysctl
-	.long _sys_ni_syscall		/* 150 sys_mlock */
-	.long _sys_ni_syscall		/* sys_munlock */
-	.long _sys_ni_syscall		/* sys_mlockall */
-	.long _sys_ni_syscall		/* sys_munlockall */
-	.long _sys_sched_setparam
-	.long _sys_sched_getparam	/* 155 */
-	.long _sys_sched_setscheduler
-	.long _sys_sched_getscheduler
-	.long _sys_sched_yield
-	.long _sys_sched_get_priority_max
-	.long _sys_sched_get_priority_min  /* 160 */
-	.long _sys_sched_rr_get_interval
-	.long _sys_nanosleep
-	.long _sys_ni_syscall		/* sys_mremap */
-	.long _sys_setresuid16
-	.long _sys_getresuid16		/* 165 */
-	.long _sys_ni_syscall		/* for vm86 */
-	.long _sys_ni_syscall		/* sys_query_module */
-	.long _sys_poll
-	.long _sys_ni_syscall		/* old nfsservctl */
-	.long _sys_setresgid16		/* 170 */
-	.long _sys_getresgid16
-	.long _sys_prctl
-	.long _sys_rt_sigreturn
-	.long _sys_rt_sigaction
-	.long _sys_rt_sigprocmask	/* 175 */
-	.long _sys_rt_sigpending
-	.long _sys_rt_sigtimedwait
-	.long _sys_rt_sigqueueinfo
-	.long _sys_rt_sigsuspend
-	.long _sys_pread64		/* 180 */
-	.long _sys_pwrite64
-	.long _sys_lchown16;
-	.long _sys_getcwd
-	.long _sys_capget
-	.long _sys_capset		/* 185 */
-	.long _sys_sigaltstack
-	.long _sys_sendfile
-	.long _sys_ni_syscall		/* streams1 */
-	.long _sys_ni_syscall		/* streams2 */
-	.long _sys_vfork		/* 190 */
-	.long _sys_getrlimit
-	.long _sys_mmap_pgoff
-	.long _sys_truncate64
-	.long _sys_ftruncate64
-	.long _sys_stat64		/* 195 */
-	.long _sys_lstat64
-	.long _sys_fstat64
-	.long _sys_chown
-	.long _sys_getuid
-	.long _sys_getgid		/* 200 */
-	.long _sys_geteuid
-	.long _sys_getegid
-	.long _sys_setreuid
-	.long _sys_setregid
-	.long _sys_getgroups		/* 205 */
-	.long _sys_setgroups
-	.long _sys_fchown
-	.long _sys_setresuid
-	.long _sys_getresuid
-	.long _sys_setresgid		/* 210 */
-	.long _sys_getresgid
-	.long _sys_lchown
-	.long _sys_setuid
-	.long _sys_setgid
-	.long _sys_setfsuid		/* 215 */
-	.long _sys_setfsgid
-	.long _sys_pivot_root
-	.long _sys_ni_syscall
-	.long _sys_ni_syscall
-	.long _sys_getdents64		/* 220 */
-	.long _sys_fcntl64
-	.long _sys_ni_syscall		/* reserved TUX */
-	.long _sys_ni_syscall		/* reserved Security */
-	.long _sys_gettid
-	.long _sys_readahead		/* 225 */
-	.long _sys_setxattr
-	.long _sys_lsetxattr
-	.long _sys_fsetxattr
-	.long _sys_getxattr
-	.long _sys_lgetxattr		/* 230 */
-	.long _sys_fgetxattr
-	.long _sys_listxattr
-	.long _sys_llistxattr
-	.long _sys_flistxattr
-	.long _sys_removexattr		/* 235 */
-	.long _sys_lremovexattr
-	.long _sys_fremovexattr
-	.long _sys_tkill
-	.long _sys_sendfile64
-	.long _sys_futex		/* 240 */
-	.long _sys_sched_setaffinity
-	.long _sys_sched_getaffinity
-	.long _sys_ni_syscall
-	.long _sys_ni_syscall
-	.long _sys_io_setup		/* 245 */
-	.long _sys_io_destroy
-	.long _sys_io_getevents
-	.long _sys_io_submit
-	.long _sys_io_cancel
-	.long _sys_fadvise64		/* 250 */
-	.long _sys_ni_syscall
-	.long _sys_exit_group
-	.long _sys_lookup_dcookie
-	.long _sys_epoll_create
-	.long _sys_epoll_ctl		/* 255 */
-	.long _sys_epoll_wait
- 	.long _sys_ni_syscall		/* sys_remap_file_pages */
- 	.long _sys_set_tid_address
- 	.long _sys_timer_create
- 	.long _sys_timer_settime	/* 260 */
- 	.long _sys_timer_gettime
- 	.long _sys_timer_getoverrun
- 	.long _sys_timer_delete
- 	.long _sys_clock_settime
- 	.long _sys_clock_gettime	/* 265 */
- 	.long _sys_clock_getres
- 	.long _sys_clock_nanosleep
-	.long _sys_statfs64
-	.long _sys_fstatfs64
-	.long _sys_tgkill		/* 270 */
-	.long _sys_utimes
- 	.long _sys_fadvise64_64
-	.long _sys_ni_syscall		/* sys_vserver */
-	.long _sys_ni_syscall
-	.long _sys_get_mempolicy	/* 275 */
-	.long _sys_set_mempolicy
-	.long _sys_mq_open
-	.long _sys_mq_unlink
-	.long _sys_mq_timedsend
-	.long _sys_mq_timedreceive	/* 280 */
-	.long _sys_mq_notify
-	.long _sys_mq_getsetattr
-	.long _sys_waitid
-	.long _sys_ni_syscall		/* sys_kexec_load */
-	.long _sys_add_key 		/* 285 */
-	.long _sys_request_key
-	.long _sys_keyctl
-	.long _sys_ioprio_set
-	.long _sys_ioprio_get		/* 290 */
-	.long _sys_inotify_init
-	.long _sys_inotify_add_watch
-	.long _sys_inotify_rm_watch
-	.long _sys_migrate_pages
-	.long _sys_openat		/* 295 */
-	.long _sys_mkdirat
-	.long _sys_mknodat
-	.long _sys_fchownat
-	.long _sys_futimesat
-	.long _sys_fstatat64		/* 300 */
-	.long _sys_unlinkat
-	.long _sys_renameat
-	.long _sys_linkat
-	.long _sys_symlinkat
-	.long _sys_readlinkat		/* 305 */
-	.long _sys_fchmodat
-	.long _sys_faccessat
-	.long _sys_ni_syscall		/* sys_pselect6 */
-	.long _sys_ni_syscall		/* sys_ppoll */
-	.long _sys_unshare		/* 310 */
-	.long _sys_set_robust_list
-	.long _sys_get_robust_list
-	.long _sys_splice
-	.long _sys_sync_file_range
-	.long _sys_tee			/* 315 */
-	.long _sys_vmsplice
-	.long _sys_ni_syscall		/* sys_move_pages */
-	.long _sys_getcpu
-	.long _sys_ni_syscall		/* sys_epoll_pwait */
-	.long _sys_setns		/* 320 */
+	CALL(sys_ni_syscall)		/* 0  -  old "setup()" system call*/
+	CALL(sys_exit)
+	CALL(sys_fork)
+	CALL(sys_read)
+	CALL(sys_write)
+	CALL(sys_open)			/* 5 */
+	CALL(sys_close)
+	CALL(sys_waitpid)
+	CALL(sys_creat)
+	CALL(sys_link)
+	CALL(sys_unlink)		/* 10 */
+	CALL(sys_execve)
+	CALL(sys_chdir)
+	CALL(sys_time)
+	CALL(sys_mknod)
+	CALL(sys_chmod)			/* 15 */
+	CALL(sys_chown16)
+	CALL(sys_ni_syscall)		/* old break syscall holder */
+	CALL(sys_stat)
+	CALL(sys_lseek)
+	CALL(sys_getpid)		/* 20 */
+	CALL(sys_mount)
+	CALL(sys_oldumount)
+	CALL(sys_setuid16)
+	CALL(sys_getuid16)
+	CALL(sys_stime)			/* 25 */
+	CALL(sys_ptrace)
+	CALL(sys_alarm)
+	CALL(sys_fstat)
+	CALL(sys_pause)
+	CALL(sys_utime)			/* 30 */
+	CALL(sys_ni_syscall)		/* old stty syscall holder */
+	CALL(sys_ni_syscall)		/* old gtty syscall holder */
+	CALL(sys_access)
+	CALL(sys_nice)
+	CALL(sys_ni_syscall)		/* 35 old ftime syscall holder */
+	CALL(sys_sync)
+	CALL(sys_kill)
+	CALL(sys_rename)
+	CALL(sys_mkdir)
+	CALL(sys_rmdir)			/* 40 */
+	CALL(sys_dup)
+	CALL(sys_pipe)
+	CALL(sys_times)
+	CALL(sys_ni_syscall)		/* old prof syscall holder */
+	CALL(sys_brk)			/* 45 */
+	CALL(sys_setgid16)
+	CALL(sys_getgid16)
+	CALL(sys_signal)
+	CALL(sys_geteuid16)
+	CALL(sys_getegid16)		/* 50 */
+	CALL(sys_acct)
+	CALL(sys_umount)		/* recycled never used phys() */
+	CALL(sys_ni_syscall)		/* old lock syscall holder */
+	CALL(sys_ioctl)
+	CALL(sys_fcntl)			/* 55 */
+	CALL(sys_ni_syscall)		/* old mpx syscall holder */
+	CALL(sys_setpgid)
+	CALL(sys_ni_syscall)		/* old ulimit syscall holder */
+	CALL(sys_ni_syscall)
+	CALL(sys_umask)			/* 60 */
+	CALL(sys_chroot)
+	CALL(sys_ustat)
+	CALL(sys_dup2)
+	CALL(sys_getppid)
+	CALL(sys_getpgrp)		/* 65 */
+	CALL(sys_setsid)
+	CALL(sys_sigaction)
+	CALL(sys_sgetmask)
+	CALL(sys_ssetmask)
+	CALL(sys_setreuid16)		/* 70 */
+	CALL(sys_setregid16)
+	CALL(sys_sigsuspend)
+	CALL(sys_sigpending)
+	CALL(sys_sethostname)
+	CALL(sys_setrlimit)		/* 75 */
+	CALL(sys_old_getrlimit)
+	CALL(sys_getrusage)
+	CALL(sys_gettimeofday)
+	CALL(sys_settimeofday)
+	CALL(sys_getgroups16)		/* 80 */
+	CALL(sys_setgroups16)
+	CALL(sys_old_select)
+	CALL(sys_symlink)
+	CALL(sys_lstat)
+	CALL(sys_readlink)		/* 85 */
+	CALL(sys_uselib)
+	CALL(sys_swapon)
+	CALL(sys_reboot)
+	CALL(sys_old_readdir)
+	CALL(sys_old_mmap)		/* 90 */
+	CALL(sys_munmap)
+	CALL(sys_truncate)
+	CALL(sys_ftruncate)
+	CALL(sys_fchmod)
+	CALL(sys_fchown16)		/* 95 */
+	CALL(sys_getpriority)
+	CALL(sys_setpriority)
+	CALL(sys_ni_syscall)		/* old profil syscall holder */
+	CALL(sys_statfs)
+	CALL(sys_fstatfs)		/* 100 */
+	CALL(sys_ni_syscall)		/* ioperm for i386 */
+	CALL(sys_socketcall)
+	CALL(sys_syslog)
+	CALL(sys_setitimer)
+	CALL(sys_getitimer)		/* 105 */
+	CALL(sys_newstat)
+	CALL(sys_newlstat)
+	CALL(sys_newfstat)
+	CALL(sys_ni_syscall)
+	CALL(sys_ni_syscall)		/* iopl for i386 */ /* 110 */
+	CALL(sys_vhangup)
+	CALL(sys_ni_syscall)		/* obsolete idle() syscall */
+	CALL(sys_ni_syscall)		/* vm86old for i386 */
+	CALL(sys_wait4)
+	CALL(sys_swapoff)		/* 115 */
+	CALL(sys_sysinfo)
+	CALL(sys_ipc)
+	CALL(sys_fsync)
+	CALL(sys_sigreturn)
+	CALL(sys_clone)			/* 120 */
+	CALL(sys_setdomainname)
+	CALL(sys_newuname)
+	CALL(sys_cacheflush)		/* modify_ldt for i386 */
+	CALL(sys_adjtimex)
+	CALL(sys_ni_syscall)		/* 125 sys_mprotect */
+	CALL(sys_sigprocmask)
+	CALL(sys_ni_syscall)		/* sys_create_module */
+	CALL(sys_init_module)
+	CALL(sys_delete_module)
+	CALL(sys_ni_syscall)		/* 130 sys_get_kernel_syms */
+	CALL(sys_quotactl)
+	CALL(sys_getpgid)
+	CALL(sys_fchdir)
+	CALL(sys_bdflush)
+	CALL(sys_sysfs)			/* 135 */
+	CALL(sys_personality)
+	CALL(sys_ni_syscall)		/* for afs_syscall */
+	CALL(sys_setfsuid16)
+	CALL(sys_setfsgid16)
+	CALL(sys_llseek)		/* 140 */
+	CALL(sys_getdents)
+	CALL(sys_select)
+	CALL(sys_flock)
+	CALL(sys_ni_syscall)		/* sys_msync */
+	CALL(sys_readv)			/* 145 */
+	CALL(sys_writev)
+	CALL(sys_getsid)
+	CALL(sys_fdatasync)
+	CALL(sys_sysctl)
+	CALL(sys_ni_syscall)		/* 150 sys_mlock */
+	CALL(sys_ni_syscall)		/* sys_munlock */
+	CALL(sys_ni_syscall)		/* sys_mlockall */
+	CALL(sys_ni_syscall)		/* sys_munlockall */
+	CALL(sys_sched_setparam)
+	CALL(sys_sched_getparam)	/* 155 */
+	CALL(sys_sched_setscheduler)
+	CALL(sys_sched_getscheduler)
+	CALL(sys_sched_yield)
+	CALL(sys_sched_get_priority_max)
+	CALL(sys_sched_get_priority_min)  /* 160 */
+	CALL(sys_sched_rr_get_interval)
+	CALL(sys_nanosleep)
+	CALL(sys_ni_syscall)		/* sys_mremap */
+	CALL(sys_setresuid16)
+	CALL(sys_getresuid16)		/* 165 */
+	CALL(sys_ni_syscall)		/* for vm86 */
+	CALL(sys_ni_syscall)		/* sys_query_module */
+	CALL(sys_poll)
+	CALL(sys_ni_syscall)		/* old nfsservctl */
+	CALL(sys_setresgid16)		/* 170 */
+	CALL(sys_getresgid16)
+	CALL(sys_prctl)
+	CALL(sys_rt_sigreturn)
+	CALL(sys_rt_sigaction)
+	CALL(sys_rt_sigprocmask)	/* 175 */
+	CALL(sys_rt_sigpending)
+	CALL(sys_rt_sigtimedwait)
+	CALL(sys_rt_sigqueueinfo)
+	CALL(sys_rt_sigsuspend)
+	CALL(sys_pread64)		/* 180 */
+	CALL(sys_pwrite64)
+	CALL(sys_lchown16);
+	CALL(sys_getcwd)
+	CALL(sys_capget)
+	CALL(sys_capset)		/* 185 */
+	CALL(sys_sigaltstack)
+	CALL(sys_sendfile)
+	CALL(sys_ni_syscall)		/* streams1 */
+	CALL(sys_ni_syscall)		/* streams2 */
+	CALL(sys_vfork)			/* 190 */
+	CALL(sys_getrlimit)
+	CALL(sys_mmap_pgoff)
+	CALL(sys_truncate64)
+	CALL(sys_ftruncate64)
+	CALL(sys_stat64)		/* 195 */
+	CALL(sys_lstat64)
+	CALL(sys_fstat64)
+	CALL(sys_chown)
+	CALL(sys_getuid)
+	CALL(sys_getgid)		/* 200 */
+	CALL(sys_geteuid)
+	CALL(sys_getegid)
+	CALL(sys_setreuid)
+	CALL(sys_setregid)
+	CALL(sys_getgroups)		/* 205 */
+	CALL(sys_setgroups)
+	CALL(sys_fchown)
+	CALL(sys_setresuid)
+	CALL(sys_getresuid)
+	CALL(sys_setresgid)		/* 210 */
+	CALL(sys_getresgid)
+	CALL(sys_lchown)
+	CALL(sys_setuid)
+	CALL(sys_setgid)
+	CALL(sys_setfsuid)		/* 215 */
+	CALL(sys_setfsgid)
+	CALL(sys_pivot_root)
+	CALL(sys_ni_syscall)
+	CALL(sys_ni_syscall)
+	CALL(sys_getdents64)		/* 220 */
+	CALL(sys_fcntl64)
+	CALL(sys_ni_syscall)		/* reserved TUX */
+	CALL(sys_ni_syscall)		/* reserved Security */
+	CALL(sys_gettid)
+	CALL(sys_readahead)		/* 225 */
+	CALL(sys_setxattr)
+	CALL(sys_lsetxattr)
+	CALL(sys_fsetxattr)
+	CALL(sys_getxattr)
+	CALL(sys_lgetxattr)		/* 230 */
+	CALL(sys_fgetxattr)
+	CALL(sys_listxattr)
+	CALL(sys_llistxattr)
+	CALL(sys_flistxattr)
+	CALL(sys_removexattr)		/* 235 */
+	CALL(sys_lremovexattr)
+	CALL(sys_fremovexattr)
+	CALL(sys_tkill)
+	CALL(sys_sendfile64)
+	CALL(sys_futex)			/* 240 */
+	CALL(sys_sched_setaffinity)
+	CALL(sys_sched_getaffinity)
+	CALL(sys_ni_syscall)
+	CALL(sys_ni_syscall)
+	CALL(sys_io_setup)		/* 245 */
+	CALL(sys_io_destroy)
+	CALL(sys_io_getevents)
+	CALL(sys_io_submit)
+	CALL(sys_io_cancel)
+	CALL(sys_fadvise64)		/* 250 */
+	CALL(sys_ni_syscall)
+	CALL(sys_exit_group)
+	CALL(sys_lookup_dcookie)
+	CALL(sys_epoll_create)
+	CALL(sys_epoll_ctl)		/* 255 */
+	CALL(sys_epoll_wait)
+	CALL(sys_ni_syscall)		/* sys_remap_file_pages */
+	CALL(sys_set_tid_address)
+	CALL(sys_timer_create)
+	CALL(sys_timer_settime)		/* 260 */
+	CALL(sys_timer_gettime)
+	CALL(sys_timer_getoverrun)
+	CALL(sys_timer_delete)
+	CALL(sys_clock_settime)
+	CALL(sys_clock_gettime)		/* 265 */
+	CALL(sys_clock_getres)
+	CALL(sys_clock_nanosleep)
+	CALL(sys_statfs64)
+	CALL(sys_fstatfs64)
+	CALL(sys_tgkill)		/* 270 */
+	CALL(sys_utimes)
+	CALL(sys_fadvise64_64)
+	CALL(sys_ni_syscall)		/* sys_vserver */
+	CALL(sys_ni_syscall)
+	CALL(sys_get_mempolicy)		/* 275 */
+	CALL(sys_set_mempolicy)
+	CALL(sys_mq_open)
+	CALL(sys_mq_unlink)
+	CALL(sys_mq_timedsend)
+	CALL(sys_mq_timedreceive)	/* 280 */
+	CALL(sys_mq_notify)
+	CALL(sys_mq_getsetattr)
+	CALL(sys_waitid)
+	CALL(sys_ni_syscall)		/* sys_kexec_load */
+	CALL(sys_add_key) 		/* 285 */
+	CALL(sys_request_key)
+	CALL(sys_keyctl)
+	CALL(sys_ioprio_set)
+	CALL(sys_ioprio_get)		/* 290 */
+	CALL(sys_inotify_init)
+	CALL(sys_inotify_add_watch)
+	CALL(sys_inotify_rm_watch)
+	CALL(sys_migrate_pages)
+	CALL(sys_openat)		/* 295 */
+	CALL(sys_mkdirat)
+	CALL(sys_mknodat)
+	CALL(sys_fchownat)
+	CALL(sys_futimesat)
+	CALL(sys_fstatat64)		/* 300 */
+	CALL(sys_unlinkat)
+	CALL(sys_renameat)
+	CALL(sys_linkat)
+	CALL(sys_symlinkat)
+	CALL(sys_readlinkat)		/* 305 */
+	CALL(sys_fchmodat)
+	CALL(sys_faccessat)
+	CALL(sys_ni_syscall)		/* sys_pselect6 */
+	CALL(sys_ni_syscall)		/* sys_ppoll */
+	CALL(sys_unshare)		/* 310 */
+	CALL(sys_set_robust_list)
+	CALL(sys_get_robust_list)
+	CALL(sys_splice)
+	CALL(sys_sync_file_range)
+	CALL(sys_tee)			/* 315 */
+	CALL(sys_vmsplice)
+	CALL(sys_ni_syscall)		/* sys_move_pages */
+	CALL(sys_getcpu)
+	CALL(sys_ni_syscall)		/* sys_epoll_pwait */
+	CALL(sys_setns)			/* 320 */
-- 
1.7.0.4

