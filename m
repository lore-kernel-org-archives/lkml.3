Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbaBZTuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:50:54 -0500
Received: from mail.candelatech.com ([208.74.158.172]:55252 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaBZTux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:50:53 -0500
Message-ID: <530E4599.1030700@candelatech.com>
Date: Wed, 26 Feb 2014 11:50:49 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Build failure related to 'spinlokk_types.h'
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is from the ath10k tree, which was recently rebased on top of
3.14.0-rc4.

I'm getting the error below, but I cannot find any reference to 'spinlokk'
in the source tree.  The build tree has two mentions, but these are auto-generated
from what I can tell:

[greearb@ben-dt2 linux-ath.x64]$ grep -r spinlokk .
./arch/x86/kernel/cpu/.common.o.tmp:  /mnt/sda/home/greearb/git/linux.ath/include/linux/spinlokk_types.h \
./arch/x86/kernel/cpu/.common.o.d: /mnt/sda/home/greearb/git/linux.ath/include/linux/spinlokk_types.h \
[greearb@ben-dt2 linux-ath.x64]$

I tried make distclean, but that did not help.


Any idea where this might be coming from?

[greearb@ben-dt2 linux-ath.x64]$ make  bzImage modules
make[3]: Nothing to be done for `all'.
make[3]: Nothing to be done for `relocs'.
  CHK     include/config/kernel.release
  Using /mnt/sda/home/greearb/git/linux.ath as source for kernel
  GEN     /home/greearb/kernel/2.6/linux-ath.x64/Makefile
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    /mnt/sda/home/greearb/git/linux.ath/scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CC      arch/x86/kernel/cpu/common.o
fixdep: error opening config file: /mnt/sda/home/greearb/git/linux.ath/include/linux/spinlokk_types.h: No such file or directory
make[5]: *** [arch/x86/kernel/cpu/common.o] Error 2
make[4]: *** [arch/x86/kernel/cpu] Error 2
make[3]: *** [arch/x86/kernel] Error 2
make[2]: *** [arch/x86] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

