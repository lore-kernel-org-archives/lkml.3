Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948Ab3BNKML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:12:11 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48696 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758091Ab3BNKMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:12:07 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH 04/13] vmcore: introduce types for objects copied in 2nd kernel
To: ebiederm@xmission.com, vgoyal@redhat.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2013 19:12:05 +0900
Message-ID: <20130214101205.22466.5909.stgit@localhost6.localdomain6>
In-Reply-To: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some parts of old memory need to be copied in buffers on 2nd kernel to
be remapped to user-space. To distinguish objects in the buffer on 2nd
kernel and the ones on old memory, enum vmcore_type is introduced: the
object in the buffer on 2nd kernel has VMCORE_2ND_KERNEL type, and the
one on old memory has VMCORE_OLD_MEMORY type.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 include/linux/proc_fs.h |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 32676b3..4b153ed 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -97,11 +97,20 @@ struct kcore_list {
 	int type;
 };
 
+enum vmcore_type {
+	VMCORE_OLD_MEMORY,
+	VMCORE_2ND_KERNEL,
+};
+
 struct vmcore {
 	struct list_head list;
-	unsigned long long paddr;
+	union {
+		unsigned long long paddr;
+		char *buf;
+	};
 	unsigned long long size;
 	loff_t offset;
+	enum vmcore_type type;
 };
 
 #ifdef CONFIG_PROC_FS

