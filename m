Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab3HFP2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 11:28:43 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:38678 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab3HFP2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 11:28:41 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1375791502.4276.38.camel@weser.hi.pengutronix.de>
References: <1374772648-19151-1-git-send-email-tom.cooksey@arm.com>
	<CAF6AEGtspnhSGNM4_QQubVfOkZ1Gh1-Z3iyHOLBPVWuqRy81ew@mail.gmail.com>
	<51f29ccd.f014b40a.34cc.ffffca2aSMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGvFPGueM_LHVij9KFzM6NJySHCzmaLstuzZkK5GwP+6gQ@mail.gmail.com>
	<51ffdc7e.06b8b40a.2cc8.0fe0SMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGsyKk_G-R-OX_YcgYFDgTEmCy9Vf2LV1pAOV0452QKSww@mail.gmail.com>
	<1375791502.4276.38.camel@weser.hi.pengutronix.de>
Date: Tue, 6 Aug 2013 17:28:40 +0200
X-Google-Sender-Auth: brnB2gPkPaSBqw162ZcBIJ5Kdso
Message-ID: <CAKMK7uFwRfJkkAV6VpC+7RgYJ1niQOb6kHMK=pepy-zGi3aa-g@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC 0/1] drm/pl111: Initial drm/kms driver for pl111
From: Daniel Vetter <daniel@ffwll.ch>
To: Lucas Stach <l.stach@pengutronix.de>
Cc: Tom Cooksey <tom.cooksey@arm.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 2:18 PM, Lucas Stach <l.stach@pengutronix.de> wrote:
> I strongly disagree with exposing low-level hardware details like tiling
> to userspace. If we have to do the negotiation of those things in
> userspace we will end up with having to pipe those information through
> things like the wayland protocol. I don't see how this could ever be
> considered a good idea.
>
> I would rather see kernel drivers negotiating those things at dmabuf
> attach time in way invisible to userspace. I agree that this negotiation
> thing isn't easy to get right for the plethora of different hardware
> constraints we see today, but I would rather see this in-kernel, where
> we have the chance to fix things up if needed, than in a fixed userspace
> interface.

The problem with negotiating tiling in the kernel for at least
drm/i915 is that userspace needs to know the tiling and for allocating
actually be in charge of it. The approach used by prime thus far is to
simply use linear buffers between different gpus. If you want
something better I guess you need to have a fairly tightly integrate
userspace driver, so I don't see how passing around the tiling
information should be an issue for those cases.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
