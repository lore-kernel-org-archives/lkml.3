Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaJTVhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:37:42 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:45840 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaJTVhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:37:39 -0400
MIME-Version: 1.0
In-Reply-To: <1413205748-6300-3-git-send-email-a.motakis@virtualopensystems.com>
References: <1413205748-6300-1-git-send-email-a.motakis@virtualopensystems.com>
 <1413205748-6300-3-git-send-email-a.motakis@virtualopensystems.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 20 Oct 2014 14:37:17 -0700
Message-ID: <CALCETrWzxjpKrou6J63_T75x=ZEGWCGbc4KEWT_AMvzSQNn1eg@mail.gmail.com>
Subject: Re: [PATCH 2/5] vfio: introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Will Deacon <will.deacon@arm.com>, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 6:09 AM, Antonios Motakis
<a.motakis@virtualopensystems.com> wrote:
> We introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag to the VFIO dma map call,
> and expose its availability via the capability VFIO_DMA_NOEXEC_IOMMU.
> This way the user can control whether the XN flag will be set on the
> requested mappings. The IOMMU_NOEXEC flag needs to be available for all
> the IOMMUs of the container used.

Since you sent this to the linux-api list, I'll bite: what's the XN
flag?  I know what PROT_EXEC does when you mmap something, and I
presume that vfio is mmappable, but I don't actually have any clue
what this patch does.

I assume that this does not have anything to do with a non-CPU DMA
master executing code in main memory, because that makes rather little
sense.  (Or maybe it really does, in which case: weird.)

--Andy
