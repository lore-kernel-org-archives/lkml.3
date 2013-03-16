Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933511Ab3CSCal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:30:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47035 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933377Ab3CSCaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:30:39 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v3 07/21] vmcore,
 procfs: introduce a flag to distinguish objects copied in 2nd kernel
To: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Date: Sat, 16 Mar 2013 13:01:26 +0900
Message-ID: <20130316040126.15064.67305.stgit@localhost6.localdomain6>
In-Reply-To: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The part of dump target memory is copied into the 2nd kernel if it
doesn't satisfy mmap()'s page-size boundary requirement. To
distinguish such copied object from usual old memory, a flag
MEM_TYPE_CURRENT_KERNEL is introduced. If this flag is set, the object
is considered being copied into buffer on the 2nd kernel.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 include/linux/proc_fs.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 8307f2f..11dd592 100644
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

