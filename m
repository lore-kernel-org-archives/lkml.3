Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaGGWPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:15:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaGGWPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:15:33 -0400
Date: Tue, 8 Jul 2014 00:15:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Chris Wilson <chris@chris-wilson.co.uk>
cc: Thomas Meyer <thomas@m3y3r.de>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] Linux 3.16-rc2
In-Reply-To: <20140707160402.GA26405@nuc-i3427.alporthouse.com>
Message-ID: <alpine.LNX.2.00.1407080013030.1655@pobox.suse.cz>
References: <CA+55aFxdAhp-esuGiY4VEugiiwcMJgg1r6fPiR9Fb+HOz_5tLg@mail.gmail.com> <1403564870.3091.6.camel@localhost.localdomain> <871tuea7nz.fsf@intel.com> <20140624115753.GD17674@nuc-i3427.alporthouse.com> <1403612670.3091.10.camel@localhost.localdomain>
 <20140624122737.GF17674@nuc-i3427.alporthouse.com> <20140630100220.GA4934@xo-6d-61-c0.localdomain> <20140630100925.GA18836@nuc-i3427.alporthouse.com> <1404317921.3910.3.camel@localhost.localdomain> <20140707151613.GG5821@phenom.ffwll.local>
 <20140707160402.GA26405@nuc-i3427.alporthouse.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2014, Chris Wilson wrote:

> > > this patch on top of v3.16-rc3-62-gd92a333 makes the resume from ram
> > > regression go away on my machine:
> > 
> > Hm, we could conditionalize this hack on IS_G4X ... Chris, thoughts?
> 
> As different machines favour different w/a, I think the issue is mostly
> timing related. It could be sequence of register writes, but we tried
> different orders early on. The next experiment I guess would be to
> insert small delays between each write to see if that helps. Or to write
> each register twice.

I actually tried to introduce rather large delays between individual 
I915_WRITE() calls in the ring initialization sequence a couple weeks ago 
already, but it resulted in complete machine lockup (which is worse than 
my usual symptoms) during resume. Therefore I probably lack the knowledge 
of internal workings of the HW that would allow me to guess what the 
reasonable timeout value should be.

Willing to test any patches.

-- 
Jiri Kosina
SUSE Labs
