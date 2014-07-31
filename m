Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbaGaOXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:23:48 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:64595 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaGaOXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:23:46 -0400
Date: Thu, 31 Jul 2014 16:23:47 +0200
From: Christoffer Dall <cdall@cs.columbia.edu>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christofferdall@christofferdall.dk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: linux-next: manual merge of the kvm-arm tree with Linus' tree
Message-ID: <20140731142347.GB589@cbox>
References: <20140731163004.474501fb@canb.auug.org.au>
 <CAEDV+gJ1oSPzgZMO=kdFDNPnzy-EOHGuLxHqTB8KO6d_8yPrxQ@mail.gmail.com>
 <87mwbpiv0z.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87mwbpiv0z.fsf@approximate.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 01:15:40PM +0100, Marc Zyngier wrote:
> On Thu, Jul 31 2014 at 12:53:03 pm BST, Christoffer Dall <christofferdall@christofferdall.dk> wrote:
> 
> Hi Christoffer,
> 
> > On Thu, Jul 31, 2014 at 8:30 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> >     Hi all,
> >    
> >     Today's linux-next merge of the kvm-arm tree got a conflict in
> >     virt/kvm/arm/vgic.c between commit 63afbe7a0ac1 ("kvm: arm64: vgic: fix
> >     hyp panic with 64k pages on juno platform") from Linus' tree and commit
> >     8f186d522c69 ("KVM: ARM: vgic: split GICv2 backend from the main vgic
> >     code") and others from the kvm-arm tree.
> >    
> >     I fixed it up (the latter extensively rewrites the function, so I just
> >     used that) and can carry the fix as necessary (no action is required).
> >
> > Hmm that doesn't look correct, the checks  for
> > PAGE_ALIGNED(vcpu_res.start) and PAGE_ALIGNED(resource_size(vcpu_res))
> > still need to be enforced for both vgic-v2 and vgic-v3.  How do we
> > provide a correct fix for Linux-next?
> 
> I've provided a resolution for GICv2 in a separate email. For GICv3, I
> have the following patch in my tree, which can be added at a later time.
> 
The GICv3 build fix and the GICv3 fix you provided here are now both in
kvmarm/next.

Stephen, did you pick up the resolution provided by Marc for the gicv2
fix patch so that it applies to tomorrow's next/kvmarm merge?

Thanks,
-Christoffer
