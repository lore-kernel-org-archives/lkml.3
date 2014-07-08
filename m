Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbaGHMrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:47:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbaGHMq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:46:59 -0400
Date: Tue, 8 Jul 2014 14:46:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Chris Wilson <chris@chris-wilson.co.uk>
cc: Thomas Meyer <thomas@m3y3r.de>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] Linux 3.16-rc2
In-Reply-To: <20140708085901.GI26405@nuc-i3427.alporthouse.com>
Message-ID: <alpine.LNX.2.00.1407081445310.1655@pobox.suse.cz>
References: <871tuea7nz.fsf@intel.com> <20140624115753.GD17674@nuc-i3427.alporthouse.com> <1403612670.3091.10.camel@localhost.localdomain> <20140624122737.GF17674@nuc-i3427.alporthouse.com> <20140630100220.GA4934@xo-6d-61-c0.localdomain>
 <20140630100925.GA18836@nuc-i3427.alporthouse.com> <1404317921.3910.3.camel@localhost.localdomain> <20140707151613.GG5821@phenom.ffwll.local> <20140707160402.GA26405@nuc-i3427.alporthouse.com> <alpine.LNX.2.00.1407080013030.1655@pobox.suse.cz>
 <20140708085901.GI26405@nuc-i3427.alporthouse.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2014, Chris Wilson wrote:

> > I actually tried to introduce rather large delays between individual 
> > I915_WRITE() calls in the ring initialization sequence a couple weeks ago 
> > already, but it resulted in complete machine lockup (which is worse than 
> > my usual symptoms) during resume. Therefore I probably lack the knowledge 
> > of internal workings of the HW that would allow me to guess what the 
> > reasonable timeout value should be.
> > 
> > Willing to test any patches.
> 
> Are you using the extra patches on bug 76554? If not, try

Just for debugging.

> diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
> index e18ed05dc0d5..48326f9628d4 100644
> --- a/drivers/gpu/drm/i915/intel_ringbuffer.c
> +++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
> @@ -526,6 +526,9 @@ static int init_ring_common(struct intel_engine_cs *ring)
>                         ((ringbuf->size - PAGE_SIZE) & RING_NR_PAGES)
>                         | RING_VALID);
>  
> +       I915_WRITE_HEAD(ring, 0);
> +       (void)I915_READ_HEAD(ring);
> +
>         /* If the head is still not zero, the ring is dead */
>         if (wait_for((I915_READ_CTL(ring) & RING_VALID) != 0 &&
>                      I915_READ_START(ring) == i915_gem_obj_ggtt_offset(obj) &&

Tried on top of current Linus' tree, and no improvement. ring 
initialization failure upon resume, and window redrawing hosed.

-- 
Jiri Kosina
SUSE Labs
