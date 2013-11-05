Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab3KETP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 14:15:29 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:44358 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab3KETPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 14:15:24 -0500
Date: Tue, 5 Nov 2013 20:15:28 +0100
From: Leif Lindholm <leif.lindholm@linaro.org>
To: The development of GNU GRUB <grub-devel@gnu.org>
Cc: Daniel Kiper <daniel.kiper@oracle.com>, david.woodhouse@intel.com,
        arvidjaar@gmail.com, mchang@suse.com, Jan Beulich <JBeulich@suse.com>,
        keir@xen.org, shidokht.yadegari@oracle.com, seth.goldberg@oracle.com,
        ross.philipson@citrix.com, grant.likely@linaro.org,
        mchang.novell@gmail.com, mjg59@srcf.ucam.org,
        andre.przywara@calxeda.com, Ian Campbell <ian.campbell@citrix.com>,
        stefano.stabellini@eu.citrix.com,
        "Vladimir =?utf-8?Q?'=CF=86-coder=2Fphcoder'?= Serbinenko" 
	<phcoder@gmail.com>,
        boris.ostrovsky@oracle.com, richard.l.maliszewski@intel.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xen.org,
        neal.pollack@oracle.com
Subject: Re: Is: Wrap-up Was: Re: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131105191528.GN1557@rocoto.smurfnet.nu>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <526599A8.9090501@gmail.com>
 <52663D54.2020800@gmail.com>
 <20131028162603.GA4716@phenom.dumpdata.com>
 <526EA686.70008@gmail.com>
 <526F7FC402000078000FD7BA@nat28.tlf.novell.com>
 <20131030111924.GE3425@debian70-amd64.local.net-space.pl>
 <alpine.DEB.2.02.1311042027420.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311042027420.26077@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 08:41:11PM +0000, Stefano Stabellini wrote:
> > 
> > multiboot2 protocol requires some more changes. However, about 80% of code
> > is ready. In this case Xen and modules are loaded by GRUB2 itself. It means
> > that all images could be placed on any filesystem recognized by GRUB2. Options
> > for Xen and modules are passed separately which simplifies command line editing
> > in boot loader and parsing. multiboot2 protocol is very flexible and could be
> > easily extended in the future if a need arises. Support for secure boot and
> > shim loader could be added. However, it was not implemented yet. Probably
> > linuxefi module could be used as a reference or even as a base for development.
> > However, I do not know are there plans to support such solution by GRUB2
> > community. Currently, support for native PE images signatures and GPG signatures
> > is under development for GRUB2 upstream.
> 
> FYI on ARM it is possible to load a kernel as PE but at the same time
> passing additional info as where the initrd or other additional binaries
> have been loaded or even command line arguments. These info are passed
> from the bootloader to the kernel via Device Tree.  Grant (CC'ed) might
> be able to add additional details on where the code actually lives.
 
The code currently lives in unclean form in my development tree on
git.linaro.org. We had a few items on the kernel boot protocol to sort
out at last week's Linaro Connect, and if I hadn't been struck down
with conference flu, I would probably have sent out the basic arm64
support by now.

The method used (for the curious) is to simply register an FDT as a
configuration table, and then look for that in the stub.

That code should be trivially portable to 32-bit ARM.

I did start out from the linuxefi code, but that was quite x86 specific,
and was also dependent on the shim, so I ended up changing most of it
(for now). I would still like to see a unified (upstream) linuxefi
module for loading the kernel as the UEFI stub
(with architecture-specific bits extracted out under loader/<arch>).

The UEFI stub loader will then call ExitBootServices(), not GRUB.

/
    Leif
