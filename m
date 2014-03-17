Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbaCQNFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:05:37 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:54191 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756378AbaCQNFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:05:36 -0400
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Mar 2014 09:05:35 EDT
Date: Mon, 17 Mar 2014 13:55:25 +0100
From: Simon =?UTF-8?B?S8OlZ3N0csO2bQ==?= <simon.kagstrom@netinsight.net>
To: linux-kernel@vger.kernel.org, joe@perches.com, kay@vrfy.org,
        akpm@linux-foundation.org, nhorman@tuxdriver.com, tj@kernel.org
Subject: [PATCH] printk: Remove double asmlinkage in printk_emit
Message-ID: <20140317135525.5e71ce6d@marrow.netinsight.se>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The double asmlinkage was introduced in
7ff9554bb578ba02166071d2d487b7fc7d860d62 ("printk: convert byte-buffer
to variable-length record buffer").

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
---
 include/linux/printk.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 3db126f..c34f0fb 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -124,9 +124,9 @@ asmlinkage __printf(1, 0)
 int vprintk(const char *fmt, va_list args);
 
 asmlinkage __printf(5, 6) __cold
-asmlinkage int printk_emit(int facility, int level,
-			   const char *dict, size_t dictlen,
-			   const char *fmt, ...);
+int printk_emit(int facility, int level,
+		const char *dict, size_t dictlen,
+		const char *fmt, ...);
 
 asmlinkage __printf(1, 2) __cold
 int printk(const char *fmt, ...);
-- 
1.7.9.6

