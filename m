Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908Ab3EGEdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:33:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560Ab3EGEZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:53 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Y8mbiK2kssUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=nIBoYseWPxQA:10 a=jdP34snFAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=ph7TQQQmLnIvo-Ghm-YA:9 a=9mtjllxcxZAA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035853.932675574@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [078/126] ath9k_hw: change AR9580 initvals to fix a stability issue
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0078-ath9k_hw-change-AR9580-initvals-to-fix-a-stability-i.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

[ Upstream commit f09a878511997c25a76bf111a32f6b8345a701a5 ]

The hardware parsing of Control Wrapper Frames needs to be disabled, as
it has been causing spurious decryption error reports. The initvals for
other chips have been updated to disable it, but AR9580 was left out for
some reason.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
index 6e1915a..c00c13a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
@@ -519,7 +519,7 @@ static const u32 ar9580_1p0_mac_core[][2] = {
 	{0x00008258, 0x00000000},
 	{0x0000825c, 0x40000000},
 	{0x00008260, 0x00080922},
-	{0x00008264, 0x9bc00010},
+	{0x00008264, 0x9d400010},
 	{0x00008268, 0xffffffff},
 	{0x0000826c, 0x0000ffff},
 	{0x00008270, 0x00000000},
-- 
1.7.10.4


