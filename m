Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab3EMMAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 08:00:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56441 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab3EMMAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 08:00:07 -0400
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH] hibernate: Correct documentation
Date: Mon, 13 May 2013 14:00:03 +0200
Message-Id: <1368446403-4896-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3.rc0
In-Reply-To: <136862945.66DBfZPmr6@vostro.rjw.lan>
References: <136862945.66DBfZPmr6@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Correct the meaning of PM_HIBERNATION_PREPARE in the docs, as per
Rafael.

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjørn Mork <bjorn@mork.no>
Link: http://lkml.kernel.org/r/20130512162717.GA6305@pd.tnic
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 Documentation/power/notifiers.txt | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/power/notifiers.txt b/Documentation/power/notifiers.txt
index c2a4a346c0d9..a81fa254303d 100644
--- a/Documentation/power/notifiers.txt
+++ b/Documentation/power/notifiers.txt
@@ -15,8 +15,10 @@ A suspend/hibernation notifier may be used for this purpose.
 The subsystems or drivers having such needs can register suspend notifiers that
 will be called upon the following events by the PM core:
 
-PM_HIBERNATION_PREPARE	The system is going to hibernate or suspend, tasks will
-			be frozen immediately.
+PM_HIBERNATION_PREPARE	The system is going to hibernate, tasks will be frozen
+			immediately. This is different from PM_SUSPEND_PREPARE
+			below because here we do additional work between notifiers
+			and drivers freezing.
 
 PM_POST_HIBERNATION	The system memory state has been restored from a
 			hibernation image or an error occurred during
-- 
1.8.3.rc0

