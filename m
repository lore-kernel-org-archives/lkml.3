Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab3GYWKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 18:10:41 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:47366 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab3GYWKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 18:10:39 -0400
Date: Fri, 26 Jul 2013 00:10:25 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ingo Molnar <mingo@kernel.org>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@elte.hu,
        torvalds@linux-foundation.org, tglx@linutronix.de
Subject: Re: [Intel-gfx] Ugly patches for stolen reservation
Message-ID: <20130725221025.GA1998@phenom.ffwll.local>
Mail-Followup-To: Jesse Barnes <jbarnes@virtuousgeek.org>,
	Ingo Molnar <mingo@kernel.org>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@elte.hu,
	torvalds@linux-foundation.org, tglx@linutronix.de
References: <1374770269-3223-1-git-send-email-jbarnes@virtuousgeek.org>
 <20130725200551.GA16719@gmail.com>
 <20130725131648.561cc63c@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725131648.561cc63c@jbarnes-desktop>
X-Operating-System: Linux phenom 3.11.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 01:16:48PM -0700, Jesse Barnes wrote:
> On Thu, 25 Jul 2013 22:05:51 +0200
> Ingo Molnar <mingo@kernel.org> wrote:
> > > Chris has some patches on top to add a new E820 type so 
> > > we can look up the region later, which removes some 
> > > redundant code in the i915 driver at least.
> > > 
> > > Any comments?  I assume no one likes this, but maybe it's 
> > > just another early quirk we'll have to live with...
> > 
> > No strong feelings against it - my only suggestion would be 
> > to make this more visible - right now it's added as e820 
> > reserved which hides amongst other areas already marked 
> > reserved - would a low-key printk() of the range added make 
> > it more apparent that a kernel quirk activated here?
> 
> Sounds good, I think Chris's patches should satisfy there.  They make
> it a new E820 type so it's clear in /proc/iomem too.

I think it'd be good to get it all in in one go, since with Chris' patches
i915 will also use the detection logic from the quirk code, so more
testing for it. And imo the i915 cleanups shouldn't conflict really with
ongoing work in drm/i915, so could all go in through x86 trees.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
