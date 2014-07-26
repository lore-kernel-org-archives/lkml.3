Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaGZOkV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:40:21 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:65472 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaGZOkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:40:20 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ken Cox <jkc@redhat.com>, Daeseok Youn <daeseok.youn@gmail.com>,
        Silvio F <silvio.fricke@gmail.com>, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: unisys: include: uisutils.h:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:41:46 +0200
Message-Id: <1406385706-3658-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/unisys/include/uisutils.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/unisys/include/uisutils.h b/drivers/staging/unisys/include/uisutils.h
index 70776c9..14d5cbd 100644
--- a/drivers/staging/unisys/include/uisutils.h
+++ b/drivers/staging/unisys/include/uisutils.h
@@ -307,20 +307,20 @@ Issue_VMCALL_CHANNEL_MISMATCH(const char *ChannelName,
 	U64 physaddr;
 	char *last_slash = NULL;
 
-	strncpy(params.ChannelName, ChannelName,
+	strlcpy(params.ChannelName, ChannelName,
 		lengthof(VMCALL_CHANNEL_VERSION_MISMATCH_PARAMS, ChannelName));
-	strncpy(params.ItemName, ItemName,
+	strlcpy(params.ItemName, ItemName,
 		lengthof(VMCALL_CHANNEL_VERSION_MISMATCH_PARAMS, ItemName));
 	params.SourceLineNumber = SourceLineNumber;
 
 	last_slash = strrchr(path_n_fn, '/');
 	if (last_slash != NULL) {
 		last_slash++;
-		strncpy(params.SourceFileName, last_slash,
+		strlcpy(params.SourceFileName, last_slash,
 			lengthof(VMCALL_CHANNEL_VERSION_MISMATCH_PARAMS,
 				 SourceFileName));
 	} else
-		strncpy(params.SourceFileName,
+		strlcpy(params.SourceFileName,
 			"Cannot determine source filename",
 			lengthof(VMCALL_CHANNEL_VERSION_MISMATCH_PARAMS,
 				 SourceFileName));
-- 
1.7.10.4

