Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3J3JdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 05:33:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab3J3JdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 05:33:01 -0400
Date: Wed, 30 Oct 2013 17:32:27 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org,
        fwts-devel@lists.ubuntu.com
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Message-ID: <20131030093227.GA5791@dhcp-16-126.nay.redhat.com>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20131008164551.GB16793@pd.tnic>
 <20131008164831.GD16793@pd.tnic>
 <20131029064720.GA16009@dhcp-16-126.nay.redhat.com>
 <20131029094033.GA10972@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029094033.GA10972@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/13 at 10:40am, Borislav Petkov wrote:
> On Tue, Oct 29, 2013 at 02:47:20PM +0800, Dave Young wrote:
> > Boris, could you update the comment? it says below: update that memory
> > descriptor with the virtual address obtained from ioremap().
> >
> > Logiclly your patch should update it, then my patch update it again
> > with the case of mapping to fixed address for kexec.
> 
> Thanks for catching this, I ended up doing the following:
> 
> /*
>  * This function will switch the EFI runtime services to virtual mode.
>  * Essentially, we look through the EFI memmap and map every region that
>  * has the runtime attribute bit set in its memory descriptor into the
>  * ->trampoline_pgd page table using a top-down VA allocation scheme.
>  *
>  * The old method which used to update that memory descriptor with the
>  * virtual address obtained from ioremap() is still supported when the
>  * kernel is booted with efi=old_map on its command line. Same old
>  * method enabled the runtime services to be called without having to
>  * thunk back into physical mode for every invocation.
>  *
>  * The new method does a pagetable switch in a preemption-safe manner
>  * so that we're in a different address space when calling a runtime
>  * function. For function arguments passing we do copy the PGDs of the
>  * kernel page table into ->trampoline_pgd prior to each call.
>  */

Boris, thanks for update, it's very elaborate, I have still wonder if
32 bit case should be mentioned as well.

Waiting for you next version of the patch series. I will redo my patches
based on that.

Thanks
Dave
