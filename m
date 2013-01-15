Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab3APAT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:19:57 -0500
Received: from mail.kernel.org ([198.145.19.201]:42233 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187Ab3AOWbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:31:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sivaram Nair <sivaramn@nvidia.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Colin Cross <ccross@android.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 104/221] cpuidle / coupled: fix ready counter decrement
Date: Tue, 15 Jan 2013 10:50:31 -0800
Message-Id: <20130115185005.548383767@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sivaram Nair <sivaramn@nvidia.com>

commit 92638e2facc5330475c7d558acec77721c3214e4 upstream.

The ready_waiting_counts atomic variable is compared against the wrong
online cpu count. The latter is computed incorrectly using logical-OR
instead of bit-OR. This patch fixes that.

Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Colin Cross <ccross@android.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpuidle/coupled.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cpuidle/coupled.c
+++ b/drivers/cpuidle/coupled.c
@@ -209,7 +209,7 @@ inline int cpuidle_coupled_set_not_ready
 	int all;
 	int ret;
 
-	all = coupled->online_count || (coupled->online_count << WAITING_BITS);
+	all = coupled->online_count | (coupled->online_count << WAITING_BITS);
 	ret = atomic_add_unless(&coupled->ready_waiting_counts,
 		-MAX_WAITING_CPUS, all);
 


