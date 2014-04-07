Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbaDGRuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 13:50:04 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:33669 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693AbaDGRtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 13:49:39 -0400
Message-Id: <20140407174933.753755321@openvz.org>
User-Agent: quilt/0.60-1
Date: Mon, 07 Apr 2014 21:47:03 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: shawn@churchofgit.com, tglx@linutronix.de, akpm@linux-foundation.org,
        avagin@openvz.org, xemul@parallels.com, gorcunov@openvz.org,
        vdavydov@parallels.com
Subject: [patch 2/3] docs: procfs -- Document timerfd output
References: <20140407174701.734703531@openvz.org>
Content-Disposition: inline; filename=timerfd-doc-fdinfo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Shawn Landden <shawn@churchofgit.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Andrey Vagin <avagin@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 Documentation/filesystems/proc.txt |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

Index: linux-2.6.git/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.git.orig/Documentation/filesystems/proc.txt
+++ linux-2.6.git/Documentation/filesystems/proc.txt
@@ -1741,6 +1741,23 @@ pair provide additional information part
 	While the first three lines are mandatory and always printed, the rest is
 	optional and may be omitted if no marks created yet.
 
+	Timerfd files
+	~~~~~~~~~~~~~
+
+	pos:	0
+	flags:	02
+	mnt_id:	9
+	clockid: 0
+	ticks: 0
+	settime flags: 01
+	it_value: (0, 49406829)
+	it_interval: (1, 0)
+
+	where 'clockid' is the clock type and 'ticks' is the number of the timer expirations
+	that have occurred [see timerfd_create(2) for details]. 'settime flags' are
+	flags in octal form used to setup the timer [see timerfd_settime(2) for
+	details]. 'it_value' and 'it_interval' are the expiration time and interval
+	for the timer.
 
 ------------------------------------------------------------------------------
 Configuring procfs

