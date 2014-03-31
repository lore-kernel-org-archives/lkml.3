Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbaCaNeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:34:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35777 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbaCaNYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:24:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 54/71] intel_idle: Check cpu_idle_get_driver() for NULL before dereferencing it.
Date: Mon, 31 Mar 2014 14:23:00 +0100
Message-Id: <1396272197-13394-55-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 3735d524da64b70b41c764359da36f88aded3610 upstream.

If the machine is booted without any cpu_idle driver set
(b/c disable_cpuidle() has been called) we should follow
other users of cpu_idle API and check the return value
for NULL before using it.

Reported-and-tested-by: Mark van Dijk <mark@internecto.net>
Suggested-by: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/idle/intel_idle.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 674e352..9b09185 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -592,8 +592,9 @@ static int __init intel_idle_init(void)
 	intel_idle_cpuidle_driver_init();
 	retval = cpuidle_register_driver(&intel_idle_driver);
 	if (retval) {
+		struct cpuidle_driver *drv = cpuidle_get_driver();
 		printk(KERN_DEBUG PREFIX "intel_idle yielding to %s",
-			cpuidle_get_driver()->name);
+			drv ? drv->name : "none");
 		return retval;
 	}
 
-- 
1.9.1

