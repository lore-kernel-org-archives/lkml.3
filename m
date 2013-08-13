Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab3HMROK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:14:10 -0400
Received: from s16502780.onlinehome-server.info ([87.106.93.118]:59519 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756363Ab3HMROH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:14:07 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Tue, 13 Aug 2013 18:13:24 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>, DRI <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "s.dilek" <s.dilek@jpberlin.de>
Subject: Re: linux-next: Tree for Aug 13 [ screen corruption in graphical
 mode ]
Message-ID: <20130813171324.GB8805@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>,
	DRI <dri-devel@lists.freedesktop.org>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	"s.dilek" <s.dilek@jpberlin.de>
References: <CA+icZUVEcCTbBre99FWiDXRAMKcdQxUagXE-2-rO9g=YVUAieQ@mail.gmail.com>
 <20130813095259.GC4519@cantiga.alporthouse.com>
 <CA+icZUX6KM3dKrdX3Qkwg-DeBYobjQ+WG6oQEUjJQG3Q=qf+Sg@mail.gmail.com>
 <CA+icZUWPdivbDc=cBUR2BJzKGwWwK-P0OP0CZ5EfCupii7sP_w@mail.gmail.com>
 <CA+icZUUKH6Fa8WksqA69FXKUUJmKsNdXv0ZJH50HA2mFavfPCg@mail.gmail.com>
 <CA+icZUXC73i4hO7LHDQ=85__JtrZmSMB+KyUnS+G6vRmm_=tkg@mail.gmail.com>
 <CA+icZUXdS3EuXyGZiS1--rMu6H0ospzCiK_CXgPv8mOk0sMt+Q@mail.gmail.com>
 <20130813163439.GA8805@cantiga.alporthouse.com>
 <CA+icZUX8HZD3z-uwTMWX9CoLdYYqyPVuhH-vWGhJuoonvMQTbQ@mail.gmail.com>
 <CA+icZUU1tbHGVPgjXNvsq-F44O6umbhp_bFcoLE35HZ0zTqo2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+icZUU1tbHGVPgjXNvsq-F44O6umbhp_bFcoLE35HZ0zTqo2g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 78.156.73.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 07:03:44PM +0200, Sedat Dilek wrote:
> On Tue, Aug 13, 2013 at 6:37 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> > On Tue, Aug 13, 2013 at 6:34 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> >> On Tue, Aug 13, 2013 at 06:23:29PM +0200, Sedat Dilek wrote:
> >>> On Tue, Aug 13, 2013 at 5:59 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >>> > I have bisected the issue on Linux v3.11-rc5 + drm-intel-nightly:
> >>> >
> >>> > 5456fe3882812aba251886e36fe55bfefb8e8829 is the first bad commit
> >>> > commit 5456fe3882812aba251886e36fe55bfefb8e8829
> >>> > Author: Chris Wilson <chris@chris-wilson.co.uk>
> >>> > Date:   Thu Aug 8 14:41:07 2013 +0100
> >>> >
> >>> >     drm/i915: Allocate LLC ringbuffers from stolen
> >>> >
> >>> >     As stolen objects now behave identically (wrt to default LLC cacheing)
> >>> >     as their normal system counterparts, we no longer have to differentiate
> >>> >     our usage for ringbuffers. So allocate them from stolen on SNB+ as well.
> >>> >
> >>> >     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> >>> >     Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> >>> >     Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> >>> >
> >>> > :040000 040000 de063a052f39095f4d2f51b49caef9f827df41e8
> >>> > 1c819aa5501a9fcc9912a5c7c037c71b9b9e9a6b M      drivers
> >>> >
> >>> > See also attached files!
> >>> >
> >>>
> >>> With the attached revert-patch my system is OK (with my customized X stack).
> >>
> >> No indication of a GPU hang? I'm puzzled as to how this ends up with the
> >> scanout being misread.
> >>
> >> cat /sys/kernel/debug/dri/0/i915_gem_stolen
> >> cat /sys/kernel/debug/dri/0/i915_gem_framebuffer
> >>
> >> would be interesting.

> Attached both outputs with GOOD and BAD (BROKEN) kernel.

ggtt offset is the same for both setups, the only difference between the
two is the location of fbcon in stolen memory.

Can you please attach the output of intel_reg_dumper for good/bad? It's
a long shot...

Speaking of long shots, try this (slightly different to the earlier patch):

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index a21f935..37ad772 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1850,6 +1850,9 @@ intel_pin_and_fence_fb_obj(struct drm_device *dev,
                BUG();
        }
 
+       if (obj->stolen && INTEL_INFO(dev)->gen >= 6)
+               alignment = 256 * 1024;
+
        /* Note that the w/a also requires 64 PTE of padding following the
         * bo. We currently fill all unused PTE with the shadow page and so
         * we should always have valid PTE following the scanout preventing


-- 
Chris Wilson, Intel Open Source Technology Centre
