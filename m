Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030252Ab3BANSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:18:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:45463 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422729Ab3BANNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:13:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [ 71/89] kvm: Fix irqfd resampler list walk
Date: Fri,  1 Feb 2013 14:08:26 +0100
Message-Id: <20130201130212.600228500@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit 49f8a1a5394d8baee5e56fb71e5cf993c228689a upstream.

Typo for the next pointer means we're walking random data here.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/eventfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -332,7 +332,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct
 		mutex_lock(&kvm->irqfds.resampler_lock);
 
 		list_for_each_entry(resampler,
-				    &kvm->irqfds.resampler_list, list) {
+				    &kvm->irqfds.resampler_list, link) {
 			if (resampler->notifier.gsi == irqfd->gsi) {
 				irqfd->resampler = resampler;
 				break;


