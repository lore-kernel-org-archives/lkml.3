Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab3JVQga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:36:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30589 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab3JVQg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:36:28 -0400
Date: Tue, 22 Oct 2013 12:35:02 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: Jan Beulich <JBeulich@suse.com>, Ian Campbell <ian.campbell@citrix.com>,
        "ross.philipson@citrix.com" <ross.philipson@citrix.com>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>,
        "Maliszewski, Richard L" <richard.l.maliszewski@intel.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Peter Jones <pjones@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keir@xen.org" <keir@xen.org>
Subject: Re: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131022163502.GD19189@phenom.dumpdata.com>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <20131021135437.GD1283@fenchurch.internal.datastacks.com>
 <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
 <1382433990.1657.66.camel@hastur.hellion.org.uk>
 <5266620602000078000FCA48@nat28.tlf.novell.com>
 <1382435127.1657.70.camel@hastur.hellion.org.uk>
 <526668A502000078000FCA7B@nat28.tlf.novell.com>
 <20131022134252.GA27302@phenom.dumpdata.com>
 <20131022144309.GA18547@phenom.dumpdata.com>
 <1382455537.8512.11.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382455537.8512.11.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 03:25:39PM +0000, Woodhouse, David wrote:
> On Tue, 2013-10-22 at 10:43 -0400, Konrad Rzeszutek Wilk wrote:
> > 
> > And looking at bit deeper in the x86/linux boot spec:
> > 
> > **** EFI HANDOVER PROTOCOL                                                      
> >                                                                                 
> > This protocol allows boot loaders to defer initialisation to the EFI            
> > boot stub. The boot loader is required to load the kernel/initrd(s)             
> > from the boot media and jump to the EFI handover protocol entry point           
> > which is hdr->handover_offset bytes from the beginning of                       
> > startup_{32,64}.      
> 
> Oh, ignore that. You want the *actual* PE executable entry point, as it
> would get invoked by a real UEFI firmware.

Right. The Xen hypervisor can be built in two images: a standard PE/COFF
that can be executed from the EFI shell, and an multiboot blob that can
be loaded by multiboot compatible boot loaders (like GRUB).

> 
> I thought that's what Grub invoked, for 'linuxefi'. Perhaps I mean a
> chainloader method of some kind instead. Either way, make Grub (or
> whatever bootloader you choose) load it as an EFI executable.

Looks like chainloader was it from Peter's answer. But then you can't
do SecureBoot <sigh>.

> 
> Seriously, forget Grub for now. Grub is mostly just an exercise in
> gratuitously doing things the difficult way and wondering why it's
> fragile.
> 
> Make your code work as an EFI executable when loaded directly from the
> UEFI firmware. Worry about the insanity of grub later.

That has been done by Jan. Now we are at the 'have a shim that launches
GRUB2, now what?'

>   
> 
> -- 
>                    Sent with MeeGo's ActiveSync support.
> 
> David Woodhouse                            Open Source Technology Centre
> David.Woodhouse@intel.com                              Intel Corporation
> 
> 
> 


