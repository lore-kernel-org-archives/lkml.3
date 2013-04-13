Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967411Ab3DRJe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:34:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36921 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967364Ab3DRJey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:34:54 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v4 3/8] vmcore,
 procfs: introduce MEM_TYPE_CURRENT_KERNEL flag to distinguish objects
 copied in 2nd kernel
To: vgoyal@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org
Cc: cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com
Date: Sat, 13 Apr 2013 09:21:22 +0900
Message-ID: <20130413002122.18245.5882.stgit@localhost6.localdomain6>
In-Reply-To: <20130413002000.18245.21513.stgit@localhost6.localdomain6>
References: <20130413002000.18245.21513.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Later patch will copy ELF note segments in buffer on the 2nd
kernel. To handle memory on the 1st kernel (old memory) and memory on
the 2nd kernel in vmcore_list uniformly, introduce
MEM_TYPE_CURRENT_KERNEL flag. If this flag is set, the vmcore object
corresponds to buffer on the 2nd kernel.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 include/linux/proc_fs.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 94dfb2a..fefead4 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -97,11 +97,17 @@ struct kcore_list {
 	int type;
 };
 
+#define MEM_TYPE_CURRENT_KERNEL 0x1
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
+	unsigned int flag;
 };
 
 #ifdef CONFIG_PROC_FS

