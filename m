Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab3EIXCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 19:02:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757381Ab3EIWcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:32:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shuah Khan <shuahkhan@gmail.com>, Joerg Roedel <joro@8bytes.org>
Subject: [ 07/73] iommu/amd: Properly initialize irq-table lock
Date: Thu,  9 May 2013 15:31:30 -0700
Message-Id: <20130509222758.767624767@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joro@8bytes.org>

commit 197887f03daecdb3ae21bafeb4155412abad3497 upstream.

Fixes a lockdep warning.

Reviewed-by: Shuah Khan <shuahkhan@gmail.com>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3948,6 +3948,9 @@ static struct irq_remap_table *get_irq_t
 	if (!table)
 		goto out;
 
+	/* Initialize table spin-lock */
+	spin_lock_init(&table->lock);
+
 	if (ioapic)
 		/* Keep the first 32 indexes free for IOAPIC interrupts */
 		table->min_index = 32;


