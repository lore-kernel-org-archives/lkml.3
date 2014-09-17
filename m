Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbaIQWVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 18:21:09 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:38625 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094AbaIQWVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 18:21:02 -0400
From: Milosz Tanski <milosz@adfin.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC v2 3/5] Export new vector IO (with flags) to userland
Date: Wed, 17 Sep 2014 22:20:48 +0000
Message-Id: <f01c74523c94871e5585f68045303baea7e6ac31.1410983999.git.milosz@adfin.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1410983998.git.milosz@adfin.com>
References: <cover.1410810247.git.milosz@adfin.com>
 <cover.1410983998.git.milosz@adfin.com>
In-Reply-To: <cover.1410983998.git.milosz@adfin.com>
References: <cover.1410983998.git.milosz@adfin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is only for x86_64 and x86. Will add other arch later.

Signed-off-by: Milosz Tanski <milosz@adfin.com>
---
 arch/x86/syscalls/syscall_32.tbl | 4 ++++
 arch/x86/syscalls/syscall_64.tbl | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index 028b781..ed85dca 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -363,3 +363,7 @@
 354	i386	seccomp			sys_seccomp
 355	i386	getrandom		sys_getrandom
 356	i386	memfd_create		sys_memfd_create
+357	i386	readv2			sys_readv2
+358	i386	writev2			sys_writev2
+359	i386	preadv2			sys_preadv2
+360	i386	pwritev2		sys_pwritev2
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 35dd922..76d9f60 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -327,6 +327,10 @@
 318	common	getrandom		sys_getrandom
 319	common	memfd_create		sys_memfd_create
 320	common	kexec_file_load		sys_kexec_file_load
+321	64	readv2			sys_readv2
+322	64	writev2			sys_writev2
+323	64	preadv2			sys_preadv2
+324	64	pwritev2		sys_pwritev2
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
-- 
2.1.0

