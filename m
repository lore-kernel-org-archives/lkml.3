Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbaA1RLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:11:08 -0500
Received: from mail1.windriver.com ([147.11.146.13]:34331 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaA1RLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:11:05 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] nohz: ensure users are aware boot CPU is not NO_HZ_FULL
Date: Tue, 28 Jan 2014 12:10:49 -0500
Message-ID: <1390929049-17758-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bit of information is in the Kconfig help text:

  Note the boot CPU will still be kept outside the range to
  handle the timekeeping duty.

However neither the variable NO_HZ_FULL_ALL, or the prompt
convey this important detail, so lets add it to the prompt
to make it more explicitly obvious to the average user.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/time/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 3ce6e8c5f3fc..76a1fbef1fd8 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -124,7 +124,7 @@ config NO_HZ_FULL
 endchoice
 
 config NO_HZ_FULL_ALL
-       bool "Full dynticks system on all CPUs by default"
+       bool "Full dynticks system on all (but boot) CPUs by default"
        depends on NO_HZ_FULL
        help
          If the user doesn't pass the nohz_full boot option to
-- 
1.8.5.2

