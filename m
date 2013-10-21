Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab3JUSkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 14:40:00 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:27800 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab3JUSj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 14:39:59 -0400
Date: Mon, 21 Oct 2013 20:39:06 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: ian.campbell@citrix.com, ross.philipson@citrix.com,
        stefano.stabellini@eu.citrix.com, grub-devel@gnu.org,
        david.woodhouse@intel.com, richard.l.maliszewski@intel.com,
        xen-devel <xen-devel@lists.xenproject.org>, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, pjones@redhat.com,
        linux-kernel@vger.kernel.org, keir@xen.org
Subject: Re: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131021183906.GB3626@debian70-amd64.local.net-space.pl>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <52654A0602000078000FC611@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52654A0602000078000FC611@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 02:36:38PM +0100, Jan Beulich wrote:
> >>> On 21.10.13 at 14:57, Daniel Kiper <daniel.kiper@oracle.com> wrote:

[...]

> > Separate multiboot2efi module should be established. It should verify system
> > kernel and all loaded modules using shim on EFI platforms with enabled
> > secure boot
>
> Each involved component verifies only the next image. I.e. the
> shim verifies the Xen image, and Xen verifies the Dom0 kernel
> binary. The Dom0 kernel (assuming it to be Linux) will then be
> responsible for dealing with its initrd. (One open question is how

Currently Linux Kernel is only verified. Sorry, my fault.
As I know Matthew Garrett would like to verify Linux Kernel
modules too. However, I do not know details now. I think that
we should take into account his work.

> Xen ought to deal with an eventual XSM module; I take it that

Could you tell me more about that? What issues do you expect here?

> the CPUs themselves take care of the microcode blob.) This can't
> be different because the shim provided verification protocol
> assumes that it's being handed a PE image (hence the need for
> Linux to package itself as a fake PE image), and hence can't be
> used for verifying other than the Xen and Dom0 kernel binaries.
>
> > At first I am going to prepare multiboot2 protocol implementation for Xen
> > (there
> > is about 80% of code ready) with above mentioned workaround.
>
> Is that really worthwhile as long as it's not clear whether ...
>
> > Later I am going to work on multiboot2efi module.
>
> ... is going to be accepted?

It is only proposal. I am not going to continue work until we agree all details.

> > What do you think about that?
> > Any comments, suggestions, objections?
>
> The complications here make it pretty clear to me that the
> GrUB2-less solution (or, if GruB2 absolutely has to be involved,
> its chain loading capability) I have been advocating continues
> to be the better (and, as said before, conceptually correct)
> model.

In general I agree but real life is more complicated (sadly). EFI boot loader
is not so flexible as GRUB2. Additionally, its configuration differs from
platform to platform. I do not mention that if you would like to change EFI
boot loader configuration from EFI platform configuration menu it is at least
onerous. Until all above mentioned issues (and others) will be fixed I do not
expect that everybody will use EFI boot loader as a standard way for system
loading. Probably it will happen later than sooner (if at all). So I think we
should find right solution for that problem instead of ignoring it.

Daniel
