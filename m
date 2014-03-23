Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaCWMPo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 08:15:44 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:57493 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaCWMPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 08:15:42 -0400
Date: Sun, 23 Mar 2014 13:15:41 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: 3.14-rc7 crashes in drm ([PATCH] a crash in
 mga_driver_irq_uninstall)
Message-ID: <20140323121541.GA20971@rhlx01.hs-esslingen.de>
References: <alpine.LRH.2.02.1402261551010.9913@file01.intranet.prod.int.rdu2.redhat.com>
 <20140322234317.GA10483@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140322234317.GA10483@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Mar 23, 2014 at 12:43:17AM +0100, Andreas Mohr wrote:
> Hi,
> 
> now testing 3.14-rc7 here (r128 hardware rather than MGA),
> and I seem to still be experiencing the same or very similar crash as you here:

I decided to do some more experimentation:

I added a

Section "Module"
        Disable "dri"
EndSection

which did reliably disable dri according to 3.12.0-rc2+ xdpyinfo / Xorg.0.log

On -rc7 however, this changed the issue from a kernel OOPS into merely a
Xorg.0.log trace and abort (no such issue on working kernel
given my userspace configuration!):

[    68.334] Backtrace:
[    68.335] 0: /usr/bin/X (xorg_backtrace+0x49) [0xb7767769]
[    68.335] 1: /usr/bin/X (0xb75ea000+0x181186) [0xb776b186]
[    68.335] 2: linux-gate.so.1 (__kernel_rt_sigreturn+0x0) [0xffffe40c]
[    68.335] 3: /usr/lib/i386-linux-gnu/libpixman-1.so.0 (0xb7430000+0x727c0) [0xb74a27c0]
[    68.335] 4: /usr/lib/i386-linux-gnu/libpixman-1.so.0 (0xb7430000+0x57abf) [0xb7487abf]
[    68.335] 5: /usr/lib/i386-linux-gnu/libpixman-1.so.0 (pixman_blt+0x7d) [0xb74367ad]
[    68.335] 6: /usr/lib/xorg/modules/libfb.so (fbCopyNtoN+0x2af) [0xb6de066f]
[    68.335] 7: /usr/bin/X (miCopyRegion+0x17c) [0xb7743f6c]
[    68.336] 8: /usr/bin/X (miDoCopy+0x4f0) [0xb77445a0]
[    68.336] 9: /usr/lib/xorg/modules/libfb.so (fbCopyArea+0x7e) [0xb6de089e]
[    68.336] 10: /usr/lib/xorg/modules/libxaa.so (0xb6f04000+0xacf3) [0xb6f0ecf3]
[    68.336] 11: /usr/lib/xorg/modules/libxaa.so (0xb6f04000+0x548d3) [0xb6f588d3]
[    68.336] 12: /usr/bin/X (0xb75ea000+0x10929d) [0xb76f329d]
[    68.336] 13: /usr/bin/X (0xb75ea000+0x15b60f) [0xb774560f]
[    68.336] 14: /usr/bin/X (0xb75ea000+0x16cd21) [0xb7756d21]
[    68.336] 15: /usr/bin/X (0xb75ea000+0x16d50c) [0xb775750c]
[    68.337] 16: /usr/bin/X (0xb75ea000+0xbe0b7) [0xb76a80b7]
[    68.337] 17: /usr/bin/X (miPointerUpdateSprite+0x2a7) [0xb7751687]
[    68.337] 18: /usr/bin/X (0xb75ea000+0x16791a) [0xb775191a]
[    68.337] 19: /usr/bin/X (0xb75ea000+0xcd1c4) [0xb76b71c4]
[    68.337] 20: /usr/bin/X (0xb75ea000+0x101bfe) [0xb76ebbfe]
[    68.337] 21: /usr/bin/X (0xb75ea000+0x4437b) [0xb762e37b]
[    68.337] 22: /usr/bin/X (WindowHasNewCursor+0x3b) [0xb762f6db]
[    68.337] 23: /usr/bin/X (ChangeWindowAttributes+0xb0c) [0xb7655e1c]
[    68.338] 24: /usr/bin/X (0xb75ea000+0x35da7) [0xb761fda7]
[    68.338] 25: /usr/bin/X (0xb75ea000+0x3c375) [0xb7626375]
[    68.338] 26: /usr/bin/X (0xb75ea000+0x29e95) [0xb7613e95]
[    68.338] 27: /lib/i386-linux-gnu/i686/cmov/libc.so.6 (__libc_start_main+0xf5) [0xb71ef8f5]
[    68.338] 28: /usr/bin/X (0xb75ea000+0x2a1e9) [0xb76141e9]
[    68.338] 
[    68.338] Bus error at address 0xb4f1ed4e
[    68.338] 
Fatal server error:
[    68.339] Caught signal 7 (Bus error). Server aborting




I then also decided to update libdrm package:

i  libdrm-dev:i386                      2.4.52-1                          i386         Userspace interface to kernel DRM services -- development files
ii  libdrm-intel1:i386                   2.4.52-1                          i386         Userspace interface to intel-specific kernel DRM services -- runtime
rc  libdrm-nouveau1                      2.4.21-1~squeeze3                 i386         Userspace interface to nouveau-specific kernel DRM services -- runtime
ii  libdrm-nouveau2:i386                 2.4.52-1                          i386         Userspace interface to nouveau-specific kernel DRM services -- runtime
ii  libdrm-radeon1:i386                  2.4.52-1                          i386         Userspace interface to radeon-specific kernel DRM services -- runtime
ii  libdrm2:i386                         2.4.52-1                          i386         Userspace interface to kernel DRM services -- runtime


which did end up flawless on 3.12.0-rc2+, too
(but failed to improve the issue on 3.14.0-rc7+).

So, for all intents and purposes, drm infrastructure seems unavoidably
(neither dri disable nor libdrm upgrade helps) affected.
Does anyone know which change caused that issue?
(I'm asking because bisect here would be relatively painful).

Thanks,

Andreas Mohr
