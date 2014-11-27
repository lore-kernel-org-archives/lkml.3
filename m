Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbaK0RF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:05:29 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:54416 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaK0RF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:05:26 -0500
Message-ID: <547759D3.3010906@gmail.com>
Date: Thu, 27 Nov 2014 20:05:23 +0300
From: Dmitry Tunin <hanipouspilot@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: platform-driver-x86@vger.kernel.org
CC: linux-kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: [PATCH] asus-nb-wmi: X200MA add wapf=4 quirk
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wifi led does not follow wireless status, add quirk.

Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Tunin <hanipouspilot@gmail.com>
---
  drivers/platform/x86/asus-nb-wmi.c | 9 +++++++++
  1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index c1a6cd6..9ecf466 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -101,6 +101,15 @@ static const struct dmi_system_id asus_quirks[] = {
  	},
  	{
  		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. X200MA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X200MA"),
+		},
+		.driver_data = &quirk_asus_wapf4,
+	},
+	{
+		.callback = dmi_matched,
  		.ident = "ASUSTeK COMPUTER INC. X401U",
  		.matches = {
  			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-- 
1.9.1
