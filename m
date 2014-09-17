Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbaIQRQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 13:16:07 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:40182 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896AbaIQRQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 13:16:05 -0400
From: Valentin Ilie <valentin.ilie@gmail.com>
To: rdunlap@infradead.org, davem@davemloft.net, minipli@googlemail.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valentin Ilie <valentin.ilie@gmail.com>
Subject: [PATCH] connector - documentation: close opened file descriptor
Date: Wed, 17 Sep 2014 20:15:57 +0300
Message-Id: <1410974157-12470-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the logging process, we use either a file or stdout.

In the case of a file, we need to fix that by calling fclose at the right time.
In the case we end up calling fclose to stdout, we will not impact the program because we do it at its very end.

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 Documentation/connector/ucon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/connector/ucon.c b/Documentation/connector/ucon.c
index 8a4da64..f9d785b 100644
--- a/Documentation/connector/ucon.c
+++ b/Documentation/connector/ucon.c
@@ -246,5 +246,6 @@ int main(int argc, char *argv[])
 	}
 
 	close(s);
+	fclose(out);
 	return 0;
 }
-- 
1.9.1

