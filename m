Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbaDVPaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:30:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbaDVPaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:30:06 -0400
From: Jan Moskyto Matejka <mq@suse.cz>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Jan Moskyto Matejka <mq@suse.cz>
Subject: [PATCH] proc: fix documentation for /proc/stat, line "intr"
Date: Tue, 22 Apr 2014 17:29:40 +0200
Message-Id: <1398180580-8089-1-git-send-email-mq@suse.cz>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sum at the beginning of line "intr" includes also unnumbered interrupts.
It implies that the sum at the beginning isn't the sum of the remainder of the
line, not even an estimation.

Fixed the documentation to mention that.

Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>
---
 Documentation/filesystems/proc.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index f00bee1..4e6f9d0 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1245,8 +1245,9 @@ second).  The meanings of the columns are as follows, from left to right:
 
 The "intr" line gives counts of interrupts  serviced since boot time, for each
 of the  possible system interrupts.   The first  column  is the  total of  all
-interrupts serviced; each  subsequent column is the  total for that particular
-interrupt.
+interrupts serviced  including  unnumbered  architecture specific  interrupts;
+each  subsequent column is the  total for that particular numbered interrupt.
+Unnumbered interrupts are not shown, only summed into the total.
 
 The "ctxt" line gives the total number of context switches across all CPUs.
 
-- 
1.8.4.5

