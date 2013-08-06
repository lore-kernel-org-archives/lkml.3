Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab3HFDOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 23:14:11 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:45861 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab3HFDNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 23:13:07 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v7 2/4] spinlock: Enable x86 architecture to do lockless refcount update
Date: Mon,  5 Aug 2013 23:12:37 -0400
Message-Id: <1375758759-29629-3-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the x86 architecture to do lockless reference
count update using the generic lockref implementation with default
parameters. Only the x86/Kconfig file needs to be changed.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b32ebf9..79a9309 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -262,6 +262,9 @@ config ARCH_CPU_PROBE_RELEASE
 config ARCH_SUPPORTS_UPROBES
 	def_bool y
 
+config GENERIC_SPINLOCK_REFCOUNT
+	def_bool y
+
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
-- 
1.7.1

