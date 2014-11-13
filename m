Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263AbaKMNVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:21:36 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:33115 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932637AbaKMNVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:21:33 -0500
From: Kever Yang <kever.yang@rock-chips.com>
To: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, dkl@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Gerhard Sittig <gsi@denx.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ben Dooks <ben.dooks@codethink.co.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/2] dt-bindings: clk: add document for assigned-clock-force-rates usage
Date: Thu, 13 Nov 2014 21:20:26 +0800
Message-Id: <1415884826-7877-3-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415884826-7877-1-git-send-email-kever.yang@rock-chips.com>
References: <1415884826-7877-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds document for how to use the opetion property
assigned-clock-force-rates.

We may use this property to force update a clock setting.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

 Documentation/devicetree/bindings/clock/clock-bindings.txt | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
index 06fc6d5..fb5d3a5 100644
--- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
+++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
@@ -154,11 +154,14 @@ set to 0, or can be omitted if it is not followed by any non-zero entry.
 
         assigned-clocks = <&clkcon 0>, <&pll 2>;
         assigned-clock-parents = <&pll 2>;
+        assigned-clock-force-rates = <500000>, <0>;
         assigned-clock-rates = <0>, <460800>;
     };
 
-In this example the <&pll 2> clock is set as parent of clock <&clkcon 0> and
-the <&pll 2> clock is assigned a frequency value of 460800 Hz.
+In this example the <&pll 2> clock is set as parent of clock <&clkcon 0>,
+the <&clkcon 0> clock is assigned a frequency value of 500000 Hz and make
+sure the we get into assigned-clock-rates even if there is no rate change,
+and the <&pll 2> clock is assigned a frequency value of 460800 Hz.
 
 Configuring a clock's parent and rate through the device node that consumes
 the clock can be done only for clocks that have a single user. Specifying
-- 
1.9.1

