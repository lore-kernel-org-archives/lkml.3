Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbbARLp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 06:45:28 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51732 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbbARLpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 06:45:25 -0500
X-Sasl-enc: a+plvzm+uPzVEDTdQrrH/hzWZnpXXcomTbG1lzJZ/HYr 1421581524
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Andy Lutomirski <luto@amacapital.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Borislav Petkov <bp@suse.de>, Rik van Riel <riel@redhat.com>
Subject: [PATCHv2 0/4] x86, entry: some cleanup and simplification...
Date: Sun, 18 Jan 2015 12:45:16 +0100
Message-Id: <1421581520-2816-1-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

The last patchset did not compile on i386. Please ignore it. This one
should be better. Instead of removing KERNEL_STACK_OFFSET, it is now
used consistently on both i386 and x86_64.

Boot tested using qemu (using klibc for userspace)
	- x86_64, 32-bit userspace, core2duo (sysenter32)
	- x86_64, 32-bit userspace, phenom (syscall32)
	- x86_64, 32-bit userspace, vdso=0 (int 0x80)
	- x86_64, 64-bit userspace
	- i386, pentium3 (sysenter)
	- i386, athlon (syscall)
	- i386, vdso=0 (int 0x80)

They were tested on top of 22f2aa4a0361707a5cfb1de9d45260b39965dead
(x86/entry-devel in your tree) and this kernel is now running on my
laptop.

Greetings,
   Alexander

Alexander van Heukelum (4):
  x86_64: cleanup THREAD_INFO(reg,offset) macro
  x86_64: embrace KERNEL_STACK_OFFSET
  i386: clean up KERNEL_STACK_OFFSET
  x86_64, entry: Create IRET-compatible stack frame at syscall entry

 arch/x86/ia32/ia32entry.S          | 33 ++++++++--------
 arch/x86/include/asm/calling.h     |  1 +
 arch/x86/include/asm/processor.h   | 43 ++++++++-------------
 arch/x86/include/asm/thread_info.h | 17 +++++++-
 arch/x86/kernel/entry_32.S         |  5 ++-
 arch/x86/kernel/entry_64.S         | 79 +++++++++++---------------------------
 arch/x86/kernel/process_64.c       |  5 +--
 7 files changed, 75 insertions(+), 108 deletions(-)

-- 
2.1.0

