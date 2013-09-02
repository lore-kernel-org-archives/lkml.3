Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748Ab3IBQQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 12:16:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548Ab3IBQQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 12:16:29 -0400
Date: Mon, 2 Sep 2013 19:16:17 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, glin@suse.de,
        agraf@suse.de, brogers@suse.de, afaerber@suse.de, lnussel@suse.de,
        edk2-devel@lists.sf.net, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: mmu: allow page tables to be in read-only slots
Message-ID: <20130902161617.GG10142@redhat.com>
References: <1377866497-3866-1-git-send-email-pbonzini@redhat.com>
 <5224584F.6010409@linux.vnet.ibm.com>
 <20130902092518.GN22899@redhat.com>
 <5224B608.3080303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5224B608.3080303@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 06:00:08PM +0200, Paolo Bonzini wrote:
> Il 02/09/2013 11:25, Gleb Natapov ha scritto:
> > On Mon, Sep 02, 2013 at 05:20:15PM +0800, Xiao Guangrong wrote:
> >> On 08/30/2013 08:41 PM, Paolo Bonzini wrote:
> >>> Page tables in a read-only memory slot will currently cause a triple
> >>> fault because the page walker uses gfn_to_hva and it fails on such a slot.
> >>>
> >>> OVMF uses such a page table; however, real hardware seems to be fine with
> >>> that as long as the accessed/dirty bits are set.  Save whether the slot
> >>> is readonly, and later check it when updating the accessed and dirty bits.
> >>
> >> Paolo, do you know why OVMF is using readonly memory like this?
> >>
> > Just a guess, but perhaps they want to move to paging mode as early as
> > possible even before memory controller is fully initialized.
> 
> More precisely they want to move to 64-bit mode as early as possible,
> and that requires paging.
> 
> >> AFAIK, The fault trigged by this kind of access can hardly be fixed by
> >> userspace since the fault is trigged by pagetable walking not by the current
> >> instruction. Do you have any idea to let uerspace emulate it properly?
> >
> > Not sure what userspace you mean here, but there shouldn't be a fault in the
> > first place if ROM page tables have access/dirty bit set and they do.
> 
> Yep.  Actually they do not set dirty on the PD/PDP/PML4, only on the
> bottom level (which is also fine).
> 
They do it for a good reason, dirty bit exists only on the bottom level :)

--
			Gleb.
