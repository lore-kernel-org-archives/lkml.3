Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbbALTTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:19:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57301 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbbALSFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:24 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Huth <thuth@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 008/216] KVM: s390: Fix size of monitor-class number field
Date: Mon, 12 Jan 2015 18:02:05 +0000
Message-Id: <1421085933-32536-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Huth <thuth@linux.vnet.ibm.com>

commit a36c5393266222129ce6f622e3bc3fb5463f290c upstream.

The monitor-class number field is only 16 bits, so we have to use
a u16 pointer to access it.

Signed-off-by: Thomas Huth <thuth@linux.vnet.ibm.com>
Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/s390/kvm/interrupt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 5d5ebd400162..db3625ae7a47 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -247,7 +247,7 @@ static int __deliver_prog_irq(struct kvm_vcpu *vcpu,
 		break;
 	case PGM_MONITOR:
 		rc = put_guest_lc(vcpu, pgm_info->mon_class_nr,
-				  (u64 *)__LC_MON_CLASS_NR);
+				  (u16 *)__LC_MON_CLASS_NR);
 		rc |= put_guest_lc(vcpu, pgm_info->mon_code,
 				   (u64 *)__LC_MON_CODE);
 		break;
-- 
2.1.4

