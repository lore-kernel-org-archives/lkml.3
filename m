Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaDAIBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 04:01:30 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56015 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaDAIB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 04:01:28 -0400
From: Tanya Brokhman <tlinder@codeaurora.org>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, Tanya Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH] mtd: ubi: Test return value of __wl_get_peb
Date: Tue,  1 Apr 2014 11:01:12 +0300
Message-Id: <1396339273-15904-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of an error (if there are not free PEB's for example),
__wl_get_peb will return a negative value. In order to prevent access
violation we need to test the returned value prior to using it later on.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 02317c1..457ead3 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -684,6 +684,9 @@ int ubi_wl_get_peb(struct ubi_device *ubi)
 	peb = __wl_get_peb(ubi);
 	spin_unlock(&ubi->wl_lock);
 
+	if (peb < 0)
+		return peb;
+
 	err = ubi_self_check_all_ff(ubi, peb, ubi->vid_hdr_aloffset,
 				    ubi->peb_size - ubi->vid_hdr_aloffset);
 	if (err) {
-- 
1.7.6
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation


