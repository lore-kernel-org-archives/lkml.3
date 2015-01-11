Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbbAKWYf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:24:35 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:55367 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbbAKWYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:24:33 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kernel: power: snapshot: Remove unused function
Date: Sun, 11 Jan 2015 23:27:38 +0100
Message-Id: <1421015258-24472-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function get_safe_write_buffer() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 kernel/power/snapshot.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 791a618..dac8919 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -2309,8 +2309,6 @@ static inline void free_highmem_data(void)
 		free_image_page(buffer, PG_UNSAFE_CLEAR);
 }
 #else
-static inline int get_safe_write_buffer(void) { return 0; }
-
 static unsigned int
 count_highmem_image_pages(struct memory_bitmap *bm) { return 0; }
 
-- 
1.7.10.4

