Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaBJO3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 09:29:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:53168 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbaBJO3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 09:29:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,818,1384329600"; 
   d="scan'208";a="480929230"
Date: Mon, 10 Feb 2014 16:29:45 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: sagar.a.kamble@intel.com, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        vijay.a.purushothaman@intel.com, tomi.valkeinen@ti.com,
        dri-devel@lists.freedesktop.org, gregkh@linuxfoundation.org,
        joe@perches.com, airlied@redhat.com
Subject: Re: [PATCH v4 00/11] Enabling 180 degree rotation for sprite and
 crtc planes
Message-ID: <20140210142945.GP3891@intel.com>
References: <1391780716-21896-1-git-send-email-sagar.a.kamble@intel.com>
 <20140210104130.7e7c3c93@alan.etchedpixels.co.uk>
 <20140210135212.GN3891@intel.com>
 <20140210141454.7f8e25e6@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140210141454.7f8e25e6@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 02:14:54PM +0000, One Thousand Gnomes wrote:
> > > Does this mean it should also handle horizontal mirroring in
> > > hardware (180° rotate, and scan lines backwards combined) ?
> > 
> > Our hardware doesn't support mirroring (h or v). Well, unless you
> > count h+v mirroring since that's 180 degree rotation :)
> > 
> > Anyways IIRC the old video overlay (present on gen2-4) was the only plane
> > to ever support mirroring on Intel hardware. With all other planes we're
> > limited to 0 and 180 degree rotation
> 
> It seems to do vertical mirroring providing your output buffer is
> allocated and aligned on page boundaries as the GTT can then be used to
> map the scan lines in any order you like ?

Oh, right. That would be possible, but that sounds like something that
needs to be done on the gem side rather than the kms side since it
impacts other things besides scanout memory access. Well either that
or we'd potentially need to map the same object multiple times into
the ggtt.

-- 
Ville Syrjälä
Intel OTC
