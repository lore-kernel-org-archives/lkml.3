Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab3CRVGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:06:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab3CRVGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:06:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Maxin B. John" <maxin.john@enea.com>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [ 06/75] tools: usb: ffs-test: Fix build failure
Date: Mon, 18 Mar 2013 14:06:29 -0700
Message-Id: <20130318210510.716036492@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Maxin B. John" <maxin.john@enea.com>

commit a0f11aceee531d444f58b939e6a537ee5e2b9cc5 upstream.

Fixes this build failure:
gcc -Wall -Wextra -g -lpthread -I../include -o testusb testusb.c
gcc -Wall -Wextra -g -lpthread -I../include -o ffs-test ffs-test.c
In file included from ffs-test.c:41:0:
../../include/linux/usb/functionfs.h:4:39: fatal error:
uapi/linux/usb/functionfs.h: No such file or directory
compilation terminated.
make: *** [ffs-test] Error 1

Signed-off-by: Maxin B. John <maxin.john@enea.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/usb/ffs-test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/usb/ffs-test.c
+++ b/tools/usb/ffs-test.c
@@ -38,7 +38,7 @@
 #include <unistd.h>
 #include <tools/le_byteshift.h>
 
-#include "../../include/linux/usb/functionfs.h"
+#include "../../include/uapi/linux/usb/functionfs.h"
 
 
 /******************** Little Endian Handling ********************************/


