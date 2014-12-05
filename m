Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbaLEXpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:45:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaLEWqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 3.17 049/122] powerpc/powernv: Fix the hmi event version check.
Date: Fri,  5 Dec 2014 14:43:43 -0800
Message-Id: <20141205223312.934897243@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>

commit 6acbc5a1dab30aa8f7be7bf3852f343f89147ac5 upstream.

The current HMI event structure is an ABI and carries a version field to
accommodate future changes without affecting/rearranging current structure
members that are valid for previous versions.

The current version check "if (hmi_evt->version != OpalHMIEvt_V1)"
doesn't accomodate the fact that the version number may change in
future.

If firmware starts returning an HMI event with version > 1, this check
will fail and no HMI information will be printed on older kernels.

This patch fixes this issue.

Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
[mpe: Reword changelog]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/opal-hmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/powernv/opal-hmi.c
+++ b/arch/powerpc/platforms/powernv/opal-hmi.c
@@ -57,7 +57,7 @@ static void print_hmi_event_info(struct
 	};
 
 	/* Print things out */
-	if (hmi_evt->version != OpalHMIEvt_V1) {
+	if (hmi_evt->version < OpalHMIEvt_V1) {
 		pr_err("HMI Interrupt, Unknown event version %d !\n",
 			hmi_evt->version);
 		return;


