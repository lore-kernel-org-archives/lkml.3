Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaFDVi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:38:57 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:47357 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaFDVi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:38:56 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentina Manea <valentina.manea.m@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        navin patidar <navinp@cdac.in>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: usbip: stub_main.c:  Cleaning up missing null-terminate after strncpy call
Date: Wed,  4 Jun 2014 23:39:49 +0200
Message-Id: <1401917989-3427-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a guaranteed null-terminate after call to strncpy.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/usbip/stub_main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
index 9c5832a..f1eb6a2 100644
--- a/drivers/staging/usbip/stub_main.c
+++ b/drivers/staging/usbip/stub_main.c
@@ -166,6 +166,7 @@ static ssize_t store_match_busid(struct device_driver *dev, const char *buf,
 		return -EINVAL;
 
 	strncpy(busid, buf + 4, BUSID_SIZE);
+	busid[BUSID_SIZE - 1] = '\0';
 
 	if (!strncmp(buf, "add ", 4)) {
 		if (add_match_busid(busid) < 0)
-- 
1.7.10.4

