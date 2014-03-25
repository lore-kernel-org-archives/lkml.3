Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbaCYWmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 18:42:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbaCYWmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:42:21 -0400
Date: Tue, 25 Mar 2014 18:42:13 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Daniel Vetter <daniel@ffwll.ch>
cc: Dave Airlie <airlied@gmail.com>, Andreas Mohr <andi@lisas.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Subject: Re: 3.14-rc7 crashes in drm ([PATCH] a crash in
 mga_driver_irq_uninstall)
In-Reply-To: <CAKMK7uFW9NSF1WhENn9_3GHNvZtEjn=o+NSpY5g41Qg_pqMz8A@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1403251836160.28109@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1402261551010.9913@file01.intranet.prod.int.rdu2.redhat.com> <20140322234317.GA10483@rhlx01.hs-esslingen.de> <20140323121541.GA20971@rhlx01.hs-esslingen.de> <CA+55aFyu_5eE5j2LLjhEQSAOAiLyuA65Z2o_TGdvhVMedWKTwA@mail.gmail.com>
 <20140323212715.GA22767@rhlx01.hs-esslingen.de> <CAPM=9tx1Cqkt1u0TUTJm7==B3M7c-ymdLFJ=qyTKaFaCqB4d_g@mail.gmail.com> <20140324085449.GA26878@phenom.ffwll.local> <alpine.LRH.2.02.1403241302260.15351@file01.intranet.prod.int.rdu2.redhat.com>
 <20140324202606.GJ26878@phenom.ffwll.local> <alpine.LRH.2.02.1403241627510.18209@file01.intranet.prod.int.rdu2.redhat.com> <CAKMK7uFW9NSF1WhENn9_3GHNvZtEjn=o+NSpY5g41Qg_pqMz8A@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 24 Mar 2014, Daniel Vetter wrote:

> >> Like I've said the entire teardown sequence for legacy drm drivers is
> >> terminally busted, so the only hope we have is to reapply this missing
> >> duct-tape which made your X crash. But if that itself isn't a regression
> >> there's no way to fix the current drm/mga driver without a complete
> >> rewrite as a new-style kernel modesetting driver.
> >> -Daniel
> >
> > If someone understands the locking issues I pointed out above, it could be
> > easy to fix.
> 
> The locking issue isn't your problem, the real issue is that putting a
> irq_uninstall into core code will break all the new (properly working)
> drivers. And you can't really fix this in mga itself since the
> lifetime rules of the register mappings are totally broken. It's a
> fundamental misdesign of the legacy drm driver architecture and the
> _only_ way to fix this bug for real is to rewrite this all. Which was
> done for all the still used drivers like i915, radeon, nouveau, ...
> -Daniel

When I tried Radeon AGP card with the KMS driver, it lacked the 
possibility to set video mode with fbset and the framebuffer console was 
very slow because it wasn't accelerated.

So, Radeon with the new driver is much less useable than Matrox.

Did I misconfigure something? Or, is console acceleration and modesetting 
deliberately unsupported in KMS drivers?

Mikulas
