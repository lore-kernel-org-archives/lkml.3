Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288Ab3KRETL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 23:19:11 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:50027 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3KRETC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 23:19:02 -0500
Message-ID: <528995B6.8010909@gmail.com>
Date: Mon, 18 Nov 2013 12:21:10 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "dhowells@redhat.com" <dhowells@redhat.com>, eliezer.tamir@linux.intel.com,
        bernat@luffy.cx, therbert@google.com, jacob.e.keller@intel.com
CC: David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: frv: uapi: be sure of "_UAPI" prefix for all guard
 macros
References: <52899429.4070604@gmail.com>
In-Reply-To: <52899429.4070604@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 12:14 PM, Chen Gang wrote:
> For all uapi headers, need use "_UAPI" prefix for its guard macro
> (which will be stripped by "scripts/headers_installer.sh").
> 
> Also be sure that all standard header files have their guard macros,
> and remove all files which only "asm-generic" related (add 'generic-by'
> in "Kbuild").
> 

I removed all files which only includes related "asm-generic" header
file in its real contents, and did not care about whether it has guard
macro or not (e.g. "errno.h"), can it cause issue?

BTW: I also changed my Signed-off-by mail address (I am a 'free' guy
which no 'job' now).


Thanks.

> Also be sure that all "#endif" are followed with correct comments, and
> single empty line after "#ifndef" and/or before "#endif", and no empty
> lines after "#endif".
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/frv/include/uapi/asm/Kbuild        |   19 ++++++++++---------
>  arch/frv/include/uapi/asm/auxvec.h      |    6 +++---
>  arch/frv/include/uapi/asm/bitsperlong.h |    1 -
>  arch/frv/include/uapi/asm/byteorder.h   |    6 +++---
>  arch/frv/include/uapi/asm/errno.h       |    7 -------
>  arch/frv/include/uapi/asm/fcntl.h       |    1 -
>  arch/frv/include/uapi/asm/ioctl.h       |    1 -
>  arch/frv/include/uapi/asm/ioctls.h      |    7 +++----
>  arch/frv/include/uapi/asm/ipcbuf.h      |    1 -
>  arch/frv/include/uapi/asm/kvm_para.h    |    1 -
>  arch/frv/include/uapi/asm/mman.h        |    1 -
>  arch/frv/include/uapi/asm/msgbuf.h      |    7 +++----
>  arch/frv/include/uapi/asm/param.h       |    6 +++---
>  arch/frv/include/uapi/asm/poll.h        |    7 +++----
>  arch/frv/include/uapi/asm/posix_types.h |    7 +++----
>  arch/frv/include/uapi/asm/registers.h   |    6 +++---
>  arch/frv/include/uapi/asm/resource.h    |    7 -------
>  arch/frv/include/uapi/asm/sembuf.h      |    6 +++---
>  arch/frv/include/uapi/asm/setup.h       |    1 -
>  arch/frv/include/uapi/asm/shmbuf.h      |    7 +++----
>  arch/frv/include/uapi/asm/sigcontext.h  |    6 +++---
>  arch/frv/include/uapi/asm/siginfo.h     |    7 +++----
>  arch/frv/include/uapi/asm/socket.h      |    7 +++----
>  arch/frv/include/uapi/asm/sockios.h     |    7 +++----
>  arch/frv/include/uapi/asm/statfs.h      |    7 -------
>  arch/frv/include/uapi/asm/swab.h        |    6 +++---
>  arch/frv/include/uapi/asm/termbits.h    |    7 +++----
>  arch/frv/include/uapi/asm/termios.h     |    1 -
>  arch/frv/include/uapi/asm/types.h       |    5 +++++
>  29 files changed, 63 insertions(+), 95 deletions(-)
>  delete mode 100644 arch/frv/include/uapi/asm/bitsperlong.h
>  delete mode 100644 arch/frv/include/uapi/asm/errno.h
>  delete mode 100644 arch/frv/include/uapi/asm/fcntl.h
>  delete mode 100644 arch/frv/include/uapi/asm/ioctl.h
>  delete mode 100644 arch/frv/include/uapi/asm/ipcbuf.h
>  delete mode 100644 arch/frv/include/uapi/asm/kvm_para.h
>  delete mode 100644 arch/frv/include/uapi/asm/mman.h
>  delete mode 100644 arch/frv/include/uapi/asm/resource.h
>  delete mode 100644 arch/frv/include/uapi/asm/statfs.h
> 
> diff --git a/arch/frv/include/uapi/asm/Kbuild b/arch/frv/include/uapi/asm/Kbuild
> index 42a2b33..2c86d64 100644
> --- a/arch/frv/include/uapi/asm/Kbuild
> +++ b/arch/frv/include/uapi/asm/Kbuild
> @@ -1,23 +1,25 @@
>  # UAPI Header export list
>  include include/uapi/asm-generic/Kbuild.asm
>  
> +generic-y += bitsperlong.h
> +generic-y += errno.h
> +generic-y += fcntl.h
> +generic-y += ioctl.h
> +generic-y += ipcbuf.h
> +generic-y += kvm_para.h
> +generic-y += mman.h
> +generic-y += resource.h
> +generic-y += statfs.h
> +
>  header-y += auxvec.h
> -header-y += bitsperlong.h
>  header-y += byteorder.h
> -header-y += errno.h
> -header-y += fcntl.h
> -header-y += ioctl.h
>  header-y += ioctls.h
> -header-y += ipcbuf.h
> -header-y += kvm_para.h
> -header-y += mman.h
>  header-y += msgbuf.h
>  header-y += param.h
>  header-y += poll.h
>  header-y += posix_types.h
>  header-y += ptrace.h
>  header-y += registers.h
> -header-y += resource.h
>  header-y += sembuf.h
>  header-y += setup.h
>  header-y += shmbuf.h
> @@ -27,7 +29,6 @@ header-y += signal.h
>  header-y += socket.h
>  header-y += sockios.h
>  header-y += stat.h
> -header-y += statfs.h
>  header-y += swab.h
>  header-y += termbits.h
>  header-y += termios.h
> diff --git a/arch/frv/include/uapi/asm/auxvec.h b/arch/frv/include/uapi/asm/auxvec.h
> index 0771077..58fbd7c 100644
> --- a/arch/frv/include/uapi/asm/auxvec.h
> +++ b/arch/frv/include/uapi/asm/auxvec.h
> @@ -1,4 +1,4 @@
> -#ifndef __FRV_AUXVEC_H
> -#define __FRV_AUXVEC_H
> +#ifndef _UAPI__FRV_AUXVEC_H
> +#define _UAPI__FRV_AUXVEC_H
>  
> -#endif
> +#endif /* _UAPI__FRV_AUXVEC_H */
> diff --git a/arch/frv/include/uapi/asm/bitsperlong.h b/arch/frv/include/uapi/asm/bitsperlong.h
> deleted file mode 100644
> index 6dc0bb0..0000000
> --- a/arch/frv/include/uapi/asm/bitsperlong.h
> +++ /dev/null
> @@ -1 +0,0 @@
> -#include <asm-generic/bitsperlong.h>
> diff --git a/arch/frv/include/uapi/asm/byteorder.h b/arch/frv/include/uapi/asm/byteorder.h
> index f29b759..460aa32 100644
> --- a/arch/frv/include/uapi/asm/byteorder.h
> +++ b/arch/frv/include/uapi/asm/byteorder.h
> @@ -1,6 +1,6 @@
> -#ifndef _ASM_BYTEORDER_H
> -#define _ASM_BYTEORDER_H
> +#ifndef _UAPI_ASM_BYTEORDER_H
> +#define _UAPI_ASM_BYTEORDER_H
>  
>  #include <linux/byteorder/big_endian.h>
>  
> -#endif /* _ASM_BYTEORDER_H */
> +#endif /* _UAPI_ASM_BYTEORDER_H */
> diff --git a/arch/frv/include/uapi/asm/errno.h b/arch/frv/include/uapi/asm/errno.h
> deleted file mode 100644
> index d010795..0000000
> --- a/arch/frv/include/uapi/asm/errno.h
> +++ /dev/null
> @@ -1,7 +0,0 @@
> -#ifndef _ASM_ERRNO_H
> -#define _ASM_ERRNO_H
> -
> -#include <asm-generic/errno.h>
> -
> -#endif /* _ASM_ERRNO_H */
> -
> diff --git a/arch/frv/include/uapi/asm/fcntl.h b/arch/frv/include/uapi/asm/fcntl.h
> deleted file mode 100644
> index 46ab12d..0000000
> --- a/arch/frv/include/uapi/asm/fcntl.h
> +++ /dev/null
> @@ -1 +0,0 @@
> -#include <asm-generic/fcntl.h>
> diff --git a/arch/frv/include/uapi/asm/ioctl.h b/arch/frv/include/uapi/asm/ioctl.h
> deleted file mode 100644
> index b279fe0..0000000
> --- a/arch/frv/include/uapi/asm/ioctl.h
> +++ /dev/null
> @@ -1 +0,0 @@
> -#include <asm-generic/ioctl.h>
> diff --git a/arch/frv/include/uapi/asm/ioctls.h b/arch/frv/include/uapi/asm/ioctls.h
> index 2f9fb43..b56bac9 100644
> --- a/arch/frv/include/uapi/asm/ioctls.h
> +++ b/arch/frv/include/uapi/asm/ioctls.h
> @@ -1,10 +1,9 @@
> -#ifndef __ASM_IOCTLS_H__
> -#define __ASM_IOCTLS_H__
> +#ifndef _UAPI__ASM_IOCTLS_H__
> +#define _UAPI__ASM_IOCTLS_H__
>  
>  #define TIOCTTYGSTRUCT	0x5426  /* For debugging only */
>  #define FIOQSIZE	0x545E
>  
>  #include <asm-generic/ioctls.h>
>  
> -#endif /* __ASM_IOCTLS_H__ */
> -
> +#endif /* _UAPI__ASM_IOCTLS_H__ */
> diff --git a/arch/frv/include/uapi/asm/ipcbuf.h b/arch/frv/include/uapi/asm/ipcbuf.h
> deleted file mode 100644
> index 84c7e51..0000000
> --- a/arch/frv/include/uapi/asm/ipcbuf.h
> +++ /dev/null
> @@ -1 +0,0 @@
> -#include <asm-generic/ipcbuf.h>
> diff --git a/arch/frv/include/uapi/asm/kvm_para.h b/arch/frv/include/uapi/asm/kvm_para.h
> deleted file mode 100644
> index 14fab8f..0000000
> --- a/arch/frv/include/uapi/asm/kvm_para.h
> +++ /dev/null
> @@ -1 +0,0 @@
> -#include <asm-generic/kvm_para.h>
> diff --git a/arch/frv/include/uapi/asm/mman.h b/arch/frv/include/uapi/asm/mman.h
> deleted file mode 100644
> index 8eebf89..0000000
> --- a/arch/frv/include/uapi/asm/mman.h
> +++ /dev/null
> @@ -1 +0,0 @@
> -#include <asm-generic/mman.h>
> diff --git a/arch/frv/include/uapi/asm/msgbuf.h b/arch/frv/include/uapi/asm/msgbuf.h
> index 97ceb55..695fed5 100644
> --- a/arch/frv/include/uapi/asm/msgbuf.h
> +++ b/arch/frv/include/uapi/asm/msgbuf.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_MSGBUF_H
> -#define _ASM_MSGBUF_H
> +#ifndef _UAPI_ASM_MSGBUF_H
> +#define _UAPI_ASM_MSGBUF_H
>  
>  /*
>   * The msqid64_ds structure for FR-V architecture.
> @@ -28,5 +28,4 @@ struct msqid64_ds {
>  	unsigned long		__unused5;
>  };
>  
> -#endif /* _ASM_MSGBUF_H */
> -
> +#endif /* _UAPI_ASM_MSGBUF_H */
> diff --git a/arch/frv/include/uapi/asm/param.h b/arch/frv/include/uapi/asm/param.h
> index a52dca9..cdfe2eb 100644
> --- a/arch/frv/include/uapi/asm/param.h
> +++ b/arch/frv/include/uapi/asm/param.h
> @@ -1,8 +1,8 @@
> -#ifndef _ASM_PARAM_H
> -#define _ASM_PARAM_H
> +#ifndef _UAPI_ASM_PARAM_H
> +#define _UAPI_ASM_PARAM_H
>  
>  #define EXEC_PAGESIZE	16384
>  
>  #include <asm-generic/param.h>
>  
> -#endif /* _ASM_PARAM_H */
> +#endif /* _UAPI_ASM_PARAM_H */
> diff --git a/arch/frv/include/uapi/asm/poll.h b/arch/frv/include/uapi/asm/poll.h
> index 0d01479..a17566c 100644
> --- a/arch/frv/include/uapi/asm/poll.h
> +++ b/arch/frv/include/uapi/asm/poll.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_POLL_H
> -#define _ASM_POLL_H
> +#ifndef _UAPI_ASM_POLL_H
> +#define _UAPI_ASM_POLL_H
>  
>  #define POLLWRNORM	POLLOUT
>  #define POLLWRBAND	256
> @@ -8,5 +8,4 @@
>  
>  #undef POLLREMOVE
>  
> -#endif
> -
> +#endif /* _UAPI_ASM_POLL_H */
> diff --git a/arch/frv/include/uapi/asm/posix_types.h b/arch/frv/include/uapi/asm/posix_types.h
> index fe512af..8380257 100644
> --- a/arch/frv/include/uapi/asm/posix_types.h
> +++ b/arch/frv/include/uapi/asm/posix_types.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_POSIX_TYPES_H
> -#define _ASM_POSIX_TYPES_H
> +#ifndef _UAPI_ASM_POSIX_TYPES_H
> +#define _UAPI_ASM_POSIX_TYPES_H
>  
>  /*
>   * This file is generally used by user-level software, so you need to
> @@ -22,5 +22,4 @@ typedef unsigned short	__kernel_old_dev_t;
>  
>  #include <asm-generic/posix_types.h>
>  
> -#endif
> -
> +#endif /* _UAPI_ASM_POSIX_TYPES_H */
> diff --git a/arch/frv/include/uapi/asm/registers.h b/arch/frv/include/uapi/asm/registers.h
> index 9666119..00301c4 100644
> --- a/arch/frv/include/uapi/asm/registers.h
> +++ b/arch/frv/include/uapi/asm/registers.h
> @@ -53,8 +53,8 @@
>   * note that GR28 points to the current exception frame
>   */
>  
> -#ifndef _ASM_REGISTERS_H
> -#define _ASM_REGISTERS_H
> +#ifndef _UAPI_ASM_REGISTERS_H
> +#define _UAPI_ASM_REGISTERS_H
>  
>  #ifndef __ASSEMBLY__
>  #define __OFFSET(X,N)	((X)+(N)*4)
> @@ -229,4 +229,4 @@ struct frv_frame0 {
>  
>  #define __THREAD_GR(R)		__OFFSET(__THREAD_GR16,		(R) - 16)
>  
> -#endif /* _ASM_REGISTERS_H */
> +#endif /* _UAPI_ASM_REGISTERS_H */
> diff --git a/arch/frv/include/uapi/asm/resource.h b/arch/frv/include/uapi/asm/resource.h
> deleted file mode 100644
> index 5fc6054..0000000
> --- a/arch/frv/include/uapi/asm/resource.h
> +++ /dev/null
> @@ -1,7 +0,0 @@
> -#ifndef _ASM_RESOURCE_H
> -#define _ASM_RESOURCE_H
> -
> -#include <asm-generic/resource.h>
> -
> -#endif /* _ASM_RESOURCE_H */
> -
> diff --git a/arch/frv/include/uapi/asm/sembuf.h b/arch/frv/include/uapi/asm/sembuf.h
> index 164b127..0024ddf 100644
> --- a/arch/frv/include/uapi/asm/sembuf.h
> +++ b/arch/frv/include/uapi/asm/sembuf.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_SEMBUF_H
> -#define _ASM_SEMBUF_H
> +#ifndef _UAPI_ASM_SEMBUF_H
> +#define _UAPI_ASM_SEMBUF_H
>  
>  /*
>   * The semid64_ds structure for FR-V architecture.
> @@ -22,5 +22,5 @@ struct semid64_ds {
>  	unsigned long		__unused4;
>  };
>  
> -#endif /* _ASM_SEMBUF_H */
> +#endif /* _UAPI_ASM_SEMBUF_H */
>  
> diff --git a/arch/frv/include/uapi/asm/setup.h b/arch/frv/include/uapi/asm/setup.h
> index fbf3fc9..8c39e05 100644
> --- a/arch/frv/include/uapi/asm/setup.h
> +++ b/arch/frv/include/uapi/asm/setup.h
> @@ -14,5 +14,4 @@
>  
>  #define COMMAND_LINE_SIZE       512
>  
> -
>  #endif /* _UAPI_ASM_SETUP_H */
> diff --git a/arch/frv/include/uapi/asm/shmbuf.h b/arch/frv/include/uapi/asm/shmbuf.h
> index 4c6e711..59c763b 100644
> --- a/arch/frv/include/uapi/asm/shmbuf.h
> +++ b/arch/frv/include/uapi/asm/shmbuf.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_SHMBUF_H
> -#define _ASM_SHMBUF_H
> +#ifndef _UAPI_ASM_SHMBUF_H
> +#define _UAPI_ASM_SHMBUF_H
>  
>  /*
>   * The shmid64_ds structure for FR-V architecture.
> @@ -39,5 +39,4 @@ struct shminfo64 {
>  	unsigned long	__unused4;
>  };
>  
> -#endif /* _ASM_SHMBUF_H */
> -
> +#endif /* _UAPI_ASM_SHMBUF_H */
> diff --git a/arch/frv/include/uapi/asm/sigcontext.h b/arch/frv/include/uapi/asm/sigcontext.h
> index 3b263f3..d3bbf00 100644
> --- a/arch/frv/include/uapi/asm/sigcontext.h
> +++ b/arch/frv/include/uapi/asm/sigcontext.h
> @@ -8,8 +8,8 @@
>   * as published by the Free Software Foundation; either version
>   * 2 of the License, or (at your option) any later version.
>   */
> -#ifndef _ASM_SIGCONTEXT_H
> -#define _ASM_SIGCONTEXT_H
> +#ifndef _UAPI_ASM_SIGCONTEXT_H
> +#define _UAPI_ASM_SIGCONTEXT_H
>  
>  #include <asm/registers.h>
>  
> @@ -23,4 +23,4 @@ struct sigcontext {
>  	unsigned long		sc_oldmask; 	/* old sigmask */
>  } __attribute__((aligned(8)));
>  
> -#endif
> +#endif /* _UAPI_ASM_SIGCONTEXT_H */
> diff --git a/arch/frv/include/uapi/asm/siginfo.h b/arch/frv/include/uapi/asm/siginfo.h
> index d3fd1ca..8a22f3c 100644
> --- a/arch/frv/include/uapi/asm/siginfo.h
> +++ b/arch/frv/include/uapi/asm/siginfo.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_SIGINFO_H
> -#define _ASM_SIGINFO_H
> +#ifndef _UAPI_ASM_SIGINFO_H
> +#define _UAPI_ASM_SIGINFO_H
>  
>  #include <linux/types.h>
>  #include <asm-generic/siginfo.h>
> @@ -8,5 +8,4 @@
>  #undef NSIGFPE
>  #define NSIGFPE		9
>  
> -#endif
> -
> +#endif /* _UAPI_ASM_SIGINFO_H */
> diff --git a/arch/frv/include/uapi/asm/socket.h b/arch/frv/include/uapi/asm/socket.h
> index 5d42997..c2316fa 100644
> --- a/arch/frv/include/uapi/asm/socket.h
> +++ b/arch/frv/include/uapi/asm/socket.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_SOCKET_H
> -#define _ASM_SOCKET_H
> +#ifndef _UAPI_ASM_SOCKET_H
> +#define _UAPI_ASM_SOCKET_H
>  
>  #include <asm/sockios.h>
>  
> @@ -78,5 +78,4 @@
>  
>  #define SO_MAX_PACING_RATE	47
>  
> -#endif /* _ASM_SOCKET_H */
> -
> +#endif /* _UAPI_ASM_SOCKET_H */
> diff --git a/arch/frv/include/uapi/asm/sockios.h b/arch/frv/include/uapi/asm/sockios.h
> index 5dbdd13..331a381 100644
> --- a/arch/frv/include/uapi/asm/sockios.h
> +++ b/arch/frv/include/uapi/asm/sockios.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_SOCKIOS__
> -#define _ASM_SOCKIOS__
> +#ifndef _UAPI_ASM_SOCKIOS__
> +#define _UAPI_ASM_SOCKIOS__
>  
>  /* Socket-level I/O control calls. */
>  #define FIOSETOWN 	0x8901
> @@ -10,5 +10,4 @@
>  #define SIOCGSTAMP	0x8906		/* Get stamp (timeval) */
>  #define SIOCGSTAMPNS	0x8907		/* Get stamp (timespec) */
>  
> -#endif /* _ASM_SOCKIOS__ */
> -
> +#endif /* _UAPI_ASM_SOCKIOS__ */
> diff --git a/arch/frv/include/uapi/asm/statfs.h b/arch/frv/include/uapi/asm/statfs.h
> deleted file mode 100644
> index 741f586..0000000
> --- a/arch/frv/include/uapi/asm/statfs.h
> +++ /dev/null
> @@ -1,7 +0,0 @@
> -#ifndef _ASM_STATFS_H
> -#define _ASM_STATFS_H
> -
> -#include <asm-generic/statfs.h>
> -
> -#endif /* _ASM_STATFS_H */
> -
> diff --git a/arch/frv/include/uapi/asm/swab.h b/arch/frv/include/uapi/asm/swab.h
> index f305834..a13bde4 100644
> --- a/arch/frv/include/uapi/asm/swab.h
> +++ b/arch/frv/include/uapi/asm/swab.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_SWAB_H
> -#define _ASM_SWAB_H
> +#ifndef _UAPI_ASM_SWAB_H
> +#define _UAPI_ASM_SWAB_H
>  
>  #include <linux/types.h>
>  
> @@ -7,4 +7,4 @@
>  #  define __SWAB_64_THRU_32__
>  #endif
>  
> -#endif /* _ASM_SWAB_H */
> +#endif /* _UAPI_ASM_SWAB_H */
> diff --git a/arch/frv/include/uapi/asm/termbits.h b/arch/frv/include/uapi/asm/termbits.h
> index 7722e19..5754202 100644
> --- a/arch/frv/include/uapi/asm/termbits.h
> +++ b/arch/frv/include/uapi/asm/termbits.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_TERMBITS_H__
> -#define _ASM_TERMBITS_H__
> +#ifndef _UAPI_ASM_TERMBITS_H__
> +#define _UAPI_ASM_TERMBITS_H__
>  
>  #include <linux/posix_types.h>
>  
> @@ -199,5 +199,4 @@ struct ktermios {
>  #define	TCSADRAIN	1
>  #define	TCSAFLUSH	2
>  
> -#endif /* _ASM_TERMBITS_H__ */
> -
> +#endif /* _UAPI_ASM_TERMBITS_H__ */
> diff --git a/arch/frv/include/uapi/asm/termios.h b/arch/frv/include/uapi/asm/termios.h
> index edcc08a..5111bfa 100644
> --- a/arch/frv/include/uapi/asm/termios.h
> +++ b/arch/frv/include/uapi/asm/termios.h
> @@ -42,5 +42,4 @@ struct termio {
>  
>  /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
>  
> -
>  #endif /* _UAPI_ASM_TERMIOS_H */
> diff --git a/arch/frv/include/uapi/asm/types.h b/arch/frv/include/uapi/asm/types.h
> index cf23149..390361c 100644
> --- a/arch/frv/include/uapi/asm/types.h
> +++ b/arch/frv/include/uapi/asm/types.h
> @@ -8,4 +8,9 @@
>   * as published by the Free Software Foundation; either version
>   * 2 of the License, or (at your option) any later version.
>   */
> +#ifndef _UAPI_ASM_FRV_TYPES_H
> +#define _UAPI_ASM_FRV_TYPES_H
> +
>  #include <asm-generic/int-ll64.h>
> +
> +#endif /* _UAPI_ASM_FRV_TYPES_H */
> 


-- 
Chen Gang
