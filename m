Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbaBNHVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 02:21:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58987 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaBNHVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 02:21:08 -0500
Message-ID: <1392362464.5579.41.camel@marge.simpson.net>
Subject: [patch] net,bonding: fix bond_options.c direct rwlock.h include
From: Mike Galbraith <bitbucket@online.de>
To: netdev <netdev@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Fri, 14 Feb 2014 08:21:04 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:CSFhh5tYfW9Q97FH9he19c+xjTZIMGMIGI/j+EAXran
 DUTpx01+DOH9wW2Ql4pL6YidmJmqVjMFsjCL+kh5ubzXQc304O
 4ztXv7PPwRA8hI9CuxqssvI5UhbxKDvN54BO3r7sw2W6eZo6RA
 YAyzn2yilEibsWQNSqjxEn9pUE16h11IBHazCsWjdPRAmchlvU
 p9io6+2GsHNont6486sSHyh1O15jHUHBcLcCX4vgRsKaTsmqes
 QMnTuTVvU+GpWQS60ZdwcmN5EDmD0Pj1PfMH8FofttIjkzc6AJ
 ztn1BX+ap7wKJf3+rOZMRPpIKuYC3AH/I2enRa5S0f5B+M29Ru
 jsvpOn1ynqutbg3C1C/LCKv27o6poPZ6YB2Y3YvHsMoRbVTCTn
 pv40DTW+Yf32g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


drivers/net/bonding/bond_options.c includes rwlock.h directly,
which is a nono, and which also breaks RT kernel build.

Signed-off-by: Mike Galbraith <bitbucket@online.de>
---
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 11cb943222d5..c37878432717 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -14,7 +14,7 @@
 #include <linux/errno.h>
 #include <linux/if.h>
 #include <linux/netdevice.h>
-#include <linux/rwlock.h>
+#include <linux/spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/ctype.h>
 #include <linux/inet.h>


