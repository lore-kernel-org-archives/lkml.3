Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574Ab3CSCay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:30:54 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47050 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933377Ab3CSCau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:30:50 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v3 09/21] vmcore: modify vmcore clean-up function to free
 buffer on 2nd kernel
To: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Date: Sat, 16 Mar 2013 13:01:37 +0900
Message-ID: <20130316040137.15064.72196.stgit@localhost6.localdomain6>
In-Reply-To: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If flag MEM_TYPE_CURRENT_KERNEL is set, the object is copied in some
buffer on the 2nd kernel, so clean-up funciton needs to free it.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 766e75f..b85ba32 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -940,6 +940,10 @@ void vmcore_cleanup(void)
 		struct vmcore *m;
 
 		m = list_entry(pos, struct vmcore, list);
+
+		if (m->flag & MEM_TYPE_CURRENT_KERNEL)
+			free_pages((unsigned long)m->buf, get_order(m->size));
+
 		list_del(&m->list);
 		kfree(m);
 	}

