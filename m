Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbaCaAWL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:22:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36308 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752952AbaC3XZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:00 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paolo Bonzini" <pbonzini@redhat.com>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.489391107@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 062/200] KVM: return an error code in kvm_vm_ioctl_register_coalesced_mmio()
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit aac5c4226e7136c331ed384c25d5560204da10a0 upstream.

If kvm_io_bus_register_dev() fails then it returns success but it should
return an error code.

I also did a little cleanup like removing an impossible NULL test.

Fixes: 2b3c246a682c ('KVM: Make coalesced mmio use a device per zone')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 virt/kvm/coalesced_mmio.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -148,17 +148,13 @@ int kvm_vm_ioctl_register_coalesced_mmio
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

