Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab3IROLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:11:36 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43099 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3IROLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:11:35 -0400
Date: Wed, 18 Sep 2013 17:11:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: keescook@chromium.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, joe@perches.com, linux@horizon.com,
        JBeulich@suse.com, kosaki.motohiro@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 0/2] vsprintf: ignore %n again
Message-ID: <20130918141104.GT19256@mwanda>
References: <1379317437-28329-1-git-send-email-keescook@chromium.org>
 <20130916155504.GC13318@ZenIV.linux.org.uk>
 <CAGXu5jK2d+9m0uA84nGbZ5E=s974NRn+Sxz3iRcTsFWqWFTGNQ@mail.gmail.com>
 <201309182214.IDD13060.FFOVJOLOFQtHSM@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309182214.IDD13060.FFOVJOLOFQtHSM@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure.  There are a lot of non-const strings though.

diff --git a/include/linux/printk.h b/include/linux/printk.h
index e6131a78..317587b 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -122,6 +122,11 @@ asmlinkage int printk_emit(int facility, int level,
 
 asmlinkage __printf(1, 2) __cold
 int printk(const char *fmt, ...);
+#define printk(fmt, ...) do {				  \
+	compiletime_assert(__builtin_constant_p(fmt),     \
+			   "Non-constant format string"); \
+	printk(fmt, ##__VA_ARGS__);			  \
+} while (0)
 
 /*
  * Special printk facility for scheduler use only, _DO_NOT_USE_ !
