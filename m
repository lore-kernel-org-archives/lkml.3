Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaKGMS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:18:59 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58242 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbaKGMS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:18:56 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: unisys: dereferencing NULL pointer
Date: Fri,  7 Nov 2014 17:48:35 +0530
Message-Id: <1415362715-24224-2-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1415362715-24224-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1415362715-24224-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we can reach the label Away in total five situation and in four of
of them pDevInfo is NULL. so we were basically dereferencing a NULL
pointer.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/unisys/visorchipset/visorchipset_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/unisys/visorchipset/visorchipset_main.c b/drivers/staging/unisys/visorchipset/visorchipset_main.c
index b5a0e46..c8f7bea 100644
--- a/drivers/staging/unisys/visorchipset/visorchipset_main.c
+++ b/drivers/staging/unisys/visorchipset/visorchipset_main.c
@@ -1298,7 +1298,8 @@ my_device_create(struct controlvm_message *inmsg)
 			 POSTCODE_SEVERITY_INFO);
 Away:
 	/* get the bus and devNo for DiagPool channel */
-	if (is_diagpool_channel(pDevInfo->chan_info.channel_type_uuid)) {
+	if (pDevInfo &&
+	    is_diagpool_channel(pDevInfo->chan_info.channel_type_uuid)) {
 		g_diagpoolBusNo = busNo;
 		g_diagpoolDevNo = devNo;
 		LOGINF("CONTROLVM_DEVICE_CREATE for DiagPool channel: busNo=%lu, devNo=%lu",
-- 
1.8.1.2

