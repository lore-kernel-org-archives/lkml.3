Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaEMQ4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:56:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbaEMQ4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:56:44 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Jones <drjones@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH] xen/x86: set panic notifier priority to minimum
Date: Tue, 13 May 2014 18:56:25 +0200
Message-Id: <1400000185-15148-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Execution is not going to continue after telling Xen about the crash.
Let other panic notifiers run by postponing the final hypercall as much
as possible.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/xen/enlighten.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c34bfc4..f17b292 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1339,6 +1339,7 @@ xen_panic_event(struct notifier_block *this, unsigned long event, void *ptr)
 
 static struct notifier_block xen_panic_block = {
 	.notifier_call= xen_panic_event,
+	.priority = INT_MIN
 };
 
 int xen_panic_handler_init(void)
-- 
1.9.0

