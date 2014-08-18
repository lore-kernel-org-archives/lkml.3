Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaHRStq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:49:46 -0400
Received: from mail-yk0-f182.google.com ([209.85.160.182]:39190 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaHRStn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:49:43 -0400
Date: Mon, 18 Aug 2014 12:49:33 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Srikanth Thokala <sthokal@xilinx.com>
Cc: monstr@monstr.eu, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        svemula@xilinx.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>, anirudh@xilinx.com
Subject: Re: [PATCH v5] pcie: Add Xilinx PCIe Host Bridge IP driver
Message-ID: <20140818184933.GA2028@google.com>
References: <1406131381-25577-1-git-send-email-sthokal@xilinx.com>
 <CA+mB=1JhDF=BBXcyTbgVB8S7qH=Mb1JH78HLL4pA9OBH19hQvA@mail.gmail.com>
 <8258903.Rn4s07GKGV@wuerfel>
 <CA+mB=1LeZn1k2VHNby2TRBcb1xuFFTQio=C845_xe2A=ZciYqg@mail.gmail.com>
 <53E9E052.3070308@monstr.eu>
 <CA+mB=1LX=yOqkx1xNoCBQLbYna76qAeRTqiW6SDpb1MYco7ZVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <CA+mB=1LX=yOqkx1xNoCBQLbYna76qAeRTqiW6SDpb1MYco7ZVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 18, 2014 at 02:47:23PM +0530, Srikanth Thokala wrote:
> Hi Michal,
> 
> On Tue, Aug 12, 2014 at 3:07 PM, Michal Simek <monstr@monstr.eu> wrote:
> > Hi Bjorn,
> >
> > On 07/30/2014 01:24 PM, Srikanth Thokala wrote:
> >> Hi Arnd,
> >>
> >> On Mon, Jul 28, 2014 at 6:32 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >>> On Monday 28 July 2014 18:04:34 Srikanth Thokala wrote:
> >>>> Hi Arnd and Rob,
> >>>>
> >>>> I discussed with Bjorn and we believe this patch is in good shape to
> >>>> apply.  And Bjorn requires ACKs to apply this patch.  So, could you
> >>>> guys please review this patch and provided your ACKs to this patch.
> >>>
> >>> Looks great for the most part. I've looked through the whole driver
> >>> again, and I have two small issues remaining:
> >>>
> >>> a) Please clarify in the changeset description why there is no support
> >>>    for PCI I/O space.
> >>
> >> Sure, I will add to my changeset.
> >>
> >>>
> >>> b) I think you should use the 'msi-parent' property, and the
> >>>    of_pci_find_msi_chip_by_node() to find the msi_chip for the
> >>>    PCI controller. This will make it possible to forward MSIs
> >>>    to the main interrupt controller in the system, which is more
> >>>    efficient. See the pcie-mvebu driver for an example of this.
> >>
> >> Ok, I need to look into this and I will plan to implement on top of this patch.
> >>
> >>>
> >>> Other than these:
> >>>
> >>> Acked-by: Arnd Bergmann <arnd@arndb.de>
> >>
> >> Thanks Arnd for the Ack.
> >
> > What's the status on this one?
> 
> It looks like Bjorn is on vacation.  I have sent v6 patch by adding
> Ack from Arnd, which
> I feel is in good shape to be applied.

I actually started applying this last night (see [1]), but got some
errors from the build-bot (attached).  I haven't looked into them,
but my guess is that you're missing a Kconfig dependency or something
equally minor.

Bjorn

[1] http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/commit/?h=pci/host-xilinx&id=a58f3d0c3b1c4a71a2418c3306fba86c26a49781

--T4sUOijqQbZv57TR
Content-Type: message/rfc822
Content-Disposition: inline

Delivered-To: bhelgaas@google.com
Received: by 10.229.161.5 with SMTP id p5csp580441qcx;
        Sun, 17 Aug 2014 21:40:33 -0700 (PDT)
X-Received: by 10.70.37.227 with SMTP id b3mr8521685pdk.147.1408336833389;
        Sun, 17 Aug 2014 21:40:33 -0700 (PDT)
Return-Path: <fengguang.wu@intel.com>
Received: from mga14.intel.com (mga14.intel.com. [192.55.52.115])
        by mx.google.com with ESMTP id w7si19799205pdr.166.2014.08.17.21.40.32
        for <bhelgaas@google.com>;
        Sun, 17 Aug 2014 21:40:33 -0700 (PDT)
Received-SPF: pass (google.com: domain of fengguang.wu@intel.com designates 192.55.52.115 as permitted sender) client-ip=192.55.52.115;
Authentication-Results: mx.google.com;
       spf=pass (google.com: domain of fengguang.wu@intel.com designates 192.55.52.115 as permitted sender) smtp.mail=fengguang.wu@intel.com
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP; 17 Aug 2014 21:32:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="373597622"
Received: from bee.sh.intel.com (HELO bee) ([10.239.97.14])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Aug 2014 21:36:52 -0700
Received: from kbuild by bee with local (Exim 4.83)
	(envelope-from <fengguang.wu@intel.com>)
	id 1XJEk9-000VIw-B9; Mon, 18 Aug 2014 12:40:29 +0800
Date: Mon, 18 Aug 2014 12:40:06 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Subject: [pci:pci/host-xilinx] a58f3d0c3b1c4a71a2418c3306fba86c26a49781
 BUILD DONE
Message-ID: <53f183a6.uPY/9YHScmTEjb1x%fengguang.wu@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false

git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git  pci/host-xilinx
a58f3d0c3b1c4a71a2418c3306fba86c26a49781  PCI: xilinx: Add Xilinx PCIe Host Bridge IP driver

drivers/pci/host/pci-xilinx.c:470:21: error: 'IRQF_VALID' undeclared (first use in this function)
drivers/pci/host/pci-xilinx.c:742:14: error: dereferencing pointer to incomplete type
drivers/pci/host/pci-xilinx.c:939:2: error: implicit declaration of function 'pci_common_init_dev' [-Werror=implicit-function-declaration]
drivers/pci/host/pci-xilinx.c:417:2: error: implicit declaration of function 'set_irq_flags' [-Werror=implicit-function-declaration]
drivers/pci/host/pci-xilinx.c:938:2: error: invalid use of undefined type 'struct hw_pci'
drivers/pci/host/pci-xilinx.c:888:16: error: storage size of 'hw' isn't known
drivers/pci/host/pci-xilinx.c:935:3: error: unknown field 'add_bus' specified in initializer
drivers/pci/host/pci-xilinx.c:934:3: error: unknown field 'map_irq' specified in initializer
drivers/pci/host/pci-xilinx.c:931:3: error: unknown field 'nr_controllers' specified in initializer
drivers/pci/host/pci-xilinx.c:937:3: error: unknown field 'ops' specified in initializer
drivers/pci/host/pci-xilinx.c:932:3: error: unknown field 'private_data' specified in initializer
drivers/pci/host/pci-xilinx.c:936:3: error: unknown field 'scan' specified in initializer
drivers/pci/host/pci-xilinx.c:933:3: error: unknown field 'setup' specified in initializer
drivers/pci/host/pci-xilinx.c:937:3: warning: (near initialization for '(anonymous)')
drivers/pci/host/pci-xilinx.c:937:3: warning: excess elements in struct initializer
drivers/pci/host/pci-xilinx.c:124:59: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/pci/host/pci-xilinx.c:737:34: warning: passing argument 1 of 'sys_to_pcie' from incompatible pointer type
drivers/pci/host/pci-xilinx.c:735:17: warning: 'struct pci_sys_data' declared inside parameter list

elapsed time: 25m

configs tested: 112

parisc                        c3000_defconfig
parisc                         b180_defconfig
parisc                              defconfig
alpha                               defconfig
parisc                            allnoconfig
i386                              allnoconfig
i386                                defconfig
i386                             allmodconfig
i386                             alldefconfig
sh                            titan_defconfig
sh                          rsk7269_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                                allnoconfig
x86_64                     randconfig-c3-0818
x86_64                     randconfig-c1-0818
x86_64                     randconfig-c0-0818
x86_64                     randconfig-c2-0818
ia64                             allmodconfig
ia64                              allnoconfig
ia64                                defconfig
ia64                             alldefconfig
x86_64                                    lkp
x86_64                                   rhel
powerpc                      chroma_defconfig
powerpc                 linkstation_defconfig
powerpc                               powerpc
powerpc                         wii_defconfig
powerpc                    gamecube_defconfig
powerpc               corenet64_smp_defconfig
powerpc                               mpc512x
powerpc                                ppc44x
x86_64                     randconfig-j0-0818
x86_64                     randconfig-j1-0818
i386                      randconfig-ha2-0818
i386                      randconfig-ha5-0818
i386                      randconfig-ha4-0818
i386                      randconfig-ha3-0818
i386                      randconfig-ha0-0818
i386                      randconfig-ha1-0818
sparc                               defconfig
sparc64                           allnoconfig
sparc64                             defconfig
x86_64                           allmodconfig
xtensa                       common_defconfig
m32r                       m32104ut_defconfig
xtensa                          iss_defconfig
m32r                         opsput_defconfig
m32r                           usrv_defconfig
m32r                     mappi3.smp_defconfig
i386                          randconfig-i002
i386                          randconfig-i003
i386                          randconfig-i000
i386                          randconfig-i001
i386                          randconfig-i006
i386                          randconfig-i007
i386                          randconfig-i004
i386                          randconfig-i005
i386                          randconfig-i008
i386                          randconfig-i009
x86_64                        randconfig-i009
x86_64                        randconfig-i008
x86_64                        randconfig-i003
x86_64                        randconfig-i002
x86_64                        randconfig-i001
x86_64                        randconfig-i000
x86_64                        randconfig-i007
x86_64                        randconfig-i006
x86_64                        randconfig-i005
x86_64                        randconfig-i004
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig
i386                             allyesconfig
cris                 etrax-100lx_v2_defconfig
blackfin                  TCM-BF537_defconfig
blackfin            BF561-EZKIT-SMP_defconfig
blackfin                BF533-EZKIT_defconfig
blackfin                BF526-EZBRD_defconfig
i386                       randconfig-r2-0818
i386                       randconfig-r1-0818
i386                       randconfig-r0-0818
i386                       randconfig-r3-0818
mn10300                     asb2364_defconfig
openrisc                    or1ksim_defconfig
um                           x86_64_defconfig
um                             i386_defconfig
avr32                      atngw100_defconfig
frv                                 defconfig
avr32                     atstk1006_defconfig
tile                         tilegx_defconfig
x86_64                   randconfig-x004-0817
i386                     randconfig-x000-0817
x86_64                   randconfig-x007-0817
i386                     randconfig-x001-0817
i386                     randconfig-x002-0817
i386                     randconfig-x005-0817
i386                     randconfig-x007-0817
x86_64                   randconfig-x003-0817
i386                     randconfig-x003-0817
x86_64                   randconfig-x008-0817
i386                     randconfig-x006-0817
x86_64                   randconfig-x000-0817
i386                     randconfig-x004-0817
x86_64                   randconfig-x002-0817
i386                     randconfig-x008-0817
i386                     randconfig-x009-0817
x86_64                   randconfig-x006-0817
x86_64                   randconfig-x009-0817
x86_64                   randconfig-x005-0817
x86_64                   randconfig-x001-0817
x86_64                             acpi-redef
x86_64                           allyesdebian
x86_64                                nfsroot

Thanks,
Fengguang

--T4sUOijqQbZv57TR
Content-Type: message/rfc822
Content-Disposition: inline

Delivered-To: bhelgaas@google.com
Received: by 10.229.161.5 with SMTP id p5csp800qcx;
        Mon, 18 Aug 2014 00:17:39 -0700 (PDT)
X-Received: by 10.67.3.234 with SMTP id bz10mr32715290pad.111.1408346259349;
        Mon, 18 Aug 2014 00:17:39 -0700 (PDT)
Return-Path: <fengguang.wu@intel.com>
Received: from mga03.intel.com (mga03.intel.com. [143.182.124.21])
        by mx.google.com with ESMTP id tm8si20330050pab.54.2014.08.18.00.17.38
        for <bhelgaas@google.com>;
        Mon, 18 Aug 2014 00:17:39 -0700 (PDT)
Received-SPF: pass (google.com: domain of fengguang.wu@intel.com designates 143.182.124.21 as permitted sender) client-ip=143.182.124.21;
Authentication-Results: mx.google.com;
       spf=pass (google.com: domain of fengguang.wu@intel.com designates 143.182.124.21 as permitted sender) smtp.mail=fengguang.wu@intel.com
Received: from azsmga001.ch.intel.com ([10.2.17.19])
  by azsmga101.ch.intel.com with ESMTP; 18 Aug 2014 00:17:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,884,1400050800"; 
   d="scan'208";a="469766744"
Received: from bee.sh.intel.com (HELO bee) ([10.239.97.14])
  by azsmga001.ch.intel.com with ESMTP; 18 Aug 2014 00:17:36 -0700
Received: from kbuild by bee with local (Exim 4.83)
	(envelope-from <fengguang.wu@intel.com>)
	id 1XJHCB-0005WR-Kc; Mon, 18 Aug 2014 15:17:35 +0800
Date: Mon, 18 Aug 2014 15:16:51 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Srikanth Thokala <sthokal@xilinx.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, kbuild-all@01.org
Subject: [pci:pci/host-xilinx 1/1] WARNING:
 drivers/built-in.o(.text+0x64acc): Section mismatch in reference from the
 function xilinx_pcie_probe() to the function
 .init.text:xilinx_pcie_scan_bus()
Message-ID: <53f1a863.4ZfgYASzj2ytBgvP%fengguang.wu@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci/host-xilinx
head:   a58f3d0c3b1c4a71a2418c3306fba86c26a49781
commit: a58f3d0c3b1c4a71a2418c3306fba86c26a49781 [1/1] PCI: xilinx: Add Xilinx PCIe Host Bridge IP driver
config: make ARCH=arm allmodconfig

All warnings:

>> WARNING: drivers/built-in.o(.text+0x64acc): Section mismatch in reference from the function xilinx_pcie_probe() to the function .init.text:xilinx_pcie_scan_bus()
   The function xilinx_pcie_probe() references
   the function __init xilinx_pcie_scan_bus().
   This is often because xilinx_pcie_probe lacks a __init
   annotation or the annotation of xilinx_pcie_scan_bus is wrong.

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

--T4sUOijqQbZv57TR--
