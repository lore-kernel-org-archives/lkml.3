Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3KQLfQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 06:35:16 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37613 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab3KQLfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 06:35:11 -0500
Message-ID: <5288A9E9.9040305@gmail.com>
Date: Sun, 17 Nov 2013 19:35:05 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: starvik@axis.com, jesper.nilsson@axis.com, dhowells@redhat.com,
        paulmck@linux.vnet.ibm.com, mattst88@gmail.com, mcree@orcon.net.nz,
        geert@linux-m68k.org, eliezer.tamir@linux.intel.com,
        edumazet@google.com, bernat@luffy.cx, therbert@google.com
CC: akpm@linux-foundation.org, davem@davemloft.net, linux-cris-kernel@axis.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: cris: uapi: be sure of "_UAPI" prefix for all guard
 macros
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For all uapi headers, need use "_UAPI" prefix for its guard macro
(which will be stripped by "scripts/headers_installer.sh").

Also be sure that all standard header files have their guard macros.

Also be sure that all "#endif" are followed with correct comments, and
single empty line after "#ifndef" and/or before "#endif", and no empty
lines after "#endif".


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/cris/include/uapi/arch-v10/arch/sv_addr_ag.h |  9 +++------
 arch/cris/include/uapi/arch-v10/arch/svinto.h     |  6 +++---
 arch/cris/include/uapi/arch-v10/arch/user.h       |  6 +++---
 arch/cris/include/uapi/arch-v32/arch/cryptocop.h  |  3 ---
 arch/cris/include/uapi/arch-v32/arch/user.h       |  6 +++---
 arch/cris/include/uapi/asm/Kbuild                 | 22 ++++++++++++----------
 arch/cris/include/uapi/asm/auxvec.h               |  6 +++---
 arch/cris/include/uapi/asm/bitsperlong.h          |  1 -
 arch/cris/include/uapi/asm/byteorder.h            |  8 +++-----
 arch/cris/include/uapi/asm/errno.h                |  6 ------
 arch/cris/include/uapi/asm/ethernet.h             |  8 +++++---
 arch/cris/include/uapi/asm/etraxgpio.h            |  6 +++---
 arch/cris/include/uapi/asm/fcntl.h                |  1 -
 arch/cris/include/uapi/asm/ioctl.h                |  1 -
 arch/cris/include/uapi/asm/ioctls.h               |  6 +++---
 arch/cris/include/uapi/asm/ipcbuf.h               |  1 -
 arch/cris/include/uapi/asm/kvm_para.h             |  1 -
 arch/cris/include/uapi/asm/mman.h                 |  1 -
 arch/cris/include/uapi/asm/msgbuf.h               |  6 +++---
 arch/cris/include/uapi/asm/param.h                |  6 +++---
 arch/cris/include/uapi/asm/poll.h                 |  1 -
 arch/cris/include/uapi/asm/posix_types.h          |  6 +++---
 arch/cris/include/uapi/asm/ptrace.h               |  5 +++++
 arch/cris/include/uapi/asm/resource.h             |  6 ------
 arch/cris/include/uapi/asm/rs485.h                |  4 ++++
 arch/cris/include/uapi/asm/sembuf.h               |  6 +++---
 arch/cris/include/uapi/asm/setup.h                |  6 +++---
 arch/cris/include/uapi/asm/shmbuf.h               |  6 +++---
 arch/cris/include/uapi/asm/sigcontext.h           |  7 +++----
 arch/cris/include/uapi/asm/siginfo.h              |  6 ------
 arch/cris/include/uapi/asm/signal.h               |  1 -
 arch/cris/include/uapi/asm/socket.h               |  8 +++-----
 arch/cris/include/uapi/asm/sockios.h              |  6 +++---
 arch/cris/include/uapi/asm/stat.h                 |  6 +++---
 arch/cris/include/uapi/asm/statfs.h               |  6 ------
 arch/cris/include/uapi/asm/swab.h                 |  4 ++++
 arch/cris/include/uapi/asm/sync_serial.h          |  6 +++---
 arch/cris/include/uapi/asm/termbits.h             |  6 +++---
 arch/cris/include/uapi/asm/termios.h              |  1 -
 arch/cris/include/uapi/asm/types.h                |  5 +++++
 40 files changed, 95 insertions(+), 117 deletions(-)
 delete mode 100644 arch/cris/include/uapi/asm/bitsperlong.h
 delete mode 100644 arch/cris/include/uapi/asm/errno.h
 delete mode 100644 arch/cris/include/uapi/asm/fcntl.h
 delete mode 100644 arch/cris/include/uapi/asm/ioctl.h
 delete mode 100644 arch/cris/include/uapi/asm/ipcbuf.h
 delete mode 100644 arch/cris/include/uapi/asm/kvm_para.h
 delete mode 100644 arch/cris/include/uapi/asm/mman.h
 delete mode 100644 arch/cris/include/uapi/asm/poll.h
 delete mode 100644 arch/cris/include/uapi/asm/resource.h
 delete mode 100644 arch/cris/include/uapi/asm/siginfo.h
 delete mode 100644 arch/cris/include/uapi/asm/statfs.h

diff --git a/arch/cris/include/uapi/arch-v10/arch/sv_addr_ag.h b/arch/cris/include/uapi/arch-v10/arch/sv_addr_ag.h
index 5517f04..de850ff 100644
--- a/arch/cris/include/uapi/arch-v10/arch/sv_addr_ag.h
+++ b/arch/cris/include/uapi/arch-v10/arch/sv_addr_ag.h
@@ -13,9 +13,8 @@
 *!
 *!**************************************************************************/
 
-#ifndef __sv_addr_ag_h__
-#define __sv_addr_ag_h__
-
+#ifndef _UAPI__sv_addr_ag_h__
+#define _UAPI__sv_addr_ag_h__
 
 #define __test_sv_addr__ 0
 
@@ -134,6 +133,4 @@ IO_RD(R_EXT_DMA_0_STAT) & IO_MASK( R_EXT_DMA_0_STAT, S )
    == IO_STATE( R_EXT_DMA_0_STAT, S, STARTED )
 #endif
 
-
-#endif  /* ifndef __sv_addr_ag_h__ */
-
+#endif  /* _UAPI__sv_addr_ag_h__ */
diff --git a/arch/cris/include/uapi/arch-v10/arch/svinto.h b/arch/cris/include/uapi/arch-v10/arch/svinto.h
index da5c152..9327d3b 100644
--- a/arch/cris/include/uapi/arch-v10/arch/svinto.h
+++ b/arch/cris/include/uapi/arch-v10/arch/svinto.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_CRIS_SVINTO_H
-#define _ASM_CRIS_SVINTO_H
+#ifndef _UAPI_ASM_CRIS_SVINTO_H
+#define _UAPI_ASM_CRIS_SVINTO_H
 
 #include <arch/sv_addr_ag.h>
 
@@ -61,4 +61,4 @@ typedef struct etrax_dma_descr {
 extern void prepare_rx_descriptor(struct etrax_dma_descr *desc);
 extern void flush_etrax_cache(void);
 
-#endif
+#endif /* _UAPI_ASM_CRIS_SVINTO_H */
diff --git a/arch/cris/include/uapi/arch-v10/arch/user.h b/arch/cris/include/uapi/arch-v10/arch/user.h
index 9303ea7..2ccd4ea 100644
--- a/arch/cris/include/uapi/arch-v10/arch/user.h
+++ b/arch/cris/include/uapi/arch-v10/arch/user.h
@@ -1,5 +1,5 @@
-#ifndef __ASM_CRIS_ARCH_USER_H
-#define __ASM_CRIS_ARCH_USER_H
+#ifndef _UAPI__ASM_CRIS_ARCH_USER_H
+#define _UAPI__ASM_CRIS_ARCH_USER_H
 
 /* User mode registers, used for core dumps. In order to keep ELF_NGREG
    sensible we let all registers be 32 bits. The csr registers are included
@@ -43,4 +43,4 @@ struct user_regs_struct {
         unsigned long csrdata;
 };
 
-#endif
+#endif /* _UAPI__ASM_CRIS_ARCH_USER_H */
diff --git a/arch/cris/include/uapi/arch-v32/arch/cryptocop.h b/arch/cris/include/uapi/arch-v32/arch/cryptocop.h
index 694fd13..e3f729a 100644
--- a/arch/cris/include/uapi/arch-v32/arch/cryptocop.h
+++ b/arch/cris/include/uapi/arch-v32/arch/cryptocop.h
@@ -116,7 +116,4 @@ struct strcop_crypto_op{
 	unsigned char            csum[CRYPTOCOP_CSUM_LENGTH];
 };
 
-
-
-
 #endif /* _UAPICRYPTOCOP_H */
diff --git a/arch/cris/include/uapi/arch-v32/arch/user.h b/arch/cris/include/uapi/arch-v32/arch/user.h
index 03fa1f3..4652d1d 100644
--- a/arch/cris/include/uapi/arch-v32/arch/user.h
+++ b/arch/cris/include/uapi/arch-v32/arch/user.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_CRIS_ARCH_USER_H
-#define _ASM_CRIS_ARCH_USER_H
+#ifndef _UAPI_ASM_CRIS_ARCH_USER_H
+#define _UAPI_ASM_CRIS_ARCH_USER_H
 
 /* User-mode register used for core dumps. */
 
@@ -38,4 +38,4 @@ struct user_regs_struct {
 	unsigned long spc;	/* P15, Single step PC. */
 };
 
-#endif /* _ASM_CRIS_ARCH_USER_H */
+#endif /* _UAPI_ASM_CRIS_ARCH_USER_H */
diff --git a/arch/cris/include/uapi/asm/Kbuild b/arch/cris/include/uapi/asm/Kbuild
index 7d47b36..c7ccec3 100644
--- a/arch/cris/include/uapi/asm/Kbuild
+++ b/arch/cris/include/uapi/asm/Kbuild
@@ -1,36 +1,38 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
+generic-y += bitsperlong.h
+generic-y += errno.h
+generic-y += fcntl.h
+generic-y += ioctl.h
+generic-y += ipcbuf.h
+generic-y += kvm_para.h
+generic-y += mman.h
+generic-y += poll.h
+generic-y += resource.h
+generic-y += siginfo.h
+generic-y += statfs.h
+
 header-y += arch-v10/
 header-y += arch-v32/
 header-y += auxvec.h
-header-y += bitsperlong.h
 header-y += byteorder.h
-header-y += errno.h
 header-y += ethernet.h
 header-y += etraxgpio.h
-header-y += fcntl.h
-header-y += ioctl.h
 header-y += ioctls.h
-header-y += ipcbuf.h
-header-y += mman.h
 header-y += msgbuf.h
 header-y += param.h
-header-y += poll.h
 header-y += posix_types.h
 header-y += ptrace.h
-header-y += resource.h
 header-y += rs485.h
 header-y += sembuf.h
 header-y += setup.h
 header-y += shmbuf.h
 header-y += sigcontext.h
-header-y += siginfo.h
 header-y += signal.h
 header-y += socket.h
 header-y += sockios.h
 header-y += stat.h
-header-y += statfs.h
 header-y += swab.h
 header-y += sync_serial.h
 header-y += termbits.h
diff --git a/arch/cris/include/uapi/asm/auxvec.h b/arch/cris/include/uapi/asm/auxvec.h
index cb30b01..762b740 100644
--- a/arch/cris/include/uapi/asm/auxvec.h
+++ b/arch/cris/include/uapi/asm/auxvec.h
@@ -1,4 +1,4 @@
-#ifndef __ASMCRIS_AUXVEC_H
-#define __ASMCRIS_AUXVEC_H
+#ifndef _UAPI__ASMCRIS_AUXVEC_H
+#define _UAPI__ASMCRIS_AUXVEC_H
 
-#endif
+#endif /* _UAPI__ASMCRIS_AUXVEC_H */
diff --git a/arch/cris/include/uapi/asm/bitsperlong.h b/arch/cris/include/uapi/asm/bitsperlong.h
deleted file mode 100644
index 6dc0bb0..0000000
--- a/arch/cris/include/uapi/asm/bitsperlong.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/bitsperlong.h>
diff --git a/arch/cris/include/uapi/asm/byteorder.h b/arch/cris/include/uapi/asm/byteorder.h
index bcd1897..ed6f57b 100644
--- a/arch/cris/include/uapi/asm/byteorder.h
+++ b/arch/cris/include/uapi/asm/byteorder.h
@@ -1,8 +1,6 @@
-#ifndef _CRIS_BYTEORDER_H
-#define _CRIS_BYTEORDER_H
+#ifndef _UAPI_CRIS_BYTEORDER_H
+#define _UAPI_CRIS_BYTEORDER_H
 
 #include <linux/byteorder/little_endian.h>
 
-#endif
-
-
+#endif /* _UAPI_CRIS_BYTEORDER_H */
diff --git a/arch/cris/include/uapi/asm/errno.h b/arch/cris/include/uapi/asm/errno.h
deleted file mode 100644
index 2bf5eb5..0000000
--- a/arch/cris/include/uapi/asm/errno.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _CRIS_ERRNO_H
-#define _CRIS_ERRNO_H
-
-#include <asm-generic/errno.h>
-
-#endif
diff --git a/arch/cris/include/uapi/asm/ethernet.h b/arch/cris/include/uapi/asm/ethernet.h
index 4d58652..c530e83 100644
--- a/arch/cris/include/uapi/asm/ethernet.h
+++ b/arch/cris/include/uapi/asm/ethernet.h
@@ -7,8 +7,9 @@
  *
  */
 
-#ifndef _CRIS_ETHERNET_H
-#define _CRIS_ETHERNET_H
+#ifndef _UAPI_CRIS_ETHERNET_H
+#define _UAPI_CRIS_ETHERNET_H
+
 #define SET_ETH_SPEED_AUTO      SIOCDEVPRIVATE          /* Auto neg speed */
 #define SET_ETH_SPEED_10        SIOCDEVPRIVATE+1        /* 10 Mbps */
 #define SET_ETH_SPEED_100       SIOCDEVPRIVATE+2        /* 100 Mbps. */
@@ -18,4 +19,5 @@
 #define SET_ETH_ENABLE_LEDS     SIOCDEVPRIVATE+6        /* Enable net LEDs */
 #define SET_ETH_DISABLE_LEDS    SIOCDEVPRIVATE+7        /* Disable net LEDs */
 #define SET_ETH_AUTONEG         SIOCDEVPRIVATE+8
-#endif /* _CRIS_ETHERNET_H */
+
+#endif /* _UAPI_CRIS_ETHERNET_H */
diff --git a/arch/cris/include/uapi/asm/etraxgpio.h b/arch/cris/include/uapi/asm/etraxgpio.h
index 461c089..d45a41b 100644
--- a/arch/cris/include/uapi/asm/etraxgpio.h
+++ b/arch/cris/include/uapi/asm/etraxgpio.h
@@ -32,8 +32,8 @@
  * /dev/ppwm   minor 19, PPWM channel
  *
  */
-#ifndef _ASM_ETRAXGPIO_H
-#define _ASM_ETRAXGPIO_H
+#ifndef _UAPI_ASM_ETRAXGPIO_H
+#define _UAPI_ASM_ETRAXGPIO_H
 
 #define GPIO_MINOR_FIRST 0
 
@@ -236,4 +236,4 @@ struct gpio_pwmclk_conf {
  * baseclk = 0, low = 0, high = 0, the values will be updated by driver.
  */
 
-#endif
+#endif /* _UAPI_ASM_ETRAXGPIO_H */
diff --git a/arch/cris/include/uapi/asm/fcntl.h b/arch/cris/include/uapi/asm/fcntl.h
deleted file mode 100644
index 46ab12d..0000000
--- a/arch/cris/include/uapi/asm/fcntl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/fcntl.h>
diff --git a/arch/cris/include/uapi/asm/ioctl.h b/arch/cris/include/uapi/asm/ioctl.h
deleted file mode 100644
index b279fe0..0000000
--- a/arch/cris/include/uapi/asm/ioctl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ioctl.h>
diff --git a/arch/cris/include/uapi/asm/ioctls.h b/arch/cris/include/uapi/asm/ioctls.h
index 488fbb3..8eb483d 100644
--- a/arch/cris/include/uapi/asm/ioctls.h
+++ b/arch/cris/include/uapi/asm/ioctls.h
@@ -1,5 +1,5 @@
-#ifndef __ARCH_CRIS_IOCTLS_H__
-#define __ARCH_CRIS_IOCTLS_H__
+#ifndef _UAPI__ARCH_CRIS_IOCTLS_H__
+#define _UAPI__ARCH_CRIS_IOCTLS_H__
 
 #define TIOCSERGSTRUCT	0x5458 /* For debugging only */
 #define TIOCSERSETRS485	0x5461  /* enable rs-485 (deprecated) */
@@ -8,4 +8,4 @@
 
 #include <asm-generic/ioctls.h>
 
-#endif
+#endif /* _UAPI__ARCH_CRIS_IOCTLS_H__ */
diff --git a/arch/cris/include/uapi/asm/ipcbuf.h b/arch/cris/include/uapi/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51..0000000
--- a/arch/cris/include/uapi/asm/ipcbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipcbuf.h>
diff --git a/arch/cris/include/uapi/asm/kvm_para.h b/arch/cris/include/uapi/asm/kvm_para.h
deleted file mode 100644
index 14fab8f..0000000
--- a/arch/cris/include/uapi/asm/kvm_para.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kvm_para.h>
diff --git a/arch/cris/include/uapi/asm/mman.h b/arch/cris/include/uapi/asm/mman.h
deleted file mode 100644
index 8eebf89..0000000
--- a/arch/cris/include/uapi/asm/mman.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/mman.h>
diff --git a/arch/cris/include/uapi/asm/msgbuf.h b/arch/cris/include/uapi/asm/msgbuf.h
index ada63df..f955bdc 100644
--- a/arch/cris/include/uapi/asm/msgbuf.h
+++ b/arch/cris/include/uapi/asm/msgbuf.h
@@ -1,5 +1,5 @@
-#ifndef _CRIS_MSGBUF_H
-#define _CRIS_MSGBUF_H
+#ifndef _UAPI_CRIS_MSGBUF_H
+#define _UAPI_CRIS_MSGBUF_H
 
 /* verbatim copy of asm-i386 version */
 
@@ -30,4 +30,4 @@ struct msqid64_ds {
 	unsigned long  __unused5;
 };
 
-#endif /* _CRIS_MSGBUF_H */
+#endif /* _UAPI_CRIS_MSGBUF_H */
diff --git a/arch/cris/include/uapi/asm/param.h b/arch/cris/include/uapi/asm/param.h
index 484fcf8..fdcdede 100644
--- a/arch/cris/include/uapi/asm/param.h
+++ b/arch/cris/include/uapi/asm/param.h
@@ -1,5 +1,5 @@
-#ifndef _ASMCRIS_PARAM_H
-#define _ASMCRIS_PARAM_H
+#ifndef _UAPI_ASMCRIS_PARAM_H
+#define _UAPI_ASMCRIS_PARAM_H
 
 /* Currently we assume that HZ=100 is good for CRIS. */
 
@@ -7,4 +7,4 @@
 
 #include <asm-generic/param.h>
 
-#endif /* _ASMCRIS_PARAM_H */
+#endif /* _UAPI_ASMCRIS_PARAM_H */
diff --git a/arch/cris/include/uapi/asm/poll.h b/arch/cris/include/uapi/asm/poll.h
deleted file mode 100644
index c98509d..0000000
--- a/arch/cris/include/uapi/asm/poll.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/poll.h>
diff --git a/arch/cris/include/uapi/asm/posix_types.h b/arch/cris/include/uapi/asm/posix_types.h
index 0f22e6a..fd2b044 100644
--- a/arch/cris/include/uapi/asm/posix_types.h
+++ b/arch/cris/include/uapi/asm/posix_types.h
@@ -3,8 +3,8 @@
 /* We cheat a bit and use our C-coded bitops functions from asm/bitops.h */
 /* I guess we should write these in assembler because they are used often. */
 
-#ifndef __ARCH_CRIS_POSIX_TYPES_H
-#define __ARCH_CRIS_POSIX_TYPES_H
+#ifndef _UAPI__ARCH_CRIS_POSIX_TYPES_H
+#define _UAPI__ARCH_CRIS_POSIX_TYPES_H
 
 /*
  * This file is generally used by user-level software, so you need to
@@ -27,4 +27,4 @@ typedef unsigned short	__kernel_old_dev_t;
 
 #include <asm-generic/posix_types.h>
 
-#endif /* __ARCH_CRIS_POSIX_TYPES_H */
+#endif /* _UAPI__ARCH_CRIS_POSIX_TYPES_H */
diff --git a/arch/cris/include/uapi/asm/ptrace.h b/arch/cris/include/uapi/asm/ptrace.h
index c689c9b..1cbdd07 100644
--- a/arch/cris/include/uapi/asm/ptrace.h
+++ b/arch/cris/include/uapi/asm/ptrace.h
@@ -1 +1,6 @@
+#ifndef _UAPI_ASM_CRIS_PTRACE_H
+#define _UAPI_ASM_CRIS_PTRACE_H
+
 #include <arch/ptrace.h>
+
+#endif /* _UAPI_ASM_CRIS_PTRACE_H */
diff --git a/arch/cris/include/uapi/asm/resource.h b/arch/cris/include/uapi/asm/resource.h
deleted file mode 100644
index b5d2944..0000000
--- a/arch/cris/include/uapi/asm/resource.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _CRIS_RESOURCE_H
-#define _CRIS_RESOURCE_H
-
-#include <asm-generic/resource.h>
-
-#endif
diff --git a/arch/cris/include/uapi/asm/rs485.h b/arch/cris/include/uapi/asm/rs485.h
index ad40f9f..e1ba07f 100644
--- a/arch/cris/include/uapi/asm/rs485.h
+++ b/arch/cris/include/uapi/asm/rs485.h
@@ -1,3 +1,6 @@
+#ifndef _UAPI_ASM_CRIS_RS485_H
+#define _UAPI_ASM_CRIS_RS485_H
+
 /* RS-485 structures */
 
 /* Used with ioctl() TIOCSERSETRS485 for backward compatibility!
@@ -16,3 +19,4 @@ struct rs485_write {
         unsigned char *outc;
 };
 
+#endif /* _UAPI_ASM_CRIS_RS485_H */
diff --git a/arch/cris/include/uapi/asm/sembuf.h b/arch/cris/include/uapi/asm/sembuf.h
index 7fed984..b957c7d 100644
--- a/arch/cris/include/uapi/asm/sembuf.h
+++ b/arch/cris/include/uapi/asm/sembuf.h
@@ -1,5 +1,5 @@
-#ifndef _CRIS_SEMBUF_H
-#define _CRIS_SEMBUF_H
+#ifndef _UAPI_CRIS_SEMBUF_H
+#define _UAPI_CRIS_SEMBUF_H
 
 /* 
  * The semid64_ds structure for CRIS architecture.
@@ -22,4 +22,4 @@ struct semid64_ds {
 	unsigned long	__unused4;
 };
 
-#endif /* _CRIS_SEMBUF_H */
+#endif /* _UAPI_CRIS_SEMBUF_H */
diff --git a/arch/cris/include/uapi/asm/setup.h b/arch/cris/include/uapi/asm/setup.h
index b907286..bb1e5d1 100644
--- a/arch/cris/include/uapi/asm/setup.h
+++ b/arch/cris/include/uapi/asm/setup.h
@@ -1,6 +1,6 @@
-#ifndef _CRIS_SETUP_H
-#define _CRIS_SETUP_H
+#ifndef _UAPI_CRIS_SETUP_H
+#define _UAPI_CRIS_SETUP_H
 
 #define COMMAND_LINE_SIZE	256
 
-#endif
+#endif /* _UAPI_CRIS_SETUP_H */
diff --git a/arch/cris/include/uapi/asm/shmbuf.h b/arch/cris/include/uapi/asm/shmbuf.h
index 3239e3f..cf39143 100644
--- a/arch/cris/include/uapi/asm/shmbuf.h
+++ b/arch/cris/include/uapi/asm/shmbuf.h
@@ -1,5 +1,5 @@
-#ifndef _CRIS_SHMBUF_H
-#define _CRIS_SHMBUF_H
+#ifndef _UAPI_CRIS_SHMBUF_H
+#define _UAPI_CRIS_SHMBUF_H
 
 /* 
  * The shmid64_ds structure for CRIS architecture (same as for i386)
@@ -39,4 +39,4 @@ struct shminfo64 {
 	unsigned long	__unused4;
 };
 
-#endif /* _CRIS_SHMBUF_H */
+#endif /* _UAPI_CRIS_SHMBUF_H */
diff --git a/arch/cris/include/uapi/asm/sigcontext.h b/arch/cris/include/uapi/asm/sigcontext.h
index a1d634e..21094a9 100644
--- a/arch/cris/include/uapi/asm/sigcontext.h
+++ b/arch/cris/include/uapi/asm/sigcontext.h
@@ -1,7 +1,7 @@
 /* $Id: sigcontext.h,v 1.1 2000/07/10 16:32:31 bjornw Exp $ */
 
-#ifndef _ASM_CRIS_SIGCONTEXT_H
-#define _ASM_CRIS_SIGCONTEXT_H
+#ifndef _UAPI_ASM_CRIS_SIGCONTEXT_H
+#define _UAPI_ASM_CRIS_SIGCONTEXT_H
 
 #include <asm/ptrace.h>
 
@@ -20,5 +20,4 @@ struct sigcontext {
 	unsigned long usp;    /* usp before stacking this gunk on it */
 };
 
-#endif
-
+#endif /* _UAPI_ASM_CRIS_SIGCONTEXT_H */
diff --git a/arch/cris/include/uapi/asm/siginfo.h b/arch/cris/include/uapi/asm/siginfo.h
deleted file mode 100644
index c1cd6d1..0000000
--- a/arch/cris/include/uapi/asm/siginfo.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _CRIS_SIGINFO_H
-#define _CRIS_SIGINFO_H
-
-#include <asm-generic/siginfo.h>
-
-#endif
diff --git a/arch/cris/include/uapi/asm/signal.h b/arch/cris/include/uapi/asm/signal.h
index ce42fa7..316226e 100644
--- a/arch/cris/include/uapi/asm/signal.h
+++ b/arch/cris/include/uapi/asm/signal.h
@@ -112,5 +112,4 @@ typedef struct sigaltstack {
 	size_t ss_size;
 } stack_t;
 
-
 #endif /* _UAPI_ASM_CRIS_SIGNAL_H */
diff --git a/arch/cris/include/uapi/asm/socket.h b/arch/cris/include/uapi/asm/socket.h
index 13829aa..b5072c4 100644
--- a/arch/cris/include/uapi/asm/socket.h
+++ b/arch/cris/include/uapi/asm/socket.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_SOCKET_H
-#define _ASM_SOCKET_H
+#ifndef _UAPI_ASM_SOCKET_H
+#define _UAPI_ASM_SOCKET_H
 
 /* almost the same as asm-i386/socket.h */
 
@@ -80,6 +80,4 @@
 
 #define SO_MAX_PACING_RATE	47
 
-#endif /* _ASM_SOCKET_H */
-
-
+#endif /* _UAPI_ASM_SOCKET_H */
diff --git a/arch/cris/include/uapi/asm/sockios.h b/arch/cris/include/uapi/asm/sockios.h
index cfe7bfe..492379f 100644
--- a/arch/cris/include/uapi/asm/sockios.h
+++ b/arch/cris/include/uapi/asm/sockios.h
@@ -1,5 +1,5 @@
-#ifndef __ARCH_CRIS_SOCKIOS__
-#define __ARCH_CRIS_SOCKIOS__
+#ifndef _UAPI__ARCH_CRIS_SOCKIOS__
+#define _UAPI__ARCH_CRIS_SOCKIOS__
 
 /* Socket-level I/O control calls. */
 #define FIOSETOWN 	0x8901
@@ -10,4 +10,4 @@
 #define SIOCGSTAMP	0x8906		/* Get stamp (timeval) */
 #define SIOCGSTAMPNS	0x8907		/* Get stamp (timespec) */
 
-#endif
+#endif /* _UAPI__ARCH_CRIS_SOCKIOS__ */
diff --git a/arch/cris/include/uapi/asm/stat.h b/arch/cris/include/uapi/asm/stat.h
index 9e558cc..a9a5e92 100644
--- a/arch/cris/include/uapi/asm/stat.h
+++ b/arch/cris/include/uapi/asm/stat.h
@@ -1,5 +1,5 @@
-#ifndef _CRIS_STAT_H
-#define _CRIS_STAT_H
+#ifndef _UAPI_CRIS_STAT_H
+#define _UAPI_CRIS_STAT_H
 
 /* Keep this a verbatim copy of i386 version; tweak CRIS-specific bits in
    the kernel if necessary.  */
@@ -78,4 +78,4 @@ struct stat64 {
 	unsigned long long	st_ino;
 };
 
-#endif
+#endif /* _UAPI_CRIS_STAT_H */
diff --git a/arch/cris/include/uapi/asm/statfs.h b/arch/cris/include/uapi/asm/statfs.h
deleted file mode 100644
index fdaf921..0000000
--- a/arch/cris/include/uapi/asm/statfs.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _CRIS_STATFS_H
-#define _CRIS_STATFS_H
-
-#include <asm-generic/statfs.h>
-
-#endif
diff --git a/arch/cris/include/uapi/asm/swab.h b/arch/cris/include/uapi/asm/swab.h
index 4adf1e9..dc529dc 100644
--- a/arch/cris/include/uapi/asm/swab.h
+++ b/arch/cris/include/uapi/asm/swab.h
@@ -1,3 +1,7 @@
 /*
  * CRIS byte swapping.
  */
+#ifndef _UAPI_ASM_CRIS_SWAB_H
+#define _UAPI_ASM_CRIS_SWAB_H
+
+#endif /* _UAPI_ASM_CRIS_SWAB_H */
diff --git a/arch/cris/include/uapi/asm/sync_serial.h b/arch/cris/include/uapi/asm/sync_serial.h
index 7f827fe..1dbb407 100644
--- a/arch/cris/include/uapi/asm/sync_serial.h
+++ b/arch/cris/include/uapi/asm/sync_serial.h
@@ -7,8 +7,8 @@
  *
  */
 
-#ifndef SYNC_SERIAL_H
-#define SYNC_SERIAL_H
+#ifndef _UAPISYNC_SERIAL_H
+#define _UAPISYNC_SERIAL_H
 
 #include <linux/ioctl.h>
 
@@ -129,4 +129,4 @@ struct ssp_request {
 	struct timespec ts;	/* The time the data was sampled. */
 };
 
-#endif
+#endif /* _UAPISYNC_SERIAL_H */
diff --git a/arch/cris/include/uapi/asm/termbits.h b/arch/cris/include/uapi/asm/termbits.h
index 1c43bc8..75de680 100644
--- a/arch/cris/include/uapi/asm/termbits.h
+++ b/arch/cris/include/uapi/asm/termbits.h
@@ -1,7 +1,7 @@
 /* $Id: termbits.h,v 1.1 2000/07/10 16:32:31 bjornw Exp $ */
 
-#ifndef __ARCH_ETRAX100_TERMBITS_H__
-#define __ARCH_ETRAX100_TERMBITS_H__
+#ifndef _UAPI__ARCH_ETRAX100_TERMBITS_H__
+#define _UAPI__ARCH_ETRAX100_TERMBITS_H__
 
 #include <linux/posix_types.h>
 
@@ -232,4 +232,4 @@ struct ktermios {
 #define	TCSADRAIN	1
 #define	TCSAFLUSH	2
 
-#endif
+#endif /* _UAPI__ARCH_ETRAX100_TERMBITS_H__ */
diff --git a/arch/cris/include/uapi/asm/termios.h b/arch/cris/include/uapi/asm/termios.h
index 0a0386a..8e50dd7 100644
--- a/arch/cris/include/uapi/asm/termios.h
+++ b/arch/cris/include/uapi/asm/termios.h
@@ -41,5 +41,4 @@ struct termio {
 
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
-
 #endif /* _UAPI_CRIS_TERMIOS_H */
diff --git a/arch/cris/include/uapi/asm/types.h b/arch/cris/include/uapi/asm/types.h
index 9ec9d4c..602514d 100644
--- a/arch/cris/include/uapi/asm/types.h
+++ b/arch/cris/include/uapi/asm/types.h
@@ -1 +1,6 @@
+#ifndef _UAPI_ASM_CRIS_TYPES_H
+#define _UAPI_ASM_CRIS_TYPES_H
+
 #include <asm-generic/int-ll64.h>
+
+#endif /* _UAPI_ASM_CRIS_TYPES_H */
-- 
1.7.11.7
