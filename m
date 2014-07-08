Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbaGHMzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:55:38 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:56612 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754250AbaGHMzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:55:36 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Tue, 8 Jul 2014 13:55:22 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Thomas Meyer <thomas@m3y3r.de>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] Linux 3.16-rc2
Message-ID: <20140708125522.GL26405@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Jiri Kosina <jkosina@suse.cz>, Thomas Meyer <thomas@m3y3r.de>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Pavel Machek <pavel@ucw.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <1403612670.3091.10.camel@localhost.localdomain>
 <20140624122737.GF17674@nuc-i3427.alporthouse.com>
 <20140630100220.GA4934@xo-6d-61-c0.localdomain>
 <20140630100925.GA18836@nuc-i3427.alporthouse.com>
 <1404317921.3910.3.camel@localhost.localdomain>
 <20140707151613.GG5821@phenom.ffwll.local>
 <20140707160402.GA26405@nuc-i3427.alporthouse.com>
 <alpine.LNX.2.00.1407080013030.1655@pobox.suse.cz>
 <20140708085901.GI26405@nuc-i3427.alporthouse.com>
 <alpine.LNX.2.00.1407081445310.1655@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1407081445310.1655@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 02:46:57PM +0200, Jiri Kosina wrote:
> On Tue, 8 Jul 2014, Chris Wilson wrote:
> 
> > > I actually tried to introduce rather large delays between individual 
> > > I915_WRITE() calls in the ring initialization sequence a couple weeks ago 
> > > already, but it resulted in complete machine lockup (which is worse than 
> > > my usual symptoms) during resume. Therefore I probably lack the knowledge 
> > > of internal workings of the HW that would allow me to guess what the 
> > > reasonable timeout value should be.
> > > 
> > > Willing to test any patches.
> > 
> > Are you using the extra patches on bug 76554? If not, try
> 
> Just for debugging.
> 
> > diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
> > index e18ed05dc0d5..48326f9628d4 100644
> > --- a/drivers/gpu/drm/i915/intel_ringbuffer.c
> > +++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
> > @@ -526,6 +526,9 @@ static int init_ring_common(struct intel_engine_cs *ring)
> >                         ((ringbuf->size - PAGE_SIZE) & RING_NR_PAGES)
> >                         | RING_VALID);
> >  
> > +       I915_WRITE_HEAD(ring, 0);
> > +       (void)I915_READ_HEAD(ring);
> > +
> >         /* If the head is still not zero, the ring is dead */
> >         if (wait_for((I915_READ_CTL(ring) & RING_VALID) != 0 &&
> >                      I915_READ_START(ring) == i915_gem_obj_ggtt_offset(obj) &&
> 
> Tried on top of current Linus' tree, and no improvement. ring 
> initialization failure upon resume, and window redrawing hosed.

Which error during ring-init are you hitting?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
