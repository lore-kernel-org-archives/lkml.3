Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaCXXLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 19:11:33 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:60775 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaCXXLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 19:11:31 -0400
Date: Tue, 25 Mar 2014 00:11:30 +0100
From: Andreas Mohr <andi@lisas.de>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Dave Airlie <airlied@gmail.com>,
        Andreas Mohr <andi@lisas.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Subject: Re: 3.14-rc7 crashes in drm ([PATCH] a crash in
 mga_driver_irq_uninstall)
Message-ID: <20140324231130.GA1386@rhlx01.hs-esslingen.de>
References: <20140322234317.GA10483@rhlx01.hs-esslingen.de>
 <20140323121541.GA20971@rhlx01.hs-esslingen.de>
 <CA+55aFyu_5eE5j2LLjhEQSAOAiLyuA65Z2o_TGdvhVMedWKTwA@mail.gmail.com>
 <20140323212715.GA22767@rhlx01.hs-esslingen.de>
 <CAPM=9tx1Cqkt1u0TUTJm7==B3M7c-ymdLFJ=qyTKaFaCqB4d_g@mail.gmail.com>
 <20140324085449.GA26878@phenom.ffwll.local>
 <alpine.LRH.2.02.1403241302260.15351@file01.intranet.prod.int.rdu2.redhat.com>
 <20140324202606.GJ26878@phenom.ffwll.local>
 <alpine.LRH.2.02.1403241627510.18209@file01.intranet.prod.int.rdu2.redhat.com>
 <CAKMK7uFW9NSF1WhENn9_3GHNvZtEjn=o+NSpY5g41Qg_pqMz8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFW9NSF1WhENn9_3GHNvZtEjn=o+NSpY5g41Qg_pqMz8A@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 24, 2014 at 10:46:49PM +0100, Daniel Vetter wrote:
> On Mon, Mar 24, 2014 at 9:40 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
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

That sounds plausible - yet with meatballs (ok, maybe I should omit
such quite possibly unjustified qualification) such as this:

git show --stat 771fe6b912fca54f03

how is a bunch of marginally-trained hobbyists ever supposed to be implementing
a working practical (i.e., "base") driver for *various* currently unsupported
(booted would perhaps even be a more fitting word?) hardware?

While the result of a wc -l check of the drivers/gpu/drm/r128 dir itself
seems quite positive, that still might be not much of help
when eyeing the large KMS changes that had to be done elsewhere.

I guess we can make use of all the practical advice/links that we can get...
(such as hints at good candidates of existing KMSified drivers
which don't come with the full bells and whistles package,
hints at suitably sized KMS support commits, grandma tutorials, ...).
Some semi-short search wasn't overly successful, with links such as
http://www.x.org/wiki/ModeSetting/
https://en.wikipedia.org/wiki/KMS_%28Linux_kernel%29#Linux
"New, Generic X.Org KMS Driver Work" http://www.phoronix.com/scan.php?page=news_item&px=OTk1OA

Or perhaps I should just state outright that I seem to be in need
of a working solution for my kernel upgrade pain
which I would be deemed to want semi-soonish
(the i810, MGA users and some others might be sharing my thoughts).
IOW, my r128 driver is somewhat of a "still used driver", thank you very much.

Thanks for having managed to survive my posting in an asbestos-lined
garment (apologies if it came across in harsh terms :),

Andreas Mohr
(not necessarily a member of the forced-monopoly hardware upgrade treadmill cult)
