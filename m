Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbaESJqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:46:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52033 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbaESJqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:46:12 -0400
Message-ID: <1400492696.8467.21.camel@weser.hi.pengutronix.de>
Subject: Re: [PATCH 3/4] drm/nouveau: hook up cache sync functions
From: Lucas Stach <l.stach@pengutronix.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>, gnurou@gmail.com,
        nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Ben Skeggs <bskeggs@redhat.com>,
        linux-tegra@vger.kernel.org
Date: Mon, 19 May 2014 11:44:56 +0200
In-Reply-To: <20140519084620.GB7138@ulmo>
References: <1400483458-9648-1-git-send-email-acourbot@nvidia.com>
	 <1400483458-9648-4-git-send-email-acourbot@nvidia.com>
	 <20140519084620.GB7138@ulmo>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 19.05.2014, 10:46 +0200 schrieb Thierry Reding:
> On Mon, May 19, 2014 at 04:10:57PM +0900, Alexandre Courbot wrote:
> > From: Lucas Stach <dev@lynxeye.de>
> > 
> > Signed-off-by: Lucas Stach <dev@lynxeye.de>
> > [acourbot@nvidia.com: make conditional and platform-friendly]
> > Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> 
> Perhaps having a propery commit message here would be good.
> 
> > diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
> [...]
> > +#ifdef NOUVEAU_NEED_CACHE_SYNC
> > +void
> > +nouveau_bo_sync_for_cpu(struct nouveau_bo *nvbo)
> > +{
> > +	struct nouveau_device *device;
> > +	struct ttm_tt *ttm = nvbo->bo.ttm;
> > +
> > +	device = nouveau_dev(nouveau_bdev(ttm->bdev)->dev);
> > +
> > +	if (nvbo->bo.ttm && nvbo->bo.ttm->caching_state == tt_cached)
> > +		ttm_dma_tt_cache_sync_for_cpu((struct ttm_dma_tt *)nvbo->bo.ttm,
> > +					      nv_device_base(device));
> 
> Can we be certain at this point that the struct ttm_tt is in fact a
> struct ttm_dma_tt?

Yes, for all cases except AGP, where things are mapped WC anyways (so
caching_state is always != cached) nouveau_bo_driver uses
nouveau_ttm_tt_create() as its ttm_tt_create callback. This in turn
calls nouveau_sgdma_create_ttm() which uses ttm_dma_tt_init()
unconditionally.

Regards,
Lucas
-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

