Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab3FDXKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:10:13 -0400
Received: from 1wt.eu ([62.212.114.60]:35511 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab3FDWme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:34 -0400
Message-Id: <20130604172134.665536031@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:15 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>, <support@connecttech.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 105/184] USB: whiteheat: fix memory leak in error path
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit c129197c99550d356cf5f69b046994dd53cd1b9d upstream.

Make sure command buffer is deallocated in case of errors during attach.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: <support@connecttech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/usb/serial/whiteheat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 1093d2e..1247be1 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -576,6 +576,7 @@ no_firmware:
 		"%s: please contact support@connecttech.com\n",
 		serial->type->description);
 	kfree(result);
+	kfree(command);
 	return -ENODEV;
 
 no_command_private:
-- 
1.7.12.2.21.g234cd45.dirty



