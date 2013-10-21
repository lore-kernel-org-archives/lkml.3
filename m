Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3JUOZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:25:29 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35896 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab3JUOZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 10:25:28 -0400
Date: Mon, 21 Oct 2013 10:23:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>, ian.campbell@citrix.com,
        ross.philipson@citrix.com, stefano.stabellini@eu.citrix.com,
        grub-devel@gnu.org, david.woodhouse@intel.com,
        richard.l.maliszewski@intel.com,
        xen-devel <xen-devel@lists.xenproject.org>, boris.ostrovsky@oracle.com,
        pjones@redhat.com, linux-kernel@vger.kernel.org, keir@xen.org
Subject: Re: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131021142347.GB4211@phenom.dumpdata.com>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <52654A0602000078000FC611@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52654A0602000078000FC611@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 02:36:38PM +0100, Jan Beulich wrote:
> >>> On 21.10.13 at 14:57, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> 
> (Looking at the Cc list it's quite interesting that you copied a
> whole lot of people, but not me as the maintainer of the EFI
> bits in Xen.)

I see this:

From: Daniel Kiper <daniel.kiper@oracle.com>
To: boris.ostrovsky@oracle.com, david.woodhouse@intel.com,
        ian.campbell@citrix.com, jbeulich@suse.com, keir@xen.org,


You are on the 'To' instead of the 'CC'. That should make the email
arrive at your mailbox much quicker than through the mailing list?

> 
> > Separate multiboot2efi module should be established. It should verify system
> > kernel and all loaded modules using shim on EFI platforms with enabled 
> > secure boot
> 
> Each involved component verifies only the next image. I.e. the
> shim verifies the Xen image, and Xen verifies the Dom0 kernel
> binary. The Dom0 kernel (assuming it to be Linux) will then be
> responsible for dealing with its initrd. (One open question is how
> Xen ought to deal with an eventual XSM module; I take it that
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
> 
> > What do you think about that?
> > Any comments, suggestions, objections?
> 
> The complications here make it pretty clear to me that the
> GrUB2-less solution (or, if GruB2 absolutely has to be involved,
> its chain loading capability) I have been advocating continues
> to be the better (and, as said before, conceptually correct)
> model.

However my understanding is that the general distro approach is
to use GRUB2 and I think we want to follow the mainstream on this.
Which means using GRUB2 and making sense of the myrid of patches
that each distro has.
