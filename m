Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbaDHHny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 03:43:54 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:51178 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaDHHnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 03:43:51 -0400
Date: Tue, 8 Apr 2014 11:43:49 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: vdavydov@parallels.com
Cc: linux-kernel@vger.kernel.org, shawn@churchofgit.com, tglx@linutronix.de,
        akpm@linux-foundation.org, avagin@openvz.org, xemul@parallels.com
Subject: [patch 2/3] docs: procfs -- Document timerfd output, v2
Message-ID: <20140408074349.GF23983@moon>
References: <20140407174701.734703531@openvz.org>
 <20140407174933.753755321@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140407174933.753755321@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

Vladimir, would the below text be more clear?

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
+	details]. 'it_value' is remaining time until the timer exiration.
+	'it_interval' is the interval for the timer.
 
 ------------------------------------------------------------------------------
 Configuring procfs
