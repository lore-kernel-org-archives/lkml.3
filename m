Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab3JRTv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 15:51:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab3JRTvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 15:51:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>, Wim Van Sebroeck <wim@iguana.be>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 5/7] watchdog: ts72xx_wdt: locking bug in ioctl
Date: Fri, 18 Oct 2013 12:52:52 -0700
Message-Id: <20131018195036.393771654@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131018195036.020644622@linuxfoundation.org>
References: <20131018195036.020644622@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 8612ed0d97abcf1c016d34755b7cf2060de71963 upstream.

Calling the WDIOC_GETSTATUS & WDIOC_GETBOOTSTATUS and twice will cause a
interruptible deadlock.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/watchdog/ts72xx_wdt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/watchdog/ts72xx_wdt.c
+++ b/drivers/watchdog/ts72xx_wdt.c
@@ -310,7 +310,8 @@ static long ts72xx_wdt_ioctl(struct file
 
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
+		error = put_user(0, p);
+		break;
 
 	case WDIOC_KEEPALIVE:
 		ts72xx_wdt_kick(wdt);


