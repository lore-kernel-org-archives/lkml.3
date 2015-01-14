Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbbANIga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:36:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbbANH1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:27:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Huth <thuth@linux.vnet.ibm.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 3.18 064/150] KVM: s390: Fix size of monitor-class number field
Date: Tue, 13 Jan 2015 23:22:15 -0800
Message-Id: <20150114072058.745732169@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Huth <thuth@linux.vnet.ibm.com>

commit a36c5393266222129ce6f622e3bc3fb5463f290c upstream.

The monitor-class number field is only 16 bits, so we have to use
a u16 pointer to access it.

Signed-off-by: Thomas Huth <thuth@linux.vnet.ibm.com>
Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kvm/interrupt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -270,7 +270,7 @@ static int __must_check __deliver_prog_i
 		break;
 	case PGM_MONITOR:
 		rc = put_guest_lc(vcpu, pgm_info->mon_class_nr,
-				  (u64 *)__LC_MON_CLASS_NR);
+				  (u16 *)__LC_MON_CLASS_NR);
 		rc |= put_guest_lc(vcpu, pgm_info->mon_code,
 				   (u64 *)__LC_MON_CODE);
 		break;


