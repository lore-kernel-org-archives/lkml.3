Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaBNQcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:32:05 -0500
Received: from mail.wdtv.com ([66.118.69.84]:59851 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbaBNQcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:32:03 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Loseing my patience with libata and sata_nv
Date: Fri, 14 Feb 2014 11:31:47 -0500
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201402141131.48157.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which is required for my $290 ASUS M2n-SLI Deluxe motherboard to boot.

Not finding the option in any kernel tree that exists on my system, 
except it appears its been replaced or something.

This once in a lifetime boot, to 3.12.9, shows from an lsmod:
libata                146855  2 sata_nv,pata_amd
scsi_mod              153579  4 sr_mod,sg,sd_mod,libata

I haven't a clue how I got it in this boot, and I built it.  And 
apparently a make oldconfig, carefully done by hand (takes about an hour
30 to do) is not capable of adding it to a .config BECAUSE it does NOT 
exist in any of the arch/x86/configs/i386_defconfig's present on this machine.

Here is how I searched:

gene@coyote:~/src/linux-3.0.69$ grep SATA_NV arch/x86/configs/i386_defconfig 
gene@coyote:~/src/linux-3.0.69$ cd ../linux-3.2.40
gene@coyote:~/src/linux-3.2.40$ grep SATA_NV arch/x86/configs/i386_defconfig 
gene@coyote:~/src/linux-3.2.40$ cd ../linux-3.4.36
gene@coyote:~/src/linux-3.4.36$ grep SATA_NV arch/x86/configs/i386_defconfig 
gene@coyote:~/src/linux-3.4.36$ cd ../linux-3.8.2
gene@coyote:~/src/linux-3.8.2$ grep SATA_NV arch/x86/configs/i386_defconfig 
gene@coyote:~/src/linux-3.8.2$ cd ../linux-3.8.3
gene@coyote:~/src/linux-3.8.3$ grep SATA_NV arch/x86/configs/i386_defconfig 
gene@coyote:~/src/linux-3.8.3$ cd ../linux-3.12.0
gene@coyote:~/src/linux-3.12.0$ grep SATA_NV arch/x86/configs/i386_defconfig 
gene@coyote:~/src/linux-3.12.0$ cd ../linux-3.12.6
gene@coyote:~/src/linux-3.12.6$ grep SATA_NV arch/x86/configs/i386_defconfig 
gene@coyote:~/src/linux-3.12.6$ cd ../linux-3.12.9
gene@coyote:~/src/linux-3.12.9$ grep SATA_NV arch/x86/configs/i386_defconfig 
gene@coyote:~/src/linux-3.12.9$ cd ../linux-3.13.1
gene@coyote:~/src/linux-3.13.1$ grep SATA_NV arch/x86/configs/i386_defconfig 
gene@coyote:~/src/linux-3.13.1$ cd ../linux-3.13.2
gene@coyote:~/src/linux-3.13.2$ grep SATA_NV arch/x86/configs/i386_defconfig 
gene@coyote:~/src/linux-3.13.2$ 

I've been fighting with this, intermittently for about 6 months.  Except 
for this 3.12.9 where I must have been holding my mouth right, all the
rest are boot failures because it can't find the boot drive with so-and-so
for a UUID. sata_nv is on the missing list, even in this WORKing boots defconfig.
"Working" however is a miss-statement, no multimedia stuff was built.

There has to be a rule I am violating, but even with Randy's D's help, it is
not becoming obvious.  FWIW libata references also can't be found, but as 
can be seen, its in memory right now.

So please guys, what is the magic dependency that causes libata and 
sata_nv to be included in a .config?

Thanks & Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>
