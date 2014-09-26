Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbaIZSIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 14:08:20 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:53645 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbaIZSIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 14:08:18 -0400
Date: Fri, 26 Sep 2014 11:08:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Eric Paris <eparis@redhat.com>
Cc: Jonas Bonn <jonas@southpole.se>, linux@openrisc.net,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-next@vger.kernel.org,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v2] next: openrisc: Fix build
Message-ID: <20140926180813.GA19291@roeck-us.net>
References: <1411747539-28308-1-git-send-email-linux@roeck-us.net>
 <1411753981.2739.16.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411753981.2739.16.camel@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 01:53:01PM -0400, Eric Paris wrote:
> Would you like me to carry this in the audit tree, since I'm the one who
> broke it?
> 
Hi Eric,

guess you are asking Jonas, but it would make sense to me.

Guenter

> -Eric
> 
> On Fri, 2014-09-26 at 09:05 -0700, Guenter Roeck wrote:
> > openrisc:defconfig fails to build in next-20140926 with the following error.
> > 
> > In file included from arch/openrisc/kernel/signal.c:31:0:
> > ./arch/openrisc/include/asm/syscall.h: In function 'syscall_get_arch':
> > ./arch/openrisc/include/asm/syscall.h:77:9: error: 'EM_OPENRISC' undeclared
> > 
> > Fix by moving EM_OPENRISC to include/uapi/linux/elf-em.h.
> > 
> > Fixes: ce5d112827e5 ("ARCH: AUDIT: implement syscall_get_arch for all arches")
> > Cc: Eric Paris <eparis@redhat.com>
> > Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> > v2: Only move EM_OPENRISC.
> > 
> > Another possible solution for the problem would be to include asm/elf.h
> > in arch/openrisc/kernel/signal.c. I had actually submitted a patch with
> > that fix back in August (maybe that is where I remembered the problem from).
> > Wonder what happened with that patch.
> > 
> > Would it make sense to drop EM_OR32 and replace it with EM_OPENRISC where
> > it is used ? binutils seems to suggest that EM_OPENRISC is the "official"
> > definition.
> > 
> >  arch/openrisc/include/uapi/asm/elf.h | 3 +--
> >  include/uapi/linux/elf-em.h          | 1 +
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/openrisc/include/uapi/asm/elf.h b/arch/openrisc/include/uapi/asm/elf.h
> > index f02ea58..8884276 100644
> > --- a/arch/openrisc/include/uapi/asm/elf.h
> > +++ b/arch/openrisc/include/uapi/asm/elf.h
> > @@ -55,9 +55,8 @@ typedef elf_greg_t elf_gregset_t[ELF_NGREG];
> >  /* A placeholder; OR32 does not have fp support yes, so no fp regs for now.  */
> >  typedef unsigned long elf_fpregset_t;
> >  
> > -/* This should be moved to include/linux/elf.h */
> > +/* EM_OPENRISC is defined in linux/elf-em.h */
> >  #define EM_OR32         0x8472
> > -#define EM_OPENRISC     92     /* OpenRISC 32-bit embedded processor */
> >  
> >  /*
> >   * These are used to set parameters in the core dumps.
> > diff --git a/include/uapi/linux/elf-em.h b/include/uapi/linux/elf-em.h
> > index 01529bd..aa90bc9 100644
> > --- a/include/uapi/linux/elf-em.h
> > +++ b/include/uapi/linux/elf-em.h
> > @@ -32,6 +32,7 @@
> >  #define EM_V850		87	/* NEC v850 */
> >  #define EM_M32R		88	/* Renesas M32R */
> >  #define EM_MN10300	89	/* Panasonic/MEI MN10300, AM33 */
> > +#define EM_OPENRISC     92     /* OpenRISC 32-bit embedded processor */
> >  #define EM_BLACKFIN     106     /* ADI Blackfin Processor */
> >  #define EM_TI_C6000	140	/* TI C6X DSPs */
> >  #define EM_AARCH64	183	/* ARM 64 bit */
> 
> 
