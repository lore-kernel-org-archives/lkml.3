Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbaJUMX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:23:26 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36885 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499AbaJUMXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:23:21 -0400
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:6596:22b6:3872:9902]
In-Reply-To: <CALCETrWzxjpKrou6J63_T75x=ZEGWCGbc4KEWT_AMvzSQNn1eg@mail.gmail.com>
References: <1413205748-6300-1-git-send-email-a.motakis@virtualopensystems.com>
 <1413205748-6300-3-git-send-email-a.motakis@virtualopensystems.com> <CALCETrWzxjpKrou6J63_T75x=ZEGWCGbc4KEWT_AMvzSQNn1eg@mail.gmail.com>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Tue, 21 Oct 2014 14:23:00 +0200
Message-ID: <CAG8rG2wfwR0gYRk-8abe7Z7Z7WZ8FdH6qURVw9up==Z0DsrUkg@mail.gmail.com>
Subject: Re: [PATCH 2/5] vfio: introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag
To: Andy Lutomirski <luto@amacapital.net>
Cc: kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Eric Auger <eric.auger@linaro.org>,
        Kim Phillips <kim.phillips@freescale.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 11:37 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Mon, Oct 13, 2014 at 6:09 AM, Antonios Motakis
> <a.motakis@virtualopensystems.com> wrote:
>> We introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag to the VFIO dma map call,
>> and expose its availability via the capability VFIO_DMA_NOEXEC_IOMMU.
>> This way the user can control whether the XN flag will be set on the
>> requested mappings. The IOMMU_NOEXEC flag needs to be available for all
>> the IOMMUs of the container used.
>
> Since you sent this to the linux-api list, I'll bite: what's the XN
> flag?  I know what PROT_EXEC does when you mmap something, and I
> presume that vfio is mmappable, but I don't actually have any clue
> what this patch does.
>
> I assume that this does not have anything to do with a non-CPU DMA
> master executing code in main memory, because that makes rather little
> sense.  (Or maybe it really does, in which case: weird.)

It does actually. For example, the ARM PL330 DMA controller will fetch
from memory code with DMA instructions, and it will respect this flag.
It is not code that can be executed on the CPU of course, but it is
executable on the DMAC.


>
> --Andy



-- 
Antonios Motakis
Virtual Open Systems
