Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaGZXOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 19:14:18 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:63593 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaGZXOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 19:14:17 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] block: elevator.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 27 Jul 2014 01:15:41 +0200
Message-Id: <1406416541-8984-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
And set a string to be empty from the start.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 block/elevator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 24c28b6..ad17774 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -118,7 +118,7 @@ static struct elevator_type *elevator_get(const char *name, bool try_loading)
 	return e;
 }
 
-static char chosen_elevator[ELV_NAME_MAX];
+static char chosen_elevator[ELV_NAME_MAX] = "";
 
 static int __init elevator_setup(char *str)
 {
@@ -126,7 +126,7 @@ static int __init elevator_setup(char *str)
 	 * Be backwards-compatible with previous kernels, so users
 	 * won't get the wrong elevator.
 	 */
-	strncpy(chosen_elevator, str, sizeof(chosen_elevator) - 1);
+	strlcpy(chosen_elevator, str, sizeof(chosen_elevator));
 	return 1;
 }
 
-- 
1.7.10.4

