Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab3HRUeI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:34:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab3HRUdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:33:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Geert Uytterhoeven <geert@linux-m68k.org>,
        Jiri Kosina <jkosina@suse.cz>, Guenter Roeck <linux@roeck-us.net>
Subject: [ 08/34] HID: microsoft: do not use compound literal - fix build
Date: Sun, 18 Aug 2013 13:34:21 -0700
Message-Id: <20130818203300.258997062@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203259.653403173@linuxfoundation.org>
References: <20130818203259.653403173@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 6b90466cfec2a2fe027187d675d8d14217c12d82 upstream.

In patch "HID: microsoft: fix invalid rdesc for 3k kbd" I fixed
support for MS 3k keyboards. However the added check using memcmp and
a compound statement breaks build on architectures where memcmp is a
macro with parameters.

hid-microsoft.c:51:18: error: macro "memcmp" passed 6 arguments, but takes just 3

On x86_64, memcmp is a function, so I did not see the error.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-microsoft.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -47,9 +47,9 @@ static __u8 *ms_report_fixup(struct hid_
 		rdesc[559] = 0x45;
 	}
 	/* the same as above (s/usage/physical/) */
-	if ((quirks & MS_RDESC_3K) && *rsize == 106 &&
-			!memcmp((char []){ 0x19, 0x00, 0x29, 0xff },
-				&rdesc[94], 4)) {
+	if ((quirks & MS_RDESC_3K) && *rsize == 106 && rdesc[94] == 0x19 &&
+			rdesc[95] == 0x00 && rdesc[96] == 0x29 &&
+			rdesc[97] == 0xff) {
 		rdesc[94] = 0x35;
 		rdesc[96] = 0x45;
 	}


