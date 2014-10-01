Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaJAJFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 05:05:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:36322 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaJAJFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 05:05:20 -0400
Date: Wed, 1 Oct 2014 11:05:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Hurley <peter@hurleysoftware.com>
cc: Akinobu Mita <akinobu.mita@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        iommu@lists.linux-foundation.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH v3 0/5] enhance DMA CMA on x86
In-Reply-To: <542B5DC2.8020806@hurleysoftware.com>
Message-ID: <alpine.DEB.2.11.1410011057290.4455@nanos>
References: <1397567329-3771-1-git-send-email-akinobu.mita@gmail.com> <5426CA0A.7000806@hurleysoftware.com> <CAC5umyhgs8---HZLa7_DOSbqW0uPbLgqTfBweScZSR9oWbG9xg@mail.gmail.com> <54294C0B.1060705@hurleysoftware.com> <CAC5umyjP4OscSC8igVLYPEm-6gqiXt9md46sLu77Vut5UiPb=g@mail.gmail.com>
 <542ABF77.1020402@hurleysoftware.com> <alpine.DEB.2.11.1410010131380.4455@nanos> <542B5DC2.8020806@hurleysoftware.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014, Peter Hurley wrote:
> On 09/30/2014 07:45 PM, Thomas Gleixner wrote:
> > Whether the proposed patchset is the correct solution to support it is
> > a completely different question.
> 
> This patchset has been in mainline since 3.16 and has already caused
> regressions, so the question of whether this is the correct solution has
> already been answered.

Agreed.
 
> > So either you stop this right now and help Akinobu to find the proper
> > solution 
> 
> If this is only a test platform for ARM parts then I don't think it
> unreasonable to suggest forking x86 swiotlb support into a iommu=cma
> selector that gets DMA mapping working for this test platform and doesn't
> cause a bunch of breakage.

Breakage is not acceptable in any case.
 
> Which is different than if the plan is to ship production units for x86;
> then a general purpose solution will be required.
> 
> As to the good design of a general purpose solution for allocating and
> mapping huge order pages, you are certainly more qualified to help Akinobu
> than I am.

Fair enough. Still this does not make the case for outright rejecting
the idea of supporting that kind of device even if it is a esoteric
case. We deal with enough esoteric hardware in Linux and if done
right, it's no harm to anyone.

I'll have a look at the technical details.

Thanks,

	tglx
