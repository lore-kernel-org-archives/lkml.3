Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbaF1RuF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:50:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406AbaF1RuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:50:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, Nishanth Menon <nm@ti.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 068/110] PM / OPP: fix incorrect OPP count handling in of_init_opp_table
Date: Sat, 28 Jun 2014 10:47:05 -0700
Message-Id: <20140628174549.619648051@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chander Kashyap <chander.kashyap@linaro.org>

commit 086abb58590a4df73e8a6ed71fd418826937cd46 upstream.

In of_init_opp_table function, if a failure to add an OPP is
detected, the count of OPPs, yet to be added is not updated.
Fix this by decrementing this count on failure as well.

Signed-off-by: Chander Kashyap <k.chander@samsung.com>
Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/power/opp.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -735,11 +735,9 @@ int of_init_opp_table(struct device *dev
 		unsigned long freq = be32_to_cpup(val++) * 1000;
 		unsigned long volt = be32_to_cpup(val++);
 
-		if (dev_pm_opp_add(dev, freq, volt)) {
+		if (dev_pm_opp_add(dev, freq, volt))
 			dev_warn(dev, "%s: Failed to add OPP %ld\n",
 				 __func__, freq);
-			continue;
-		}
 		nr -= 2;
 	}
 


