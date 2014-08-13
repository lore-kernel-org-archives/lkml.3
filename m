Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaHMPGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 11:06:38 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:46299 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbaHMPGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 11:06:37 -0400
Date: Wed, 13 Aug 2014 08:07:05 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Juergen Gross <jgross@suse.com>,
        Ben Widawsky <benjamin.widawsky@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: Usage of _PAGE_PCD et al in i915 driver
Message-ID: <20140813080705.31a0901a@jbarnes-desktop>
In-Reply-To: <CAKMK7uEqfLudZbj1ArKJVXET69d+g+SA3=GtXQ0zXi+FeudAag@mail.gmail.com>
References: <53E4B338.3040904@suse.com>
	<CAKMK7uEqfLudZbj1ArKJVXET69d+g+SA3=GtXQ0zXi+FeudAag@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2014 15:14:15 +0200
Daniel Vetter <daniel.vetter@ffwll.ch> wrote:

> Adding relevant mailing lists.
> 
> On Fri, Aug 8, 2014 at 1:23 PM, Juergen Gross <jgross@suse.com> wrote:
> > I'm just about to create a patch for full PAT support in the Linux
> > kernel, including Xen. For this purpose I introduce a translation
> > between cache modes and pte bits.
> >
> > Scanning the kernel sources for usage of the cache mode bits in the
> > pte I discovered  drivers/gpu/drm/i915/i915_gem_gtt.h is using
> > _PAGE_PCD, _PAGE_PWT and _PAGE_PAT. I think those defines are used
> > to create ptes not for usage by the main processor, but for the
> > graphics processor. Is this true? In this case I'd suggest to define
> > i915-specific macros instead of using the x86 ones.
> 
> Yeah, those are gpu specific PAT tables, but the hw engineers
> specifically designed this to match, and we've tried to follow the cpu
> side to match it. Especially in the future that will be somewhat
> important, since we want to fully share the entire address space
> between cpu and gpu on the next platform. Jesse is working on that.

Right, we have an x86 compatible MMU in the GPU itself, so re-using the
defines makes sense.  I suppose with your work you'll move them and
make them a bit more opaque?  If so, we'll still want a way to get at
them directly, or access your mapping functions for generating PTE bits
for the GPU MMU.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
