Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaLUSu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 13:50:58 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64941 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaLUSrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 13:47:15 -0500
From: Richard Cochran <richardcochran@gmail.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Amir Vadai <amirv@mellanox.com>,
        Ariel Elior <ariel.elior@qlogic.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        David Miller <davem@davemloft.net>, Frank Li <Frank.Li@freescale.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Matthew Vick <matthew.vick@intel.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH net-next 02/11] timecounter: provide a helper function to shift the time.
Date: Sun, 21 Dec 2014 19:46:57 +0100
Message-Id: <cb154598f15dff99f244f957a0a5cac2f5512461.1418504889.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1418504883.git.richardcochran@gmail.com>
References: <cover.1418504883.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some PTP Hardware Clock drivers use a struct timecounter to represent
their clock. To adjust the time by a given offset, these drivers all
perform a two step read/write of their timecounter. However, it is
better and simpler just to adjust the offset in one step. This patch
introduces a little routine to help drivers implement the adjtime
method.

Suggested-by: Janusz Użycki <j.uzycki@elproma.com.pl>
Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 include/linux/timecounter.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/timecounter.h b/include/linux/timecounter.h
index 146f07a..af3dfa4 100644
--- a/include/linux/timecounter.h
+++ b/include/linux/timecounter.h
@@ -79,6 +79,15 @@ static inline u64 cyclecounter_cyc2ns(const struct cyclecounter *cc,
 }
 
 /**
+ * timecounter_adjtime - Shifts the time of the clock.
+ * @delta:	Desired change in nanoseconds.
+ */
+static inline void timecounter_adjtime(struct timecounter *tc, s64 delta)
+{
+	tc->nsec += delta;
+}
+
+/**
  * timecounter_init - initialize a time counter
  * @tc:			Pointer to time counter which is to be initialized/reset
  * @cc:			A cycle counter, ready to be used.
-- 
1.7.10.4

