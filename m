Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaBTXuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:50:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbaBTXue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:50:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.4 20/25] KVM: return an error code in kvm_vm_ioctl_register_coalesced_mmio()
Date: Thu, 20 Feb 2014 15:51:36 -0800
Message-Id: <20140220234843.049947586@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234842.483343851@linuxfoundation.org>
References: <20140220234842.483343851@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit aac5c4226e7136c331ed384c25d5560204da10a0 upstream.

If kvm_io_bus_register_dev() fails then it returns success but it should
return an error code.

I also did a little cleanup like removing an impossible NULL test.

Fixes: 2b3c246a682c ('KVM: Make coalesced mmio use a device per zone')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/coalesced_mmio.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -154,17 +154,13 @@ int kvm_vm_ioctl_register_coalesced_mmio
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


