Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab3AJXlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:41:52 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:54400 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754440Ab3AJXlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:41:44 -0500
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com
Subject: [PATCH 4/6] VMCI: Fix "always true condition"
Date: Thu, 10 Jan 2013 15:41:41 -0800
Message-Id: <1357861303-25903-4-git-send-email-dtor@vmware.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357861303-25903-1-git-send-email-dtor@vmware.com>
References: <1357861303-25903-1-git-send-email-dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy King <acking@vmware.com>

vmci_send_datagram() returns an int, with negative values indicating failure.
But we store it locally in a u32, which makes comparison of >= 0 useless.
Fixed to use an int.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andy King <acking@vmware.com>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_guest.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_guest.c b/drivers/misc/vmw_vmci/vmci_guest.c
index d302c89..d7df6cf 100644
--- a/drivers/misc/vmw_vmci/vmci_guest.c
+++ b/drivers/misc/vmw_vmci/vmci_guest.c
@@ -78,7 +78,7 @@ bool vmci_guest_code_active(void)
 u32 vmci_get_vm_context_id(void)
 {
 	if (vm_context_id == VMCI_INVALID_ID) {
-		u32 result;
+		int result;
 		struct vmci_datagram get_cid_msg;
 		get_cid_msg.dst =
 		    vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
-- 
1.7.4.1

