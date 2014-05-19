Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbaESK16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:27:58 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:39559 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbaESK1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:27:55 -0400
Date: Mon, 19 May 2014 12:27:50 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Ben Skeggs <bskeggs@redhat.com>, linux-tegra@vger.kernel.org
Subject: Re: [Nouveau] [PATCH 4/4] drm/nouveau: introduce CPU cache flushing
 macro
Message-ID: <20140519102750.GI8790@phenom.ffwll.local>
Mail-Followup-To: Thierry Reding <thierry.reding@gmail.com>,
	Lucas Stach <l.stach@pengutronix.de>, nouveau@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Ben Skeggs <bskeggs@redhat.com>, linux-tegra@vger.kernel.org
References: <1400483458-9648-1-git-send-email-acourbot@nvidia.com>
 <1400483458-9648-5-git-send-email-acourbot@nvidia.com>
 <20140519090202.GC7138@ulmo>
 <1400491331.8467.8.camel@weser.hi.pengutronix.de>
 <20140519100316.GE7138@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519100316.GE7138@ulmo>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 12:03:17PM +0200, Thierry Reding wrote:
> On Mon, May 19, 2014 at 11:22:11AM +0200, Lucas Stach wrote:
> > Am Montag, den 19.05.2014, 11:02 +0200 schrieb Thierry Reding:
> > > On Mon, May 19, 2014 at 04:10:58PM +0900, Alexandre Courbot wrote:
> > > > Some architectures (e.g. ARM) need the CPU buffers to be explicitely
> > > > flushed for a memory write to take effect. Not doing so results in
> > > > synchronization issues, especially after writing to BOs.
> > > 
> > > It seems to me that the above is generally true for all architectures,
> > > not just ARM.
> > > 
> > No, on PCI coherent arches, like x86 and some PowerPCs, the GPU will
> > snoop the CPU caches and therefore an explicit cache flush is not
> > required.
> 
> I was criticizing the wording in the commit message. Perhaps it could be
> enhanced with what you just said.

Shouldn't this be done in the dma mapping layer? I know that i915 does all
the cpu cache flushing itself, but that's because the x86 dma layer
refuses to believe that there are non-coherent platforms on x86. But on
arm it can cope.

This is somewhat important for dma-buf buffer sharing since if the cpu
cache control is done in drivers you must do double-flushing on shared
buffers. Atm you have to do that anyway, but at least this would make it
easier. The other problem is that ttm reinvents half of the dma mapping
functions.

Just my 2 cents.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
