Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab3ITQro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:47:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab3ITQrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:47:43 -0400
Date: Fri, 20 Sep 2013 12:47:32 -0400
From: Dave Jones <davej@redhat.com>
To: rostedt@goodmis.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: tracing: don't stuff stale pointers in filp->private_data
Message-ID: <20130920164732.GA31520@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, rostedt@goodmis.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probably harmless, but still not a nice thing to do.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 368a4d5..75d3556 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1124,6 +1124,7 @@ static int system_tr_open(struct inode *inode, struct file *filp)
 	if (ret < 0) {
 		trace_array_put(tr);
 		kfree(dir);
+		dir = NULL;
 	}
 
 	filp->private_data = dir;
