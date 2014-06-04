Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaFDWUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:20:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36393 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaFDWUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:20:22 -0400
Date: Wed, 4 Jun 2014 15:19:55 -0700
Message-Id: <201406042219.s54MJtGd015394@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/x32 changes for v3.16
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Cc: hjl.tools@gmail.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, tglx@linutronix.de, vapier@gentoo.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A single fix for the x32 ABI: the io_setup() and io_submit() system
call need to use the compat stubs.

The following changes since commit d1db0eea852497762cab43b905b879dfcd3b8987:

  Linux 3.15-rc3 (2014-04-27 19:29:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-x32-for-linus

for you to fetch changes up to 7fd44dacdd803c0bbf38bf478d51d280902bb0f1:

  x86, x32: Use compat shims for io_{setup,submit} (2014-05-04 17:49:22 -0700)

----------------------------------------------------------------
Mike Frysinger (1):
      x86, x32: Use compat shims for io_{setup,submit}

 arch/x86/syscalls/syscall_64.tbl | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 04376ac..ec255a1 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -212,10 +212,10 @@
 203	common	sched_setaffinity	sys_sched_setaffinity
 204	common	sched_getaffinity	sys_sched_getaffinity
 205	64	set_thread_area
-206	common	io_setup		sys_io_setup
+206	64	io_setup		sys_io_setup
 207	common	io_destroy		sys_io_destroy
 208	common	io_getevents		sys_io_getevents
-209	common	io_submit		sys_io_submit
+209	64	io_submit		sys_io_submit
 210	common	io_cancel		sys_io_cancel
 211	64	get_thread_area
 212	common	lookup_dcookie		sys_lookup_dcookie
@@ -359,3 +359,5 @@
 540	x32	process_vm_writev	compat_sys_process_vm_writev
 541	x32	setsockopt		compat_sys_setsockopt
 542	x32	getsockopt		compat_sys_getsockopt
+543	x32	io_setup		compat_sys_io_setup
+544	x32	io_submit		compat_sys_io_submit
