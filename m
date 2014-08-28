Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaH1NQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:16:53 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:36264 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaH1NOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:14:35 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, gregkh@linuxfoundation.org
Subject: [PATCH 03/11] misc: st_kim: Increase size of dev_name buffer to incorporate termination
Date: Thu, 28 Aug 2014 14:14:09 +0100
Message-Id: <1409231657-18294-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409231657-18294-1-git-send-email-lee.jones@linaro.org>
References: <1409231657-18294-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling strncpy with a maximum size argument of 32 bytes on destination
array kim_gdata->dev_name of size 32 bytes might leave the destination
string unterminated.

Cc: gregkh@linuxfoundation.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/ti_wilink_st.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ti_wilink_st.h b/include/linux/ti_wilink_st.h
index 932b7639..884d626 100644
--- a/include/linux/ti_wilink_st.h
+++ b/include/linux/ti_wilink_st.h
@@ -268,7 +268,7 @@ struct kim_data_s {
 	struct st_data_s *core_data;
 	struct chip_version version;
 	unsigned char ldisc_install;
-	unsigned char dev_name[UART_DEV_NAME_LEN];
+	unsigned char dev_name[UART_DEV_NAME_LEN + 1];
 	unsigned char flow_cntrl;
 	unsigned long baud_rate;
 };
-- 
1.9.1

