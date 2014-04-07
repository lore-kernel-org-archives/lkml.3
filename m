Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaDGFWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 01:22:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44111 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaDGFWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 01:22:09 -0400
From: "Dolev Raviv" <draviv@codeaurora.org>
To: "'Tanya Brokhman'" <tlinder@codeaurora.org>, <dedekind1@gmail.com>
Cc: <linux-mtd@lists.infradead.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1396339273-15904-1-git-send-email-tlinder@codeaurora.org>
In-Reply-To: <1396339273-15904-1-git-send-email-tlinder@codeaurora.org>
Subject: RE: [RFC/PATCH] mtd: ubi: Test return value of __wl_get_peb
Date: Mon, 7 Apr 2014 08:22:05 +0300
Message-ID: <001901cf5221$52161110$f6423330$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIvHMrUK5vo1vjs3gwR8pOPAffflZpGCQdw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Dolev Raviv <draviv@codeaurora.org>

Thanks,
Dolev
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation


-----Original Message-----
From: linux-mtd [mailto:linux-mtd-bounces@lists.infradead.org] On Behalf Of
Tanya Brokhman
Sent: Tuesday, April 01, 2014 11:01 AM
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org; open list; Tanya Brokhman
Subject: [RFC/PATCH] mtd: ubi: Test return value of __wl_get_peb

In case of an error (if there are not free PEB's for example), __wl_get_peb
will return a negative value. In order to prevent access violation we need
to test the returned value prior to using it later on.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c index
02317c1..457ead3 100644
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



______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/

