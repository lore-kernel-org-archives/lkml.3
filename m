Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaJFFJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 01:09:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510AbaJFFJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 01:09:21 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        aviro@redhat.com, pmoore@redhat.com, arozansk@redhat.com,
        ebiederm@xmission.com, serge@hallyn.com
Subject: [PATCH V5 05/13] audit: initialize at subsystem time rather than device time
Date: Mon,  6 Oct 2014 01:08:30 -0400
Message-Id: <7fda57304bb2f74ccb7f610c04df6aa0c04bf4ba.1412543112.git.rgb@redhat.com>
In-Reply-To: <cover.1412543112.git.rgb@redhat.com>
References: <cover.1412543112.git.rgb@redhat.com>
In-Reply-To: <cover.1412543112.git.rgb@redhat.com>
References: <cover.1412543112.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The audit subsystem should be initialized a bit earlier so that it is in place
in time for initial namespace serial number logging.
---
 kernel/audit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index ff1630d..8ff7f28 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1186,7 +1186,7 @@ static int __init audit_init(void)
 
 	return 0;
 }
-__initcall(audit_init);
+subsys_initcall(audit_init);
 
 /* Process kernel command-line parameter at boot time.  audit=0 or audit=1. */
 static int __init audit_enable(char *str)
-- 
1.7.1

