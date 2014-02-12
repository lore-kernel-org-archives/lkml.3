Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaBLVBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:01:49 -0500
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:18871 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752762AbaBLVBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:01:48 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkMRAKbg+1JXQAka/2dsb2JhbABaKIJkgkN7E7xoAgKBGBd0gmYcIxiBAjeICQHJEo55HYQiBIlGjmMBkiGDOi8
Date: Wed, 12 Feb 2014 21:03:06 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: akpm <akpm@linux-foundation.org>, rdunlap <rdunlap@infradead.org>
Subject: [RFC 1/2] Arch: Kconfig: Disable obsolete syscalls
Message-Id: <20140212210306.0c143411c25ffaaadc405701@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a generic configuration flag to disable obsolete
system calls (ie no longer supported by current c libraries).

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/Kconfig | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 80bbb8c..e9bd58f 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -522,4 +522,13 @@ config OLD_SIGACTION
 config COMPAT_OLD_SIGACTION
 	bool
 
+config DISABLE_OBSOLETE_SYSCALLS
+	bool "Disable obsolete system calls"
+	help
+	  Optimize your kernel by disabling system calls no longer
+	  supported by current c libraries. Only officially obsolete
+	  system calls feature here however be warned that meanwhile
+	  this improves security, this option can break compliance
+	  with other systems.
+
 source "kernel/gcov/Kconfig"
-- 
1.8.1.4

