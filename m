Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaD2CCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 22:02:40 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:13400
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751096AbaD2CCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 22:02:38 -0400
X-Greylist: delayed 10891 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Apr 2014 22:02:38 EDT
X-WSS-ID: 0N4RSC6-08-HAA-02
X-M-MSG: 
Message-ID: <535F0837.2020102@amd.com>
Date: Mon, 28 Apr 2014 21:02:31 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Daniel J Blueman <daniel@numascale.com>,
        Myron Stowe <myron.stowe@gmail.com>, Borislav Petkov <bp@suse.de>
CC: Myron Stowe <myron.stowe@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        <kim.naru@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        <mingo@redhat.com>, <hpa@zytor.com>, x86 <x86@kernel.org>,
        <sp@numascale.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] PCI: Remove redundant 'quirk_amd_nb_node'
References: <20140419025308.2408.51252.stgit@amt.stowe>
	<20140419025345.2408.99229.stgit@amt.stowe>	<20140420105419.GB19676@pd.tnic>
 <CAL-B5D1_fns=mu7Cw6jeVHO0XPeKYakUrPv-JgO=ma1rjCoQvg@mail.gmail.com>
 <53554D27.1010803@numascale.com>
In-Reply-To: <53554D27.1010803@numascale.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(979002)(6009001)(428001)(189002)(199002)(51914003)(24454002)(377454003)(479174003)(51704005)(69234005)(164054003)(85852003)(2009001)(92566001)(65816999)(76482001)(74502001)(76176999)(46102001)(65806001)(31966008)(97736001)(84676001)(86362001)(4396001)(87936001)(74662001)(54356999)(99396002)(33656001)(87266999)(77096999)(19580405001)(92726001)(64126003)(50986999)(83072002)(44976005)(77982001)(83322001)(101416001)(19580395003)(65956001)(36756003)(47776003)(80316001)(79102001)(59896001)(23676002)(80022001)(50466002)(20776003)(81542001)(83506001)(80976001)(81342001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR02MB122;H:atltwp02.amd.com;FPR:AC19F019.83D2D851.F5D10573.47E6FA38.205F4;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0196A226D1
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/21/2014 11:53 AM, Daniel J Blueman wrote:
> Hi Myron,
>
> On 04/20/2014 09:44 PM, Myron Stowe wrote:
>> On Sun, Apr 20, 2014 at 4:54 AM, Borislav Petkov <bp@suse.de> wrote:
>>> On Fri, Apr 18, 2014 at 08:53:46PM -0600, Myron Stowe wrote:
>>>> With the amd_bus.c updates to support additional AMD processors
>>>> (11h, 12h,
>>>> 14h 15h  and 16h) 'quirk_amd_nb_node' seems to be redundant.  This
>>>> patch
>>>> removes it.
>>>>
>>>> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
>>>
>>> Good idea. Has this been tested, though? There are a bunch of places
>>> using dev_to_node() which this quirk corrects, especially 'local_cpus'
>>> in a bunch of sysfs nodes in the PCI hierarchy /sys/devices/pci*.
>>
>> Borislav:
>>
>> Thanks for the review, suggestions, and comments.
>>
>> Just and FYI - I'll be gone until late in this coming week on a
>> backpacking trip in remote Utah.  I'll work your suggestions when I
>> get back.
>>
>> With respect to this patch and testing.  Yes, I did test and it worked
>> for my situation.  I would like to hear from Daniel as I'm not exactly
>> sure what his last change was specific to.
>>
>> Daniel: with the previous patches in this series applied do you still
>> need this quirk for your situation?
>
> It's fine enough for us, since we'll always emit a PXM method for any
> PCI host bridges (but roots), which gets correctly preserved with your
> patches [1]. I don't have reason to suspect northbridges at bus 0,
> devices 0x19 and later in each PCI domain having the wrong NUMA node is
> going to cause any issues.
>
> We could improve things by changing probe_pci_hostbridge to iterate all
> PCI bus domains, but it's probably not a big deal to bail with one
> warning, as we currently see multiple (which would become a lot on most
> of our systems):
>
> [    3.155974] AMD-Bus: TOM: 00000000d8000000 aka 3456M
> [    3.160003]
> [    3.161496] AMD-Bus: WARNING: Failed to find root info for node 0x4,
> link 0x0
> [    3.168625]
> [    3.170002]
> [    3.171492] AMD-Bus: WARNING: Failed to find root info for node 0x4,
> link 0x0
> [    3.178614] AMD-Bus: WARNING: Failed to find root info for node 0x4,
> link 0x0
> [    3.180003] AMD-Bus: TOM2: 0000001900000000 aka 102400M
>
> Thanks,
>    Daniel
>
> -- [1] (two server NumaConnect system)
>
> # lspci
> 0000:00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890
> Northbridge only dual slot (2x16) PCI-e GFX Hydra part (rev 02)
> 0000:00:0d.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890
> PCI to PCI bridge (external gfx1 port B)
> 0000:00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI]
> SB7x0/SB8x0/SB9x0 SATA Controller [IDE mode]
> 0000:00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
> SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
> 0000:00:12.1 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
> SB7x0 USB OHCI1 Controller
> 0000:00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
> SB7x0/SB8x0/SB9x0 USB EHCI Controller
> 0000:00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
> SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
> 0000:00:13.1 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
> SB7x0 USB OHCI1 Controller
> 0000:00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
> SB7x0/SB8x0/SB9x0 USB EHCI Controller
> 0000:00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus
> Controller (rev 3d)
> 0000:00:14.1 IDE interface: Advanced Micro Devices, Inc. [AMD/ATI]
> SB7x0/SB8x0/SB9x0 IDE Controller
> 0000:00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD/ATI]
> SB7x0/SB8x0/SB9x0 LPC host controller
> 0000:00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00
> PCI to PCI Bridge
> 0000:00:14.5 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
> SB7x0/SB8x0/SB9x0 USB OHCI2 Controller
> 0000:00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 0
> 0000:00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 1
> 0000:00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 2
> 0000:00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 3
> 0000:00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 4
> 0000:00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 5
> 0000:00:19.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 0
> 0000:00:19.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 1
> 0000:00:19.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 2
> 0000:00:19.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 3
> 0000:00:19.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 4
> 0000:00:19.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 5
> 0000:00:1a.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 0
> 0000:00:1a.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 1
> 0000:00:1a.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 2
> 0000:00:1a.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 3
> 0000:00:1a.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 4
> 0000:00:1a.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 5
> 0000:00:1b.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 0
> 0000:00:1b.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 1
> 0000:00:1b.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 2
> 0000:00:1b.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 3
> 0000:00:1b.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 4
> 0000:00:1b.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 5
> 0000:00:1c.0 Host bridge: Numascale AS NumaChip N601 (rev 02)
> 0000:00:1c.1 Host bridge: Numascale AS NumaChip N602 (rev 02)
> 0000:01:04.0 VGA compatible controller: Matrox Electronics Systems Ltd.
> MGA G200eW WPCM450 (rev 0a)
> 0000:02:00.0 Ethernet controller: Intel Corporation 82576 Gigabit
> Network Connection (rev 01)
> 0000:02:00.1 Ethernet controller: Intel Corporation 82576 Gigabit
> Network Connection (rev 01)
> 0001:00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890
> Northbridge only dual slot (2x16) PCI-e GFX Hydra part (rev 02)
> 0001:00:0d.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890
> PCI to PCI bridge (external gfx1 port B)
> 0001:00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI]
> SB7x0/SB8x0/SB9x0 SATA Controller [IDE mode]
> 0001:00:14.0 ISA bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00
> SMBus Controller (rev 3d)
> 0001:00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00
> PCI to PCI Bridge
> 0001:00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 0
> 0001:00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 1
> 0001:00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 2
> 0001:00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 3
> 0001:00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 4
> 0001:00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 5
> 0001:00:19.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 0
> 0001:00:19.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 1
> 0001:00:19.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 2
> 0001:00:19.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 3
> 0001:00:19.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 4
> 0001:00:19.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 5
> 0001:00:1a.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 0
> 0001:00:1a.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 1
> 0001:00:1a.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 2
> 0001:00:1a.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 3
> 0001:00:1a.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 4
> 0001:00:1a.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 5
> 0001:00:1b.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 0
> 0001:00:1b.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 1
> 0001:00:1b.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 2
> 0001:00:1b.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 3
> 0001:00:1b.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 4
> 0001:00:1b.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
> Processor Function 5
> 0001:00:1c.0 Host bridge: Numascale AS NumaChip N601 (rev 02)
> 0001:00:1c.1 Host bridge: Numascale AS NumaChip N602 (rev 02)
> 0001:02:00.0 Ethernet controller: Intel Corporation 82576 Gigabit
> Network Connection (rev 01)
> 0001:02:00.1 Ethernet controller: Intel Corporation 82576 Gigabit
> Network Connection (rev 01)
>
> # find /sys/devices/pci* -name numa_node -print -exec cat {} \;
> /sys/devices/pci0000:00/0000:00:00.0/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:11.0/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:12.0/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:12.1/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:12.2/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:13.0/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:13.1/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:13.2/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:14.0/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:14.1/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:14.3/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:14.4/0000:01:04.0/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:14.4/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:14.5/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:18.0/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:18.1/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:18.2/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:18.3/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:18.4/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:18.5/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:19.0/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:19.1/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:19.2/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:19.3/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:19.4/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:19.5/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:0d.0/0000:02:00.0/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:0d.0/0000:02:00.1/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:0d.0/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:1a.0/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:1a.1/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:1a.2/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:1a.3/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:1a.4/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:1a.5/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:1b.0/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:1b.1/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:1b.2/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:1b.3/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:1b.4/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:1b.5/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:1c.0/numa_node
> 0
> /sys/devices/pci0000:00/0000:00:1c.1/numa_node
> 0
> /sys/devices/pci0001:00/0001:00:00.0/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:11.0/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:14.0/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:14.4/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:18.0/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:18.1/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:18.2/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:18.3/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:18.4/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:18.5/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:19.0/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:19.1/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:19.2/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:19.3/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:19.4/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:19.5/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:0d.0/0001:02:00.0/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:0d.0/0001:02:00.1/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:0d.0/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:1a.0/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:1a.1/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:1a.2/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:1a.3/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:1a.4/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:1a.5/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:1b.0/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:1b.1/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:1b.2/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:1b.3/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:1b.4/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:1b.5/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:1c.0/numa_node
> 4
> /sys/devices/pci0001:00/0001:00:1c.1/numa_node
> 4

Sorry for late reply.  My concern is that removing the 
"quirk_amd_nb_node()" will affect the value of "numa_node" of the host 
bridge devices (i.e. X:00.[18|19|1a|1b|1c|1d|1e|1f].X).  I am not sure 
if any code is using this information.  But in theory, these host-bridge 
devices are not on the same node as where the PCI root complex lives 
(e.g. 0 and 4 from the example above).

If we want the "numa_node" to really representing the actual node, then 
the quirk has to stay for now.  We might need to come up with a 
different logic to replace the quirks here, which would automatically 
determine the actual node value for these host-bridge devices.

Suravee

Suravee

