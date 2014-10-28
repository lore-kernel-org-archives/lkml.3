Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285AbaJ1Gvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:51:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932957AbaJ1Ds0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:48:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@linux.vnet.ibm.com>
Subject: [PATCH 3.14 014/100] KVM: s390: unintended fallthrough for external call
Date: Tue, 28 Oct 2014 11:34:59 +0800
Message-Id: <20141028033501.290280787@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033500.670583608@linuxfoundation.org>
References: <20141028033500.670583608@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit f346026e55f1efd3949a67ddd1dcea7c1b9a615e upstream.

We must not fallthrough if the conditions for external call are not met.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Thomas Huth <thuth@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kvm/interrupt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -71,6 +71,7 @@ static int __interrupt_is_deliverable(st
 			return 0;
 		if (vcpu->arch.sie_block->gcr[0] & 0x2000ul)
 			return 1;
+		return 0;
 	case KVM_S390_INT_EMERGENCY:
 		if (psw_extint_disabled(vcpu))
 			return 0;


