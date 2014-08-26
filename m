Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbaHZVmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 17:42:47 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:45821 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbaHZVmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 17:42:46 -0400
Date: Wed, 27 Aug 2014 01:42:43 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] headers: prctl.h -- Add missing linux/types.h
Message-ID: <20140826214243.GE8952@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen reported:

 | After merging the akpm-current tree, today's linux-next build (x86_64
 | allmodconfig) failed like this:
 |
 | ./usr/include/linux/prctl.h:132: found __[us]{8,16,32,64} type without #include <linux/types.h>
 | In file included from /usr/include/x86_64-linux-gnu/sys/prctl.h:23:0,
 |                 from Documentation/prctl/disable-tsc-test.c:14:
 | ./usr/include/linux/prctl.h:132:2: error: unknown type name '__u64'
 |

Include the header needed.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/uapi/linux/prctl.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.git/include/uapi/linux/prctl.h
===================================================================
--- linux-2.6.git.orig/include/uapi/linux/prctl.h
+++ linux-2.6.git/include/uapi/linux/prctl.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_PRCTL_H
 #define _LINUX_PRCTL_H
 
+#include <linux/types.h>
+
 /* Values to pass as first argument to prctl() */
 
 #define PR_SET_PDEATHSIG  1  /* Second arg is a signal */
