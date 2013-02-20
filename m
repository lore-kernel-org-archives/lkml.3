Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab3BTX6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 18:58:09 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:51746 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3BTX6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 18:58:07 -0500
From: maxin.john@gmail.com
To: gregkh@linuxfoundation.org, mina86@mina86.com
Cc: matt.fleming@intel.com, matthias.fend@wolfvision.net, balbi@ti.com,
        linux-usb@vger.kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "Maxin B. John" <maxin.john@enea.com>
Subject: [PATCH] tools: usb: ffs-test: Fix build failure
Date: Thu, 21 Feb 2013 01:57:51 +0200
Message-Id: <1361404671-11713-1-git-send-email-maxin.john@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Maxin B. John" <maxin.john@enea.com>

Fixes this build failure:
gcc -Wall -Wextra -g -lpthread -I../include -o testusb testusb.c
gcc -Wall -Wextra -g -lpthread -I../include -o ffs-test ffs-test.c
In file included from ffs-test.c:41:0:
../../include/linux/usb/functionfs.h:4:39: fatal error:
uapi/linux/usb/functionfs.h: No such file or directory
compilation terminated.
make: *** [ffs-test] Error 1

Signed-off-by: Maxin B. John <maxin.john@enea.com>
---
 tools/usb/ffs-test.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
index 8674b9e..fe1e66b 100644
--- a/tools/usb/ffs-test.c
+++ b/tools/usb/ffs-test.c
@@ -38,7 +38,7 @@
 #include <unistd.h>
 #include <tools/le_byteshift.h>
 
-#include "../../include/linux/usb/functionfs.h"
+#include "../../include/uapi/linux/usb/functionfs.h"
 
 
 /******************** Little Endian Handling ********************************/
-- 
1.7.7

