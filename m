Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbaDBIrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 04:47:25 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23487 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049AbaDBIrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 04:47:23 -0400
Date: Wed, 2 Apr 2014 11:47:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>, vegard.nossum@oracle.com,
        netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 1/2] lib/string.c: use the name "C-string" in comments
Message-ID: <20140402084708.GA6018@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140401.161838.1562296825577866979.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For strncpy() and friends the source string may or may not have an
actual NUL character at the end.  The documentation is confusing in this
because it specifically mentions that you are passing a "NUL-terminated"
string.  Wikipedia says that "C-string" is an alternative name we can
use instead.

http://en.wikipedia.org/wiki/Null-terminated_string

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/lib/string.c b/lib/string.c
index 9b1f906..89ad0f0 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -107,7 +107,7 @@ EXPORT_SYMBOL(strcpy);
 
 #ifndef __HAVE_ARCH_STRNCPY
 /**
- * strncpy - Copy a length-limited, %NUL-terminated string
+ * strncpy - Copy a length-limited, C-string
  * @dest: Where to copy the string to
  * @src: Where to copy the string from
  * @count: The maximum number of bytes to copy
@@ -136,7 +136,7 @@ EXPORT_SYMBOL(strncpy);
 
 #ifndef __HAVE_ARCH_STRLCPY
 /**
- * strlcpy - Copy a %NUL terminated string into a sized buffer
+ * strlcpy - Copy a C-string into a sized buffer
  * @dest: Where to copy the string to
  * @src: Where to copy the string from
  * @size: size of destination buffer
@@ -182,7 +182,7 @@ EXPORT_SYMBOL(strcat);
 
 #ifndef __HAVE_ARCH_STRNCAT
 /**
- * strncat - Append a length-limited, %NUL-terminated string to another
+ * strncat - Append a length-limited, C-string to another
  * @dest: The string to be appended to
  * @src: The string to append to it
  * @count: The maximum numbers of bytes to copy
@@ -211,7 +211,7 @@ EXPORT_SYMBOL(strncat);
 
 #ifndef __HAVE_ARCH_STRLCAT
 /**
- * strlcat - Append a length-limited, %NUL-terminated string to another
+ * strlcat - Append a length-limited, C-string to another
  * @dest: The string to be appended to
  * @src: The string to append to it
  * @count: The size of the destination buffer.
