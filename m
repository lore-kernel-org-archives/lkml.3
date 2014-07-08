Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaGHIKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:10:17 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55118 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbaGHIKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:10:03 -0400
Date: Tue, 8 Jul 2014 10:10:12 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Ed Tomlinson <edt@aei.ca>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Dave Airlie <airlied@linux.ie>
Subject: Re: [Intel-gfx] [PATCH 5/5] drm/i915: Kick out vga console
Message-ID: <20140708081012.GN17271@phenom.ffwll.local>
Mail-Followup-To: Ed Tomlinson <edt@aei.ca>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>,
	David Herrmann <dh.herrmann@gmail.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Dave Airlie <airlied@linux.ie>
References: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch>
 <1974170.pJAPFfvtjC@grover>
 <20140707122654.GQ5821@phenom.ffwll.local>
 <2319392.n3fnJUhemF@grover>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2319392.n3fnJUhemF@grover>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 10:53:16PM -0400, Ed Tomlinson wrote:
> Hi Daniel,
> 
> The patch below also works.  You can use my Tested By for it.

Thanks a lot for testing, patch submitted and should get forwarded asap.
> 
> Thanks
> Ed Tomlinson <edtoml@gmail.com>
> 
> PS. I _really_ need to get a serial console working on my i7 box.

Usually this doesn't help a lot with gfx initialization issues since we do
an awful lot of setup while holding the console_lock. Which prevents any
dmesg output on any console :(

Cheers, Daniel

> 
> On Monday 07 July 2014 14:26:54 Daniel Vetter wrote:
> > On Mon, Jul 07, 2014 at 06:45:49AM -0400, Ed Tomlinson wrote:
> > > Daniel,
> > > 
> > > I am not quite sure I understand what you want me to test?
> > > Do you want me to try it without:
> > > 
> > > > > +               if (ret == 0) {
> > > > > +                       ret = do_unregister_con_driver(&vga_con);
> > 
> > Below the diff of what I mean.
> > -Daniel
> > 
> > 
> > diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
> > index 5e583a1838f8..bd8517151479 100644
> > --- a/drivers/gpu/drm/i915/i915_dma.c
> > +++ b/drivers/gpu/drm/i915/i915_dma.c
> > @@ -1466,12 +1466,13 @@ static int i915_kick_out_vgacon(struct drm_i915_private *dev_priv)
> >  #else
> >  static int i915_kick_out_vgacon(struct drm_i915_private *dev_priv)
> >  {
> > -	int ret;
> > +	int ret = 0;
> >  
> >  	DRM_INFO("Replacing VGA console driver\n");
> >  
> >  	console_lock();
> > -	ret = do_take_over_console(&dummy_con, 0, MAX_NR_CONSOLES - 1, 1);
> > +	if (con_is_bound(&vga_con))
> > +		ret = do_take_over_console(&dummy_con, 0, MAX_NR_CONSOLES - 1, 1);
> >  	if (ret == 0) {
> >  		ret = do_unregister_con_driver(&vga_con);
> >  
> > 
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
