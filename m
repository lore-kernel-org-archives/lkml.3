Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaH2O4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:56:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50161 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbaH2O4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:56:13 -0400
Date: Fri, 29 Aug 2014 10:55:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Stefan Bader <stefan.bader@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] Solved the Xen PV/KASLR riddle
Message-ID: <20140829145558.GK3609@laptop.dumpdata.com>
References: <20140827204940.GA10556@laptop.dumpdata.com>
 <1409248903-19625-1-git-send-email-stefan.bader@canonical.com>
 <20140829140823.GF3609@laptop.dumpdata.com>
 <54008DDA.3040701@canonical.com>
 <5400ADD6020000780002F159@mail.emea.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5400ADD6020000780002F159@mail.emea.novell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 03:44:06PM +0100, Jan Beulich wrote:
> >>> On 29.08.14 at 16:27, <stefan.bader@canonical.com> wrote:
> > Sure. Btw, someone also contacted me saying they have the same problem 
> > without
> > changing the layout but having really big initrd (500M). While that feels 
> > like
> > it should be impossible (if the kernel+initrd+xen stuff has to fix the 512M
> > kernel image size area then). But if it can happen, then surely it does 
> > cause
> > mappings to be where the module space starts then.
> 
> Since the initrd doesn't really need to be mapped into the (limited)
> virtual address space a pv guest starts with, we specifically got
> 
> /*
>  * Whether or not the guest can deal with being passed an initrd not
>  * mapped through its initial page tables.
>  */
> #define XEN_ELFNOTE_MOD_START_PFN 16
> 
> to deal with that situation. The hypervisor side for Dom0 is in place,
> and the kernel side works in our (classic) kernels. Whether it got
> implemented for DomU meanwhile I don't know; I'm pretty certain
> pv-ops kernels don't support it so far.

Correct - Not implemented. Here is what I had mentioned in the past:
(see http://lists.xen.org/archives/html/xen-devel/2014-03/msg00580.html)


XEN_ELFNOTE_INIT_P2M, XEN_ELFNOTE_MOD_START_PFN - I had been looking
    at that but I can't figure out a nice way of implementing this
    without the usage of SPARSEMAP_VMAP virtual addresses - which is how
    the classic Xen does it. But then - I don't know who is using huge PV
    guests - as the PVHVM does a fine job? But then with PVH, now you can
    boot with large amount of memory (1TB?) - so some of these issues
    would go away? Except the 'large ramdisk' as that would eat in the
    MODULES_VADDR I think? Needs more thinking.

.. and then I left it and to my suprise saw on Luis's slides that
Jurgen is going to take a look at that (500GB support).

> 
> Jan
> 
