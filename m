Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaLCQJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:09:54 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:26811 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaLCQJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:09:50 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-b2-547f359ce172
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Jacek Anaszewski <j.anaszewski@samsung.com>,
        devicetree@vger.kernel.org
Subject: [PATCH/RFC v9 17/19] DT: Add documentation for exynos4-is 'flashes'
 property
Date: Wed, 03 Dec 2014 17:06:52 +0100
Message-id: <1417622814-10845-18-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t9jQd05pvUhBn8OWllsnLGe1eLozolM
	FvOPnGO16H+zkNXi3KuVjBa9V58zWpxtesNucXnXHDaLrW/WMVr0bNjKarH0+kUmi7unjrJZ
	TJi+lsWide8Rdovdu56yWhx+085qcWb/SjYHQY8189Ywelzu62Xy2DnrLrvHyuVf2DwOf13I
	4rFpVSebx575P1g9+rasYvRYsfo7u8fnTXIBXFFcNimpOZllqUX6dglcGdsfPWEteM5TcXXp
	NrYGxidcXYycHBICJhJ3L7WyQ9hiEhfurWfrYuTiEBKYziix49EeZginnUmi5f8LRpAqNgFD
	iZ8vXjN1MXJwiAhES1w6Vg9Swyxwl0li3oZvYDXCAuESm5avYwKxWQRUJVat2s4GYvMKeEo8
	u3yPFaRXQkBBYs4kG5AwJ1D46Y/77CBhIQEPiYMT/Scw8i5gZFjFKJpakFxQnJSea6RXnJhb
	XJqXrpecn7uJERzoz6R3MK5qsDjEKMDBqMTDaxFXFyLEmlhWXJl7iFGCg1lJhPfZN6AQb0pi
	ZVVqUX58UWlOavEhRmkOFiVx3hs3c0OEBNITS1KzU1MLUotgskwcnFINjEIt/rKT9tqvL5P8
	9NdHofL6jt+W2vG5x6bni/F4TzvC2Cjy/YYi5+JMzbbAutDHi0/eNNT8ck8+LOHTAqmpDlUd
	wfy6n7LO7jp6dv9lG/PGXxOeRkhyLjd2VrGqMONbu+zzIveGaafEHrNNO3El8+y9bjXpdGmJ
	gOo1fFmck55MWWwaV/EmXYmlOCPRUIu5qDgRAIx9BVJwAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a description of 'flashes' property
to the samsung-fimc.txt.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: <devicetree@vger.kernel.org>
---
 .../devicetree/bindings/media/samsung-fimc.txt     |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
index 922d6f8..22a6b2f 100644
--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
@@ -40,6 +40,12 @@ should be inactive. For the "active-a" state the camera port A must be activated
 and the port B deactivated and for the state "active-b" it should be the other
 way around.
 
+Optional properties:
+
+- flashes - Array of phandles to flash LED devices, or their sub-nodes
+	    representing sub-leds.
+	    (see Documentation/devicetree/bindings/leds/common.txt)
+
 The 'camera' node must include at least one 'fimc' child node.
 
 
@@ -166,6 +172,7 @@ Example:
 		clock-output-names = "cam_a_clkout", "cam_b_clkout";
 		pinctrl-names = "default";
 		pinctrl-0 = <&cam_port_a_clk_active>;
+		flashes = <&camera_flash>, <&system_torch>;
 		status = "okay";
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
1.7.9.5

