Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbaBUNRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:17:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47716 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674AbaBUNCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:02:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 30/60] KVM: return an error code in kvm_vm_ioctl_register_coalesced_mmio()
Date: Fri, 21 Feb 2014 13:00:57 +0000
Message-Id: <1392987687-15367-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit aac5c4226e7136c331ed384c25d5560204da10a0 upstream.

If kvm_io_bus_register_dev() fails then it returns success but it should
return an error code.

I also did a little cleanup like removing an impossible NULL test.

Fixes: 2b3c246a682c ('KVM: Make coalesced mmio use a device per zone')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 virt/kvm/coalesced_mmio.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 88b2fe3..00d8642 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -154,17 +154,13 @@ int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
 	list_add_tail(&dev->list, &kvm->coalesced_zones);
 	mutex_unlock(&kvm->slots_lock);
 
-	return ret;
+	return 0;
 
 out_free_dev:
 	mutex_unlock(&kvm->slots_lock);
-
 	kfree(dev);
 
-	if (dev == NULL)
-		return -ENXIO;
-
-	return 0;
+	return ret;
 }
 
 int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
-- 
1.9.0

