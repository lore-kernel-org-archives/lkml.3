Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab3JWG5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 02:57:07 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21233 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab3JWG5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 02:57:04 -0400
Date: Wed, 23 Oct 2013 08:56:40 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jan Beulich <JBeulich@suse.com>, Ian Campbell <ian.campbell@citrix.com>,
        ross.philipson@citrix.com, stefano.stabellini@eu.citrix.com,
        grub-devel@gnu.org, david.woodhouse@intel.com,
        richard.l.maliszewski@intel.com, xen-devel@lists.xen.org,
        boris.ostrovsky@oracle.com, Peter Jones <pjones@redhat.com>,
        linux-kernel@vger.kernel.org, keir@xen.org
Subject: Re: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131023065640.GP3626@debian70-amd64.local.net-space.pl>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <20131021135437.GD1283@fenchurch.internal.datastacks.com>
 <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
 <1382433990.1657.66.camel@hastur.hellion.org.uk>
 <5266620602000078000FCA48@nat28.tlf.novell.com>
 <1382435127.1657.70.camel@hastur.hellion.org.uk>
 <526668A502000078000FCA7B@nat28.tlf.novell.com>
 <20131022134252.GA27302@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131022134252.GA27302@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 09:42:52AM -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Oct 22, 2013 at 10:59:33AM +0100, Jan Beulich wrote:
> > >>> On 22.10.13 at 11:45, Ian Campbell <ian.campbell@citrix.com> wrote:
> > > On Tue, 2013-10-22 at 10:31 +0100, Jan Beulich wrote:
> > >> >>> On 22.10.13 at 11:26, Ian Campbell <ian.campbell@citrix.com> wrote:
> > >> > AIUI "efilinux" is somewhat badly named and does not use the Linux Boot
> > >> > Protocol (i.e. the (b)zImage stuff with real mode entry point) either.
> > >> > It actually loads and executes the kernel binary as a PE/COFF executable
> > >> > (the native UEFI binary executable format). xen.efi is a PE/COFF binary
> > >> > too and could equally well be launched by linuxefi in this way.
> > >>
> > >> Except that unless I'm mistaken "linuxefi" still expects to find certain
> > >> Linux-specific internal data structures inside the PE image, which I
> > >> don't see us wanting to be emulating. That's the main difference to
> > >> "chainloader" afaict.
> > >
> > > Ah, I'd been led to believe it was just the lack of a call to
> > > ExitBootServices, but I didn't check. What you say sounds completely
> > > plausible.
> > >
> > > Do you know what sort of Linux specific data structures are we talking
> > > about?
> >
> > The setup header I would assume (i.e. the bits surrounding the
> > "HdrS" signature). But I'm only guessing anyway.
>
> This is a bit lengthy email, so please get your coffee/tea ready.

[...]

> We can also support all three: PE/COFF by itself launched from GRUB2
> (ExitBootServices called, not too good), multiboot2 support, and
> linuxefi, I think?
>
> The disadvantage of multiboot2 is that it is not upstream. But the patches
> do exist and it looks like they could be put in GRUB2 upstream. The neat
> about them is that it also supports Solaris and can support any other
> multboot payload type kernels (ie, non-Linux centric).
>
> The advantage of linuxefi is that it is supported by all Linux distros right
> now - so we would fit right away. We still have to fiddle with the
> linux_kernel_parameters to get everything we want from it - which
> is probably just the EFI stuff and we can ditch the rest.

Usage of Linux Boot protocol is quiet complicated in our case. It pases
one pointer to all initrd images loaded one by one into memory. So if
we would like to use it we will be forced to parse this blob to find
separate images. Not good. multiboot2 protocol passes list of pointers
to all loaded modules.

Daniel
