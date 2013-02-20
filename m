Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935579Ab3BTVYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:24:32 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:33747 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935219Ab3BTVYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:24:00 -0500
Date: Wed, 20 Feb 2013 22:23:40 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Davide Ciminaghi <ciminaghi@gnudd.com>, wim@iguana.be,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: [PATCH V5 2/5] watchdog: sp805_wdt depends on ARM
Message-ID: <1e8486a5ebe77094a970b8a6d72a1cc5a18e2e52.1361393832.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1361393832.git.rubini@gnudd.com>
In-Reply-To: <cover.1361393832.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SP805 driver is only used by the Spear machines, and uses
writel_relaxed, which is not available on all architectures.

The dependency from CONFIG_ARM avoids compilation problems under
randomconfig when CONFIG_ARM_AMBA is enabled for x86 builds.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Acked-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---

@Wim: I repost this after rebasing, on hpa's suggestion.

 drivers/watchdog/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 83ac1f7..e89fc31 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -109,7 +109,7 @@ config WM8350_WATCHDOG
 
 config ARM_SP805_WATCHDOG
 	tristate "ARM SP805 Watchdog"
-	depends on ARM_AMBA
+	depends on ARM && ARM_AMBA
 	select WATCHDOG_CORE
 	help
 	  ARM Primecell SP805 Watchdog timer. This will reboot your system when
-- 
1.7.7.2
