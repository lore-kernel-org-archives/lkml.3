Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbbARBRr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 20:17:47 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47181 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225AbbARBRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 20:17:45 -0500
X-Sasl-enc: msYohuBGfrVLtM9JH49hFSfPFWuJwT+STOefqvxBhBw5 1421543864
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Andy Lutomirski <luto@amacapital.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Borislav Petkov <bp@suse.de>, Rik van Riel <riel@redhat.com>
Subject: [PATCH 0/3] x86_64, entry: some cleanup and simplification...
Date: Sun, 18 Jan 2015 02:17:39 +0100
Message-Id: <1421543862-3552-1-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

Seems you are the person to talk now :). Good to see some activity in
the "entry" area of the kernel. I found some (very) old patches in this
area lying around and some time to dust them off.

Any chance you can review them?

They were redone on top of 22f2aa4a0361707a5cfb1de9d45260b39965dead
(x86/entry-devel in your tree) and this kernel is now running happily
on my laptop. I didn't try any benchmarking, though.

Greetings,
   Alexander


Alexander van Heukelum (3):
  x86_64: remove KERNEL_STACK_OFFSET from THREAD_INFO macro
  x86_64: don't use KERNEL_STACK_OFFSET for syscall and sysenter
  x86_64, entry: Create IRET-compatible stack frame at syscall entry

 arch/x86/ia32/ia32entry.S          | 34 ++++++++--------
 arch/x86/include/asm/calling.h     |  1 +
 arch/x86/include/asm/thread_info.h |  8 ++--
 arch/x86/kernel/cpu/common.c       |  2 +-
 arch/x86/kernel/entry_64.S         | 82 ++++++++++++--------------------------
 arch/x86/kernel/process_64.c       |  3 +-
 arch/x86/kernel/smpboot.c          |  3 +-
 arch/x86/xen/smp.c                 |  3 +-
 8 files changed, 50 insertions(+), 86 deletions(-)

-- 
2.1.0

