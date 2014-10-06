Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaJFHrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 03:47:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37724 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaJFHru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 03:47:50 -0400
Message-ID: <54324922.906@gmail.com>
Date: Mon, 06 Oct 2014 09:47:46 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
To: Benoit Masson <benoitm@perenite.com>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benoit Masson <yahoo@perenite.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] Armada XP pinctrl consolidation and ix4-300d fixes
References: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com> <-7443282711873112734@unknownmsgid> <20141003141102.GJ3895@titan.lakedaemon.net> <542EBB93.108@gmail.com> <A9781A2E-F3CA-4E8A-833C-D167B456D9F7@perenite.com> <542EC3A3.1060605@gmail.com> <1ACB5318-863E-40D8-8B27-41F1C0D0A4B8@perenite.com>
In-Reply-To: <1ACB5318-863E-40D8-8B27-41F1C0D0A4B8@perenite.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.10.2014 01:11, Benoit Masson wrote:
> > Le 3 oct. 2014 à 17:41, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> a écrit :
>> On 10/03/2014 05:29 PM, Benoit Masson wrote:
>>> Le 3 oct. 2014 à 17:06, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> a écrit :
>>>> On 10/03/2014 04:11 PM, Jason Cooper wrote:
>>>>> On Sun, Sep 21, 2014 at 04:11:23PM +0200, Benoit Masson wrote:
>>>>>>> Le 19 sept. 2014 à 22:14, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> a écrit :
>> [...]
>>>>>>> Patches are based on v3.17-rc1 and intended for v3.18 but I am not in
>>>>>>> a hurry. I only compile tested this, so a formal Tested-by from Benoit
>>>>>>> for the ix4 and any other Armada XP board would be great.
[...]
>>>>> Did you ever get a chance to test this series?
>>>>
>>>> Uhm, I never prepared a branch for Benoit to test. I have pushed the
>>>> patches with Thomas Acked-by's and renamed eeprom node based on
>>>> v3.17-rc1 to
>>>>
>>>> https://github.com/shesselba/linux-dove.git devel/mvebu-ix4
>>>>
[...]
>> It is too late for v3.18 anyway, so I'll resend them once v3.18-rc1
>> drops.
>>
>>> I'll test those over Sunday night.
>
> No so great, so far what I've done:
>   - use my working config this config has worked over mainline 3.16 for weeks
>   - compil you branch with it using you dts file
>   - boot KO it get stuck on i2C pcf8563 init (at least it is the last message dsplayed.
>
> then I turn on DEBUG_LL but I get nothing more on the serial that could help
>
>   - I've tried removing the eeprom section you added to the dts -> same results
>
> Maybe I missed something ? is this branch you sent me a bare fork from mainline 3.17 ? does it includes the armada XP step A0 patch ?

Benoit,

the branch is straight forked from v3.17-rc1 with the patches in
question added. If there is any fixes that got in after rc1, they
are not included. I'll rebase the series on latest next tonight.

Anyway, I doubt the series is involved in the regression you see,
can you also boot plain v3.17-rc1 and v3.17 which got just released?

Also, DEBUG_LL will not give you any more information on this one,
as you passed serial console hand-off. You only need it for early
debugging and you have to make sure that (a) you select the correct
DEBUG_LL Kconfig for MVEBU with registers located at 0xd0000000 and
(b) you should always double check the phys/virt addresses of the
early console.

> dump of the serial output:
> Uncompressing Linux... done, booting the kernel.
> Booting Linux on physical CPU 0x0
> Linux version 3.17.0-rc1-42264-gb065757 (benoitm@aaaa) (gcc version 4.6.3 (Debian 4.6.3-14) ) #3 SMP Mon Oct 6 00:42:59 CEST 2014
> CPU: ARMv7 Processor [562f5842] revision 2 (ARMv7), cr=10c5387d
> CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
> Machine model: Lenovo Iomega ix4-300d
> Memory policy: Data cache writealloc
> PERCPU: Embedded 7 pages/cpu @dfbd9000 s6784 r8192 d13696 u32768
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130048
> Kernel command line: console=ttyS0,115200 earlyprintk=ttyS0,115200 root=/dev/md0 rw mem=512M

/dev/md0 is soft-RAID on your harddisks, isn't it?
Also, you should not need the mem= parameter but that is just a nit.

[...]
> NR_IRQS:16 nr_irqs:16 16
> L2C: device tree omits to specify unified cache

Jason, Thomas, Gregory,

we should add a "cache-unified" to the l2cc nodes for all SoCs.

> L2C: DT/platform modifies aux control register: 0x1a696b10 -> 0x1a696b12
> Aurora cache controller enabled, 16 ways, 1024 kB
> Aurora: CACHE_ID 0x00000100, AUX_CTRL 0x1a696b12
> sched_clock: 32 bits at 25MHz, resolution 40ns, wraps every 171798691800ns
[...]
> Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> console [ttyS0] disabled
> d0012000.serial: ttyS0 at MMIO 0xd0012000 (irq = 19, base_baud = 15625000) is a 16550A
> console [ttyS0] enabled

Here is the serial console hand-off, i.e. if you get this far, you
don't need DEBUG_LL at all.

> zram: Created 1 device(s) ...
> pci 0000:00:01.0: enabling device (0140 -> 0143)
> sata_mv 0000:01:00.0: Gen-IIE 32 slots 4 ports SCSI mode IRQ via INTx
> scsi host0: sata_mv
> scsi host1: sata_mv
> scsi host2: sata_mv
> scsi host3: sata_mv
> ata1: SATA max UDMA/133 mmio m1048576@0xf8000000 port 0xf8022000 irq 86
> ata2: SATA max UDMA/133 mmio m1048576@0xf8000000 port 0xf8024000 irq 86
> ata3: SATA max UDMA/133 mmio m1048576@0xf8000000 port 0xf8026000 irq 86
> ata4: SATA max UDMA/133 mmio m1048576@0xf8000000 port 0xf8028000 irq 86

Shouldn't it detect your hard-disks attached here?

Sebastian

> pxa3xx-nand d00d0000.nand: This platform can't do DMA on this device
> nand: device found, Manufacturer ID: 0xec, Chip ID: 0xd3
> nand: Samsung NAND 1GiB 3,3V 8-bit
> nand: 1024MiB, SLC, page size: 2048, OOB size: 64
> pxa3xx-nand d00d0000.nand: ECC strength 1, ECC step size 512
> Bad block table found at page 524224, version 0x01
> Bad block table found at page 524160, version 0x01
> nand_read_bbt: bad block at 0x00003ca60000
> 7 ofpart partitions found on MTD device pxa3xx_nand-0
> Creating 7 MTD partitions on "pxa3xx_nand-0":
> 0x000000000000-0x0000000e0000 : "u-boot"
> 0x0000000e0000-0x000000100000 : "u-boot-env"
> 0x000000100000-0x000000120000 : "u-boot-env2"
> 0x000000120000-0x000000520000 : "zImage"
> 0x000000520000-0x000000920000 : "initrd"
> 0x000000e00000-0x000040000000 : "boot"
> 0x000000000000-0x000040000000 : "flash"
> spi_gpio spi3: gpio-miso property not found, switching to no-rx mode
> libphy: orion_mdio_bus: probed
> mvneta d0070000.ethernet eth0: Using hardware mac address 00:d0:b8:25:38:4d
> mvneta d0074000.ethernet eth1: Using random mac address 12:93:5b:2b:44:6e
> ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> ehci-pci: EHCI PCI platform driver
> ehci-orion: EHCI orion driver
> orion-ehci d0050000.usb: EHCI Host Controller
> orion-ehci d0050000.usb: new USB bus registered, assigned bus number 1
> orion-ehci d0050000.usb: irq 25, io mem 0xd0050000
> orion-ehci d0050000.usb: USB 2.0 started, EHCI 1.00
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 1 port detected
> orion-ehci d0051000.usb: EHCI Host Controller
> orion-ehci d0051000.usb: new USB bus registered, assigned bus number 2
> orion-ehci d0051000.usb: irq 26, io mem 0xd0051000
> orion-ehci d0051000.usb: USB 2.0 started, EHCI 1.00
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 1 port detected
> xhci_hcd 0000:02:00.0: xHCI Host Controller
> xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 3
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 2 ports detected
> xhci_hcd 0000:02:00.0: xHCI Host Controller
> xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 4
> hub 4-0:1.0: USB hub found
> hub 4-0:1.0: 2 ports detected
> usbcore: registered new interface driver usb-storage
> rtc-mv d0010300.rtc: rtc core: registered d0010300.rtc as rtc0
> i2c /dev entries driver
> rtc-pcf8563 0-0051: chip found, driver version 0.4.3


