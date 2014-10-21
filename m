Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaJUENa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:13:30 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:33541 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbaJUEN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:13:26 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 06/47] gpio-poweroff: Drop reference to pm_power_off from devicetree bindings
Date: Mon, 20 Oct 2014 21:12:22 -0700
Message-Id: <1413864783-3271-7-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.5445DD65.0118,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 23
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pm_power_off is an implementation detail. Replace it with a more generic
description of the driver's functionality.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: No change

 Documentation/devicetree/bindings/gpio/gpio-poweroff.txt | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio-poweroff.txt b/Documentation/devicetree/bindings/gpio/gpio-poweroff.txt
index d4eab92..c95a1a6 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-poweroff.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio-poweroff.txt
@@ -2,12 +2,12 @@ Driver a GPIO line that can be used to turn the power off.
 
 The driver supports both level triggered and edge triggered power off.
 At driver load time, the driver will request the given gpio line and
-install a pm_power_off handler. If the optional properties 'input' is
-not found, the GPIO line will be driven in the inactive
+install a handler to power off the system. If the optional properties
+'input' is not found, the GPIO line will be driven in the inactive
 state. Otherwise its configured as an input.
 
-When the pm_power_off is called, the gpio is configured as an output,
-and drive active, so triggering a level triggered power off
+When the the poweroff handler is called, the gpio is configured as an
+output, and drive active, so triggering a level triggered power off
 condition. This will also cause an inactive->active edge condition, so
 triggering positive edge triggered power off. After a delay of 100ms,
 the GPIO is set to inactive, thus causing an active->inactive edge,
@@ -24,7 +24,7 @@ Required properties:
 
 Optional properties:
 - input : Initially configure the GPIO line as an input. Only reconfigure
-  it to an output when the pm_power_off function is called. If this optional
+  it to an output when the poweroff handler is called. If this optional
   property is not specified, the GPIO is initialized as an output in its
   inactive state.
 
-- 
1.9.1

