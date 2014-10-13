Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbaJMPzD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 11:55:03 -0400
Received: from smtprelay0153.hostedemail.com ([216.40.44.153]:42298 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753850AbaJMPzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 11:55:01 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:334:355:368:369:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2393:2553:2559:2562:2740:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3873:3874:4184:4321:5007:6119:6691:7652:7807:7903:8603:8660:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12555:12663:12740:13069:13148:13230:13311:13357:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hot31_64f6999a0dd18
X-Filterd-Recvd-Size: 2253
Message-ID: <1413215692.1287.11.camel@joe-AO725>
Subject: Re: [PATCH] drm: drm_err: Remove unnecessary __func__ argument
From: Joe Perches <joe@perches.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 13 Oct 2014 08:54:52 -0700
In-Reply-To: <CANq1E4Rz9REGPj=Wga61h13yMfgUdB4K3UTmLFYWnRpYf+iTSA@mail.gmail.com>
References: <1411403411.2952.36.camel@joe-AO725> <87lhpa5w5f.fsf@intel.com>
	 <20140923135256.GG15734@phenom.ffwll.local>
	 <1413090537.22149.16.camel@joe-AO725>
	 <CANq1E4Rz9REGPj=Wga61h13yMfgUdB4K3UTmLFYWnRpYf+iTSA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 17:46 +0200, David Herrmann wrote:
> Hi
> 
> On Sun, Oct 12, 2014 at 7:08 AM, Joe Perches <joe@perches.com> wrote:
> > Removing the unnecessary drm_err __func__ argument by using
> > the equivalent %pf and __builtin_return_address(0) makes the
> > code smaller for every use of the DRM_ERROR macro.
> >
> > For instance: (allmodconfig)
> >
> > $ size drivers/gpu/drm/i915/i915.o*
> >    text    data     bss     dec     hex filename
> >  922447  193257  296736 1412440  158d58 drivers/gpu/drm/i915/i915.o.new
> >  928111  193257  296736 1418104  15a378 drivers/gpu/drm/i915/i915.o.old
> 
> You might want to mention that this requires a binary-search through
> kallsyms on each call.

All these calls are infrequently taken error paths
and the cost of the printk itself is _far_ higher
than a binary search for the symbol.

> I guess that's the reason you didn't use it for
> drm_ut_debug_printk()? I'm fine with doing this on drm_err(). Looks
> good.

No, the reason I didn't do it there is that those calls
should really be consolidated and be able to use dynamic_debug.
It'd be a separate patch.

cheers, Joe

