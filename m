Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbaF3JIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:08:43 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:33925 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997AbaF3JIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:08:41 -0400
Date: Mon, 30 Jun 2014 02:08:43 -0700
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Kim Phillips <kim.phillips@freescale.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Eric Auger <eric.auger@linaro.org>,
        Kim Phillips <kim.phillips@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2 v2] ARM: KVM: user_mem_abort: support stage 2 MMIO
 page mapping
Message-ID: <20140630090843.GB9233@cbox>
References: <1395785294-2545-1-git-send-email-kim.phillips@linaro.org>
 <1395785294-2545-2-git-send-email-kim.phillips@linaro.org>
 <20140506180448.GH3066@lvm>
 <87bnvaotei.fsf@approximate.cambridge.arm.com>
 <20140507145557.GJ3066@lvm>
 <20140624102327.GA9121@arm.com>
 <53A9556D.3000003@arm.com>
 <20140625194551.a6443252bf913023159d25fd@freescale.com>
 <20140626084625.GA376@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626084625.GA376@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 09:46:26AM +0100, Will Deacon wrote:
> On Thu, Jun 26, 2014 at 01:45:51AM +0100, Kim Phillips wrote:
> > From: Kim Phillips <kim.phillips@linaro.org>
> > 
> > A userspace process can map device MMIO memory via VFIO or /dev/mem,
> > e.g., for platform device passthrough support in QEMU.
> > 
> > During early development, we found the PAGE_S2 memory type being used
> > for MMIO mappings.  This patch corrects that by using the more strongly
> > ordered memory type for device MMIO mappings: PAGE_S2_DEVICE.
> > 
> > Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
> > Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> > Hi, here's a v2, upon request:
> > 
> > - rebased onto today's mainline ToT
> > - mmu.o-build tested only (ToT build doesn't complete)
> > - made commit text less terse
> > - added Christoffer's ack
> 
> Thanks for reposting this so quickly!
> 
>   Acked-by: Will Deacon <will.deacon@arm.com>
> 
Thanks,

Marc, will you apply this one to kvmarm/queue [and kvmarm/next]?

-Christoffer
