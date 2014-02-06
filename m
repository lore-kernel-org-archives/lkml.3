Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbaBFSgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:36:31 -0500
Received: from mail1.windriver.com ([147.11.146.13]:41575 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaBFSg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:36:29 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v2] nohz: ensure users are aware boot CPU is not NO_HZ_FULL
Date: Thu, 6 Feb 2014 13:36:21 -0500
Message-ID: <1391711781-7466-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <52F3D583.9070208@windriver.com>
References: <52F3D583.9070208@windriver.com>
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

v2: use "CPU 0" instead of "boot CPU".

 kernel/time/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 3ce6e8c5f3fc..f448513a45ed 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -124,7 +124,7 @@ config NO_HZ_FULL
 endchoice
 
 config NO_HZ_FULL_ALL
-       bool "Full dynticks system on all CPUs by default"
+       bool "Full dynticks system on all CPUs by default (except CPU 0)"
        depends on NO_HZ_FULL
        help
          If the user doesn't pass the nohz_full boot option to
-- 
1.8.5.2

