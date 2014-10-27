Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaJ0DJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 23:09:58 -0400
Received: from mail.eperm.de ([89.247.134.16]:54144 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbaJ0DJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 23:09:57 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: platform-driver-x86@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] quirk for Lenovo Yoga 3: no rfkill switch
Date: Mon, 27 Oct 2014 04:09:50 +0100
Message-ID: <11408587.sP876r0cR3@tachyon.chronox.de>
User-Agent: KMail/4.14.1 (Linux/3.17.1-302.fc21.x86_64; KDE/4.14.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Yoga 3 does not contain any physical rfkill switch. Therefore
disable the rfkill switch identically to the Yoga 2 approach. 

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/platform/x86/ideapad-laptop.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 02152de..ed494f3 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -837,6 +837,13 @@ static const struct dmi_system_id no_hw_rfkill_list[] = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo Yoga 2"),
 		},
 	},
+	{
+		.ident = "Lenovo Yoga 3 Pro 1370",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo YOGA 3 Pro-1370"),
+		},
+	},
 	{}
 };
 
-- 
2.1.0


