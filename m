Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbaJ3JAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 05:00:44 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:43246 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758558AbaJ3JAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 05:00:41 -0400
Message-ID: <1414659635.1823.3.camel@jlt4.sipsolutions.net>
Subject: [PATCH 3.18] tiny: rename ENABLE_DEV_COREDUMP to ALLOW_DEV_COREDUMP
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Josh Triplett <josh@joshtriplett.org>, Aristeu Rozanski <aris@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 30 Oct 2014 10:00:35 +0100
In-Reply-To: <1414656079.1823.1.camel@jlt4.sipsolutions.net>
References: <20141016133658.GP5930@redhat.com> <20141016134430.GB7664@thin>
	 <20141016154949.GR5930@redhat.com>
	 <1413798151.10246.10.camel@jlt4.sipsolutions.net>
	 <20141020115511.GA28133@thin> <20141020221800.GB2101@kroah.com>
	 <1414656079.1823.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

The ENABLE_DEV_COREDUMP option is misleading as it implies that
it gets the framework enabled, this isn't true it just allows it
to get enabled if a driver needs it.

Rename it to ALLOW_DEV_COREDUMP to better capture its semantics.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/base/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 99d30729d11e..e9f96afe920d 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -171,8 +171,8 @@ config WANT_DEV_COREDUMP
 	  Drivers should "select" this option if they desire to use the
 	  device coredump mechanism.
 
-config ENABLE_DEV_COREDUMP
-	bool "Enable device coredump" if EXPERT
+config ALLOW_DEV_COREDUMP
+	bool "Allow device coredump" if EXPERT
 	default y
 	help
 	  This option controls if the device coredump mechanism is available or
@@ -187,7 +187,7 @@ config ENABLE_DEV_COREDUMP
 config DEV_COREDUMP
 	bool
 	default y if WANT_DEV_COREDUMP
-	depends on ENABLE_DEV_COREDUMP
+	depends on ALLOW_DEV_COREDUMP
 
 config DEBUG_DRIVER
 	bool "Driver Core verbose debug messages"
-- 
2.1.0


