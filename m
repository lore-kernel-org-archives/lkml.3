Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048AbaJGXer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:34:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524AbaJGXT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:19:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 04/37] cpufreq: integrator: fix integrator_cpufreq_remove return type
Date: Tue,  7 Oct 2014 16:19:21 -0700
Message-Id: <20141007231827.202199807@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231827.043235686@linuxfoundation.org>
References: <20141007231827.043235686@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit d62dbf77f7dfaa6fb455b4b9828069a11965929c upstream.

When building this driver as a module, we get a helpful warning
about the return type:

drivers/cpufreq/integrator-cpufreq.c:232:2: warning: initialization from incompatible pointer type
  .remove = __exit_p(integrator_cpufreq_remove),

If the remove callback returns void, the caller gets an undefined
value as it expects an integer to be returned. This fixes the
problem by passing down the value from cpufreq_unregister_driver.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/integrator-cpufreq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/integrator-cpufreq.c
+++ b/drivers/cpufreq/integrator-cpufreq.c
@@ -213,9 +213,9 @@ static int __init integrator_cpufreq_pro
 	return cpufreq_register_driver(&integrator_driver);
 }
 
-static void __exit integrator_cpufreq_remove(struct platform_device *pdev)
+static int __exit integrator_cpufreq_remove(struct platform_device *pdev)
 {
-	cpufreq_unregister_driver(&integrator_driver);
+	return cpufreq_unregister_driver(&integrator_driver);
 }
 
 static const struct of_device_id integrator_cpufreq_match[] = {


