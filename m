Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab3JXNZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 09:25:50 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53113 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab3JXNZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 09:25:49 -0400
From: Russ Dill <Russ.Dill@ti.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
        Russ Dill <Russ.Dill@ti.com>
Subject: [PATCH] PM / hibernate: Move software_resume to late_initcall_sync
Date: Thu, 24 Oct 2013 14:25:26 +0100
Message-Id: <1382621126-24090-1-git-send-email-Russ.Dill@ti.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

software_resume is being called after deferred_probe_initcall in
drivers base. If the probing of the device that contains the resume
image is deferred, and the system has been instructed to wait for
it to show up, this wait will occur in software_resume. This causes
a deadlock.

Move software_resume into late_initcall_sync so that it happens
after all the other late_initcalls.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
---
 kernel/power/hibernate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index c9c759d..0121dab 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -846,7 +846,7 @@ static int software_resume(void)
 	goto Finish;
 }
 
-late_initcall(software_resume);
+late_initcall_sync(software_resume);
 
 
 static const char * const hibernation_modes[] = {
-- 
1.8.3.2

