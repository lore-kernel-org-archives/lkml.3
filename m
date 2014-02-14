Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbaBNJC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:02:57 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:53241 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbaBNJCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:02:48 -0500
MIME-Version: 1.0
Date: Fri, 14 Feb 2014 14:32:47 +0530
Message-ID: <CA+G9fYuT4TSs=3j6K9zztsTgFNVp2YG6JT-2Q_L==1P5G+SBew@mail.gmail.com>
Subject: How to get the Linux kernel coverage data on ARM arch when I run LTP test?
From: Naresh Kamboju <naresh.kamboju@linaro.org>
To: Arnd Bergmann <arnd.bergmann@linaro.org>, fhrbata@redhat.com,
        oberpar@linux.vnet.ibm.com, Paul Larson <paul.larson@canonical.com>
Cc: Deepak Saxena <dsaxena@linaro.org>, Mark Brown <mark.brown@linaro.org>,
        Milosz Wasilewski <milosz.wasilewski@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ltp-coverage <ltp-coverage@lists.sourceforge.net>,
        ltp-list <ltp-list@lists.sourceforge.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Sorry for the wide distribution:

According to LTP page info,
http://ltp.sourceforge.net/coverage/gcov.php
http://ltp.sourceforge.net/coverage/lcov.php

My question is
How to get kernel coverage when I run LTP test?

Since we do not have direct GCOV support on ARM I have enabled ( just
for experiment)

$ git diff  kernel/gcov/Kconfig
diff --git a/kernel/gcov/Kconfig b/kernel/gcov/Kconfig
index d4da55d..fceac85 100644
--- a/kernel/gcov/Kconfig
+++ b/kernel/gcov/Kconfig
@@ -35,7 +35,7 @@ config GCOV_KERNEL
 config GCOV_PROFILE_ALL
        bool "Profile entire Kernel"
        depends on GCOV_KERNEL
-       depends on SUPERH || S390 || X86 || PPC || MICROBLAZE
+       depends on SUPERH || S390 || X86 || PPC || MICROBLAZE || ARM
        default n
        ---help---
        This options activates profiling for the entire kernel.

I have enabled below kernel config and built the kernel.
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_GCOV_FORMAT_AUTODETECT=y

of course I have disabled gcov on below folders and files, because
since it is an experiment i would like to be on safe side
- arch/arm/mm/
- arch/arm/kernel/
- arch/arm/boot/
- arch/arm/boot/compressed/
- arch/arm/boot/bootp/
- arch/arm/boot/dts

Arndale booted with this configuration successfully.
Took more than 65 seconds to finish boot.

gcov related files are found under /sys/ similer to X86 machine.
And  gcov supporting files filename.gcda are having links to kernel source
root@linaro-developer:~# ls /sys/kernel/debug/gcov/
reset  tmp
root@linaro-developer:~#

root@linaro-developer:~# ls /sys/kernel/debug/gcov/tmp/
linux-linaro-3.13-2014.01
root@linaro-developer:~# ls
/sys/kernel/debug/gcov/tmp/linux-linaro-3.13-2014.01/
arch  block  crypto  drivers  fs  init  ipc  kernel  lib  mm  security  virt
root@linaro-developer:~# ls
/sys/kernel/debug/gcov/tmp/linux-linaro-3.13-2014.01/kernel/time.* -l
-rw------- 1 root root 0 Jan  1  1970
/sys/kernel/debug/gcov/tmp/linux-linaro-3.13-2014.01/kernel/time.gcda
lrwxrwxrwx 1 root root 0 Jan  1  1970
/sys/kernel/debug/gcov/tmp/linux-linaro-3.13-2014.01/kernel/time.gcno
-> /tmp/linux-linaro-3.13-2014.01/kernel/time.gcno
root@linaro-developer:~#

Source are placed under /tmp/
root@linaro-developer:/tmp/linux-linaro-3.13-2014.01# ls  kernel/time.* -l
-rw-rw-r-- 1 linaro linaro  19233 Jan 24  2014 kernel/time.c
-rw-rw-r-- 1 linaro linaro  12768 Feb 13  2014 kernel/time.gcno
-rw-rw-r-- 1 linaro linaro 136444 Feb 13  2014 kernel/time.o
root@linaro-developer:/tmp/linux-linaro-3.13-2014.01#


root@linaro-developer:/tmp/linux-linaro-3.13-2014.01# gcov kernel/gcov/base.c -o
 /sys/kernel/debug/gcov/tmp/linux-linaro-3.13-2014.01/kernel/gcov/
File 'kernel/gcov/base.c'
Lines executed:43.18% of 44
Creating 'base.c.gcov'

root@linaro-developer:/tmp/linux-linaro-3.13-2014.01#

The above experiment gives coverage of a single file base.c when i run
gcov manually.
Is there any way to get Linux kernel coverage of all files after
running LTP test cases ?

Thanks in advance.

Best regards
Naresh Kamboju
