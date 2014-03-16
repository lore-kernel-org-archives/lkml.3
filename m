Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbaCPOiK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 10:38:10 -0400
Received: from mail.tpi.com ([74.45.170.26]:52419 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbaCPOiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 10:38:07 -0400
X-Greylist: delayed 1945 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Mar 2014 10:38:07 EDT
Message-ID: <5325AFB2.4050505@canonical.com>
Date: Sun, 16 Mar 2014 08:05:38 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>, Tejun Heo <tj@kernel.org>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        dann frazier <dann.frazier@canonical.com>
Subject: linux-next: ahci_platform broken build
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gents  - while reviewing some patches for arm64 in Ubuntu I noticed that 
there is at least one patch sequence in linux-next that breaks the build.

156c5887948cd191417f18026aab9ce26e5a95da ahci-platform: Add support for 
devices with more then 1 clock
039ece38da45f5e6a94be3aa7611cf3634bc2461 libahci: Allow drivers to 
override start_engine

For example:

git reset --hard 156c5887948cd191417f18026aab9ce26e5a95da
echo "CONFIG_SATA_AHCI_PLATFORM=y" >> .config
make oldconfig scripts prepare
make M=drivers/ata

   WARNING: Symbol version dump /home/rtg/linux/linux-next/Module.symvers
            is missing; modules will have no dependencies and modversions.

   CC      drivers/ata/libata-core.o
   CC      drivers/ata/libata-scsi.o
   CC      drivers/ata/libata-eh.o
   CC      drivers/ata/libata-transport.o
   CC      drivers/ata/libata-sff.o
   CC      drivers/ata/libata-pmp.o
   CC      drivers/ata/libata-acpi.o
   LD      drivers/ata/libata.o
   CC      drivers/ata/ahci.o
   CC      drivers/ata/libahci.o
   CC      drivers/ata/ahci_platform.o
drivers/ata/ahci_platform.c: In function ‘ahci_probe’:
drivers/ata/ahci_platform.c:209:2: error: implicit declaration of 
function ‘ahci_enable_clks’ [-Werror=implicit-function-declaration]
drivers/ata/ahci_platform.c:293:2: error: implicit declaration of 
function ‘ahci_disable_clks’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[1]: *** [drivers/ata/ahci_platform.o] Error 1
make: *** [_module_drivers/ata] Error 2

The compile problem is then fixed in 
96a01ba52c60fdd74dd6e8cf06645d06515b1396 (ahci-platform: Add enable_ / 
disable_resources helper functions) which is not really kosher.

It seems like you ought to fix this before the 3.15 merge window opens.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
