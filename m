Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbbAUJHC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:07:02 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:58310 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbbAUJGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:06:39 -0500
Date: Wed, 21 Jan 2015 11:06:34 +0200
From: Asaf Vertz <asaf.vertz@tandemg.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, amit.virdi@st.com, andrzej.p@samsung.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: gadget: zero: fix format string warnings
Message-ID: <20150121090633.GA15849@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following warnings (reported by cppcheck):
[drivers/usb/gadget/function/f_sourcesink.c:1217]: (warning) %d in format string (no. 1)
requires 'int' but the argument type is 'unsigned int'.
[drivers/usb/gadget/function/f_sourcesink.c:1261]: (warning) %d in format string (no. 1)
requires 'int' but the argument type is 'unsigned int'.
[drivers/usb/gadget/function/f_sourcesink.c:1305]: (warning) %d in format string (no. 1)
requires 'int' but the argument type is 'unsigned int'.
[drivers/usb/gadget/function/f_sourcesink.c:1349]: (warning) %d in format string (no. 1)
requires 'int' but the argument type is 'unsigned int'.
[drivers/usb/gadget/function/f_sourcesink.c:1393]: (warning) %d in format string (no. 1)
requires 'int' but the argument type is 'unsigned int'.
[drivers/usb/gadget/function/f_sourcesink.c:1437]: (warning) %d in format string (no. 1)
requires 'int' but the argument type is 'unsigned int'.
[drivers/usb/gadget/function/f_sourcesink.c:1476]: (warning) %d in format string (no. 1)
requires 'int' but the argument type is 'unsigned int'.
[drivers/usb/gadget/function/f_sourcesink.c:1520]: (warning) %d in format string (no. 1)
requires 'int' but the argument type is 'unsigned int'.
[drivers/usb/gadget/function/f_sourcesink.c:1564]: (warning) %d in format string (no. 1)
requires 'int' but the argument type is 'unsigned int'.
[drivers/usb/gadget/function/f_sourcesink.c:1608]: (warning) %d in format string (no. 1)
requires 'int' but the argument type is 'unsigned int'

Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
---
 drivers/usb/gadget/function/f_sourcesink.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/function/f_sourcesink.c b/drivers/usb/gadget/function/f_sourcesink.c
index 80be25b..e07c50c 100644
--- a/drivers/usb/gadget/function/f_sourcesink.c
+++ b/drivers/usb/gadget/function/f_sourcesink.c
@@ -1214,7 +1214,7 @@ static ssize_t f_ss_opts_pattern_show(struct f_ss_opts *opts, char *page)
 	int result;
 
 	mutex_lock(&opts->lock);
-	result = sprintf(page, "%d", opts->pattern);
+	result = sprintf(page, "%u", opts->pattern);
 	mutex_unlock(&opts->lock);
 
 	return result;
@@ -1258,7 +1258,7 @@ static ssize_t f_ss_opts_isoc_interval_show(struct f_ss_opts *opts, char *page)
 	int result;
 
 	mutex_lock(&opts->lock);
-	result = sprintf(page, "%d", opts->isoc_interval);
+	result = sprintf(page, "%u", opts->isoc_interval);
 	mutex_unlock(&opts->lock);
 
 	return result;
@@ -1302,7 +1302,7 @@ static ssize_t f_ss_opts_isoc_maxpacket_show(struct f_ss_opts *opts, char *page)
 	int result;
 
 	mutex_lock(&opts->lock);
-	result = sprintf(page, "%d", opts->isoc_maxpacket);
+	result = sprintf(page, "%u", opts->isoc_maxpacket);
 	mutex_unlock(&opts->lock);
 
 	return result;
@@ -1346,7 +1346,7 @@ static ssize_t f_ss_opts_isoc_mult_show(struct f_ss_opts *opts, char *page)
 	int result;
 
 	mutex_lock(&opts->lock);
-	result = sprintf(page, "%d", opts->isoc_mult);
+	result = sprintf(page, "%u", opts->isoc_mult);
 	mutex_unlock(&opts->lock);
 
 	return result;
@@ -1390,7 +1390,7 @@ static ssize_t f_ss_opts_isoc_maxburst_show(struct f_ss_opts *opts, char *page)
 	int result;
 
 	mutex_lock(&opts->lock);
-	result = sprintf(page, "%d", opts->isoc_maxburst);
+	result = sprintf(page, "%u", opts->isoc_maxburst);
 	mutex_unlock(&opts->lock);
 
 	return result;
@@ -1434,7 +1434,7 @@ static ssize_t f_ss_opts_bulk_buflen_show(struct f_ss_opts *opts, char *page)
 	int result;
 
 	mutex_lock(&opts->lock);
-	result = sprintf(page, "%d", opts->bulk_buflen);
+	result = sprintf(page, "%u", opts->bulk_buflen);
 	mutex_unlock(&opts->lock);
 
 	return result;
@@ -1473,7 +1473,7 @@ static ssize_t f_ss_opts_int_interval_show(struct f_ss_opts *opts, char *page)
 	int result;
 
 	mutex_lock(&opts->lock);
-	result = sprintf(page, "%d", opts->int_interval);
+	result = sprintf(page, "%u", opts->int_interval);
 	mutex_unlock(&opts->lock);
 
 	return result;
@@ -1517,7 +1517,7 @@ static ssize_t f_ss_opts_int_maxpacket_show(struct f_ss_opts *opts, char *page)
 	int result;
 
 	mutex_lock(&opts->lock);
-	result = sprintf(page, "%d", opts->int_maxpacket);
+	result = sprintf(page, "%u", opts->int_maxpacket);
 	mutex_unlock(&opts->lock);
 
 	return result;
@@ -1561,7 +1561,7 @@ static ssize_t f_ss_opts_int_mult_show(struct f_ss_opts *opts, char *page)
 	int result;
 
 	mutex_lock(&opts->lock);
-	result = sprintf(page, "%d", opts->int_mult);
+	result = sprintf(page, "%u", opts->int_mult);
 	mutex_unlock(&opts->lock);
 
 	return result;
@@ -1605,7 +1605,7 @@ static ssize_t f_ss_opts_int_maxburst_show(struct f_ss_opts *opts, char *page)
 	int result;
 
 	mutex_lock(&opts->lock);
-	result = sprintf(page, "%d", opts->int_maxburst);
+	result = sprintf(page, "%u", opts->int_maxburst);
 	mutex_unlock(&opts->lock);
 
 	return result;
-- 
1.7.0.4

