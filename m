Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966746AbaKLBzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:55:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33073 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966728AbaKLBz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:55:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Baron <jbaron@akamai.com>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 3.10 100/123] i3200_edac: Report CE events properly
Date: Wed, 12 Nov 2014 10:17:46 +0900
Message-Id: <20141112011723.538617445@linuxfoundation.org>
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

commit 8a3f075d6c9b3612b4a5fb2af8db82b38b20caf0 upstream.

Fix CE event being reported as HW_EVENT_ERR_UNCORRECTED.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Link: http://lkml.kernel.org/r/d02465b4f30314b390c12c061502eda5e9d29c52.1413405053.git.jbaron@akamai.com
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/i3200_edac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -242,11 +242,11 @@ static void i3200_process_error_info(str
 					     -1, -1,
 					     "i3000 UE", "");
 		} else if (log & I3200_ECCERRLOG_CE) {
-			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 					     0, 0, eccerrlog_syndrome(log),
 					     eccerrlog_row(channel, log),
 					     -1, -1,
-					     "i3000 UE", "");
+					     "i3000 CE", "");
 		}
 	}
 }


