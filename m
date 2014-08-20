Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaHTMNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:13:45 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:44242 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbaHTMNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:13:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140818184933.GA2028@google.com>
References: <1406131381-25577-1-git-send-email-sthokal@xilinx.com>
	<CA+mB=1JhDF=BBXcyTbgVB8S7qH=Mb1JH78HLL4pA9OBH19hQvA@mail.gmail.com>
	<8258903.Rn4s07GKGV@wuerfel>
	<CA+mB=1LeZn1k2VHNby2TRBcb1xuFFTQio=C845_xe2A=ZciYqg@mail.gmail.com>
	<53E9E052.3070308@monstr.eu>
	<CA+mB=1LX=yOqkx1xNoCBQLbYna76qAeRTqiW6SDpb1MYco7ZVQ@mail.gmail.com>
	<20140818184933.GA2028@google.com>
Date: Wed, 20 Aug 2014 17:43:39 +0530
X-Google-Sender-Auth: hWcUqFSPIbziEyxQCYXCc-EYveg
Message-ID: <CA+mB=1+vy-9bM6gOBekU4V4id187gjstXq5frOQFjRqnAig4JQ@mail.gmail.com>
Subject: Re: [PATCH v5] pcie: Add Xilinx PCIe Host Bridge IP driver
From: Srikanth Thokala <sthokal@xilinx.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Srikanth Thokala <sthokal@xilinx.com>, Michal Simek <monstr@monstr.eu>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        svemula@xilinx.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>, anirudh@xilinx.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On Tue, Aug 19, 2014 at 12:19 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Mon, Aug 18, 2014 at 02:47:23PM +0530, Srikanth Thokala wrote:
>> Hi Michal,
>>
>> On Tue, Aug 12, 2014 at 3:07 PM, Michal Simek <monstr@monstr.eu> wrote:
>> > Hi Bjorn,
>> >
>> > On 07/30/2014 01:24 PM, Srikanth Thokala wrote:
>> >> Hi Arnd,
>> >>
>> >> On Mon, Jul 28, 2014 at 6:32 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> >>> On Monday 28 July 2014 18:04:34 Srikanth Thokala wrote:
>> >>>> Hi Arnd and Rob,
>> >>>>
>> >>>> I discussed with Bjorn and we believe this patch is in good shape to
>> >>>> apply.  And Bjorn requires ACKs to apply this patch.  So, could you
>> >>>> guys please review this patch and provided your ACKs to this patch.
>> >>>
>> >>> Looks great for the most part. I've looked through the whole driver
>> >>> again, and I have two small issues remaining:
>> >>>
>> >>> a) Please clarify in the changeset description why there is no support
>> >>>    for PCI I/O space.
>> >>
>> >> Sure, I will add to my changeset.
>> >>
>> >>>
>> >>> b) I think you should use the 'msi-parent' property, and the
>> >>>    of_pci_find_msi_chip_by_node() to find the msi_chip for the
>> >>>    PCI controller. This will make it possible to forward MSIs
>> >>>    to the main interrupt controller in the system, which is more
>> >>>    efficient. See the pcie-mvebu driver for an example of this.
>> >>
>> >> Ok, I need to look into this and I will plan to implement on top of this patch.
>> >>
>> >>>
>> >>> Other than these:
>> >>>
>> >>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>> >>
>> >> Thanks Arnd for the Ack.
>> >
>> > What's the status on this one?
>>
>> It looks like Bjorn is on vacation.  I have sent v6 patch by adding
>> Ack from Arnd, which
>> I feel is in good shape to be applied.
>
> I actually started applying this last night (see [1]), but got some
> errors from the build-bot (attached).  I haven't looked into them,
> but my guess is that you're missing a Kconfig dependency or something
> equally minor.

These are due to the same config flag name (CONFIG_PCI_XILINX) being used
for Microblaze and Zynq platforms.  I will fix it and send you next
version of patch.

Thanks,
Srikanth

>
> Bjorn
>
> [1] http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/commit/?h=pci/host-xilinx&id=a58f3d0c3b1c4a71a2418c3306fba86c26a49781
>
>
> ---------- Forwarded message ----------
> From: kbuild test robot <fengguang.wu@intel.com>
> To: Bjorn Helgaas <bhelgaas@google.com>
> Cc:
> Date: Mon, 18 Aug 2014 12:40:06 +0800
> Subject: [pci:pci/host-xilinx] a58f3d0c3b1c4a71a2418c3306fba86c26a49781 BUILD DONE
> git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git  pci/host-xilinx
> a58f3d0c3b1c4a71a2418c3306fba86c26a49781  PCI: xilinx: Add Xilinx PCIe Host Bridge IP driver
>
> drivers/pci/host/pci-xilinx.c:470:21: error: 'IRQF_VALID' undeclared (first use in this function)
> drivers/pci/host/pci-xilinx.c:742:14: error: dereferencing pointer to incomplete type
> drivers/pci/host/pci-xilinx.c:939:2: error: implicit declaration of function 'pci_common_init_dev' [-Werror=implicit-function-declaration]
> drivers/pci/host/pci-xilinx.c:417:2: error: implicit declaration of function 'set_irq_flags' [-Werror=implicit-function-declaration]
> drivers/pci/host/pci-xilinx.c:938:2: error: invalid use of undefined type 'struct hw_pci'
> drivers/pci/host/pci-xilinx.c:888:16: error: storage size of 'hw' isn't known
> drivers/pci/host/pci-xilinx.c:935:3: error: unknown field 'add_bus' specified in initializer
> drivers/pci/host/pci-xilinx.c:934:3: error: unknown field 'map_irq' specified in initializer
> drivers/pci/host/pci-xilinx.c:931:3: error: unknown field 'nr_controllers' specified in initializer
> drivers/pci/host/pci-xilinx.c:937:3: error: unknown field 'ops' specified in initializer
> drivers/pci/host/pci-xilinx.c:932:3: error: unknown field 'private_data' specified in initializer
> drivers/pci/host/pci-xilinx.c:936:3: error: unknown field 'scan' specified in initializer
> drivers/pci/host/pci-xilinx.c:933:3: error: unknown field 'setup' specified in initializer
> drivers/pci/host/pci-xilinx.c:937:3: warning: (near initialization for '(anonymous)')
> drivers/pci/host/pci-xilinx.c:937:3: warning: excess elements in struct initializer
> drivers/pci/host/pci-xilinx.c:124:59: warning: its scope is only this definition or declaration, which is probably not what you want
> drivers/pci/host/pci-xilinx.c:737:34: warning: passing argument 1 of 'sys_to_pcie' from incompatible pointer type
> drivers/pci/host/pci-xilinx.c:735:17: warning: 'struct pci_sys_data' declared inside parameter list
>
> elapsed time: 25m
>
> configs tested: 112
>
> parisc                        c3000_defconfig
> parisc                         b180_defconfig
> parisc                              defconfig
> alpha                               defconfig
> parisc                            allnoconfig
> i386                              allnoconfig
> i386                                defconfig
> i386                             allmodconfig
> i386                             alldefconfig
> sh                            titan_defconfig
> sh                          rsk7269_defconfig
> sh                  sh7785lcr_32bit_defconfig
> sh                                allnoconfig
> x86_64                     randconfig-c3-0818
> x86_64                     randconfig-c1-0818
> x86_64                     randconfig-c0-0818
> x86_64                     randconfig-c2-0818
> ia64                             allmodconfig
> ia64                              allnoconfig
> ia64                                defconfig
> ia64                             alldefconfig
> x86_64                                    lkp
> x86_64                                   rhel
> powerpc                      chroma_defconfig
> powerpc                 linkstation_defconfig
> powerpc                               powerpc
> powerpc                         wii_defconfig
> powerpc                    gamecube_defconfig
> powerpc               corenet64_smp_defconfig
> powerpc                               mpc512x
> powerpc                                ppc44x
> x86_64                     randconfig-j0-0818
> x86_64                     randconfig-j1-0818
> i386                      randconfig-ha2-0818
> i386                      randconfig-ha5-0818
> i386                      randconfig-ha4-0818
> i386                      randconfig-ha3-0818
> i386                      randconfig-ha0-0818
> i386                      randconfig-ha1-0818
> sparc                               defconfig
> sparc64                           allnoconfig
> sparc64                             defconfig
> x86_64                           allmodconfig
> xtensa                       common_defconfig
> m32r                       m32104ut_defconfig
> xtensa                          iss_defconfig
> m32r                         opsput_defconfig
> m32r                           usrv_defconfig
> m32r                     mappi3.smp_defconfig
> i386                          randconfig-i002
> i386                          randconfig-i003
> i386                          randconfig-i000
> i386                          randconfig-i001
> i386                          randconfig-i006
> i386                          randconfig-i007
> i386                          randconfig-i004
> i386                          randconfig-i005
> i386                          randconfig-i008
> i386                          randconfig-i009
> x86_64                        randconfig-i009
> x86_64                        randconfig-i008
> x86_64                        randconfig-i003
> x86_64                        randconfig-i002
> x86_64                        randconfig-i001
> x86_64                        randconfig-i000
> x86_64                        randconfig-i007
> x86_64                        randconfig-i006
> x86_64                        randconfig-i005
> x86_64                        randconfig-i004
> microblaze                      mmu_defconfig
> microblaze                    nommu_defconfig
> i386                             allyesconfig
> cris                 etrax-100lx_v2_defconfig
> blackfin                  TCM-BF537_defconfig
> blackfin            BF561-EZKIT-SMP_defconfig
> blackfin                BF533-EZKIT_defconfig
> blackfin                BF526-EZBRD_defconfig
> i386                       randconfig-r2-0818
> i386                       randconfig-r1-0818
> i386                       randconfig-r0-0818
> i386                       randconfig-r3-0818
> mn10300                     asb2364_defconfig
> openrisc                    or1ksim_defconfig
> um                           x86_64_defconfig
> um                             i386_defconfig
> avr32                      atngw100_defconfig
> frv                                 defconfig
> avr32                     atstk1006_defconfig
> tile                         tilegx_defconfig
> x86_64                   randconfig-x004-0817
> i386                     randconfig-x000-0817
> x86_64                   randconfig-x007-0817
> i386                     randconfig-x001-0817
> i386                     randconfig-x002-0817
> i386                     randconfig-x005-0817
> i386                     randconfig-x007-0817
> x86_64                   randconfig-x003-0817
> i386                     randconfig-x003-0817
> x86_64                   randconfig-x008-0817
> i386                     randconfig-x006-0817
> x86_64                   randconfig-x000-0817
> i386                     randconfig-x004-0817
> x86_64                   randconfig-x002-0817
> i386                     randconfig-x008-0817
> i386                     randconfig-x009-0817
> x86_64                   randconfig-x006-0817
> x86_64                   randconfig-x009-0817
> x86_64                   randconfig-x005-0817
> x86_64                   randconfig-x001-0817
> x86_64                             acpi-redef
> x86_64                           allyesdebian
> x86_64                                nfsroot
>
> Thanks,
> Fengguang
>
>
> ---------- Forwarded message ----------
> From: kbuild test robot <fengguang.wu@intel.com>
> To: Srikanth Thokala <sthokal@xilinx.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>, kbuild-all@01.org
> Date: Mon, 18 Aug 2014 15:16:51 +0800
> Subject: [pci:pci/host-xilinx 1/1] WARNING: drivers/built-in.o(.text+0x64acc): Section mismatch in reference from the function xilinx_pcie_probe() to the function .init.text:xilinx_pcie_scan_bus()
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci/host-xilinx
> head:   a58f3d0c3b1c4a71a2418c3306fba86c26a49781
> commit: a58f3d0c3b1c4a71a2418c3306fba86c26a49781 [1/1] PCI: xilinx: Add Xilinx PCIe Host Bridge IP driver
> config: make ARCH=arm allmodconfig
>
> All warnings:
>
>>> WARNING: drivers/built-in.o(.text+0x64acc): Section mismatch in reference from the function xilinx_pcie_probe() to the function .init.text:xilinx_pcie_scan_bus()
>    The function xilinx_pcie_probe() references
>    the function __init xilinx_pcie_scan_bus().
>    This is often because xilinx_pcie_probe lacks a __init
>    annotation or the annotation of xilinx_pcie_scan_bus is wrong.
>
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
>
