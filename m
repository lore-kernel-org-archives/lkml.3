Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaBJRba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:31:30 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:63029 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaBJRbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:31:21 -0500
Date: Mon, 10 Feb 2014 18:31:14 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, sagar.a.kamble@intel.com,
        daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, vijay.a.purushothaman@intel.com,
        tomi.valkeinen@ti.com, dri-devel@lists.freedesktop.org,
        gregkh@linuxfoundation.org, joe@perches.com, airlied@redhat.com
Subject: Re: [PATCH v4 00/11] Enabling 180 degree rotation for sprite and
 crtc planes
Message-ID: <20140210173114.GB17001@phenom.ffwll.local>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
	One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
	sagar.a.kamble@intel.com, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, vijay.a.purushothaman@intel.com,
	tomi.valkeinen@ti.com, dri-devel@lists.freedesktop.org,
	gregkh@linuxfoundation.org, joe@perches.com, airlied@redhat.com
References: <1391780716-21896-1-git-send-email-sagar.a.kamble@intel.com>
 <20140210104130.7e7c3c93@alan.etchedpixels.co.uk>
 <20140210135212.GN3891@intel.com>
 <20140210141454.7f8e25e6@alan.etchedpixels.co.uk>
 <20140210142945.GP3891@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140210142945.GP3891@intel.com>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 04:29:45PM +0200, Ville Syrjälä wrote:
> On Mon, Feb 10, 2014 at 02:14:54PM +0000, One Thousand Gnomes wrote:
> > > > Does this mean it should also handle horizontal mirroring in
> > > > hardware (180° rotate, and scan lines backwards combined) ?
> > > 
> > > Our hardware doesn't support mirroring (h or v). Well, unless you
> > > count h+v mirroring since that's 180 degree rotation :)
> > > 
> > > Anyways IIRC the old video overlay (present on gen2-4) was the only plane
> > > to ever support mirroring on Intel hardware. With all other planes we're
> > > limited to 0 and 180 degree rotation
> > 
> > It seems to do vertical mirroring providing your output buffer is
> > allocated and aligned on page boundaries as the GTT can then be used to
> > map the scan lines in any order you like ?
> 
> Oh, right. That would be possible, but that sounds like something that
> needs to be done on the gem side rather than the kms side since it
> impacts other things besides scanout memory access. Well either that
> or we'd potentially need to map the same object multiple times into
> the ggtt.

Until someone demonstrates a clear benefit and use-case for that I'll vote
"pls just blit it with the render engine". The common use-case for
rotation is tablets/phones and there we can't do it in many cases anyway.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
