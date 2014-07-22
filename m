Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaGVFH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 01:07:28 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:33472 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaGVFH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 01:07:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAAVeFuJFCQdRuuJ=WQAL65MMoWzPj03evGiXmfQh=2K7+i5Gdg@mail.gmail.com>
References: <1405390206-5081-1-git-send-email-acourbot@nvidia.com>
	<CAAVeFuJFCQdRuuJ=WQAL65MMoWzPj03evGiXmfQh=2K7+i5Gdg@mail.gmail.com>
Date: Tue, 22 Jul 2014 15:07:25 +1000
Message-ID: <CAPM=9txDw7fJpeFB72OdSgAVuaZbpfivV-9imT9V1MBYDvBv-A@mail.gmail.com>
Subject: Re: [PATCH RESEND] drm/ttm: expose CPU address of DMA-allocated pages
From: Dave Airlie <airlied@gmail.com>
To: Alexandre Courbot <gnurou@gmail.com>
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

On 22 July 2014 14:21, Alexandre Courbot <gnurou@gmail.com> wrote:
> DRM maintainers, could I have a comment about this patch? A bunch of
> Nouveau changes depend on it.

I'm not sure we really have anyone who is in a great position to comment,

my major issue would be its allocate a large chunk of RAM that might
not be needed
in all cases, and if we could avoid that when we don't need it, then
it would be good.

Or maybe we could join some allocations together, but with the Linux
mm subsystem,
who knows maybe separate small allocs have a better hope of success.

Dave.
