Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbbA1UP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:15:57 -0500
Received: from dehamd003.servertools24.de ([31.47.254.18]:52854 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755155AbbA1UPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:15:55 -0500
Message-ID: <54C9418F.1050600@ladisch.de>
Date: Wed, 28 Jan 2015 21:07:43 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64;
	rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Hurley <peter@hurleysoftware.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, devel@driverdev.osuosl.org,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] staging/fwserial: use correct vendor/version IDs
References: <54C940E0.5090906@ladisch.de>
In-Reply-To: <54C940E0.5090906@ladisch.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <20150128200255.317905.80820@dehamd003.servertools24.de>
X-PPP-Vhost: ladisch.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver was using the vendor ID 0xd00d1e from the FireWire core.
However, this ID was not registered, and invalid.

Instead, use the vendor/version IDs that now are officially assigned to
firewire-serial:
https://ieee1394.wiki.kernel.org/index.php/IEEE_OUI_Assignments

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 drivers/staging/fwserial/TODO       |    5 ++---
 drivers/staging/fwserial/fwserial.c |    4 ++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/fwserial/TODO b/drivers/staging/fwserial/TODO
index 382a795..c3d1d3a 100644
--- a/drivers/staging/fwserial/TODO
+++ b/drivers/staging/fwserial/TODO
@@ -9,6 +9,5 @@ TODOs prior to this driver moving out of staging
    GUID-to-port matching/whitelist/blacklist.

 -- Issues with firewire stack --
-1. This driver uses the same unregistered vendor id that the firewire core does
-     (0xd00d1e). Perhaps this could be exposed as a define in
-     firewire.h?
+1. This driver uses the same ids that the firewire core does (001f11:0239xx).
+   Perhaps this could be exposed as a define in firewire.h?
diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index 73deae3..2964366 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -30,8 +30,8 @@

 #define be32_to_u64(hi, lo)  ((u64)be32_to_cpu(hi) << 32 | be32_to_cpu(lo))

-#define LINUX_VENDOR_ID   0xd00d1eU  /* same id used in card root directory   */
-#define FWSERIAL_VERSION  0x00e81cU  /* must be unique within LINUX_VENDOR_ID */
+#define LINUX_VENDOR_ID   0x001f11U  /* same id used in card root directory   */
+#define FWSERIAL_VERSION  0x023953U  /* must be unique within LINUX_VENDOR_ID */

 /* configurable options */
 static int num_ttys = 4;	    /* # of std ttys to create per fw_card    */
