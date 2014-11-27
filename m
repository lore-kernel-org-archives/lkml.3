Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbaK0QkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:40:05 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:46326 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaK0QkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:40:02 -0500
Message-ID: <547753DE.9050809@gmail.com>
Date: Thu, 27 Nov 2014 19:39:58 +0300
From: Dmitry Tunin <hanipouspilot@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: platform-driver-x86@vger.kernel.org
CC: stable@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ideapad_laptop: Lenovo G50-30 fix rfkill always reports wireless
 blocked
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rfkill always shows wireless blocked unless ideapad_laptop is blacklisted.
Add a quirk.

Cc: stable@vger.kernel.org
BugLink:https://bugs.launchpad.net/bugs/1397021
Signed-off-by: Dmitry Tunin <hanipouspilot@gmail.com>
---
  drivers/platform/x86/ideapad-laptop.c | 7 +++++++
  1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index ed494f3..9958de6 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -844,6 +844,13 @@ static const struct dmi_system_id no_hw_rfkill_list[] = {
  			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo YOGA 3 Pro-1370"),
  		},
  	},
+	{
+		.ident = "Lenovo G50-30",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo G50-30"),
+		},
+	},
  	{}
  };
  
-- 
1.9.1
