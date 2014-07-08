Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbaGHIfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:35:03 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60599 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbaGHIez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:34:55 -0400
Date: Tue, 8 Jul 2014 10:35:05 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Pavel Machek <pavel@ucw.cz>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [Intel-gfx] Linux 3.16-rc2
Message-ID: <20140708083505.GQ17271@phenom.ffwll.local>
Mail-Followup-To: Jiri Kosina <jkosina@suse.cz>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Pavel Machek <pavel@ucw.cz>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Thomas Meyer <thomas@m3y3r.de>
References: <871tuea7nz.fsf@intel.com>
 <20140624115753.GD17674@nuc-i3427.alporthouse.com>
 <1403612670.3091.10.camel@localhost.localdomain>
 <20140624122737.GF17674@nuc-i3427.alporthouse.com>
 <20140630100220.GA4934@xo-6d-61-c0.localdomain>
 <20140630100925.GA18836@nuc-i3427.alporthouse.com>
 <1404317921.3910.3.camel@localhost.localdomain>
 <20140707151613.GG5821@phenom.ffwll.local>
 <20140707160402.GA26405@nuc-i3427.alporthouse.com>
 <alpine.LNX.2.00.1407080013030.1655@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1407080013030.1655@pobox.suse.cz>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 12:15:31AM +0200, Jiri Kosina wrote:
> On Mon, 7 Jul 2014, Chris Wilson wrote:
> 
> > > > this patch on top of v3.16-rc3-62-gd92a333 makes the resume from ram
> > > > regression go away on my machine:
> > > 
> > > Hm, we could conditionalize this hack on IS_G4X ... Chris, thoughts?
> > 
> > As different machines favour different w/a, I think the issue is mostly
> > timing related. It could be sequence of register writes, but we tried
> > different orders early on. The next experiment I guess would be to
> > insert small delays between each write to see if that helps. Or to write
> > each register twice.
> 
> I actually tried to introduce rather large delays between individual 
> I915_WRITE() calls in the ring initialization sequence a couple weeks ago 
> already, but it resulted in complete machine lockup (which is worse than 
> my usual symptoms) during resume. Therefore I probably lack the knowledge 
> of internal workings of the HW that would allow me to guess what the 
> reasonable timeout value should be.

Have you used msleep or udelay? The latter just spins the cpu and might be
less dangerous.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
