Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933361AbaJ1H7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:59:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbaJ1DhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:37:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@linux.vnet.ibm.com>
Subject: [PATCH 3.17 019/146] KVM: s390: unintended fallthrough for external call
Date: Tue, 28 Oct 2014 11:32:41 +0800
Message-Id: <20141028033344.248669677@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -85,6 +85,7 @@ static int __interrupt_is_deliverable(st
 			return 0;
 		if (vcpu->arch.sie_block->gcr[0] & 0x2000ul)
 			return 1;
+		return 0;
 	case KVM_S390_INT_EMERGENCY:
 		if (psw_extint_disabled(vcpu))
 			return 0;


