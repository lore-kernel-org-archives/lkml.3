Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab3CDApe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 19:45:34 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:60057 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab3CDApd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 19:45:33 -0500
MIME-Version: 1.0
From: Guan Xin <guanx.bac@gmail.com>
Date: Mon, 4 Mar 2013 01:44:52 +0100
Message-ID: <CANeMGR5a78oq63N4Fr9x0kEQue3GiXeMX7L9Om5-AqUUxdzEPQ@mail.gmail.com>
Subject: [Bug] Various abnormal WiFi behaviors with Linux 3.8 on arm/imx23
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have just moved from Linux 3.7.x to Linux 3.8.x because 3.7.x is
EOL-ed. On an iMX233-OLinuXino-MICRO with USB WiFi adapters I got the
following problems which were never present in Linux 3.7.x.

Error 1:
At first I used a USB-WiFi adapter with the RTL8192CU chip. The
rtlwifi driver showed nothing wrong in dmesg. However, I could get
nothing when scanning for APs. It looks exactly like there are no AP
at all. Of course I could not associate with my AP either.
I also tried to use the manufacturer's driver, same problem.

Error 2:
Then I changed to use an adapter with the RT5370 chip. This time I got
scanning working. It can also associate with the AP and works as
expected. The problem is -- when I tried to add the wlan IF to a
bridge, I got this:
"can't add wlan0 to bridge br0: Operation not supported"

Here are some of my kernel config options:
CONFIG_RT2X00=m
CONFIG_RT2500USB=m
CONFIG_RT73USB=m
CONFIG_RT2800USB=m
CONFIG_RT2800USB_RT33XX=y
CONFIG_RT2800USB_RT35XX=y
CONFIG_RT2800USB_RT53XX=y
CONFIG_RT2800USB_UNKNOWN=y
CONFIG_RT2800_LIB=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
# CONFIG_RT2X00_DEBUG is not set
CONFIG_RTL8192CU=m
CONFIG_RTLWIFI=m
CONFIG_RTLWIFI_DEBUG=y
CONFIG_RTL8192C_COMMON=m

I will post more information if necessary.

Best regards,
Guan
