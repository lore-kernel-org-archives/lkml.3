Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaEZTxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:53:34 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:62464 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232AbaEZTxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:53:33 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQKAGibg1NbsG99/2dsb2JhbABZgwdSqlEEAQEBAQEBBQGDPJRQgRUXdIJTExwjGIECJBOIRgHVJIVViH2ERwEDjz+KMwGLF4gQgXiBQjs
Date: Mon, 26 May 2014 21:53:30 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] Documentation/filesystems/seq_file.txt:
 create_proc_entry deprecated
Message-Id: <20140526215330.b258fa45046b9f801491d5e9@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linked article in seq_file.txt still uses create_proc_entry which was removed in

80e928f7ebb958
"proc: Kill create_proc_entry()"

This patch adds information for kernel 3.10 and above

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 Documentation/filesystems/seq_file.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/filesystems/seq_file.txt b/Documentation/filesystems/seq_file.txt
index a1e2e0d..1fe0ccb 100644
--- a/Documentation/filesystems/seq_file.txt
+++ b/Documentation/filesystems/seq_file.txt
@@ -54,6 +54,15 @@ how the mechanism works without getting lost in other details.  (Those
 wanting to see the full source for this module can find it at
 http://lwn.net/Articles/22359/).
 
+Deprecated create_proc_entry
+
+Note that the above article uses create_proc_entry which was removed in
+kernel 3.10. Current versions require the following update
+
+-	entry = create_proc_entry("sequence", 0, NULL);
+-	if (entry)
+-		entry->proc_fops = &ct_file_ops;
++	entry = proc_create("sequence", 0, NULL, &ct_file_ops);
 
 The iterator interface
 
-- 
1.9.1
