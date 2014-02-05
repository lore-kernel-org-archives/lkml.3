Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaBEXm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 18:42:57 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:34046 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaBEXmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 18:42:55 -0500
Message-ID: <52F2CC7B.80406@gmail.com>
Date: Thu, 06 Feb 2014 00:42:51 +0100
From: Bastien Traverse <bastien.traverse@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: francis.moro@gmail.com, linuux-pm@vger.kernel.org
Subject: Re: 3.12: ethernet controller missing after resuming from suspend
 to RAM
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm encountering the exact same problem (same model of machine, same
controller, same OS) and was wondering where this bug was at.

I just used my Ethernet NIC for the first time on an up-to-date
Archlinux; it was working fine until I suspended to RAM: on resume the
Realtek/Ethernet device had completely disappeared.

The two entries absent from lspci output after resume are:
$ sudo lspci -v
(…)
03:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. Device
5289 (rev 01)
	Subsystem: CLEVO/KAPOK Computer Device 0540
	Flags: bus master, fast devsel, latency 0, IRQ 44
	Memory at f7200000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Endpoint, MSI 00
	Capabilities: [b0] MSI-X: Enable- Count=1 Masked-
	Capabilities: [d0] Vital Product Data
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Virtual Channel
	Capabilities: [160] Device Serial Number 00-00-00-00-00-00-00-00
	Kernel driver in use: rtsx_pci
	Kernel modules: rtsx_pci

03:00.2 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0a)
	Subsystem: CLEVO/KAPOK Computer Device 0540
	Flags: bus master, fast devsel, latency 0, IRQ 45
	I/O ports at e000 [size=256]
	Memory at f0a04000 (64-bit, prefetchable) [size=4K]
	Memory at f0a00000 (64-bit, prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Endpoint, MSI 01
	Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
	Capabilities: [d0] Vital Product Data
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [160] Device Serial Number 02-00-00-00-68-4c-e0-00
	Kernel driver in use: r8169
	Kernel modules: r8169

Trying to modprobe r8169 & rtsx_pci didn't change anything.

Tell me whether my dmesg may be of any use, but I doubt it as it is
pretty close to original poster's one.

Thanks,
Bastien
