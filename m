Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491AbaKLBen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:34:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933447AbaKLBei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:34:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Baron <jbaron@akamai.com>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 3.17 252/319] i82860_edac: Report CE events properly
Date: Wed, 12 Nov 2014 10:16:30 +0900
Message-Id: <20141112011034.488410879@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Baron <jbaron@akamai.com>

commit ab0543de6ff0877474f57a5aafbb51a61e88676f upstream.

Fix CE event being reported as HW_EVENT_ERR_UNCORRECTED.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Link: http://lkml.kernel.org/r/7aee8e244a32ff86b399a8f966c4aae70296aae0.1413405053.git.jbaron@akamai.com
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/i82860_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/i82860_edac.c
+++ b/drivers/edac/i82860_edac.c
@@ -124,7 +124,7 @@ static int i82860_process_error_info(str
 				     dimm->location[0], dimm->location[1], -1,
 				     "i82860 UE", "");
 	else
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 				     info->eap, 0, info->derrsyn,
 				     dimm->location[0], dimm->location[1], -1,
 				     "i82860 CE", "");


