Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaIMANK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 20:13:10 -0400
Received: from services.gouders.net ([141.101.32.176]:54023 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbaIMANH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 20:13:07 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
In-Reply-To: <CAE9FiQUk-sAHnjfBvNeHQWibJRqbPE1V0UtDtARtwxmS=7aQrw@mail.gmail.com>
	(Yinghai Lu's message of "Fri, 12 Sep 2014 16:09:14 -0700")
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
	<gh4mwcef0r.fsf@quad.gouders.net>
	<CAE9FiQWgioBeVmfWCaE38BrkjbWKaS+_FYYdmdd+7X8fpeEgnQ@mail.gmail.com>
	<ghoaukcx6b.fsf@quad.gouders.net>
	<CAE9FiQUk-sAHnjfBvNeHQWibJRqbPE1V0UtDtARtwxmS=7aQrw@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Sat, 13 Sep 2014 02:11:33 +0200
Message-ID: <ghk358crbe.fsf@quad.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On Fri, Sep 12, 2014 at 3:05 PM, Dirk Gouders <dirk@gouders.net> wrote:
>> Yinghai Lu <yinghai@kernel.org> writes:
>>
>>> On Fri, Sep 12, 2014 at 1:54 PM, Dirk Gouders <dirk@gouders.net> wrote:
>>>> Yinghai Lu <yinghai@kernel.org> writes:
>>>>
>>>>> On Fri, Sep 12, 2014 at 1:05 PM, Dirk Gouders <dirk@gouders.net> wrote:
>>>>>> Dirk Gouders <dirk@gouders.net> writes:
>>>> -[0000:00]-+-01.0-[01-02]--+-0d.0-[02]--
>>>>            |               +-0e.0  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
>>>>            |               \-0e.1  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
>>>>            +-02.0  Broadcom BCM5785 [HT1000] Legacy South Bridge
>>>>            +-02.1  Broadcom BCM5785 [HT1000] IDE
>>>>            +-02.2  Broadcom BCM5785 [HT1000] LPC
>>>>            +-03.0  Broadcom BCM5785 [HT1000] USB
>>>>            +-03.1  Broadcom BCM5785 [HT1000] USB
>>>>            +-03.2  Broadcom BCM5785 [HT1000] USB
>>>>            +-06.0-[03]--
>>>>            +-07.0-[04]--+-04.0  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
>>>>            |            \-04.1  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
>>>>            +-0a.0-[05]--
>>>>            +-0b.0-[06]--
>>>
>>> what is "lspci -tv" and "lspci -vvxxx" look like before your patch that cut down
>>> end bus to 07 ...?
>>
>> Rebooted with 3.16 kernel:
>>
>> # lspci -tv
>>
>> -[0000:00]-+-01.0-[01-02]--+-0d.0-[02]--
>>            |               +-0e.0  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
>>            |               \-0e.1  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
>>            +-02.0  Broadcom BCM5785 [HT1000] Legacy South Bridge
>>            +-02.1  Broadcom BCM5785 [HT1000] IDE
>>            +-02.2  Broadcom BCM5785 [HT1000] LPC
>>            +-03.0  Broadcom BCM5785 [HT1000] USB
>>            +-03.1  Broadcom BCM5785 [HT1000] USB
>>            +-03.2  Broadcom BCM5785 [HT1000] USB
>>            +-06.0-[03]--
>>            +-07.0-[04]--+-04.0  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
>>            |            \-04.1  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
>>            +-08.0-[05]--
>>            +-09.0-[06]--
>>            +-0a.0-[07]----00.0  LSI Logic / Symbios Logic FC949ES Fibre Channel Adapter
>>            +-0b.0-[08]--
>
> where are 00:08.0 and 00:09.0 going? Did you just skip them in "cut
> end bus patch" ?

Yes, I skip them in pci_scan_device() to get the unused bus number space
that 0a.0 and 0b.0 then can use when reconfiguration is triggered.

> Proper simulation could be:
> 1. remove 07:00.0
>     echo 1 > /sys/bus/pci/devices/0000:07:00.0/remove
> 2. change bus range in 00:0a.0 bus
>     setpci -s 00:0a.0 0x1c.l=0x00101000
> 3. remove 00:0a.0
>     echo 1 > /sys/bus/pci/devices/0000:00:0a.0/remove
> 4. rescan pci
>     echo 1 > /sys/bus/pci/rescan
> 5. reset pcie link from 00:0a.0
>     setpci -s 00:0a.0 0xc0.b=0x18
>     sleep 1s
>     setpci -s 00:0a.0 0xc0.b=0x08
> 6. rescan pci bus
>     echo 1 > /sys/bus/pci/rescan

OK, I did that (with 3.16) but the reconfiguration code doesn't
get triggered.  Here is what dmesg and lspci -tv say:

[  166.775570] pci_bus 0000:07: busn_res: [bus 07] is released
[  166.775744] pci_scan_child_bus: pci_bus 0000:00: scanning bus
[  166.775787] pci 0000:00:0a.0: [1166:0132] type 01 class 0x060400
[  166.775902] pci 0000:00:0a.0: System wakeup disabled by ACPI
[  166.776031] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 0
[  166.776038] pci_scan_child_bus: pci_bus 0000:01: scanning bus
[  166.776071] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 0
[  166.776076] pci_scan_child_bus: pci_bus 0000:02: scanning bus
[  166.776114] pci_scan_child_bus: pci_bus 0000:02: bus scan returning with max=02
[  166.776119] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 1
[  166.776124] pci_scan_child_bus: pci_bus 0000:01: bus scan returning with max=02
[  166.776130] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 0
[  166.776134] pci_scan_child_bus: pci_bus 0000:03: scanning bus
[  166.776163] pci_scan_child_bus: pci_bus 0000:03: bus scan returning with max=03
[  166.776168] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 0
[  166.776172] pci_scan_child_bus: pci_bus 0000:04: scanning bus
[  166.776197] pci_scan_child_bus: pci_bus 0000:04: bus scan returning with max=04
[  166.776202] pci_scan_bridge: pcieport 0000:00:08.0: scanning [bus 05-05] behind bridge, pass 0
[  166.776206] pci_scan_child_bus: pci_bus 0000:05: scanning bus
[  166.776210] pci_scan_child_bus: pci_bus 0000:05: bus scan returning with max=05
[  166.776215] pci_scan_bridge: pcieport 0000:00:09.0: scanning [bus 06-06] behind bridge, pass 0
[  166.776219] pci_scan_child_bus: pci_bus 0000:06: scanning bus
[  166.776223] pci_scan_child_bus: pci_bus 0000:06: bus scan returning with max=06
[  166.776227] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 08-08] behind bridge, pass 0
[  166.776231] pci_scan_child_bus: pci_bus 0000:08: scanning bus
[  166.776235] pci_scan_child_bus: pci_bus 0000:08: bus scan returning with max=08
[  166.776240] pci_scan_bridge: pci 0000:00:0a.0: scanning [bus 07-07] behind bridge, pass 0
[  166.776284] pci_scan_child_bus: pci_bus 0000:07: scanning bus
[  166.776300] pci 0000:07:00.0: [1000:0646] type 00 class 0x0c0400
[  166.776314] pci 0000:07:00.0: reg 0x10: [io  0xb000-0xb0ff]
[  166.776327] pci 0000:07:00.0: reg 0x14: [mem 0xff5fc000-0xff5fffff 64bit]
[  166.776340] pci 0000:07:00.0: reg 0x1c: [mem 0xff5e0000-0xff5effff 64bit]
[  166.776355] pci 0000:07:00.0: reg 0x30: [mem 0xff400000-0xff4fffff pref]
[  166.776396] pci 0000:07:00.0: supports D1 D2
[  166.778033] pci_scan_child_bus: pci_bus 0000:07: fixups for bus
[  166.778038] pci 0000:00:0a.0: PCI bridge to [bus 07]
[  166.778045] pci 0000:00:0a.0:   bridge window [io  0x0000-0x1fff]
[  166.778048] pci 0000:00:0a.0:   bridge window [mem 0xff300000-0xff5fffff]
[  166.778054] pci 0000:00:0a.0:   bridge window [mem 0xcfe00000-0xcfefffff 64bit pref]
[  166.778057] pci_scan_child_bus: pci_bus 0000:07: bus scan returning with max=07
[  166.778062] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 1
[  166.778068] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 1
[  166.778073] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 1
[  166.778079] pci_scan_bridge: pcieport 0000:00:08.0: scanning [bus 05-05] behind bridge, pass 1
[  166.778084] pci_scan_bridge: pcieport 0000:00:09.0: scanning [bus 06-06] behind bridge, pass 1
[  166.778089] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 08-08] behind bridge, pass 1
[  166.778094] pci_scan_bridge: pci 0000:00:0a.0: scanning [bus 07-07] behind bridge, pass 1
[  166.778098] pci_scan_child_bus: pci_bus 0000:00: bus scan returning with max=08
[  166.778152] pci 0000:00:0a.0: BAR 8: assigned [mem 0x80000000-0x802fffff]
[  166.778159] pci 0000:00:0a.0: BAR 9: assigned [mem 0x200000000-0x2000fffff 64bit pref]
[  166.778164] pci 0000:00:0a.0: BAR 7: assigned [io  0x1000-0x2fff]
[  166.778169] pci 0000:01:0d.0: PCI bridge to [bus 02]
[  166.778179] pci 0000:00:06.0: PCI bridge to [bus 03]
[  166.778188] pci 0000:07:00.0: BAR 6: assigned [mem 0x80000000-0x800fffff pref]
[  166.778193] pci 0000:07:00.0: BAR 3: assigned [mem 0x80100000-0x8010ffff 64bit]
[  166.778204] pci 0000:07:00.0: BAR 1: assigned [mem 0x80110000-0x80113fff 64bit]
[  166.778213] pci 0000:07:00.0: BAR 0: assigned [io  0x1000-0x10ff]
[  166.778218] pci 0000:00:0a.0: PCI bridge to [bus 07]
[  166.778221] pci 0000:00:0a.0:   bridge window [io  0x1000-0x2fff]
[  166.778226] pci 0000:00:0a.0:   bridge window [mem 0x80000000-0x802fffff]
[  166.778229] pci 0000:00:0a.0:   bridge window [mem 0x200000000-0x2000fffff 64bit pref]
[  166.778244] fixup_debug_start: pci 0000:00:0a.0: calling quirk_msi_ht_cap+0x0/0x50
[  166.778251] pci 0000:00:0a.0: Found enabled HT MSI Mapping
[  167.800394] pci_scan_child_bus: pci_bus 0000:00: scanning bus
[  167.800456] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 0
[  167.800463] pci_scan_child_bus: pci_bus 0000:01: scanning bus
[  167.800495] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 0
[  167.800501] pci_scan_child_bus: pci_bus 0000:02: scanning bus
[  167.800536] pci_scan_child_bus: pci_bus 0000:02: bus scan returning with max=02
[  167.800541] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 1
[  167.800547] pci_scan_child_bus: pci_bus 0000:01: bus scan returning with max=02
[  167.800552] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 0
[  167.800556] pci_scan_child_bus: pci_bus 0000:03: scanning bus
[  167.800584] pci_scan_child_bus: pci_bus 0000:03: bus scan returning with max=03
[  167.800589] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 0
[  167.800593] pci_scan_child_bus: pci_bus 0000:04: scanning bus
[  167.800618] pci_scan_child_bus: pci_bus 0000:04: bus scan returning with max=04
[  167.800623] pci_scan_bridge: pcieport 0000:00:08.0: scanning [bus 05-05] behind bridge, pass 0
[  167.800627] pci_scan_child_bus: pci_bus 0000:05: scanning bus
[  167.800631] pci_scan_child_bus: pci_bus 0000:05: bus scan returning with max=05
[  167.800635] pci_scan_bridge: pcieport 0000:00:09.0: scanning [bus 06-06] behind bridge, pass 0
[  167.800640] pci_scan_child_bus: pci_bus 0000:06: scanning bus
[  167.800643] pci_scan_child_bus: pci_bus 0000:06: bus scan returning with max=06
[  167.800648] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 08-08] behind bridge, pass 0
[  167.800652] pci_scan_child_bus: pci_bus 0000:08: scanning bus
[  167.800656] pci_scan_child_bus: pci_bus 0000:08: bus scan returning with max=08
[  167.800660] pci_scan_bridge: pcieport 0000:00:0a.0: scanning [bus 07-07] behind bridge, pass 0
[  167.800664] pci_scan_child_bus: pci_bus 0000:07: scanning bus
[  167.800668] pci_scan_child_bus: pci_bus 0000:07: bus scan returning with max=07
[  167.800673] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 1
[  167.800678] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 1
[  167.800683] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 1
[  167.800689] pci_scan_bridge: pcieport 0000:00:08.0: scanning [bus 05-05] behind bridge, pass 1
[  167.800693] pci_scan_bridge: pcieport 0000:00:09.0: scanning [bus 06-06] behind bridge, pass 1
[  167.800698] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 08-08] behind bridge, pass 1
[  167.800704] pci_scan_bridge: pcieport 0000:00:0a.0: scanning [bus 07-07] behind bridge, pass 1
[  167.800708] pci_scan_child_bus: pci_bus 0000:00: bus scan returning with max=08
[  167.800752] pci 0000:01:0d.0: PCI bridge to [bus 02]
[  167.800762] pci 0000:00:06.0: PCI bridge to [bus 03]

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
           +-08.0-[05]--
           +-09.0-[06]--
           +-0a.0-[07]----00.0  LSI Logic / Symbios Logic FC949ES Fibre Channel Adapter
           +-0b.0-[08]--
           +-0c.0  Advanced Micro Devices, Inc. [AMD/ATI] ES1000
           +-18.0  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
           +-18.1  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Address Map
           +-18.2  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] DRAM Controller
           +-18.3  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
           +-19.0  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
           +-19.1  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Address Map
           +-19.2  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] DRAM Controller
           \-19.3  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
