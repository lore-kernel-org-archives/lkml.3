Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934775Ab3JPR7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:59:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934555Ab3JPRqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>, Wim Van Sebroeck <wim@iguana.be>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 19/50] watchdog: ts72xx_wdt: locking bug in ioctl
Date: Wed, 16 Oct 2013 10:45:05 -0700
Message-Id: <20131016174400.702568719@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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


