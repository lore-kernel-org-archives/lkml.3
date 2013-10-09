Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab3JIJEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 05:04:08 -0400
Received: from intranet.asianux.com ([58.214.24.6]:6394 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757015Ab3JIJEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 05:04:05 -0400
X-Spam-Score: -100.8
Message-ID: <52551BC6.5040906@asianux.com>
Date: Wed, 09 Oct 2013 17:03:02 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>, xi.wang@gmail.com
CC: nicolas.dichtel@6wind.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Richard Weinberger <richard@nod.at>
Subject: [PATCH] kernel/sysctl_binary.c: use scnprintf() instead of snprintf()
References: <525513E8.6040900@asianux.com>
In-Reply-To: <525513E8.6040900@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

snprintf() will return the 'ideal' length which may be larger than real
buffer length, if we only want to use real length, need use scnprintf()
instead of.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/sysctl_binary.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index b609213..653cbbd 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -1024,7 +1024,7 @@ static ssize_t bin_intvec(struct file *file,
 			if (get_user(value, vec + i))
 				goto out_kfree;
 
-			str += snprintf(str, end - str, "%lu\t", value);
+			str += scnprintf(str, end - str, "%lu\t", value);
 		}
 
 		result = kernel_write(file, buffer, str - buffer, 0);
@@ -1095,7 +1095,7 @@ static ssize_t bin_ulongvec(struct file *file,
 			if (get_user(value, vec + i))
 				goto out_kfree;
 
-			str += snprintf(str, end - str, "%lu\t", value);
+			str += scnprintf(str, end - str, "%lu\t", value);
 		}
 
 		result = kernel_write(file, buffer, str - buffer, 0);
@@ -1205,7 +1205,7 @@ static ssize_t bin_dn_node_address(struct file *file,
 		if (get_user(dnaddr, (__le16 __user *)newval))
 			goto out;
 
-		len = snprintf(buf, sizeof(buf), "%hu.%hu",
+		len = scnprintf(buf, sizeof(buf), "%hu.%hu",
 				le16_to_cpu(dnaddr) >> 10,
 				le16_to_cpu(dnaddr) & 0x3ff);
 
-- 
1.7.7.6
