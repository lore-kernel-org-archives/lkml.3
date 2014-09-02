Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbaIBTWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 15:22:19 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27517 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaIBTWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 15:22:18 -0400
Date: Tue, 2 Sep 2014 15:22:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Juergen Gross <jgross@suse.com>
Cc: Jan Beulich <JBeulich@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kees Cook <keescook@chromium.org>,
        Stefan Bader <stefan.bader@canonical.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH] Solved the Xen PV/KASLR riddle
Message-ID: <20140902192204.GF3291@laptop.dumpdata.com>
References: <20140827204940.GA10556@laptop.dumpdata.com>
 <1409248903-19625-1-git-send-email-stefan.bader@canonical.com>
 <20140829140823.GF3609@laptop.dumpdata.com>
 <54008DDA.3040701@canonical.com>
 <5400ADD6020000780002F159@mail.emea.novell.com>
 <20140829145558.GK3609@laptop.dumpdata.com>
 <5403EFFA.50701@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5403EFFA.50701@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 06:03:06AM +0200, Juergen Gross wrote:
> On 08/29/2014 04:55 PM, Konrad Rzeszutek Wilk wrote:
> >On Fri, Aug 29, 2014 at 03:44:06PM +0100, Jan Beulich wrote:
> >>>>>On 29.08.14 at 16:27, <stefan.bader@canonical.com> wrote:
> >>>Sure. Btw, someone also contacted me saying they have the same problem
> >>>without
> >>>changing the layout but having really big initrd (500M). While that feels
> >>>like
> >>>it should be impossible (if the kernel+initrd+xen stuff has to fix the 512M
> >>>kernel image size area then). But if it can happen, then surely it does
> >>>cause
> >>>mappings to be where the module space starts then.
> >>
> >>Since the initrd doesn't really need to be mapped into the (limited)
> >>virtual address space a pv guest starts with, we specifically got
> >>
> >>/*
> >>  * Whether or not the guest can deal with being passed an initrd not
> >>  * mapped through its initial page tables.
> >>  */
> >>#define XEN_ELFNOTE_MOD_START_PFN 16
> >>
> >>to deal with that situation. The hypervisor side for Dom0 is in place,
> >>and the kernel side works in our (classic) kernels. Whether it got
> >>implemented for DomU meanwhile I don't know; I'm pretty certain
> >>pv-ops kernels don't support it so far.
> >
> >Correct - Not implemented. Here is what I had mentioned in the past:
> >(see http://lists.xen.org/archives/html/xen-devel/2014-03/msg00580.html)
> >
> >
> >XEN_ELFNOTE_INIT_P2M, XEN_ELFNOTE_MOD_START_PFN - I had been looking
> >     at that but I can't figure out a nice way of implementing this
> >     without the usage of SPARSEMAP_VMAP virtual addresses - which is how
> >     the classic Xen does it. But then - I don't know who is using huge PV
> >     guests - as the PVHVM does a fine job? But then with PVH, now you can
> >     boot with large amount of memory (1TB?) - so some of these issues
> >     would go away? Except the 'large ramdisk' as that would eat in the
> >     MODULES_VADDR I think? Needs more thinking.
> >
> >.. and then I left it and to my suprise saw on Luis's slides that
> >Jurgen is going to take a look at that (500GB support).
> 
> I have a patch which should do the job. It is based on the classic
> kernel patch Jan mentioned above. The system is coming up with it, I
> haven't tested it with a huge initrd up to now. My plan was to post the
> patch together with the rest of the >500GB support, but I can send it
> on it's own if required.

Oooh goodies! I think it makes sense to post it whenever you think
it is in the right state to be posted.

Now that your pvSCSI drivers are in, you have tons of free time
I suspect :-)


> 
> Juergen
> 
