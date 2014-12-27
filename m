Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbaL0WBV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 17:01:21 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:60954 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaL0WBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 17:01:19 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ken Cox <jkc@redhat.com>, Daeseok Youn <daeseok.youn@gmail.com>,
        "Tobenna P. Igwe" <ptigwe@gmail.com>, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: unisys: uislib: uisutils.c:  Fix a missing va_end
Date: Sat, 27 Dec 2014 23:04:14 +0100
Message-Id: <1419717855-6760-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A missing va_end in connection with vsnprintf

Was found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/unisys/uislib/uisutils.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/unisys/uislib/uisutils.c b/drivers/staging/unisys/uislib/uisutils.c
index 8ff6d26..d821c82 100644
--- a/drivers/staging/unisys/uislib/uisutils.c
+++ b/drivers/staging/unisys/uislib/uisutils.c
@@ -59,6 +59,7 @@ uisutil_add_proc_line_ex(int *total, char **buffer, int *buffer_remaining,
 	DBGINF("buffer = 0x%p : *buffer = 0x%p.\n", buffer, *buffer);
 	va_start(args, format);
 	len = vsnprintf(*buffer, *buffer_remaining, format, args);
+	va_end(args);
 	if (len >= *buffer_remaining) {
 		*buffer += *buffer_remaining;
 		*total += *buffer_remaining;
-- 
1.7.10.4

