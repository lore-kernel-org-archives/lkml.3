Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab3L0RZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 12:25:20 -0500
Received: from mail-gg0-f172.google.com ([209.85.161.172]:57780 "EHLO
	mail-gg0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab3L0RZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 12:25:18 -0500
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: "H.J. Lu" <hjl.tools@gmail.com>
Subject: [PATCH 0/8] Update kernel uabi header files for x32
Date: Fri, 27 Dec 2013 09:25:04 -0800
Message-Id: <1388165112-6545-1-git-send-email-hjl.tools@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X32 uses the same kernel system call interface as x86-64 for many
system calls.  However, "long" is 64-bit for x86-64 and is 32-bit for
x32.  Where long or unsigned long are used in struct types for such
system calls, they are wrong for x32.  __kernel_[u]long_t is [unsigned]
long for all ABIs other than x32.  I am submitting 8 patches to replace
long or unsigned long with __kernel_[u]long_t so that those struct types
can be used with x32 system calls.

H.J. Lu (8):
  Use __kernel_long_t in struct timex
  Use __kernel_long_t/__kernel_ulong_t in <linux/resource.h>
  Use __kernel_ulong_t in uapi struct ipc64_perm
  Use __kernel_long_t in struct msgbuf
  Use __kernel_ulong_t in struct msqid64_ds
  Use __kernel_ulong_t in x86 struct semid64_ds
  Use __kernel_ulong_t in shmid64_ds/shminfo64/shm_info
  Use __kernel_long_t in struct mq_attr

 arch/x86/include/uapi/asm/sembuf.h | 10 ++++-----
 include/uapi/asm-generic/ipcbuf.h  |  5 +++++
 include/uapi/asm-generic/msgbuf.h  | 19 +++++++++++-----
 include/uapi/asm-generic/shmbuf.h  | 36 +++++++++++++++++++++--------
 include/uapi/linux/mqueue.h        | 18 ++++++++++-----
 include/uapi/linux/msg.h           |  8 +++++--
 include/uapi/linux/resource.h      | 26 +++++++++++++++++++--
 include/uapi/linux/shm.h           | 14 +++++++++---
 include/uapi/linux/timex.h         | 46 +++++++++++++++++++++++++++++++-------
 9 files changed, 143 insertions(+), 39 deletions(-)

-- 
1.8.4.2

