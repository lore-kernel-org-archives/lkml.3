Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab3BOOQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 09:16:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63958 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab3BOOQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 09:16:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: fb: mmp: include linux/platform_device.h
Date: Fri, 15 Feb 2013 14:16:17 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Zhou Zhu <zzhu3@marvell.com>, Lisa Du <cldu@marvell.com>,
        Guoqing Li <ligq@marvell.com>
References: <1360880818-4071454-1-git-send-email-arnd@arndb.de> <1360880818-4071454-8-git-send-email-arnd@arndb.de> <20130214230501.GA30269@kroah.com>
In-Reply-To: <20130214230501.GA30269@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302151416.18121.arnd@arndb.de>
X-Provags-ID: V02:K0:YA5u65o9ZhkVWjXnRoI4CwXBvad1t5Xt7p5ggswbKIi
 BH2q93Zp4wXx/XjbDMHi0RDLU+qhoBCeQdK5fAnUgSXByRUs/K
 cEHvhw9y+78ZjCtAXtH4c6SN0AQLng08x3qTh1A4dQi5a5ztKV
 ZoDuRb+l2fgnT3uomwYrIs1czG5CGJOf2T/Iz4U7BJJSguW8aL
 tWlZc5mXe95iU5OUWdvbJ7ayDWiPQQwvIaw9KvBczv18C/wLwt
 T3gVL70iFNPzyqZdMy986bEC7qOjUpAw/j+QxNXJpzl0tpLSZB
 dPrnjqRzhkiCQlgybkkREYsLqg8WZmJkEJTUyl7t78B8tNeiS4
 VUBSisH511svAYzuCDRs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 16559ae "kgdb: remove #include <linux/serial_8250.h> from kgdb.h"
changes the kgdb.h file so that drivers including it do not implicitly
include linux/platform_device.h. The mmp framebuffer driver is new,
so Greg did not have a chance to fix it up when introducing his change.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
On Thursday 14 February 2013, Greg Kroah-Hartman wrote:
> On Thu, Feb 14, 2013 at 11:26:56PM +0100, Arnd Bergmann wrote:
> > Patch 16559ae "kgdb: remove #include <linux/serial_8250.h> from kgdb.h"
> > removed an implicit inclusion of linux/platform_device.h
> > In a number of places. This adds back explicit inclusions in a few
> > more places I found.
>
> >  drivers/video/mmp/fb/mmpfb.c             | 1 +
> 
> This file isn't my tty tree, so I can't apply that part of the patch,
> but I've applied the rest of the patch, and the 2 others you sent me to
> fix this issue.

Right. It seems the driver is only in Andrew's tree. Andrew, can you 
add this hunk on top?

diff --git a/drivers/video/mmp/fb/mmpfb.c b/drivers/video/mmp/fb/mmpfb.c
index f34a3a9..6d1fa96 100644
--- a/drivers/video/mmp/fb/mmpfb.c
+++ b/drivers/video/mmp/fb/mmpfb.c
@@ -21,6 +21,7 @@
  */
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
 #include "mmpfb.h"
 
 static int var_to_pixfmt(struct fb_var_screeninfo *var)
