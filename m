Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaKGEoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 23:44:24 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:34905 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaKGEoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 23:44:21 -0500
Message-ID: <545C4E1F.4060401@gmail.com>
Date: Thu, 06 Nov 2014 20:44:15 -0800
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

Update devicetree binding for msm_serial to reflect msm_serial_probe()
getting line id from the serial alias.

Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
---
 Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt |   15 +++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

Index: b/Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt
===================================================================
--- a/Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt
+++ b/Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt
@@ -27,11 +27,18 @@ Optional properties:
 - dmas: Should contain dma specifiers for transmit and receive channels
 - dma-names: Should contain "tx" for transmit and "rx" for receive channels
 
+Additional requirements:
+- Each UART port must have an alias correctly numbered in "aliases" node.
+
 Examples:
 
 A uartdm v1.4 device with dma capabilities.
 
-serial@f991e000 {
+aliases {
+	serial0 = &serial0;
+};
+
+serial0: serial@f991e000 {
 	compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
 	reg = <0xf991e000 0x1000>;
 	interrupts = <0 108 0x0>;
@@ -43,7 +50,11 @@ serial@f991e000 {
 
 A uartdm v1.3 device without dma capabilities and part of a GSBI complex.
 
-serial@19c40000 {
+aliases {
+	serial0 = &serial0;
+};
+
+serial0: serial@19c40000 {
 	compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
 	reg = <0x19c40000 0x1000>,
 	      <0x19c00000 0x1000>;
