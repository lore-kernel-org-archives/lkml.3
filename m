Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbaJPPt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 11:49:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbaJPPt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 11:49:56 -0400
Date: Thu, 16 Oct 2014 11:49:49 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH] tiny: reverse logic for DISABLE_DEV_COREDUMP
Message-ID: <20141016154949.GR5930@redhat.com>
References: <20141016133658.GP5930@redhat.com>
 <20141016134430.GB7664@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016134430.GB7664@thin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's desirable for allnconfig and tinyconfig targets to result in the
least amount of code possible. DISABLE_DEV_COREDUMP exists as a way to
switch off DEV_COREDUMP regardless if any drivers select
WANT_DEV_COREDUMP.

This patch renames the option to ENABLE_DEV_COREDUMP and setting it to
'n' (as in allnconfig or tinyconfig) will effectively disable device
coredump.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
---
 drivers/base/Kconfig | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 134f763..99d3072 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -171,20 +171,23 @@ config WANT_DEV_COREDUMP
 	  Drivers should "select" this option if they desire to use the
 	  device coredump mechanism.
 
-config DISABLE_DEV_COREDUMP
-	bool "Disable device coredump" if EXPERT
+config ENABLE_DEV_COREDUMP
+	bool "Enable device coredump" if EXPERT
+	default y
 	help
-	  Disable the device coredump mechanism despite drivers wanting to
-	  use it; this allows for more sensitive systems or systems that
-	  don't want to ever access the information to not have the code,
-	  nor keep any data.
+	  This option controls if the device coredump mechanism is available or
+	  not; if disabled, the mechanism will be omitted even if drivers that
+	  can use it are enabled.
+	  Say 'N' for more sensitive systems or systems that don't want
+	  to ever access the information to not have the code, nor keep any
+	  data.
 
-	  If unsure, say N.
+	  If unsure, say Y.
 
 config DEV_COREDUMP
 	bool
 	default y if WANT_DEV_COREDUMP
-	depends on !DISABLE_DEV_COREDUMP
+	depends on ENABLE_DEV_COREDUMP
 
 config DEBUG_DRIVER
 	bool "Driver Core verbose debug messages"
-- 
1.8.3.1

