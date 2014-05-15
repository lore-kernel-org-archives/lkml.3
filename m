Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbaEOUzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:55:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38106 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaEOUzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:55:36 -0400
Message-ID: <537529C6.6010408@infradead.org>
Date: Thu, 15 May 2014 13:55:34 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jan Moskyto Matejka <mq@suse.cz>
Subject: [PATCH 4/4] Documentation: update /proc/stat "intr" count summary
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Moskyto Matejka <mq@suse.cz>

The sum at the beginning of line "intr" includes also unnumbered interrupts.
It implies that the sum at the beginning isn't the sum of the remainder of the
line, not even an estimation.

Fixed the documentation to mention that.

This behaviour was added to /proc/stat in commit
a2eddfa95919a730e0e5ed17e9c303fe5ba249cd.

Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 Documentation/filesystems/proc.txt |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- lnx-315-rc2.orig/Documentation/filesystems/proc.txt
+++ lnx-315-rc2/Documentation/filesystems/proc.txt
@@ -1245,8 +1245,9 @@ second).  The meanings of the columns ar
 
 The "intr" line gives counts of interrupts  serviced since boot time, for each
 of the  possible system interrupts.   The first  column  is the  total of  all
-interrupts serviced; each  subsequent column is the  total for that particular
-interrupt.
+interrupts serviced  including  unnumbered  architecture specific  interrupts;
+each  subsequent column is the  total for that particular numbered interrupt.
+Unnumbered interrupts are not shown, only summed into the total.
 
 The "ctxt" line gives the total number of context switches across all CPUs.
 
