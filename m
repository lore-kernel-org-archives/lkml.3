Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaG1Nb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:31:26 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:43042 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaG1N3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:29:22 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: kay@vrfy.org, pmladek@suse.cz, john.stultz@linaro.org, jack@suse.cz,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 1/7] printk: report dropped messages on separate line
Date: Mon, 28 Jul 2014 08:29:14 -0500
Message-Id: <1406554160-9562-2-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406554160-9562-1-git-send-email-elder@linaro.org>
References: <1406554160-9562-1-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible for the log to be filled too quickly for the consoles
to be able to keep up.  This is detected in console_unlock(), and when
it occurs, a message is inserted to note the event.  When reviewing
some nearby code, Petr Mládek suggested it might be nicer if this
message were placed on a separate line.  This patch implements that
suggestion.

Suggested-by: Petr Mládek <pmladek@suse.cz>
Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Petr Mládek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 13e839d..ffc9928 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2142,9 +2142,10 @@ again:
 		}
 
 		if (console_seq < log_first_seq) {
-			len = sprintf(text, "** %u printk messages dropped ** ",
+			len = sprintf(text,
+				      "%s** %u printk messages dropped **\n",
+				      (console_prev & LOG_CONT) ? "\n" : "",
 				      (unsigned)(log_first_seq - console_seq));
-
 			/* messages are gone, move to first one */
 			console_seq = log_first_seq;
 			console_idx = log_first_idx;
-- 
1.9.1

