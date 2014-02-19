Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaBSKPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:15:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbaBSKOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:14:01 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH] kvm: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Wed, 19 Feb 2014 11:15:31 +0100
Message-Id: <1392804931-30671-11-git-send-email-agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 virt/kvm/assigned-dev.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index 8db4370..92e25e9 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -395,8 +395,9 @@ static int assigned_device_enable_host_msix(struct kvm *kvm,
 	if (dev->entries_nr == 0)
 		return r;
 
-	r = pci_enable_msix(dev->dev, dev->host_msix_entries, dev->entries_nr);
-	if (r)
+	r = pci_enable_msix_range(dev->dev, dev->host_msix_entries,
+				  dev->entries_nr, dev->entries_nr);
+	if (r < 0)
 		return r;
 
 	for (i = 0; i < dev->entries_nr; i++) {
-- 
1.7.7.6

