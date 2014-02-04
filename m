Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaBDJPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:15:33 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:50308 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbaBDJPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:15:25 -0500
Date: Tue, 4 Feb 2014 10:15:18 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, gnurou@gmail.com,
        Eric Brower <ebrower@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Terje Bergstrom <tbergstrom@nvidia.com>,
        Ken Adams <KAdams@nvidia.com>
Subject: Re: [RFC 12/16] drm/nouveau/fifo: add GK20A support
Message-ID: <20140204091518.GZ17001@phenom.ffwll.local>
Mail-Followup-To: Alexandre Courbot <acourbot@nvidia.com>,
	Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, gnurou@gmail.com,
	Eric Brower <ebrower@nvidia.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
	Terje Bergstrom <tbergstrom@nvidia.com>,
	Ken Adams <KAdams@nvidia.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
 <1391224618-3794-13-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391224618-3794-13-git-send-email-acourbot@nvidia.com>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 01, 2014 at 12:16:54PM +0900, Alexandre Courbot wrote:
> GK20A's FIFO is compatible with NVE0, but only features 128 channels and
> 1 runlist.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpu/drm/nouveau/Makefile                   |  1 +
>  drivers/gpu/drm/nouveau/core/engine/fifo/nve0.h    |  1 +
>  drivers/gpu/drm/nouveau/core/engine/fifo/nvea.c    | 27 ++++++++++++++++++++++
>  drivers/gpu/drm/nouveau/core/include/engine/fifo.h |  1 +
>  4 files changed, 30 insertions(+)
>  create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/nvea.c
> 
> diff --git a/drivers/gpu/drm/nouveau/Makefile b/drivers/gpu/drm/nouveau/Makefile
> index e88145b..6c4b76d 100644
> --- a/drivers/gpu/drm/nouveau/Makefile
> +++ b/drivers/gpu/drm/nouveau/Makefile
> @@ -236,6 +236,7 @@ nouveau-y += core/engine/fifo/nv50.o
>  nouveau-y += core/engine/fifo/nv84.o
>  nouveau-y += core/engine/fifo/nvc0.o
>  nouveau-y += core/engine/fifo/nve0.o
> +nouveau-y += core/engine/fifo/nvea.o
>  nouveau-y += core/engine/fifo/nv108.o
>  nouveau-y += core/engine/graph/ctxnv40.o
>  nouveau-y += core/engine/graph/ctxnv50.o
> diff --git a/drivers/gpu/drm/nouveau/core/engine/fifo/nve0.h b/drivers/gpu/drm/nouveau/core/engine/fifo/nve0.h
> index 014344e..e96b32b 100644
> --- a/drivers/gpu/drm/nouveau/core/engine/fifo/nve0.h
> +++ b/drivers/gpu/drm/nouveau/core/engine/fifo/nve0.h
> @@ -8,6 +8,7 @@ int  nve0_fifo_ctor(struct nouveau_object *, struct nouveau_object *,
>  		    struct nouveau_object **);
>  void nve0_fifo_dtor(struct nouveau_object *);
>  int  nve0_fifo_init(struct nouveau_object *);
> +int  nve0_fifo_fini(struct nouveau_object *, bool);
>  
>  struct nve0_fifo_impl {
>  	struct nouveau_oclass base;
> diff --git a/drivers/gpu/drm/nouveau/core/engine/fifo/nvea.c b/drivers/gpu/drm/nouveau/core/engine/fifo/nvea.c
> new file mode 100644
> index 0000000..16f8905
> --- /dev/null
> +++ b/drivers/gpu/drm/nouveau/core/engine/fifo/nvea.c
> @@ -0,0 +1,27 @@
> +/*
> + * Copyright (c) 2014, NVIDIA Corporation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.

Just stumbled over this lincense header: Generally drm is mit/gpl dual
lincensed. The important part for me is the drm core, but due to all the
refactoring we tend to do and code extraction from drivers those are
rather relevant imo, too. Was this just an oversight or are you still
working with your legap people on this?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
