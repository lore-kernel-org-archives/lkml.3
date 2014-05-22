Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbaEVLYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 07:24:40 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:37266 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677AbaEVLYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 07:24:37 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>, devicetree@vger.kernel.org
Subject: [PATCH 08/10] mtd: st_spi_fsm: Provide documentation for boot device mask property
Date: Thu, 22 May 2014 12:24:06 +0100
Message-Id: <1400757848-18075-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400757848-18075-1-git-send-email-lee.jones@linaro.org>
References: <1400757848-18075-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The system configuration registers which display which device the system
booted on are in the same place on all boards which support the FSM.
However, the bits do shift every so slightly.  To combat these we're
adding a new property which supplies the necessary mask used to abstract
the required information.

Cc: devicetree@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/mtd/st-fsm.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/mtd/st-fsm.txt b/Documentation/devicetree/bindings/mtd/st-fsm.txt
index c248939..0523fd4 100644
--- a/Documentation/devicetree/bindings/mtd/st-fsm.txt
+++ b/Documentation/devicetree/bindings/mtd/st-fsm.txt
@@ -11,6 +11,8 @@ Optional properties:
   - st,syscfg          : Phandle to boot-device system configuration registers
   - st,boot-device-reg : Address of the aforementioned boot-device register(s)
   - st,boot-device-spi : Expected boot-device value if booted via this device
+  - st,boot-device-msk : Mask to use when extracting boot device from the
+			 above system config registers
 
 Example:
 	spifsm: spifsm@fe902000{
-- 
1.8.3.2

