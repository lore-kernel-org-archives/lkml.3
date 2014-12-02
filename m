Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645AbaLBT0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:26:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46898 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933589AbaLBT0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:26:10 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 112/121] of/irq: Drop obsolete 'interrupts' vs 'interrupts-extended' text
Date: Tue,  2 Dec 2014 11:19:51 -0800
Message-Id: <1417548000-1794-113-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit 66865de4314caca30598244b86817e774c188afa upstream.

a9ecdc0fdc54 ("of/irq: Fix lookup to use 'interrupts-extended' property
first") updated the description to say that:

  - Both 'interrupts' and 'interrupts-extended' may be present
  - Software should prefer 'interrupts-extended'
  - Software that doesn't comprehend 'interrupts-extended' may use
    'interrupts'

But there is still a paragraph at the end that prohibits having both and
says 'interrupts' should be preferred.

Remove the contradictory text.

Fixes: a9ecdc0fdc54 ("of/irq: Fix lookup to use 'interrupts-extended' property first")
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Brian Norris <computersforpeace@gmail.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 Documentation/devicetree/bindings/interrupt-controller/interrupts.txt | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
index ce6a1a0..8a3c408 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
+++ b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
@@ -30,10 +30,6 @@ should only be used when a device has multiple interrupt parents.
   Example:
 	interrupts-extended = <&intc1 5 1>, <&intc2 1 0>;
 
-A device node may contain either "interrupts" or "interrupts-extended", but not
-both. If both properties are present, then the operating system should log an
-error and use only the data in "interrupts".
-
 2) Interrupt controller nodes
 -----------------------------
 
-- 
1.9.1

