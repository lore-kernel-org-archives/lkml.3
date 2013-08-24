Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab3HXGNl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 02:13:41 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:39164 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab3HXGNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 02:13:40 -0400
MIME-Version: 1.0
X-Originating-IP: [119.74.125.49]
Date: Sat, 24 Aug 2013 14:13:38 +0800
Message-ID: <CAMVG2su7av_Aym+wh-YpkMQN__u+Niya-QXsLX_xor2rhqBuew@mail.gmail.com>
Subject: BCM57765: timeout waiting for hardware interrupt
From: Daniel J Blueman <daniel@quora.org>
To: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris et al,

with 3.11-rc6 and the Broadcom BCM57765 card reader [1] in my Macbook
Retina, interrupts are not seen during card insertion:

sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pci 0000:03:00.1: SDHCI controller found [14e4:16bc] (rev 10)
mmc0: no vqmmc regulator found
mmc0: no vmmc regulator found
mmc0: SDHCI controller on PCI [0000:03:00.1] using ADMA
[...]
mmc0: Timeout waiting for hardware interrupt.

However /proc/interrupts shows 4 interrupts occurring at insertion time:

 17:          6          0          0          0          0          0
         0          0   IO-APIC-fasteoi   mmc0

Debugging shows the interrupt handler inspecting the state of the
hardware and finding no work to do; are the missing regulators
unexpected?

--- [1]

$ sudo lspci -s 03:00.1 -v
03:00.1 SD Host controller: Broadcom Corporation NetXtreme BCM57765
Memory Card Reader (rev 10) (prog-if 01)
    Subsystem: Broadcom Corporation Device 96bc
    Flags: bus master, fast devsel, latency 0, IRQ 17
    Memory at c1820000 (64-bit, prefetchable) [size=64K]
    Capabilities: [48] Power Management version 3
    Capabilities: [58] MSI: Enable- Count=1/1 Maskable- 64bit+
    Capabilities: [ac] Express Endpoint, MSI 00
    Capabilities: [100] Advanced Error Reporting
    Capabilities: [150] Power Budgeting <?>
    Capabilities: [160] Virtual Channel
    Kernel driver in use: sdhci-pci
-- 
Daniel J Blueman
