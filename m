Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbaEFALa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 20:11:30 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:62720 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbaEFAL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 20:11:28 -0400
MIME-Version: 1.0
In-Reply-To: <1399023162-13159-1-git-send-email-acourbot@nvidia.com>
References: <1399023162-13159-1-git-send-email-acourbot@nvidia.com>
Date: Tue, 6 May 2014 10:11:27 +1000
Message-ID: <CACAvsv4k8W_vcG3ygk_NCWttKM_A51BA8aGvK_Nqz_CmRMFjiw@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH v4 0/9] drm/nouveau: support for GK20A, cont'd
From: Ben Skeggs <skeggsb@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2014 at 7:32 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Latest patches for GK20A, taking comments received for v3 into account.
>
> Changes since v3:
> - use only pfn_to_page() and page_to_pfn() in GK20A's FB. These functions
>   are present on every arch and the physical address to page frame number
>   conversion is also consistently a shift of PAGE_SHIFT. This part will
>   probably be replaced by something nicer in the future anyway.
> - fixed a warning on 64-bit architectures when printing a dma_addr_t
> - tested compilation on x86_64 and ensured there was no error! ;)
> - in graph, always use external firmware if no microcode is linked for the
>   graph class (instead of only relying on the NvGrUseFW parameter).
Hey Alex,

I've merged all the patches and they'll make it into the merge window for 3.16.

Thanks again,
Ben.

>
> Alexandre Courbot (9):
>   drm/nouveau/bar: only ioremap BAR3 if it exists
>   drm/nouveau/bar/nvc0: support chips without BAR3
>   drm/nouveau/ibus: add GK20A support
>   drm/nouveau/fb: add GK20A support
>   drm/nouveau/fifo: add GK20A support
>   drm/nouveau/graph: enable when using external fw
>   drm/nouveau/graph: pad firmware code at load time
>   drm/nouveau/graph: add GK20A support
>   drm/nouveau: support for probing GK20A
>
>  drivers/gpu/drm/nouveau/Makefile                   |   6 +
>  drivers/gpu/drm/nouveau/core/engine/device/nve0.c  |  17 +++
>  drivers/gpu/drm/nouveau/core/engine/fifo/gk20a.c   |  35 +++++
>  drivers/gpu/drm/nouveau/core/engine/fifo/nve0.h    |   1 +
>  .../gpu/drm/nouveau/core/engine/graph/ctxgk20a.c   |  53 +++++++
>  .../gpu/drm/nouveau/core/engine/graph/ctxnvc0.h    |   9 ++
>  .../gpu/drm/nouveau/core/engine/graph/ctxnve4.c    |  14 +-
>  drivers/gpu/drm/nouveau/core/engine/graph/gk20a.c  |  47 ++++++
>  drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c   |  14 +-
>  drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h   |   2 +
>  drivers/gpu/drm/nouveau/core/engine/graph/nve4.c   |   4 +-
>  drivers/gpu/drm/nouveau/core/include/engine/fifo.h |   1 +
>  .../gpu/drm/nouveau/core/include/engine/graph.h    |   1 +
>  drivers/gpu/drm/nouveau/core/include/subdev/fb.h   |   1 +
>  drivers/gpu/drm/nouveau/core/include/subdev/ibus.h |   1 +
>  drivers/gpu/drm/nouveau/core/subdev/bar/base.c     |   6 +-
>  drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c     | 114 +++++++-------
>  drivers/gpu/drm/nouveau/core/subdev/fb/gk20a.c     |  56 +++++++
>  drivers/gpu/drm/nouveau/core/subdev/fb/priv.h      |   1 +
>  drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c  | 167 +++++++++++++++++++++
>  drivers/gpu/drm/nouveau/core/subdev/ibus/gk20a.c   | 103 +++++++++++++
>  21 files changed, 584 insertions(+), 69 deletions(-)
>  create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/gk20a.c
>  create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/ctxgk20a.c
>  create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/gk20a.c
>  create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/gk20a.c
>  create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
>  create mode 100644 drivers/gpu/drm/nouveau/core/subdev/ibus/gk20a.c
>
> --
> 1.9.2
>
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/nouveau
