Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934461Ab3CZOEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:04:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52916 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933930Ab3CZOEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:04:40 -0400
Date: Tue, 26 Mar 2013 14:04:37 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Sebastian Gottschall (DD-WRT)" <s.gottschall@dd-wrt.com>
Subject: Re: signal: Define __ARCH_HAS_SA_RESTORER so we know whether to
 clear sa_restorer
Message-ID: <20130326140437.GB3542@hercules>
References: <514A07DC.60708@dd-wrt.com>
 <514A1F7A.6090407@dd-wrt.com>
 <1363830108.31336.83.camel@deadeye.wl.decadent.org.uk>
 <1364273142.3520.16.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364273142.3520.16.camel@deadeye.wl.decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 04:45:42AM +0000, Ben Hutchings wrote:
> On Thu, 2013-03-21 at 01:41 +0000, Ben Hutchings wrote:
> > On Wed, 2013-03-20 at 21:43 +0100, Sebastian Gottschall (DD-WRT) wrote:
> > > Am 20.03.2013 20:02, schrieb Sebastian Gottschall (DD-WRT):
> > > > Hello
> > > >
> > > > The patch for sa_restorer will break mips builds, since sa_restorer 
> > > > isnt defined as field within the struct, but the MACRO is.
> > > > so use the __ARCH_HAS_SA_RESTORER way which is implemented in that way 
> > > > in linux 3.9 or simply revert the patch
> > 
> > This also appears to break blackfin, ia64, parisc and tile.
> > 
> > I think for earlier 3.x.y series we can use one of the attached
> > (untested) patches to define __ARCH_HAS_SA_RESTORER appropriately, and
> > then apply the upstream change:
> > 
> > commit 522cff142d7d2f9230839c9e1f21a4d8bcc22a4a
> > Author: Andrew Morton <akpm@linux-foundation.org>
> > Date:   Wed Mar 13 14:59:34 2013 -0700
> > 
> >     kernel/signal.c: use __ARCH_HAS_SA_RESTORER instead of SA_RESTORER
> > 
> > Ben.
> 
> The Debian package of 3.2.41, which included these two patches, built on
> mips and ia64.  (Actually it failed on ia64, but *compilation* was
> successful.)
> 
> (This does not, of course, prove that I didn't un-fix the information
> leak.)
> 
> Here is the first patch again (separate versions for 3.8.y and for
> earlier series), now with a more accurate subject line.  I'm going to
> include this in 3.2.42.

Thanks a lot Ben.  I'm queuing it for 3.5.

Cheers,
--
Luis


> 
> Ben.
> 
> -- 
> Ben Hutchings
> The two most common things in the universe are hydrogen and stupidity.
> 

> From: Ben Hutchings <ben@decadent.org.uk>
> Date: Sun, 25 Nov 2012 22:24:19 -0500
> Subject: signal: Define __ARCH_HAS_SA_RESTORER so we know whether to clear sa_restorer
> 
> flush_signal_handlers() needs to know whether sigaction::sa_restorer
> is defined, not whether SA_RESTORER is defined.  Define the
> __ARCH_HAS_SA_RESTORER macro to indicate this.
> 
> Vaguely based on upstream commit 574c4866e33d 'consolidate kernel-side
> struct sigaction declarations'.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> ---
> --- a/arch/arm/include/asm/signal.h
> +++ b/arch/arm/include/asm/signal.h
> @@ -127,6 +127,7 @@ struct sigaction {
>  	__sigrestore_t sa_restorer;
>  	sigset_t sa_mask;		/* mask last for extensibility */
>  };
> +#define __ARCH_HAS_SA_RESTORER
>  
>  struct k_sigaction {
>  	struct sigaction sa;
> --- a/arch/avr32/include/asm/signal.h
> +++ b/arch/avr32/include/asm/signal.h
> @@ -128,6 +128,7 @@ struct sigaction {
>  	__sigrestore_t sa_restorer;
>  	sigset_t sa_mask;		/* mask last for extensibility */
>  };
> +#define __ARCH_HAS_SA_RESTORER
>  
>  struct k_sigaction {
>  	struct sigaction sa;
> --- a/arch/cris/include/asm/signal.h
> +++ b/arch/cris/include/asm/signal.h
> @@ -122,6 +122,7 @@ struct sigaction {
>  	void (*sa_restorer)(void);
>  	sigset_t sa_mask;		/* mask last for extensibility */
>  };
> +#define __ARCH_HAS_SA_RESTORER
>  
>  struct k_sigaction {
>  	struct sigaction sa;
> --- a/arch/h8300/include/asm/signal.h
> +++ b/arch/h8300/include/asm/signal.h
> @@ -121,6 +121,7 @@ struct sigaction {
>  	void (*sa_restorer)(void);
>  	sigset_t sa_mask;		/* mask last for extensibility */
>  };
> +#define __ARCH_HAS_SA_RESTORER
>  
>  struct k_sigaction {
>  	struct sigaction sa;
> --- a/arch/m32r/include/asm/signal.h
> +++ b/arch/m32r/include/asm/signal.h
> @@ -123,6 +123,7 @@ struct sigaction {
>  	__sigrestore_t sa_restorer;
>  	sigset_t sa_mask;		/* mask last for extensibility */
>  };
> +#define __ARCH_HAS_SA_RESTORER
>  
>  struct k_sigaction {
>  	struct sigaction sa;
> --- a/arch/m68k/include/asm/signal.h
> +++ b/arch/m68k/include/asm/signal.h
> @@ -119,6 +119,7 @@ struct sigaction {
>  	__sigrestore_t sa_restorer;
>  	sigset_t sa_mask;		/* mask last for extensibility */
>  };
> +#define __ARCH_HAS_SA_RESTORER
>  
>  struct k_sigaction {
>  	struct sigaction sa;
> --- a/arch/mn10300/include/asm/signal.h
> +++ b/arch/mn10300/include/asm/signal.h
> @@ -131,6 +131,7 @@ struct sigaction {
>  	__sigrestore_t sa_restorer;
>  	sigset_t sa_mask;		/* mask last for extensibility */
>  };
> +#define __ARCH_HAS_SA_RESTORER
>  
>  struct k_sigaction {
>  	struct sigaction sa;
> --- a/arch/powerpc/include/asm/signal.h
> +++ b/arch/powerpc/include/asm/signal.h
> @@ -109,6 +109,7 @@ struct sigaction {
>  	__sigrestore_t sa_restorer;
>  	sigset_t sa_mask;		/* mask last for extensibility */
>  };
> +#define __ARCH_HAS_SA_RESTORER
>  
>  struct k_sigaction {
>  	struct sigaction sa;
> --- a/arch/s390/include/asm/signal.h
> +++ b/arch/s390/include/asm/signal.h
> @@ -131,6 +131,7 @@ struct sigaction {
>          void (*sa_restorer)(void);
>          sigset_t sa_mask;               /* mask last for extensibility */
>  };
> +#define __ARCH_HAS_SA_RESTORER
>  
>  struct k_sigaction {
>          struct sigaction sa;
> --- a/arch/sparc/include/asm/signal.h
> +++ b/arch/sparc/include/asm/signal.h
> @@ -191,6 +191,7 @@ struct __old_sigaction {
>  	unsigned long		sa_flags;
>  	void			(*sa_restorer)(void);  /* not used by Linux/SPARC yet */
>  };
> +#define __ARCH_HAS_SA_RESTORER
>  
>  typedef struct sigaltstack {
>  	void			__user *ss_sp;
> --- a/arch/x86/include/asm/signal.h
> +++ b/arch/x86/include/asm/signal.h
> @@ -125,6 +125,8 @@ typedef unsigned long sigset_t;
>  extern void do_notify_resume(struct pt_regs *, void *, __u32);
>  # endif /* __KERNEL__ */
>  
> +#define __ARCH_HAS_SA_RESTORER
> +
>  #ifdef __i386__
>  # ifdef __KERNEL__
>  struct old_sigaction {
> --- a/arch/xtensa/include/asm/signal.h
> +++ b/arch/xtensa/include/asm/signal.h
> @@ -133,6 +133,7 @@ struct sigaction {
>  	void (*sa_restorer)(void);
>  	sigset_t sa_mask;		/* mask last for extensibility */
>  };
> +#define __ARCH_HAS_SA_RESTORER
>  
>  struct k_sigaction {
>  	struct sigaction sa;
> --- a/include/asm-generic/signal.h
> +++ b/include/asm-generic/signal.h
> @@ -99,6 +99,10 @@ typedef unsigned long old_sigset_t;
>  
>  #include <asm-generic/signal-defs.h>
>  
> +#ifdef SA_RESTORER
> +#define __ARCH_HAS_SA_RESTORER
> +#endif
> +
>  struct sigaction {
>  	__sighandler_t sa_handler;
>  	unsigned long sa_flags;

> From: Ben Hutchings <ben@decadent.org.uk>
> Date: Sun, 25 Nov 2012 22:24:19 -0500
> Subject: signal: Define __ARCH_HAS_SA_RESTORER so we know whether to clear sa_restorer
> 
> flush_signal_handlers() needs to know whether sigaction::sa_restorer
> is defined, not whether SA_RESTORER is defined.  Define the
> __ARCH_HAS_SA_RESTORER macro to indicate this.
> 
> Vaguely based on upstream commit 574c4866e33d 'consolidate kernel-side
> struct sigaction declarations'.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> ---
> --- a/arch/arm/include/asm/signal.h
> +++ b/arch/arm/include/asm/signal.h
> @@ -29,6 +29,7 @@ struct sigaction {
>  	__sigrestore_t sa_restorer;
>  	sigset_t sa_mask;		/* mask last for extensibility */
>  };
> +#define __ARCH_HAS_SA_RESTORER
>  
>  struct k_sigaction {
>  	struct sigaction sa;
> --- a/arch/avr32/include/asm/signal.h
> +++ b/arch/avr32/include/asm/signal.h
> @@ -29,6 +29,7 @@ struct sigaction {
>  	__sigrestore_t sa_restorer;
>  	sigset_t sa_mask;		/* mask last for extensibility */
>  };
> +#define __ARCH_HAS_SA_RESTORER
>  
>  struct k_sigaction {
>  	struct sigaction sa;
> --- a/arch/cris/include/asm/signal.h
> +++ b/arch/cris/include/asm/signal.h
> @@ -29,6 +29,7 @@ struct sigaction {
>  	void (*sa_restorer)(void);
>  	sigset_t sa_mask;		/* mask last for extensibility */
>  };
> +#define __ARCH_HAS_SA_RESTORER
>  
>  struct k_sigaction {
>  	struct sigaction sa;
> --- a/arch/h8300/include/asm/signal.h
> +++ b/arch/h8300/include/asm/signal.h
> @@ -29,6 +29,7 @@ struct sigaction {
>  	void (*sa_restorer)(void);
>  	sigset_t sa_mask;		/* mask last for extensibility */
>  };
> +#define __ARCH_HAS_SA_RESTORER
>  
>  struct k_sigaction {
>  	struct sigaction sa;
> --- a/arch/m32r/include/asm/signal.h
> +++ b/arch/m32r/include/asm/signal.h
> @@ -22,6 +22,7 @@ struct sigaction {
>  	__sigrestore_t sa_restorer;
>  	sigset_t sa_mask;		/* mask last for extensibility */
>  };
> +#define __ARCH_HAS_SA_RESTORER
>  
>  struct k_sigaction {
>  	struct sigaction sa;
> --- a/arch/m68k/include/asm/signal.h
> +++ b/arch/m68k/include/asm/signal.h
> @@ -29,6 +29,7 @@ struct sigaction {
>  	__sigrestore_t sa_restorer;
>  	sigset_t sa_mask;		/* mask last for extensibility */
>  };
> +#define __ARCH_HAS_SA_RESTORER
>  
>  struct k_sigaction {
>  	struct sigaction sa;
> --- a/arch/mn10300/include/asm/signal.h
> +++ b/arch/mn10300/include/asm/signal.h
> @@ -39,6 +39,7 @@ struct sigaction {
>  	__sigrestore_t sa_restorer;
>  	sigset_t sa_mask;		/* mask last for extensibility */
>  };
> +#define __ARCH_HAS_SA_RESTORER
>  
>  struct k_sigaction {
>  	struct sigaction sa;
> --- a/arch/powerpc/include/asm/signal.h
> +++ b/arch/powerpc/include/asm/signal.h
> @@ -1,6 +1,7 @@
>  #ifndef _ASM_POWERPC_SIGNAL_H
>  #define _ASM_POWERPC_SIGNAL_H
>  
> +#define __ARCH_HAS_SA_RESTORER
>  #include <uapi/asm/signal.h>
>  
>  #endif /* _ASM_POWERPC_SIGNAL_H */
> --- a/arch/s390/include/asm/signal.h
> +++ b/arch/s390/include/asm/signal.h
> @@ -34,6 +34,7 @@ struct sigaction {
>          void (*sa_restorer)(void);
>          sigset_t sa_mask;               /* mask last for extensibility */
>  };
> +#define __ARCH_HAS_SA_RESTORER
>  
>  struct k_sigaction {
>          struct sigaction sa;
> --- a/arch/sparc/include/asm/signal.h
> +++ b/arch/sparc/include/asm/signal.h
> @@ -26,5 +26,7 @@ struct k_sigaction {
>  	void			__user *ka_restorer;
>  };
>  
> +#define __ARCH_HAS_SA_RESTORER
> +
>  #endif /* !(__ASSEMBLY__) */
>  #endif /* !(__SPARC_SIGNAL_H) */
> --- a/arch/x86/include/asm/signal.h
> +++ b/arch/x86/include/asm/signal.h
> @@ -31,6 +31,9 @@ typedef sigset_t compat_sigset_t;
>  #include <uapi/asm/signal.h>
>  #ifndef __ASSEMBLY__
>  extern void do_notify_resume(struct pt_regs *, void *, __u32);
> +
> +#define __ARCH_HAS_SA_RESTORER
> +
>  #ifdef __i386__
>  struct old_sigaction {
>  	__sighandler_t sa_handler;
> --- a/arch/xtensa/include/asm/signal.h
> +++ b/arch/xtensa/include/asm/signal.h
> @@ -21,6 +21,7 @@ struct sigaction {
>  	void (*sa_restorer)(void);
>  	sigset_t sa_mask;		/* mask last for extensibility */
>  };
> +#define __ARCH_HAS_SA_RESTORER
>  
>  struct k_sigaction {
>  	struct sigaction sa;
> --- a/include/uapi/asm-generic/signal.h
> +++ b/include/uapi/asm-generic/signal.h
> @@ -93,6 +93,10 @@ typedef unsigned long old_sigset_t;
>  
>  #include <asm-generic/signal-defs.h>
>  
> +#ifdef SA_RESTORER
> +#define __ARCH_HAS_SA_RESTORER
> +#endif
> +
>  struct sigaction {
>  	__sighandler_t sa_handler;
>  	unsigned long sa_flags;


