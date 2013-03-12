Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab3CLEzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 00:55:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:47475 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab3CLEzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 00:55:41 -0400
X-IronPort-AV: E=Sophos;i="4.84,827,1355068800"; 
   d="scan'208";a="6856217"
Message-ID: <513EB4EE.1040300@cn.fujitsu.com>
Date: Tue, 12 Mar 2013 12:54:06 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/18] powerpc: remove cast for kmalloc/kzalloc return value
References: <513EB23D.7020303@cn.fujitsu.com>
In-Reply-To: <513EB23D.7020303@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 12:54:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 12:54:27,
	Serialize complete at 2013/03/12 12:54:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove cast for kmalloc/kzalloc return value.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/kernel/nvram_64.c |    3 +--
 arch/powerpc/kvm/book3s_pr.c   |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/nvram_64.c b/arch/powerpc/kernel/nvram_64.c
index bec1e93..48fbc2b 100644
--- a/arch/powerpc/kernel/nvram_64.c
+++ b/arch/powerpc/kernel/nvram_64.c
@@ -511,8 +511,7 @@ int __init nvram_scan_partitions(void)
 			       "detected: 0-length partition\n");
 			goto out;
 		}
-		tmp_part = (struct nvram_partition *)
-			kmalloc(sizeof(struct nvram_partition), GFP_KERNEL);
+		tmp_part = kmalloc(sizeof(struct nvram_partition), GFP_KERNEL);
 		err = -ENOMEM;
 		if (!tmp_part) {
 			printk(KERN_ERR "nvram_scan_partitions: kmalloc failed\n");
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 5e93438..dbdc15a 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1039,7 +1039,7 @@ struct kvm_vcpu *kvmppc_core_vcpu_create(struct kvm *kvm, unsigned int id)
 	if (!vcpu_book3s)
 		goto out;
 
-	vcpu_book3s->shadow_vcpu = (struct kvmppc_book3s_shadow_vcpu *)
+	vcpu_book3s->shadow_vcpu =
 		kzalloc(sizeof(*vcpu_book3s->shadow_vcpu), GFP_KERNEL);
 	if (!vcpu_book3s->shadow_vcpu)
 		goto free_vcpu;
-- 
1.7.1

