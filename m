Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaILUzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:55:23 -0400
Received: from services.gouders.net ([141.101.32.176]:53915 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaILUzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:55:22 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
In-Reply-To: <CAE9FiQXQesrDMqf1b6ZhHdmY_wEEUrOEvNO4N_d6WtaNMGNLww@mail.gmail.com>
	(Yinghai Lu's message of "Fri, 12 Sep 2014 13:39:04 -0700")
References: <ghiol53r9u.fsf@lena.gouders.net>
	<CAMxnaaXiEZeJOsgQ6ZSbiqy5Z1zNoXonwNSQNRyRhV0t5jveYQ@mail.gmail.com>
	<ghwq9k3m6z.fsf@lena.gouders.net>
	<CAMxnaaUqTMf1uEQUqrAGjym8ZrQaBf2QbE4Jqxh2t6a2JgJkOQ@mail.gmail.com>
	<ghioku5l29.fsf@lena.gouders.net>
	<CAErSpo7j=a3y2MVsvEQGQ4B63_mNCyZSRNXNEZa-2++xs88NmQ@mail.gmail.com>
	<CAE9FiQUXvuZo2bQSRg0vpuDVYrnkcXDu7KZBNp-YgXbKa2LQhw@mail.gmail.com>
	<ghppf15236.fsf@quad.gouders.net>
	<CAErSpo5SVUOz+qa_x5JTC+-Y5ewTyYzA0N=jyPtK9LaguRrt=w@mail.gmail.com>
	<ghd2b1svdw.fsf@quad.gouders.net>
	<CAErSpo5e0GOdVbZdQYriP+aWziKELpb9BWTgJ4ERPia354CM5w@mail.gmail.com>
	<ghvbotd8es.fsf@quad.gouders.net> <ghzje5f5zt.fsf@lena.gouders.net>
	<ghbnqkeh9k.fsf@quad.gouders.net>
	<CAE9FiQXQesrDMqf1b6ZhHdmY_wEEUrOEvNO4N_d6WtaNMGNLww@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Fri, 12 Sep 2014 22:54:12 +0200
Message-ID: <gh4mwcef0r.fsf@quad.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On Fri, Sep 12, 2014 at 1:05 PM, Dirk Gouders <dirk@gouders.net> wrote:
>> Dirk Gouders <dirk@gouders.net> writes:
>>
>> I now applied your patches and tested them:
>>
>> echo 1 > /sys/bus/pci/devices/0000\:00\:0a.0/pcie_link_disable
>> echo 0 > /sys/bus/pci/devices/0000\:00\:0a.0/pcie_link_disable
>>
>> The FC Adapter did not show up, this is the dmesg output (I also tested
>> with 0b.0):
>>
>> [  143.294168] pcieport 0000:00:0a.0: pcie_link_disable_set: lnk_ctrl = 18
>> [  148.284456] pcieport 0000:00:0a.0: pcie_link_disable_set: lnk_ctrl = 8
>> [  304.065942] pcieport 0000:00:0b.0: pcie_link_disable_set: lnk_ctrl = 18
>> [  309.035278] pcieport 0000:00:0b.0: pcie_link_disable_set: lnk_ctrl = 8
>>
>> So, probably my test environment does not work as expected and I have to
>> test it on the failing machine.
>
> You need to rescan the pci devices.
> like
>
> echo 1 >  /sys/bus/pci/rescan

Thank you (all) for your suggestions.

I tried both: the plain rescan and Bjorn's suggestion but the FC adapter
seems to be very shy:

[  143.294168] pcieport 0000:00:0a.0: pcie_link_disable_set: lnk_ctrl = 18
[  148.284456] pcieport 0000:00:0a.0: pcie_link_disable_set: lnk_ctrl = 8
[  304.065942] pcieport 0000:00:0b.0: pcie_link_disable_set: lnk_ctrl = 18
[  309.035278] pcieport 0000:00:0b.0: pcie_link_disable_set: lnk_ctrl = 8
[ 2514.440442] pcieport 0000:00:0a.0: pcie_link_disable_set: lnk_ctrl = 18
[ 2554.819381] pcieport 0000:00:0a.0: pcie_link_disable_set: lnk_ctrl = 8
[ 3339.722154] pci_scan_child_bus: pci_bus 0000:00: scanning bus
[ 3339.722215] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 0
[ 3339.722222] pci_scan_child_bus: pci_bus 0000:01: scanning bus
[ 3339.722251] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 0
[ 3339.722256] pci_scan_child_bus: pci_bus 0000:02: scanning bus
[ 3339.722287] pci_scan_child_bus: pci_bus 0000:02: bus scan returning with max=02
[ 3339.722292] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 1
[ 3339.722297] pci_scan_child_bus: pci_bus 0000:01: bus scan returning with max=02
[ 3339.722302] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 0
[ 3339.722307] pci_scan_child_bus: pci_bus 0000:03: scanning bus
[ 3339.722332] pci_scan_child_bus: pci_bus 0000:03: bus scan returning with max=03
[ 3339.722337] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 0
[ 3339.722341] pci_scan_child_bus: pci_bus 0000:04: scanning bus
[ 3339.722364] pci_scan_child_bus: pci_bus 0000:04: bus scan returning with max=04
[ 3339.722369] pci_scan_bridge: pcieport 0000:00:0a.0: scanning [bus 05-05] behind bridge, pass 0
[ 3339.722373] pci_scan_child_bus: pci_bus 0000:05: scanning bus
[ 3339.722377] pci_scan_child_bus: pci_bus 0000:05: bus scan returning with max=05
[ 3339.722381] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 06-06] behind bridge, pass 0
[ 3339.722386] pci_scan_child_bus: pci_bus 0000:06: scanning bus
[ 3339.722389] pci_scan_child_bus: pci_bus 0000:06: bus scan returning with max=06
[ 3339.722394] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 1
[ 3339.722400] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 1
[ 3339.722404] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 1
[ 3339.722409] pci_scan_bridge: pcieport 0000:00:0a.0: scanning [bus 05-05] behind bridge, pass 1
[ 3339.722414] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 06-06] behind bridge, pass 1
[ 3339.722418] pci_scan_child_bus: pci_bus 0000:00: bus scan returning with max=06
[ 3339.722455] pci 0000:01:0d.0: PCI bridge to [bus 02]
[ 3339.722466] pci 0000:00:06.0: PCI bridge to [bus 03]
[ 3583.321906] pci_scan_child_bus: pci_bus 0000:00: scanning bus
[ 3583.321974] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 0
[ 3583.321982] pci_scan_child_bus: pci_bus 0000:01: scanning bus
[ 3583.322032] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 0
[ 3583.322037] pci_scan_child_bus: pci_bus 0000:02: scanning bus
[ 3583.322070] pci_scan_child_bus: pci_bus 0000:02: bus scan returning with max=02
[ 3583.322076] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 1
[ 3583.322081] pci_scan_child_bus: pci_bus 0000:01: bus scan returning with max=02
[ 3583.322087] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 0
[ 3583.322092] pci_scan_child_bus: pci_bus 0000:03: scanning bus
[ 3583.322121] pci_scan_child_bus: pci_bus 0000:03: bus scan returning with max=03
[ 3583.322126] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 0
[ 3583.322130] pci_scan_child_bus: pci_bus 0000:04: scanning bus
[ 3583.322155] pci_scan_child_bus: pci_bus 0000:04: bus scan returning with max=04
[ 3583.322160] pci_scan_bridge: pcieport 0000:00:0a.0: scanning [bus 05-05] behind bridge, pass 0
[ 3583.322164] pci_scan_child_bus: pci_bus 0000:05: scanning bus
[ 3583.322168] pci_scan_child_bus: pci_bus 0000:05: bus scan returning with max=05
[ 3583.322177] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 06-06] behind bridge, pass 0
[ 3583.322182] pci_scan_child_bus: pci_bus 0000:06: scanning bus
[ 3583.322185] pci_scan_child_bus: pci_bus 0000:06: bus scan returning with max=06
[ 3583.322191] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 1
[ 3583.322196] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 1
[ 3583.322202] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 1
[ 3583.322207] pci_scan_bridge: pcieport 0000:00:0a.0: scanning [bus 05-05] behind bridge, pass 1
[ 3583.322212] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 06-06] behind bridge, pass 1
[ 3583.322216] pci_scan_child_bus: pci_bus 0000:00: bus scan returning with max=06
[ 3583.322262] pci 0000:01:0d.0: PCI bridge to [bus 02]
[ 3583.322273] pci 0000:00:06.0: PCI bridge to [bus 03]

# lspci -tv
-[0000:00]-+-01.0-[01-02]--+-0d.0-[02]--
           |               +-0e.0  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
           |               \-0e.1  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
           +-02.0  Broadcom BCM5785 [HT1000] Legacy South Bridge
           +-02.1  Broadcom BCM5785 [HT1000] IDE
           +-02.2  Broadcom BCM5785 [HT1000] LPC
           +-03.0  Broadcom BCM5785 [HT1000] USB
           +-03.1  Broadcom BCM5785 [HT1000] USB
           +-03.2  Broadcom BCM5785 [HT1000] USB
           +-06.0-[03]--
           +-07.0-[04]--+-04.0  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
           |            \-04.1  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
           +-0a.0-[05]--
           +-0b.0-[06]--
           +-0c.0  Advanced Micro Devices, Inc. [AMD/ATI] ES1000
           +-18.0  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
           +-18.1  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Address Map
           +-18.2  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] DRAM Controller
           +-18.3  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
           +-19.0  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
           +-19.1  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Address Map
           +-19.2  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] DRAM Controller
           \-19.3  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
