Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab3JXIlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 04:41:10 -0400
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:34761 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3JXIlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 04:41:08 -0400
X-Originating-IP: 77.221.165.98
Date: Thu, 24 Oct 2013 09:41:04 +0100
From: Josh Triplett <josh@joshtriplett.org>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rob Landley <rob@landley.net>, Tao Ma <boyu.mt@taobao.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] Documentation/ABI: Document the non-ABI status of Kconfig
 and symbols
Message-ID: <20131024084104.GA2861@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Discussion at Kernel Summit made it clear that the presence or absence
of specific Kconfig symbols are not considered ABI, and that no
userspace (or bootloader, etc) should rely on them.

In addition, kernel-internal symbols are well established as non-ABI,
per Documentation/stable_api_nonsense.txt.

Document both of these in Documentation/ABI/README, in a new section for
notable bits of non-ABI.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 Documentation/ABI/README | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/ABI/README b/Documentation/ABI/README
index 1006982..1fafc4b 100644
--- a/Documentation/ABI/README
+++ b/Documentation/ABI/README
@@ -72,3 +72,16 @@ kernel tree without going through the obsolete state first.
 
 It's up to the developer to place their interfaces in the category they
 wish for it to start out in.
+
+
+Notable bits of non-ABI, which should not under any circumstances be considered
+stable:
+
+- Kconfig.  Userspace should not rely on the presence or absence of any
+  particular Kconfig symbol, in /proc/config.gz, in the copy of .config
+  commonly installed to /boot, or in any invocation of the kernel build
+  process.
+
+- Kernel-internal symbols.  Do not rely on the presence, absence, location, or
+  type of any kernel symbol, either in System.map files or the kernel binary
+  itself.  See Documentation/stable_api_nonsense.txt.
-- 
1.8.4.rc3

