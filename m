Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab3JVQ0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:26:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24681 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab3JVQ0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:26:47 -0400
Date: Tue, 22 Oct 2013 12:26:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: grub-devel@gnu.org, keir@xen.org, david.woodhouse@intel.com,
        stefano.stabellini@eu.citrix.com,
        Daniel Kiper <daniel.kiper@oracle.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, Jan Beulich <JBeulich@suse.com>,
        Peter Jones <pjones@redhat.com>, ross.philipson@citrix.com,
        boris.ostrovsky@oracle.com, richard.l.maliszewski@intel.com
Subject: Re: [Xen-devel] EFI and multiboot2 devlopment work for Xen
Message-ID: <20131022162632.GB19189@phenom.dumpdata.com>
References: <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
 <1382433990.1657.66.camel@hastur.hellion.org.uk>
 <5266620602000078000FCA48@nat28.tlf.novell.com>
 <1382435127.1657.70.camel@hastur.hellion.org.uk>
 <526668A502000078000FCA7B@nat28.tlf.novell.com>
 <20131022134252.GA27302@phenom.dumpdata.com>
 <1382449985.18283.12.camel@hastur.hellion.org.uk>
 <20131022140947.GA17829@phenom.dumpdata.com>
 <1382451868.18283.21.camel@hastur.hellion.org.uk>
 <1382455358.18283.31.camel@hastur.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382455358.18283.31.camel@hastur.hellion.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 04:22:38PM +0100, Ian Campbell wrote:
> On Tue, 2013-10-22 at 15:24 +0100, Ian Campbell wrote:
> > On Tue, 2013-10-22 at 10:09 -0400, Konrad Rzeszutek Wilk wrote:
> > 
> > > So it can be booted the same way as xen.efi. But my understanding is
> > > that folks prefer a bootloader instead of loading the bzImage in an
> > > NVRAM of a platform with pre-set parameters. Hence that mechanism
> > > is not used by the majority of users.
> > 
> > My understanding is that they prefer a bootloader which can launch Linux
> > as a PE/COFF image, i.e. the linuxefi thing.
> 
> What I'm trying to say here is that from the xen.efi or linux.efi point
> of view it can't tell if it was launched directly from the EFI shell or
> by some intermediate bootloader (i.e. by grub2's linuxefi command).

It can (at least in Linux). There are two entry points in the Linux kernel
and - one when it is launched from 'linuxefi' (See efi_stub_entry in 
arch/x86/boot/compressed/head_64.S), the other when it is launched
from an EFI shell - see efi_pe_entry in arch/x86/boot/compressed/head_64.S.
