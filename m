Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaD0RI1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:08:27 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48092 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389AbaD0RIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:25 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: "John L. Hammond" <john.hammond@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 33/47] staging/lustre: remove lustre/include/ioctl.h
Date: Sun, 27 Apr 2014 13:06:57 -0400
Message-Id: <1398618431-29757-34-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Remove the nowhere included header lustre/include/ioctl.h.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-on: http://review.whamcloud.com/9757
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2675
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: Dmitry Eremin <dmitry.eremin@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/include/ioctl.h | 106 --------------------------
 1 file changed, 106 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/ioctl.h

diff --git a/drivers/staging/lustre/lustre/include/ioctl.h b/drivers/staging/lustre/lustre/include/ioctl.h
deleted file mode 100644
index b986920..0000000
--- a/drivers/staging/lustre/lustre/include/ioctl.h
+++ /dev/null
@@ -1,106 +0,0 @@
-/*
- * GPL HEADER START
- *
- * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 only,
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License version 2 for more details (a copy is included
- * in the LICENSE file that accompanied this code).
- *
- * You should have received a copy of the GNU General Public License
- * version 2 along with this program; If not, see
- * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
- *
- * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
- * CA 95054 USA or visit www.sun.com if you need additional information or
- * have any questions.
- *
- * GPL HEADER END
- */
-/*
- * Copyright (c) 2003, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- */
-
-#ifndef _IOWR
-
-/* On i386 and x86_64, _ASM_I386_IOCTL_H is defined by the kernel's ioctl.h,
- * and on newer kernels this header is shared as _ASM_GENERIC_IOCTL_H.
- *
- * We can avoid any problems with the kernel header being included again by
- * defining _ASM_I386_IOCTL_H here so that a later occurrence of <asm/ioctl.h>
- * does not include the kernel's ioctl.h after this one. b=14746 */
-#define _ASM_I386_IOCTL_H
-#define _ASM_GENERIC_IOCTL_H
-
-/* ioctl command encoding: 32 bits total, command in lower 16 bits,
- * size of the parameter structure in the lower 14 bits of the
- * upper 16 bits.
- * Encoding the size of the parameter structure in the ioctl request
- * The highest 2 bits are reserved for indicating the ``access mode''.
- * NOTE: This limits the max parameter size to 16kB -1 !
- */
-
-/*
- * The following is for compatibility across the various Linux
- * platforms.  The i386 ioctl numbering scheme doesn't really enforce
- * a type field.  De facto, however, the top 8 bits of the lower 16
- * bits are indeed used as a type field, so we might just as well make
- * this explicit here.  Please be sure to use the decoding macros
- * below from now on.
- */
-#define _IOC_NRBITS     8
-#define _IOC_TYPEBITS   8
-#define _IOC_SIZEBITS   14
-#define _IOC_DIRBITS    2
-
-#define _IOC_NRMASK     ((1 << _IOC_NRBITS)-1)
-#define _IOC_TYPEMASK   ((1 << _IOC_TYPEBITS)-1)
-#define _IOC_SIZEMASK   ((1 << _IOC_SIZEBITS)-1)
-#define _IOC_DIRMASK    ((1 << _IOC_DIRBITS)-1)
-
-#define _IOC_NRSHIFT    0
-#define _IOC_TYPESHIFT  (_IOC_NRSHIFT+_IOC_NRBITS)
-#define _IOC_SIZESHIFT  (_IOC_TYPESHIFT+_IOC_TYPEBITS)
-#define _IOC_DIRSHIFT   (_IOC_SIZESHIFT+_IOC_SIZEBITS)
-
-/*
- * Direction bits.
- */
-#define _IOC_NONE       0U
-#define _IOC_WRITE      1U
-#define _IOC_READ       2U
-
-#define _IOC(dir,type,nr,size) (((dir)  << _IOC_DIRSHIFT) | ((type) << _IOC_TYPESHIFT) | ((nr)   << _IOC_NRSHIFT) | ((size) << _IOC_SIZESHIFT))
-
-/* used to create numbers */
-#define _IO(type,nr)	    _IOC(_IOC_NONE,(type),(nr),0)
-#define _IOR(type,nr,size)      _IOC(_IOC_READ,(type),(nr),sizeof(size))
-#define _IOW(type,nr,size)      _IOC(_IOC_WRITE,(type),(nr),sizeof(size))
-#define _IOWR(type,nr,size)     _IOC(_IOC_READ|_IOC_WRITE,(type),(nr),sizeof(size))
-
-/* used to decode ioctl numbers.. */
-#define _IOC_DIR(nr)	    (((nr) >> _IOC_DIRSHIFT) & _IOC_DIRMASK)
-#define _IOC_TYPE(nr)	   (((nr) >> _IOC_TYPESHIFT) & _IOC_TYPEMASK)
-#define _IOC_NR(nr)	     (((nr) >> _IOC_NRSHIFT) & _IOC_NRMASK)
-#define _IOC_SIZE(nr)	   (((nr) >> _IOC_SIZESHIFT) & _IOC_SIZEMASK)
-
-/* ...and for the drivers/sound files... */
-
-#define IOC_IN	  (_IOC_WRITE << _IOC_DIRSHIFT)
-#define IOC_OUT	 (_IOC_READ << _IOC_DIRSHIFT)
-#define IOC_INOUT       ((_IOC_WRITE|_IOC_READ) << _IOC_DIRSHIFT)
-#define IOCSIZE_MASK    (_IOC_SIZEMASK << _IOC_SIZESHIFT)
-#define IOCSIZE_SHIFT   (_IOC_SIZESHIFT)
-
-#endif /* _IOWR */
-- 
1.8.5.3

