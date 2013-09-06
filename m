Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab3IFOjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 10:39:20 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44694 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab3IFOjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 10:39:19 -0400
Date: Fri, 6 Sep 2013 10:39:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: david.vrabel@citrix.com, xen-devel <xen-devel@lists.xenproject.org>,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen/p2m: Export set_phys_to_machine.
Message-ID: <20130906143909.GC5140@phenom.dumpdata.com>
References: <1378476042-4821-1-git-send-email-konrad.wilk@oracle.com>
 <5229FD6A02000078000F119C@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5229FD6A02000078000F119C@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 03:06:02PM +0100, Jan Beulich wrote:
> >>> On 06.09.13 at 16:00, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > We have already exported 'get_phys_to_machine' and there are
> > third-party drivers that depend on this other symbol. As such
> > lets make this balanced and also export this symbol.
> 
> I tend to disagree: Allowing external modules read access to some
> internal state is quite different from also allowing them to alter it.

I am not following you. We have drivers in the kernel that do
this now. For example xen-netfront uses set_phys_to_machine.

Oddly it can be built as a module.  I am wondering how it actually
works without this EXPORT symbol.

> 
> Jan
> 
> > Reported-by: Yuval Shaia <yuval.shaia@oracle.com>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/xen/p2m.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> > index 0d4ec35..cdb96bc 100644
> > --- a/arch/x86/xen/p2m.c
> > +++ b/arch/x86/xen/p2m.c
> > @@ -847,6 +847,7 @@ bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
> >  
> >  	return true;
> >  }
> > +EXPORT_SYMBOL_GPL(set_phys_to_machine);
> >  
> >  #define M2P_OVERRIDE_HASH_SHIFT	10
> >  #define M2P_OVERRIDE_HASH	(1 << M2P_OVERRIDE_HASH_SHIFT)
> > -- 
> > 1.8.3.1
> > 
> > 
> > _______________________________________________
> > Xen-devel mailing list
> > Xen-devel@lists.xen.org 
> > http://lists.xen.org/xen-devel 
> 
> 
> 
