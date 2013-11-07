Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab3KGNvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 08:51:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab3KGNvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 08:51:16 -0500
Date: Thu, 7 Nov 2013 08:51:08 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, prarit@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH v3] x86/cpu: Allow higher NR_CPUS values
Message-ID: <20131107135107.GA595@hansolo.jdub.homelinux.org>
References: <20131101141148.GH8652@hansolo.jdub.homelinux.org>
 <20131105143728.GJ9944@hansolo.jdub.homelinux.org>
 <20131106071540.GA3053@gmail.com>
 <20131106152113.GQ9944@hansolo.jdub.homelinux.org>
 <20131107091555.GA2671@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107091555.GA2671@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 10:15:55AM +0100, Ingo Molnar wrote:
> 
> * Josh Boyer <jwboyer@redhat.com> wrote:
> 
> > The current range for SMP configs is 2 - 512 CPUs, or a full 4096 in the 
> > case of MAXSMP.  There are machines that have 1024 CPUs in them today 
> > and configuring a kernel for that means you are forced to set MAXSMP.  
> > This adds additional unnecessary overhead.  While that overhead might be 
> > considered tiny for large machines, it isn't necessarily so if you are 
> > building a kernel that runs across a wide variety of machines.
> > 
> > To cover the range of more common machines today, we allow NR_CPUS to be
> > up to 4096 when CPUMASK_OFFSTACK is enabled.  Relatedly, we no longer make
> > that option depend on DEBUG_PER_CPU_MASKS.
> 
> > index b3c8be0..50b47cd 100644
> > --- a/lib/Kconfig
> > +++ b/lib/Kconfig
> > @@ -342,7 +342,8 @@ config CHECK_SIGNATURE
> >  	bool
> >  
> >  config CPUMASK_OFFSTACK
> > -	bool "Force CPU masks off stack" if DEBUG_PER_CPU_MAPS
> > +	bool "Force CPU masks off stack"
> > +	depends on SMP
> >  	help
> >  	  Use dynamic allocation for cpumask_var_t, instead of putting
> >  	  them on the stack.  This is a bit more expensive, but avoids
> 
> So this chunk really doesn't belong into the patch - it should be a 
> separate patch.
>
> Also, because I already applied the patch (sans the unrelated chunk) 
> please only send this single change against tip:master.

I missed that you removed that chunk, my mistake.  I'll send a follow up
as you suggest.

josh
