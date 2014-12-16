Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbaLPK4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 05:56:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbaLPK4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 05:56:46 -0500
Message-ID: <54900FEA.3050000@suse.com>
Date: Tue, 16 Dec 2014 11:56:42 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: "make binrpm-pkg O=jg/master" fails
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

doing

make binrpm-pkg O=jg/master

on latest //git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git

fails:

...
   INSTALL sound/usb/usx2y/snd-usb-us122l.ko
   INSTALL sound/usb/usx2y/snd-usb-usx2y.ko
   DEPMOD  3.18.0+
+ 
INSTALL_FW_PATH=/home/gross/rpmbuild/BUILDROOT/kernel-3.18.0+-6.x86_64/lib/firmware/3.18.0+
+ make 
INSTALL_FW_PATH=/home/gross/rpmbuild/BUILDROOT/kernel-3.18.0+-6.x86_64/lib/firmware/3.18.0+ 
firmware_install
make[3]: warning: jobserver unavailable: using -j1.  Add '+' to parent 
make rule.
scripts/kconfig/conf --silentoldconfig Kconfig
***
*** Configuration file ".config" not found!
***
*** Please run some configurator (e.g. "make oldconfig" or
*** "make menuconfig" or "make xconfig").
***
/home/gross/linux/scripts/kconfig/Makefile:36: recipe for target 
'silentoldconfig' failed
make[6]: *** [silentoldconfig] Error 1
/home/gross/linux/Makefile:541: recipe for target 'silentoldconfig' failed
make[5]: *** [silentoldconfig] Error 2
   IHEX    firmware/acenic/tg1.bin
   INSTALL 
/home/gross/rpmbuild/BUILDROOT/kernel-3.18.0+-6.x86_64/lib/firmware/3.18.0+/acenic/tg1.bin
...
   IHEX    firmware/yam/9600.bin
   INSTALL 
/home/gross/rpmbuild/BUILDROOT/kernel-3.18.0+-6.x86_64/lib/firmware/3.18.0+/yam/9600.bin
+ cp HOSTCC scripts/basic/fixdep HOSTCC scripts/kconfig/conf.o SHIPPED 
scripts/kconfig/zconf.tab.c SHIPPED scripts/kconfig/zconf.lex.c SHIPPED 
scripts/kconfig/zconf.hash.c HOSTCC scripts/kconfig/zconf.tab.o HOSTLD 
scripts/kconfig/conf scripts/kconfig/conf --silentoldconfig Kconfig 
/home/gross/linux/scripts/kconfig/Makefile:36: recipe for target 
''\''silentoldconfig'\''' failed /home/gross/linux/Makefile:541: recipe 
for target ''\''silentoldconfig'\''' failed arch/x86/boot/bzImage 
/home/gross/rpmbuild/BUILDROOT/kernel-3.18.0+-6.x86_64/boot/vmlinuz-3.18.0+
cp: unrecognized option '--silentoldconfig'
Try 'cp --help' for more information.
error: Bad exit status from /var/tmp/rpm-tmp.lsGzRz (%install)


RPM build errors:
     Bad exit status from /var/tmp/rpm-tmp.lsGzRz (%install)
/home/gross/linux/scripts/package/Makefile:60: recipe for target 
'binrpm-pkg' failed
make[2]: *** [binrpm-pkg] Error 1
/home/gross/linux/Makefile:1229: recipe for target 'binrpm-pkg' failed
make[1]: *** [binrpm-pkg] Error 2
make[1]: Leaving directory '/home/gross/linux/jg/master'
Makefile:145: recipe for target 'sub-make' failed
make: *** [sub-make] Error 2


After that I see new objects under firmware in the source tree.

Juergen
