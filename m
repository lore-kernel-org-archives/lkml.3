Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbaJBQm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:42:28 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49441 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbaJBQm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:42:27 -0400
Date: Thu, 2 Oct 2014 12:41:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        iommu@lists.linux-foundation.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH v3 0/5] enhance DMA CMA on x86
Message-ID: <20141002164121.GF1715@laptop.dumpdata.com>
References: <1397567329-3771-1-git-send-email-akinobu.mita@gmail.com>
 <5426CA0A.7000806@hurleysoftware.com>
 <CAC5umyhgs8---HZLa7_DOSbqW0uPbLgqTfBweScZSR9oWbG9xg@mail.gmail.com>
 <54294C0B.1060705@hurleysoftware.com>
 <CAC5umyjP4OscSC8igVLYPEm-6gqiXt9md46sLu77Vut5UiPb=g@mail.gmail.com>
 <542ABF77.1020402@hurleysoftware.com>
 <alpine.DEB.2.11.1410010131380.4455@nanos>
 <542B5DC2.8020806@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542B5DC2.8020806@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 09:49:54PM -0400, Peter Hurley wrote:
> On 09/30/2014 07:45 PM, Thomas Gleixner wrote:
> > Whether the proposed patchset is the correct solution to support it is
> > a completely different question.
> 
> This patchset has been in mainline since 3.16 and has already caused
> regressions, so the question of whether this is the correct solution has
> already been answered.
> 
> > So either you stop this right now and help Akinobu to find the proper
> > solution 
> 
> If this is only a test platform for ARM parts then I don't think it
> unreasonable to suggest forking x86 swiotlb support into a iommu=cma

Not sure what you mean by 'forking x86 swiotlb' ? As in have SWIOTLB
work under ARM?

> selector that gets DMA mapping working for this test platform and doesn't
> cause a bunch of breakage.

I think you might want to take a look at the IOMMU_DETECT macros
and enable CMA there only if the certain devices are available.

That way the normal flow of detecting which IOMMU to use is still present
and will turn of CMA if there is no device that would use it.

> 
> Which is different than if the plan is to ship production units for x86;
> then a general purpose solution will be required.
> 
> As to the good design of a general purpose solution for allocating and
> mapping huge order pages, you are certainly more qualified to help Akinobu
> than I am.
> 
> Regards,
> Peter Hurley
> 
