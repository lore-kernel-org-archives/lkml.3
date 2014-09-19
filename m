Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbaISLsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:48:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56307 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbaISLst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:48:49 -0400
Date: Fri, 19 Sep 2014 04:48:37 -0700
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-beb9147e95a75f41c984d7235cf6d59f3ca2d5db@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ryabinin.a.a@gmail.com, dvyukov@google.com,
        dave.hansen@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ryabinin.a.a@gmail.com, tglx@linutronix.de,
        dave.hansen@linux.intel.com, dvyukov@google.com
In-Reply-To: <20140918195606.841389D2@viggo.jf.intel.com>
References: <20140918195606.841389D2@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/mm:
  Update memory map description to list hypervisor-reserved area
Git-Commit-ID: beb9147e95a75f41c984d7235cf6d59f3ca2d5db
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  beb9147e95a75f41c984d7235cf6d59f3ca2d5db
Gitweb:     http://git.kernel.org/tip/beb9147e95a75f41c984d7235cf6d59f3ca2d5db
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Thu, 18 Sep 2014 12:56:06 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:48:02 +0200

x86/mm: Update memory map description to list hypervisor-reserved area

Peter Anvin says:

 > 0xffff880000000000 is the lowest usable address because we have
 > agreed to leave 0xffff800000000000-0xffff880000000000 for the
 > hypervisor or other non-OS uses.

Let's call this out in the documentation.

This came up during the kernel address sanitizer discussions
where it was proposed to use this area for other kernel things.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Link: http://lkml.kernel.org/r/20140918195606.841389D2@viggo.jf.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/x86/x86_64/mm.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.txt
index afe68dd..052ee64 100644
--- a/Documentation/x86/x86_64/mm.txt
+++ b/Documentation/x86/x86_64/mm.txt
@@ -5,7 +5,7 @@ Virtual memory map with 4 level page tables:
 
 0000000000000000 - 00007fffffffffff (=47 bits) user space, different per mm
 hole caused by [48:63] sign extension
-ffff800000000000 - ffff80ffffffffff (=40 bits) guard hole
+ffff800000000000 - ffff87ffffffffff (=43 bits) guard hole, reserved for hypervisor
 ffff880000000000 - ffffc7ffffffffff (=64 TB) direct mapping of all phys. memory
 ffffc80000000000 - ffffc8ffffffffff (=40 bits) hole
 ffffc90000000000 - ffffe8ffffffffff (=45 bits) vmalloc/ioremap space
