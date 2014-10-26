Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaJZK0x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 06:26:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbaJZK0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 06:26:52 -0400
Date: Sun, 26 Oct 2014 11:23:55 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Darren Hart <dvhart@infradead.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] asus-nb-wmi: Add wapf4 quirk for the X550VB
Message-ID: <20141026102354.GA2588@redhat.com>
References: <20141022123252.GC1876@redhat.com>
 <20141025051116.GA53394@vmdeb7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141025051116.GA53394@vmdeb7>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X550VB as many others Asus laptops need wapf4 quirk to make RFKILL
switch be functional. Otherwise system boots with wireless card
disabled and is only possible to enable it by suspend/resume.

Bug report:
http://bugzilla.redhat.com/show_bug.cgi?id=1089731#c23

Reported-and-tested-by: Vratislav Podzimek <vpodzime@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2: update changelog

 drivers/platform/x86/asus-nb-wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 3a4951f..c1a6cd6 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -182,6 +182,15 @@ static const struct dmi_system_id asus_quirks[] = {
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. X550VB",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X550VB"),
+		},
+		.driver_data = &quirk_asus_wapf4,
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "ASUSTeK COMPUTER INC. X55A",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-- 
1.8.3.1

