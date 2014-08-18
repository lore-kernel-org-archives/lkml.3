Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaHRCCa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 22:02:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:26123 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbaHRCC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 22:02:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,882,1400050800"; 
   d="scan'208";a="469706065"
Message-ID: <53F15E0D.7090503@intel.com>
Date: Mon, 18 Aug 2014 09:59:41 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: mika.westerberg@linux.intel.com, torvalds@linux-foundation.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] I2C: Rework kernel config I2C_ACPI
References: <20140814093743.GB2824@katana> <1408081139-6292-1-git-send-email-tianyu.lan@intel.com> <20140815110323.GA2860@katana>
In-Reply-To: <20140815110323.GA2860@katana>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年08月15日 19:03, Wolfram Sang wrote:
> On Fri, Aug 15, 2014 at 01:38:59PM +0800, Lan Tianyu wrote:
>> Commit da3c6647(I2C/ACPI: Clean up I2C ACPI code and Add CONFIG_I2C_ACPI
>> config) adds a new kernel config I2C_ACPI and make I2C core built in
>> when the config is selected. This is wrong because distributions
>> etc generally compile I2C as a module and the commit broken that.
>> This patch is to rename I2C_ACPI to ACPI_I2C_OPREGION. New config
>> only controls ACPI I2C operation region code and depends on I2C=y.
>>
>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> 
> It looks good. What tests did you perform?
> 
> Thanks,
> 
>    Wolfram
> 

Hi Wolfram:
	The patch passed through Fengguang's 0-day autobuild test.

Following are config files tested.

configs tested: 122

parisc                        c3000_defconfig
parisc                         b180_defconfig
parisc                              defconfig
alpha                               defconfig
parisc                            allnoconfig
mips                             allmodconfig
mips                                   jz4740
mips                              allnoconfig
mips                      fuloong2e_defconfig
mips                                     txx9
x86_64                            allnoconfig
x86_64                                    lkp
x86_64                                   rhel
sh                            titan_defconfig
sh                          rsk7269_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                                allnoconfig
x86_64                     randconfig-c3-0815
x86_64                     randconfig-c1-0815
x86_64                     randconfig-c0-0815
x86_64                     randconfig-c2-0815
x86_64                           allmodconfig
i386                           randconfig-jx5
i386                           randconfig-jx4
i386                           randconfig-jx7
i386                           randconfig-jx6
i386                           randconfig-jx1
i386                           randconfig-jx0
i386                           randconfig-jx3
i386                           randconfig-jx2
i386                           randconfig-jx9
i386                           randconfig-jx8
x86_64                         randconfig-jx8
x86_64                         randconfig-jx9
x86_64                         randconfig-jx2
x86_64                         randconfig-jx3
x86_64                         randconfig-jx0
x86_64                         randconfig-jx1
x86_64                         randconfig-jx6
x86_64                         randconfig-jx7
x86_64                         randconfig-jx4
x86_64                         randconfig-jx5
powerpc                      chroma_defconfig
powerpc                 linkstation_defconfig
powerpc                               powerpc
powerpc                         wii_defconfig
powerpc                    gamecube_defconfig
powerpc               corenet64_smp_defconfig
powerpc                               mpc512x
powerpc                                ppc44x
x86_64                     randconfig-j0-0815
x86_64                     randconfig-j1-0815
i386                      randconfig-ha2-0815
i386                      randconfig-ha5-0815
i386                      randconfig-ha1-0815
i386                      randconfig-ha0-0815
i386                      randconfig-ha3-0815
i386                      randconfig-ha4-0815
ia64                             allmodconfig
ia64                              allnoconfig
ia64                                defconfig
ia64                             alldefconfig
sparc                               defconfig
sparc64                           allnoconfig
sparc64                             defconfig
xtensa                       common_defconfig
m32r                       m32104ut_defconfig
xtensa                          iss_defconfig
m32r                         opsput_defconfig
m32r                           usrv_defconfig
m32r                     mappi3.smp_defconfig
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig
microblaze                       allyesconfig
i386                             allyesconfig
cris                 etrax-100lx_v2_defconfig
blackfin                  TCM-BF537_defconfig
blackfin            BF561-EZKIT-SMP_defconfig
blackfin                BF533-EZKIT_defconfig
blackfin                BF526-EZBRD_defconfig
i386                       randconfig-r1-0815
i386                       randconfig-r2-0815
i386                       randconfig-r3-0815
i386                       randconfig-r0-0815
s390                             allmodconfig
s390                              allnoconfig
s390                                defconfig
mn10300                     asb2364_defconfig
openrisc                    or1ksim_defconfig
um                           x86_64_defconfig
um                             i386_defconfig
avr32                      atngw100_defconfig
frv                                 defconfig
avr32                     atstk1006_defconfig
tile                         tilegx_defconfig
i386                          randconfig-x009
i386                          randconfig-x008
i386                          randconfig-x005
i386                          randconfig-x004
i386                          randconfig-x007
i386                          randconfig-x006
i386                          randconfig-x001
i386                          randconfig-x000
i386                          randconfig-x003
i386                          randconfig-x002
x86_64                        randconfig-x000
x86_64                        randconfig-x001
x86_64                        randconfig-x002
x86_64                        randconfig-x003
x86_64                        randconfig-x004
x86_64                        randconfig-x005
x86_64                        randconfig-x006
x86_64                        randconfig-x007
x86_64                        randconfig-x008
x86_64                        randconfig-x009
powerpc                             defconfig
powerpc                       ppc64_defconfig
powerpc                           allnoconfig
powerpc                          allmodconfig
x86_64                             acpi-redef
x86_64                           allyesdebian
x86_64                                nfsroot

-- 
Best regards
Tianyu Lan
