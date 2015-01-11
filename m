Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbbAKWUY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:20:24 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:61136 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbbAKWUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:20:21 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Thomas Pugliese <thomas.pugliese@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] uwb: lc-dev: Remove unused function
Date: Sun, 11 Jan 2015 23:23:25 +0100
Message-Id: <1421015005-24286-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function uwb_dev_addr_bcast() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/uwb/lc-dev.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/uwb/lc-dev.c b/drivers/uwb/lc-dev.c
index 8c7cfab..7203358 100644
--- a/drivers/uwb/lc-dev.c
+++ b/drivers/uwb/lc-dev.c
@@ -43,13 +43,6 @@ static inline void uwb_mac_addr_init(struct uwb_mac_addr *addr)
 	memset(&addr->data, 0xff, sizeof(addr->data));
 }
 
-/* @returns !0 if a device @addr is a broadcast address */
-static inline int uwb_dev_addr_bcast(const struct uwb_dev_addr *addr)
-{
-	static const struct uwb_dev_addr bcast = { .data = { 0xff, 0xff } };
-	return !uwb_dev_addr_cmp(addr, &bcast);
-}
-
 /*
  * Add callback @new to be called when an event occurs in @rc.
  */
-- 
1.7.10.4

