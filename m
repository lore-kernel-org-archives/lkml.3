Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaC2Acr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 20:32:47 -0400
Received: from ring0.de ([5.45.105.125]:42883 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbaC2Acn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 20:32:43 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        =?UTF-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE=20=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv3 01/14] Documentation: HSI: Add some general description for the HSI subsystem
Date: Sat, 29 Mar 2014 01:31:37 +0100
Message-Id: <1396053110-21639-2-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396053110-21639-1-git-send-email-sre@kernel.org>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a document, which gives a rough introduction about what HSI
is and how its handled by the Linux kernel.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 Documentation/hsi.txt | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100644 Documentation/hsi.txt

diff --git a/Documentation/hsi.txt b/Documentation/hsi.txt
new file mode 100644
index 0000000..6ac6cd5
--- /dev/null
+++ b/Documentation/hsi.txt
@@ -0,0 +1,75 @@
+HSI - High-speed Synchronous Serial Interface
+
+1. Introduction
+~~~~~~~~~~~~~~~
+
+High Speed Syncronous Interface (HSI) is a fullduplex, low latency protocol,
+that is optimized for die-level interconnect between an Application Processor
+and a Baseband chipset. It has been specified by the MIPI alliance in 2003 and
+implemented by multiple vendors since then.
+
+The HSI interface supports full duplex communication over multiple channels
+(typically 8) and is capable of reaching speeds up to 200 Mbit/s.
+
+The serial protocol uses two signals, DATA and FLAG as combined data and clock
+signals and an additional READY signal for flow control. An additional WAKE
+signal can be used to wakeup the chips from standby modes. The signals are
+commonly prefixed by AC for signals going from the application die to the
+cellular die and CA for signals going the other way around.
+
++------------+                                 +---------------+
+|  Cellular  |                                 |  Application  |
+|    Die     |                                 |      Die      |
+|            | - - - - - - CAWAKE - - - - - - >|               |
+|           T|------------ CADATA ------------>|R              |
+|           X|------------ CAFLAG ------------>|X              |
+|            |<----------- ACREADY ------------|               |
+|            |                                 |               |
+|            |                                 |               |
+|            |< - - - - -  ACWAKE - - - - - - -|               |
+|           R|<----------- ACDATA -------------|T              |
+|           X|<----------- ACFLAG -------------|X              |
+|            |------------ CAREADY ----------->|               |
+|            |                                 |               |
+|            |                                 |               |
++------------+                                 +---------------+
+
+2. HSI Subsystem in Linux
+~~~~~~~~~~~~~~~~~~~~~~~~~
+
+In the Linux kernel the hsi subsystem is supposed to be used for HSI devices.
+The hsi subsystem contains drivers for hsi controllers including support for
+multi-port controllers and provides a generic API for using the HSI ports.
+
+It also contains HSI client drivers, which make use of the generic API to
+implement a protocol used on the HSI interface. These client drivers can
+use an arbitrary number of channels.
+
+3. hsi-char Device
+~~~~~~~~~~~~~~~~~~
+
+Each port automatically registers a generic client driver called hsi_char,
+which provides a charecter device for userspace representing the HSI port.
+It can be used to communicate via HSI from userspace. Userspace may
+configure the hsi_char device using the following ioctl commands:
+
+* HSC_RESET:
+ - flush the HSI port
+
+* HSC_SET_PM
+ - enable or disable the client.
+
+* HSC_SEND_BREAK
+ - send break
+
+* HSC_SET_RX
+ - set RX configuration
+
+* HSC_GET_RX
+ - get RX configuration
+
+* HSC_SET_TX
+ - set TX configuration
+
+* HSC_GET_TX
+ - get TX configuration
-- 
1.9.0

