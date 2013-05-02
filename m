Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694Ab3EBMtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 08:49:11 -0400
Received: from relay3.sgi.com ([192.48.152.1]:47777 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757060Ab3EBMtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 08:49:10 -0400
Date: Thu, 2 May 2013 07:49:06 -0500
From: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Miguel Boton <mboton.lkml@gmail.com>, Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v7 10/11] arm, change reboot_mode to use enum
 reboot_mode
Message-ID: <20130502124906.GW3658@sgi.com>
References: <1367428011-17123-1-git-send-email-holt@sgi.com>
 <1367428011-17123-11-git-send-email-holt@sgi.com>
 <20130502073020.GC26361@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502073020.GC26361@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 09:30:20AM +0200, Ingo Molnar wrote:
> 
> * Robin Holt <holt@sgi.com> wrote:
> 
> >  #ifndef __ASSEMBLY__
> >  
> >  #include <linux/types.h>
> > +#include <linux/reboot.h>
> >  
> >  void iop3xx_map_io(void);
> >  void iop_init_cp6_handler(void);
> >  void iop_init_time(unsigned long tickrate);
> > -void iop3xx_restart(char, const char *);
> > +void iop3xx_restart(enum reboot_mode, const char *);
> 
> IMO the introduction of the enum is making things cleaner here all around.
> 
> As long as it's an equivalent transformation for ARM with no reduction in 
> functionality (i.e. please fix any bugs Russell found), this all looks 
> like a nice series.
> 
> Is there no parameter namespace clash between reboot modifier strings on 
> various architectures? I.e. 's' meaning something on x86 and meaning a 
> different thing on ARM or some other architecture.

There is.  I used an #ifdef in kernel/reboot.c.  Also w[arm] | c[old]
on x86 becomes s[oft] | h[ard] | g[pio] on arm/unicore32. (Well, I just
added gpio that to the patch set after noticing I missed it earlier).

Robin
