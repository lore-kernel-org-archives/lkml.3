Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbaLEW7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:59:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbaLEW41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh@kernel.org>
Subject: [PATCH 3.14 45/73] of/irq: Drop obsolete interrupts vs interrupts-extended text
Date: Fri,  5 Dec 2014 14:44:51 -0800
Message-Id: <20141205224435.291991564@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/interrupt-controller/interrupts.txt |    4 ----
 1 file changed, 4 deletions(-)

--- a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
+++ b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
@@ -30,10 +30,6 @@ should only be used when a device has mu
   Example:
 	interrupts-extended = <&intc1 5 1>, <&intc2 1 0>;
 
-A device node may contain either "interrupts" or "interrupts-extended", but not
-both. If both properties are present, then the operating system should log an
-error and use only the data in "interrupts".
-
 2) Interrupt controller nodes
 -----------------------------
 


