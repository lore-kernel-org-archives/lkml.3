Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbaJPG7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 02:59:33 -0400
Received: from mga14.intel.com ([192.55.52.115]:33385 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbaJPG7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 02:59:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="401094641"
Date: Thu, 16 Oct 2014 08:59:20 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/x86/realmode: make trampoline code conditional for
 x86-32
Message-ID: <20141016065920.GA4235@intel.com>
References: <1413387506-5269-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <543E96FF.6000201@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543E96FF.6000201@zytor.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 08:47:11AM -0700, H. Peter Anvin wrote:
> On 10/15/2014 08:38 AM, Jarkko Sakkinen wrote:
> > Trampoline code is only needed for SMP and in x86-64 for wakeup
> > code. Make it conditional in order to minimize the kernel size.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  arch/x86/realmode/rm/Makefile | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
> > index 7c0d7be..82b7312 100644
> > --- a/arch/x86/realmode/rm/Makefile
> > +++ b/arch/x86/realmode/rm/Makefile
> > @@ -20,7 +20,11 @@ wakeup-objs	+= video-vesa.o
> >  wakeup-objs	+= video-bios.o
> >  
> >  realmode-y			+= header.o
> > +ifdef CONFIG_X86_64
> >  realmode-y			+= trampoline_$(BITS).o
> > +else
> > +realmode-$(CONFIG_SMP)		+= trampoline_$(BITS).o
> > +endif
> >  realmode-y			+= stack.o
> >  realmode-y			+= reboot.o
> >  realmode-$(CONFIG_ACPI_SLEEP)	+= $(wakeup-objs)
> > 
> 
> It is usually preferred to make this a hidden config option (e.g.
> CONFIG_X86_TRAMPOLINE) rather than use ifdef, especially since your
> ifdef has another conditional inside it.

OK, I'll revise the patch, thanks.

> 	-hpa

/Jarkko
