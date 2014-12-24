Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaLXKXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 05:23:09 -0500
Received: from regular1.263xmail.com ([211.150.99.130]:51318 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaLXKWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 05:22:35 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: wulf@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wulf@rock-chips.com
X-UNIQUE-TAG: <803c2f28f67cd009938e0574dace80e5>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Wu Liang feng <wulf@rock-chips.com>
To: heiko@sntech.de
Cc: huangtao@rock-chips.com, kever.yang@rock-chips.com,
        eddie.cai@rock-chips.com, roy.li@rock-chips.com, zyw@rock-chips.com,
        jwerner@google.com, dianders@google.com, posciak@google.com,
        tfiga@google.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Wu Liang feng <wulf@rock-chips.com>
Subject: [PATCH 1/2] dt-bindings: usb-ehci: Add an optional property "needs-reset-on-resume"
Date: Wed, 24 Dec 2014 18:22:18 +0800
Message-Id: <1419416539-3830-2-git-send-email-wulf@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1419416539-3830-1-git-send-email-wulf@rock-chips.com>
References: <1419416539-3830-1-git-send-email-wulf@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device-tree bindings for EHCI so we can use "needs-reset-on-resume"
property to force EHCI reset after resume if necessary. This is necessary
on platforms like rk3288 that need a reset after resume to detect if a
device has been disconnected during suspend time.

Signed-off-by: Wu Liang feng <wulf@rock-chips.com>
Reviewed-by: Julius Werner <jwerner@google.com>
Reviewed-by: Doug Anderson <dianders@google.com>
Reviewed-by: Tomasz Figa <tfiga@google.com>
Reviewed-by: Pawel Osciak <posciak@google.com>
Reviewed-by: Sonny Rao <sonnyrao@google.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Doug Anderson <dianders@google.com>
---
 Documentation/devicetree/bindings/usb/usb-ehci.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/usb/usb-ehci.txt b/Documentation/devicetree/bindings/usb/usb-ehci.txt
index 43c1a4e..0b04fdf 100644
--- a/Documentation/devicetree/bindings/usb/usb-ehci.txt
+++ b/Documentation/devicetree/bindings/usb/usb-ehci.txt
@@ -12,6 +12,7 @@ Optional properties:
  - big-endian-regs : boolean, set this for hcds with big-endian registers
  - big-endian-desc : boolean, set this for hcds with big-endian descriptors
  - big-endian : boolean, for hcds with big-endian-regs + big-endian-desc
+ - needs-reset-on-resume : boolean, set this to force EHCI reset after resume
  - clocks : a list of phandle + clock specifier pairs
  - phys : phandle + phy specifier pair
  - phy-names : "usb"
-- 
1.8.3.2


