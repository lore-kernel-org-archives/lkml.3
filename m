Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab3JIIaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 04:30:35 -0400
Received: from intranet.asianux.com ([58.214.24.6]:56205 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab3JIIad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 04:30:33 -0400
X-Spam-Score: -100.8
Message-ID: <525513E8.6040900@asianux.com>
Date: Wed, 09 Oct 2013 16:29:28 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: kexec@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Richard Weinberger <richard@nod.at>
Subject: [PATCH] kernel/kexec.c: use vscnprintf() instead of vsnprintf() in
 vmcoreinfo_append_str()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vsnprintf() may let 'r' larger than sizeof(buf), in this case, if 'r'
is also less than "vmcoreinfo_max_size - vmcoreinfo_size" (left size of
destination buffer), next memcpy() will read the unexpected addresses.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/kexec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 2a74f30..0abcd68 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1533,7 +1533,7 @@ void vmcoreinfo_append_str(const char *fmt, ...)
 	size_t r;
 
 	va_start(args, fmt);
-	r = vsnprintf(buf, sizeof(buf), fmt, args);
+	r = vscnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 
 	r = min(r, vmcoreinfo_max_size - vmcoreinfo_size);
-- 
1.7.7.6
