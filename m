Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab3CFJFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 04:05:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41818 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab3CFJFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 04:05:38 -0500
Date: Wed, 6 Mar 2013 01:03:23 -0800
From: "tip-bot for Li, Zhen-Hua" <tipbot@zytor.com>
Message-ID: <tip-4ecccd9edd5eb4dd185486e6e593c671484691bc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        joro@8bytes.org, ddutile@redhat.com, zhen-hual@hp.com, hare@suse.de,
        suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joro@8bytes.org, ddutile@redhat.com, zhen-hual@hp.com, hare@suse.de,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1362537797-6034-1-git-send-email-zhen-hual@hp.com>
References: <1362537797-6034-1-git-send-email-zhen-hual@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] iommu, x86: Add DMA remap fault reason
Git-Commit-ID: 4ecccd9edd5eb4dd185486e6e593c671484691bc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Mar 2013 01:03:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4ecccd9edd5eb4dd185486e6e593c671484691bc
Gitweb:     http://git.kernel.org/tip/4ecccd9edd5eb4dd185486e6e593c671484691bc
Author:     Li, Zhen-Hua <zhen-hual@hp.com>
AuthorDate: Wed, 6 Mar 2013 10:43:17 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Mar 2013 09:41:51 +0100

iommu, x86: Add DMA remap fault reason

The number of DMA fault reasons in intel's document are from 1
to 0xD, but in dmar.c fault reason 0xD is not printed out.

In this document:

 "Intel Virtualization Technology for Directed I/O Architecture Specification"
 http://download.intel.com/technology/computing/vptech/Intel(r)_VT_for_Direct_IO.pdf

Chapter 4. Support For Device-IOTLBs

Table 6. Unsuccessful Translated Requests

There is fault reason for 0xD not listed in kernel:

    Present context-entry used to process translation request
    specifies blocking of Translation Requests (Translation Type (T)
    field value not equal to 01b).

This patch adds reason 0xD as well.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Donald Dutile <ddutile@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Hannes Reinecke <hare@suse.de>
Link: http://lkml.kernel.org/r/1362537797-6034-1-git-send-email-zhen-hual@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/iommu/dmar.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index dc7e478..e5cdaf8 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1083,6 +1083,7 @@ static const char *dma_remap_fault_reasons[] =
 	"non-zero reserved fields in RTP",
 	"non-zero reserved fields in CTP",
 	"non-zero reserved fields in PTE",
+	"PCE for translation request specifies blocking",
 };
 
 static const char *irq_remap_fault_reasons[] =
