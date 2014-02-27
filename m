Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbaB0L6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:58:13 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:37090 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaB0L6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:58:09 -0500
Date: Thu, 27 Feb 2014 17:25:54 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        josh@joshtriplett.org
Subject: [PATCH 22/46] kernel: Include appropriate header file in
 time/timekeeping_debug.c
Message-ID: <294021ae4578d627ac56704dab7caee5bca2db86.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file kernel/time/timekeeping_internal.h in
kernel/time/timekeeping_debug.c because it has prototype declaration of
function defined in kernel/time/timekeeping_debug.c.

This eliminates the following warning in
kernel/time/timekeeping_debug.c:
kernel/time/timekeeping_debug.c:68:6: warning: no previous prototype for ‘tk_debug_account_sleep_time’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/time/timekeeping_debug.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/time/timekeeping_debug.c b/kernel/time/timekeeping_debug.c
index 802433a..4d54f97 100644
--- a/kernel/time/timekeeping_debug.c
+++ b/kernel/time/timekeeping_debug.c
@@ -21,6 +21,8 @@
 #include <linux/seq_file.h>
 #include <linux/time.h>
 
+#include "timekeeping_internal.h"
+
 static unsigned int sleep_time_bin[32] = {0};
 
 static int tk_debug_show_sleep_time(struct seq_file *s, void *data)
-- 
1.7.9.5

