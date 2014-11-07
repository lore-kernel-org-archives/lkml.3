Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaKGGkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 01:40:43 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:46029 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaKGGkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 01:40:16 -0500
Message-ID: <545C694D.1030204@gmail.com>
Date: Thu, 06 Nov 2014 22:40:13 -0800
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty: serial: msm_serial: Use DT aliases
References: <1414024381-12204-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1414024381-12204-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Rowand <frank.rowand@sonymobile.com>

Update msm8974 dtsi for msm_serial to reflect msm_serial_probe()
getting line id from the serial alias.

Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
---
 arch/arm/boot/dts/qcom-msm8974.dtsi |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: b/arch/arm/boot/dts/qcom-msm8974.dtsi
===================================================================
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -9,6 +9,10 @@
 	compatible = "qcom,msm8974";
 	interrupt-parent = <&intc>;
 
+	aliases {
+		serial0 = &serial0;
+	};
+
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -189,7 +193,7 @@
 			reg = <0xfd8c0000 0x6000>;
 		};
 
-		serial@f991e000 {
+		serial0: serial@f991e000 {
 			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
 			reg = <0xf991e000 0x1000>;
 			interrupts = <0 108 0x0>;
