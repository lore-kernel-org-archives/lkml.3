Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbaJ1Dpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:45:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbaJ1Dpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:45:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 3.16 094/127] ARM: dts: imx28-evk: Let i2c0 run at 100kHz
Date: Tue, 28 Oct 2014 11:35:29 +0800
Message-Id: <20141028033424.956424557@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit d1e61eb443dc7512885dfe89ee2f2a1c29fcb1da upstream.

Commit 78b81f4666fb ("ARM: dts: imx28-evk: Run I2C0 at 400kHz") caused issues
when doing the following sequence in loop:

- Boot the kernel
- Perform audio playback
- Reboot the system via 'reboot' command

In many times the audio card cannot be probed, which causes playback to fail.

After restoring to the original i2c0 frequency of 100kHz there is no such
problem anymore.

This reverts commit 78b81f4666fbb22a20b1e63e5baf197ad2e90e88.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx28-evk.dts |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm/boot/dts/imx28-evk.dts
+++ b/arch/arm/boot/dts/imx28-evk.dts
@@ -193,7 +193,6 @@
 			i2c0: i2c@80058000 {
 				pinctrl-names = "default";
 				pinctrl-0 = <&i2c0_pins_a>;
-				clock-frequency = <400000>;
 				status = "okay";
 
 				sgtl5000: codec@0a {


