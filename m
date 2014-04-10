Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934923AbaDJDWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:22:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934646AbaDJDVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:21:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH 3.4 014/134] intel_idle: Check cpu_idle_get_driver() for NULL before dereferencing it.
Date: Wed,  9 Apr 2014 20:22:10 -0700
Message-Id: <20140410032301.630515702@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/idle/intel_idle.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -594,8 +594,9 @@ static int __init intel_idle_init(void)
 	intel_idle_cpuidle_driver_init();
 	retval = cpuidle_register_driver(&intel_idle_driver);
 	if (retval) {
+		struct cpuidle_driver *drv = cpuidle_get_driver();
 		printk(KERN_DEBUG PREFIX "intel_idle yielding to %s",
-			cpuidle_get_driver()->name);
+			drv ? drv->name : "none");
 		return retval;
 	}
 


