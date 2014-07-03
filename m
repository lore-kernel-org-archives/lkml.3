Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbaGCVTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:19:30 -0400
Received: from know-smtprelay-omc-10.server.virginmedia.net ([80.0.253.74]:46433
	"EHLO know-smtprelay-omc-10.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbaGCVT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:19:28 -0400
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=KpbD2AmN c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=J0QyKEt1u0cA:10 a=_iiiZ5loNNoA:10
 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=LDTyvWtZY36o2PcIv20A:9
 a=QEXdDO2ut3YA:10
Date: Thu, 3 Jul 2014 22:19:25 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: linux-kernel@vger.kernel.org
Subject: Re: rtl_nic firmware error in 3.16
Message-ID: <20140703211925.GA23074@milliways>
References: <20140626021723.GA16141@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140626021723.GA16141@milliways>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 03:17:23AM +0100, Ken Moffat wrote:
> Hi,
> 
>  I'm getting 15 lines of the following in -rc2
> 
> /bin/sh: firmware/rtl_nic/rtl8168e-3.fw.gen.S: No such file or directory
> 
> followed by
> firmware/Makefile:185: recipe for target 'firmware/rtl_nic/rtl8168e-3.fw.gen.S' failed
> make[1]: *** [firmware/rtl_nic/rtl8168e-3.fw.gen.S] Error 1
> 
>  I've now tried bisecting this twice, from v3.15 to v3.16-rc2 but
> each time the only bad version was v3.16-rc2 itself which is clearly
> not true.
> 
>  The relevant part of my .config is probably in here:
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER=y
> CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
> CONFIG_DEVTMPFS=y
> CONFIG_DEVTMPFS_MOUNT=y
> # CONFIG_STANDALONE is not set
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> # CONFIG_FIRMWARE_IN_KERNEL is not set
> CONFIG_EXTRA_FIRMWARE="radeon/R600_rlc.bin radeon/RS780_pfp.bin radeon/RS780_me.bin rtl_nic/rtl8168e-3.fw"
> CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"
> CONFIG_FW_LOADER_USER_HELPER=y
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_GENERIC_CPU_AUTOPROBE=y
> CONFIG_DMA_SHARED_BUFFER=y
> 
> and the external firmware is in /lib/firmware :
> 
> ken@ac4tv ~ $ls -l /lib/firmware/rtl_nic/
> total 4
> -rw-r--r-- 1 root root 2804 Feb 18 18:03 rtl8168e-3.fw
> 
>  So I assume something is erroneously trying to recreate it.
> 
>  For the second run, I tried using 'make clean' on each build, and
> then after a while I changed to 'make mrproper'.  Perhaps I should
> have used 'mrproper' from the start (never needed it before, and it
> does normally slow things down when you approach the guilty commit).
> 
>  I have now pulled the -rc1 tarball and confirmed that the problem
> is present there, but this is doing my head in, so I thought I would
> ask if anyone else is hitting this ?
> 
> ĸen

 Update, just in case anybody cares.

 I still saw it on -rc3, an attempt to build using what was in linus'
tree the last time I pulled it (a bit after rc2) showed it once, and
bisecting between 3.15-rc8 and 3.16-rc1 with 'make mrproper' on each
build again blamed the version I labelled as bad, i.e. -rc1.

 So, I dropped it from my config for -rc3 to see if it would boot
without this.  It does, and shows no sign of wanting the firmware.

 Weird. I'm _fairly_ sure that an older kernel (some time after I
first put this box together) complained that this firmware was
missing (but appeared to still work), which is why I first added it.

 But since -rc3 is happy without this firmware, I don't have a
problem.

ĸen
-- 
Nanny Ogg usually went to bed early. After all, she was an old lady.
Sometimes she went to bed as early as 6 a.m.
