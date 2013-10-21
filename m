Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3JUD6z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 23:58:55 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33802 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab3JUD6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 23:58:51 -0400
From: Benson Leung <bleung@chromium.org>
To: matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, adurbin@chromium.org,
        dlaurie@chromium.org, olofj@chromium.org, enselic@gmail.com
Cc: bleung@chromium.org
Subject: [PATCH 3/6] Platform: x86: chromeos_laptop - fix incorrect placement of __initdata tag
Date: Sun, 20 Oct 2013 20:58:26 -0700
Message-Id: <1382327909-6140-4-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382327909-6140-1-git-send-email-bleung@chromium.org>
References: <1382327909-6140-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__initdata tag should be placed between the variable name and equal
sign for the variable to be placed in the intended .init.data section.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/platform/x86/chromeos_laptop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/chromeos_laptop.c b/drivers/platform/x86/chromeos_laptop.c
index e542330..1c2747f 100644
--- a/drivers/platform/x86/chromeos_laptop.c
+++ b/drivers/platform/x86/chromeos_laptop.c
@@ -406,7 +406,7 @@ static struct chromeos_laptop cr48 = {
 	.callback = chromeos_laptop_dmi_matched, \
 	.driver_data = (void *)&board_
 
-static struct dmi_system_id __initdata chromeos_laptop_dmi_table[] = {
+static struct dmi_system_id chromeos_laptop_dmi_table[] __initdata = {
 	{
 		.ident = "Samsung Series 5 550",
 		.matches = {
-- 
1.8.3.2

