Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161055AbaKLBzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:55:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966728AbaKLBzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:55:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Baron <jbaron@akamai.com>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 3.10 102/123] cpc925_edac: Report UE events properly
Date: Wed, 12 Nov 2014 10:17:48 +0900
Message-Id: <20141112011723.626561361@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Baron <jbaron@akamai.com>

commit fa19ac4b92bc2b5024af3e868f41f81fa738567a upstream.

Fix UE event being reported as HW_EVENT_ERR_CORRECTED.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Link: http://lkml.kernel.org/r/8beb13803500076fef827eab33d523e355d83759.1413405053.git.jbaron@akamai.com
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/cpc925_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -562,7 +562,7 @@ static void cpc925_mc_check(struct mem_c
 
 	if (apiexcp & UECC_EXCP_DETECTED) {
 		cpc925_mc_printk(mci, KERN_INFO, "DRAM UECC Fault\n");
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 				     pfn, offset, 0,
 				     csrow, -1, -1,
 				     mci->ctl_name, "");


