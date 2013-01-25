Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab3AYS32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:29:28 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:58177 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932552Ab3AYS30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:29:26 -0500
Date: Fri, 25 Jan 2013 10:29:25 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, X86 ML <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
        Borislav Petkov <bp@suse.de>, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH -v2 2/2] x86: Make Linux guest support optional
Message-ID: <20130125182925.GB29810@dtor-ws.eng.vmware.com>
References: <20130125100655.GC23404@pd.tnic>
 <1359136777-4512-2-git-send-email-bp@alien8.de>
 <20130125180730.GA29810@dtor-ws.eng.vmware.com>
 <20130125182335.GA1380@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125182335.GA1380@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 07:23:35PM +0100, Borislav Petkov wrote:
> On Fri, Jan 25, 2013 at 10:07:31AM -0800, Dmitry Torokhov wrote:
> > > -	if (x86_hyper != &x86_hyper_ms_hyperv)
> > > +	if (!x86_hyper || strncmp(x86_hyper->name, "VMware", 6))
> > >  		return -ENODEV;
> > 
> > I assume this is a typo as I doubt MS is using the same signature as we
> > do.
> 
> Yeah, Vmware is assimilating Microsoft. :-)
> 
> Damn copy-paste crap. Sorry, will fix.
> 
> > > diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
> > > index cb56e270da11..85f15a6d8798 100644
> > > --- a/drivers/misc/vmw_balloon.c
> > > +++ b/drivers/misc/vmw_balloon.c
> > > @@ -786,7 +786,7 @@ static int __init vmballoon_init(void)
> > >  	 * Check if we are running on VMware's hypervisor and bail out
> > >  	 * if we are not.
> > >  	 */
> > > -	if (x86_hyper != &x86_hyper_vmware)
> > > +	if (!x86_hyper || strncmp(x86_hyper->name, "VMware", 6))
> > >  		return -ENODEV;
> > >
> > 
> > I wonder why you decided to switch from address matching (which is quite
> > precise and would potentially allow adding signatures without needing
> > to change the drivers) to string matching?
> 
> Ok, this is a bit more involved. If we put all hypervisor stuff behind
> CONFIG_HYPERVISOR_GUEST and in the cases where this is disabled,
> the build fails because the x86_hyper_vmware symbol is undefined.
> Alternatively, this doesn't happen when we look at the name.

Can't we make the balloon driver depend on CONFIG_HYPERVISOR_GUEST?

> 
> But why would you want to add signatures? Isn't "VMware" enough as a
> name for the vmware hypervisor and why would you need more? And besides,
> hypervisor_x86.name is only a single const char * so you'd need to
> change that struct to add more names...Hm.

We do not _need_ more and have no plans to introduce new ones AFAIK, but
I think that comparing an address of a structure instead of string
comparison is much more elegant and it is safer from typos.

Thanks,
Dmitry
