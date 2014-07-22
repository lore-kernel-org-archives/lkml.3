Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaGVFrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 01:47:19 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:52401 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaGVFrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 01:47:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9txDw7fJpeFB72OdSgAVuaZbpfivV-9imT9V1MBYDvBv-A@mail.gmail.com>
References: <1405390206-5081-1-git-send-email-acourbot@nvidia.com>
 <CAAVeFuJFCQdRuuJ=WQAL65MMoWzPj03evGiXmfQh=2K7+i5Gdg@mail.gmail.com> <CAPM=9txDw7fJpeFB72OdSgAVuaZbpfivV-9imT9V1MBYDvBv-A@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 22 Jul 2014 14:46:55 +0900
Message-ID: <CAAVeFuLfREn00Qw51Q9=0ncqO-WAR87Sf=0VWOPETrk9T5sG2w@mail.gmail.com>
Subject: Re: [PATCH RESEND] drm/ttm: expose CPU address of DMA-allocated pages
To: Dave Airlie <airlied@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>, David Airlie <airlied@linux.ie>,
        Ben Skeggs <bskeggs@redhat.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 2:07 PM, Dave Airlie <airlied@gmail.com> wrote:
> On 22 July 2014 14:21, Alexandre Courbot <gnurou@gmail.com> wrote:
>> DRM maintainers, could I have a comment about this patch? A bunch of
>> Nouveau changes depend on it.
>
> I'm not sure we really have anyone who is in a great position to comment,
>
> my major issue would be its allocate a large chunk of RAM that might
> not be needed
> in all cases, and if we could avoid that when we don't need it, then
> it would be good.

Strictly speaking memory allocated using dma_alloc_coherent() should
only be accessed by the CPU through the returned mapping, so having
this extra information is probably as legitimate as the current
dma_address array.

Now I agree that this results in more memory being used, which is
especially sad since this information is already known in the dma_page
internal structure. Maybe we could expose the whole dma_pages instead
of just the dma address? That way both addresses would be accessible
for the same memory cost (we will need an array to store the adresses
to the dma_pages).

>
> Or maybe we could join some allocations together, but with the Linux
> mm subsystem,
> who knows maybe separate small allocs have a better hope of success.
>
> Dave.
