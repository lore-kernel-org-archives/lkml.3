Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaCDRCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 12:02:19 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:49861 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaCDRCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 12:02:17 -0500
Date: Tue, 4 Mar 2014 22:31:53 +0530
From: yogesh <mr.yogesh@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Joe Perches <joe@perches.com>,
        rdunlap@infradead.org
Subject: Subject: [PATCH v2 1/1] Add documentation for proper usage and order
 of preference of calls to print diagnostic messages.
Message-ID: <20140304170153.GA11780@yogesh-Dell-System-XPS-L502X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds documentation that clarifies the use of various
diagnostic printing messages. It shows the preference of subsystem_dbg
calls to dev_dbg (whenever possible), as the first preferred format of
logging debug messages.
Signed-off-by: Yogesh Chaudhari <mr.yogesh@gmail.com>
---
 Documentation/CodingStyle | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 7fe0546..cd14cc8 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -662,6 +662,23 @@ and driver, and are tagged with the right level:  dev_err(), dev_warn(),
 dev_info(), and so forth.  For messages that aren't associated with a
 particular device, <linux/printk.h> defines pr_debug() and pr_info().
 
+If the subsystem has its own diagnostic macros then they should be used
+instead of dev_dbg calls.
+E.g. If you are using network subsystem, use netdev_dbg;
+if you are using V4L, use v4l_dbg etc.
+This standardises the output format in every subsystem.
+
+Depending on your changes, the following order of precedence
+applies to printing messages:
+1. [subsystem]_dbg() is preferred when the subsystem has its own
+diagnostic macros.
+2. dev_dbg() is preferred when you have a generic struct device object.
+3. pr_debug() should be used when 1 and 2 above are not applicable.
+4. printk() should be avoided.
+
+Note: The above order applies to diagnostic calls of all log levels viz:
+*_emerg, *_alert, *_crit, *_err, *_warn, *_notice, *_info and *_dbg.
+
 Coming up with good debugging messages can be quite a challenge; and once
 you have them, they can be a huge help for remote troubleshooting.  Such
 messages should be compiled out when the DEBUG symbol is not defined (that
