Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbaEERco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:32:44 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:25121 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134AbaEERcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:32:41 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoEJAOLKZ1NbsEtU/2dsb2JhbABZgwarUQcBAgUBmgyBFxd0glMTHCMYgQIkE4hFAcwLhVaIfIRGAQOPGooZAZJ0gzY7
Date: Mon, 5 May 2014 19:32:39 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH 1/1] kernel/capability.c: code clean-up
Message-Id: <20140505193239.4cdf36d7368e415f788e84c8@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-EXPORT_SYMBOL
-typo: unexpectidly->unexpectedly
-function prototype over 80 characters

Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/capability.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/capability.c b/kernel/capability.c
index a8d63df..84b2bbf 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -24,7 +24,6 @@
  */
 
 const kernel_cap_t __cap_empty_set = CAP_EMPTY_SET;
-
 EXPORT_SYMBOL(__cap_empty_set);
 
 int file_caps_enabled = 1;
@@ -189,7 +188,7 @@ SYSCALL_DEFINE2(capget, cap_user_header_t, header, cap_user_data_t, dataptr)
 		 *
 		 * An alternative would be to return an error here
 		 * (-ERANGE), but that causes legacy applications to
-		 * unexpectidly fail; the capget/modify/capset aborts
+		 * unexpectedly fail; the capget/modify/capset aborts
 		 * before modification is attempted and the application
 		 * fails.
 		 */
@@ -395,7 +394,8 @@ EXPORT_SYMBOL(ns_capable);
  * This does not set PF_SUPERPRIV because the caller may not
  * actually be privileged.
  */
-bool file_ns_capable(const struct file *file, struct user_namespace *ns, int cap)
+bool file_ns_capable(const struct file *file, struct user_namespace *ns,
+		     int cap)
 {
 	if (WARN_ON_ONCE(!cap_valid(cap)))
 		return false;
-- 
1.9.1
