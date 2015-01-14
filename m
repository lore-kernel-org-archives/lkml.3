Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbbANHaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:30:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbbANHaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:30:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.18 116/150] ARM: dts: am437x-sk: fix lcd enable pin mux data
Date: Tue, 13 Jan 2015 23:23:07 -0800
Message-Id: <20150114072101.109927124@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 58230c2c443bc9801293f6535144d04ceaf731e0 upstream.

Caused by a copy & paste error. Note that even with
this bug AM437x SK display still works because GPIO
mux mode is always enabled. It's still wrong to mux
somebody else's pin.

Luckily ball D25 (offset 0x238 - gpio5_8) on AM437x
isn't used for anything.

While at that, also replace a pullup with a pulldown
as that gpio should be normally low, not high.

Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/am437x-sk-evm.dts |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/arm/boot/dts/am437x-sk-evm.dts
+++ b/arch/arm/boot/dts/am437x-sk-evm.dts
@@ -320,8 +320,7 @@
 
 	lcd_pins: lcd_pins {
 		pinctrl-single,pins = <
-			/* GPIO 5_8 to select LCD / HDMI */
-			0x238 (PIN_OUTPUT_PULLUP | MUX_MODE7)
+			0x1c (PIN_OUTPUT_PULLDOWN | MUX_MODE7) /* gpcm_ad7.gpio1_7 */
 		>;
 	};
 };


