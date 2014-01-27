Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaA0NVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 08:21:54 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:42737 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbaA0NVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 08:21:53 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 0/3] fix various small compat bugs
Date: Mon, 27 Jan 2014 14:21:42 +0100
Message-Id: <1390828905-52245-1-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.4.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012713-2966-0000-0000-00000A0E0B19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are a couple of bug fixes which affect all architectures where the ABI
requires that the calling function performs sign and/or zero extension to
full 64 bit of all 32 bit parameters.

These bugs where introduced with the COMPAT_SYSCALL_DEFINE conversion of a
couple of compat syscalls.

Note1: I looked through all COMPAT_SYSCALL_DEFINE usages in the kernel and it
       looks like these were the only broken ones.

Note2: I left the preadv64/pwrite64 compat syscalls alone since only x86 uses
       these. *If* I got it right, then these are special, since these are only
       to be used by the new x86 32 bit ABI which actually uses 64 bit
       registers and therefore passes 64 bit values to the kernel. (?)

Heiko Carstens (3):
  fs/compat: fix parameter handling for compat readv/writev syscalls
  fs/compat: fix lookup_dcookie() parameter handling
  s390/compat: change parameter types from unsigned long to compat_ulong_t

 arch/s390/kernel/compat_linux.c |  4 ++--
 fs/dcookies.c                   |  2 +-
 fs/read_write.c                 | 16 ++++++++--------
 include/linux/compat.h          | 18 +++++++++---------
 4 files changed, 20 insertions(+), 20 deletions(-)

-- 
1.8.4.5

