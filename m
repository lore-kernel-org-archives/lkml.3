Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738AbaD1VdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:33:10 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:41922 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456AbaD1VdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:33:08 -0400
Message-Id: <20140428213301.406805138@openvz.org>
User-Agent: quilt/0.60-1
Date: Tue, 29 Apr 2014 01:25:19 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: shawn@churchofgit.com, tglx@linutronix.de, akpm@linux-foundation.org,
        avagin@openvz.org, xemul@parallels.com, gorcunov@openvz.org,
        vdavydov@parallels.com
Subject: [patch 2/3] docs: procfs -- Document timerfd output
References: <20140428212517.200264067@openvz.org>
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
 Documentation/filesystems/proc.txt |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

Index: linux-2.6.git/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.git.orig/Documentation/filesystems/proc.txt
+++ linux-2.6.git/Documentation/filesystems/proc.txt
@@ -1741,6 +1741,25 @@ pair provide additional information part
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
+	details]. 'it_value' is remaining time until the timer exiration.
+	'it_interval' is the interval for the timer. Note the timer might be set
+	up with TFD_TIMER_ABSTIME option which will be shown in 'settime flags',
+	but 'it_value' still exhibit timer's remaining time.
 
 ------------------------------------------------------------------------------
 Configuring procfs

