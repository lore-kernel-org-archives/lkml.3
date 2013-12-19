Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab3LSKMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:12:14 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:44995 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab3LSKML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:12:11 -0500
Date: Thu, 19 Dec 2013 15:42:03 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 5/7] drivers: usb: Mark function as static in usbsevseg.c
Message-ID: <4f12812db338b0cacc9ed456a1b18679a3ac4a6d.1387439261.git.rashika.kheria@gmail.com>
References: <0e0e74b4487edd341b66674333d734d5828c7e64.1387439261.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0e0e74b4487edd341b66674333d734d5828c7e64.1387439261.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function my_memlen() as static in misc/usbsevseg.c because it is
not used outside this file.

This eliminates the following warning in misc/usbsevseg.c:
drivers/usb/misc/usbsevseg.c:60:15: warning: no previous prototype for ‘my_memlen’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/usb/misc/usbsevseg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/misc/usbsevseg.c b/drivers/usb/misc/usbsevseg.c
index b2d82b9..0a87d3e 100644
--- a/drivers/usb/misc/usbsevseg.c
+++ b/drivers/usb/misc/usbsevseg.c
@@ -57,7 +57,7 @@ struct usb_sevsegdev {
  * if str commands are used, we would assume the end of string
  * so mem commands are used.
  */
-inline size_t my_memlen(const char *buf, size_t count)
+static inline size_t my_memlen(const char *buf, size_t count)
 {
 	if (count > 0 && buf[count-1] == '\n')
 		return count - 1;
-- 
1.7.9.5

