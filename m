Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbaDFVaO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 17:30:14 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:35488 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaDFVaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 17:30:10 -0400
Message-ID: <5341C760.3080508@gmail.com>
Date: Sun, 06 Apr 2014 16:30:08 -0500
From: Joel Pelaez Jorge <joelpelaez@gmail.com>
Organization: DarkSoft Foundation
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Silvan Jegen <s.jegen@gmail.com>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: rtl8192e: Fix sparse warning
References: <5341C643.4050700@gmail.com>
In-Reply-To: <5341C643.4050700@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include the header 'rtl_wx.h' to 'rtl_wx.c'

'rtl_wx.h' has the declarations used for some source files of
the driver. It has:

extern struct iw_handler_def r8192_wx_handlers_def;

That fix the problem:

drivers/staging/rtl8192e/rtl8192e/rtl_wx.c:1323:24: warning:
symbol 'r8192_wx_handlers_def' was not declared. Should it be static?

Signed-off-by: Joel Pelaez Jorge <joelpelaez@gmail.com>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
index 498995d..2de95f3 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
@@ -19,6 +19,7 @@

 #include <linux/string.h>
 #include "rtl_core.h"
+#include "rtl_wx.h"

 #define RATE_COUNT 12
 static u32 rtl8192_rates[] = {
-- 
1.9.1


