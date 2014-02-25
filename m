Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaBYL4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:56:34 -0500
Received: from mga03.intel.com ([143.182.124.21]:29093 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbaBYL4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:56:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,539,1389772800"; 
   d="scan'208";a="481414401"
Date: Tue, 25 Feb 2014 13:56:27 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: sagar.a.kamble@intel.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, "G, Pallavi" <pallavi.g@intel.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/1] drm/i915: Enabling 128x128 and 256x256 ARGB Cursor
 Support
Message-ID: <20140225115627.GZ3852@intel.com>
References: <1392718186-12453-1-git-send-email-sagar.a.kamble@intel.com>
 <20140218131333.GR3852@intel.com>
 <20140225113520.GA723@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140225113520.GA723@ulmo.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 12:35:21PM +0100, Thierry Reding wrote:
> On Tue, Feb 18, 2014 at 03:13:33PM +0200, Ville Syrjälä wrote:
> [...]
> > Once we have drm_planes for cursors, I was thinking we might add some kind
> > of enum property that lists all the supported sizes for the plane.
> 
> This comment was intriguing, so I was wondering whether you could
> elaborate a little on this. The reason why I ask is that we have a
> fairly similar issue on Tegra, where recent hardware supports 128x128
> and 256x256 hardware cursors, whereas older generations support only
> 32x32 and 64x64. Also very early generations don't support ARGB cursors,
> but a somewhat funky pixel format (2 bpp, background, foreground,
> transparent, invert).

Yeah there a a bunch of legacy cursor modes on most hardware which
might be supportable. Whether or not they would actually get used is
another matter though. I think these days everyone expects the
cursor to have alpha at least. I guess userspace could figure out if
the legacy formats are enough to represent the cursor image, and maybe
even decide to take a small quality hit by converting the ARGB image
to one of the legacy formats if it's "close enough".

I think for i915 we'll just not bother with that since all our hardware
has ARGB cursor support.

> 
> With the current set of cursor IOCTLs it isn't really practical to
> support the legacy kind of cursors, but representing the cursor as a
> plane would have the benefit of attaching a number of supported formats
> as well as resolutions to it. That would make it a whole lot easier to
> support these additional modes.
> 
> As for the supported sizes enumeration, how do you intend to handle the
> correlation between horizontal and vertical sizes, since an enumeration
> property is only a single 32-bit value. I suppose if we limit ourselves
> to supporting only cursors with 64Kx64K we could stash horizontal and
> vertical dimensions into a single 32-bit value.

Prop values are 64bit so you could stick a 32x32 dimensions into a
single value. Or you could even ignore the actual value, and just
stick the dimensions to the enum name as "%ux%u". But userspace
would need to parse that, so maybe doing both is the best option.

The only issue here is that enum properties must have a current
value. That doesn't really make sense in this case. So maybe we
actually want to come up with some kind of plane caps mechanism
that would be more fitting for this purpose. OTOH I'm not sure
adding yet another mechanism is worth it.

> 
> Also, is there a plan to add a type field to the planes so that
> userspace can determine if it's a proper overlay or a cursor?

First you have to define what's the differnece between a cursor
and a proper overlay.

-- 
Ville Syrjälä
Intel OTC
