Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab3DCAT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 20:19:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59675 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3DCATy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 20:19:54 -0400
Date: Tue, 2 Apr 2013 17:19:35 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-aca91bfc67fe356544eb1cfc483c09b27ce49fa9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@alien8.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@alien8.de, hpa@linux.intel.com
In-Reply-To: <1362428180-8865-4-git-send-email-bp@alien8.de>
References: <1362428180-8865-4-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86-64, docs, mm:
  Add vsyscall range to virtual address space layout
Git-Commit-ID: aca91bfc67fe356544eb1cfc483c09b27ce49fa9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 17:19:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aca91bfc67fe356544eb1cfc483c09b27ce49fa9
Gitweb:     http://git.kernel.org/tip/aca91bfc67fe356544eb1cfc483c09b27ce49fa9
Author:     Borislav Petkov <bp@alien8.de>
AuthorDate: Mon, 4 Mar 2013 21:16:18 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 2 Apr 2013 16:03:31 -0700

x86-64, docs, mm: Add vsyscall range to virtual address space layout

Add the end of the virtual address space to its layout documentation.

Signed-off-by: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1362428180-8865-4-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/x86/x86_64/mm.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.txt
index d6498e3..881582f 100644
--- a/Documentation/x86/x86_64/mm.txt
+++ b/Documentation/x86/x86_64/mm.txt
@@ -13,7 +13,9 @@ ffffe90000000000 - ffffe9ffffffffff (=40 bits) hole
 ffffea0000000000 - ffffeaffffffffff (=40 bits) virtual memory map (1TB)
 ... unused hole ...
 ffffffff80000000 - ffffffffa0000000 (=512 MB)  kernel text mapping, from phys 0
-ffffffffa0000000 - fffffffffff00000 (=1536 MB) module mapping space
+ffffffffa0000000 - ffffffffff5fffff (=1525 MB) module mapping space
+ffffffffff600000 - ffffffffffdfffff (=8 MB) vsyscalls
+ffffffffffe00000 - ffffffffffffffff (=2 MB) unused hole
 
 The direct mapping covers all memory in the system up to the highest
 memory address (this means in some cases it can also include PCI memory
