Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaGHCxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 22:53:21 -0400
Received: from mail001.aei.ca ([206.123.6.130]:34464 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbaGHCxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 22:53:19 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Dave Airlie <airlied@linux.ie>
Subject: Re: [Intel-gfx] [PATCH 5/5] drm/i915: Kick out vga console
Date: Mon, 07 Jul 2014 22:53:16 -0400
Message-ID: <2319392.n3fnJUhemF@grover>
Organization: me
User-Agent: KMail/4.13.2 (Linux/3.16.0-1-git; KDE/4.13.2; x86_64; ; )
In-Reply-To: <20140707122654.GQ5821@phenom.ffwll.local>
References: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch> <1974170.pJAPFfvtjC@grover> <20140707122654.GQ5821@phenom.ffwll.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

The patch below also works.  You can use my Tested By for it.

Thanks
Ed Tomlinson <edtoml@gmail.com>

PS. I _really_ need to get a serial console working on my i7 box.

On Monday 07 July 2014 14:26:54 Daniel Vetter wrote:
> On Mon, Jul 07, 2014 at 06:45:49AM -0400, Ed Tomlinson wrote:
> > Daniel,
> > 
> > I am not quite sure I understand what you want me to test?
> > Do you want me to try it without:
> > 
> > > > +               if (ret == 0) {
> > > > +                       ret = do_unregister_con_driver(&vga_con);
> 
> Below the diff of what I mean.
> -Daniel
> 
> 
> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
> index 5e583a1838f8..bd8517151479 100644
> --- a/drivers/gpu/drm/i915/i915_dma.c
> +++ b/drivers/gpu/drm/i915/i915_dma.c
> @@ -1466,12 +1466,13 @@ static int i915_kick_out_vgacon(struct drm_i915_private *dev_priv)
>  #else
>  static int i915_kick_out_vgacon(struct drm_i915_private *dev_priv)
>  {
> -	int ret;
> +	int ret = 0;
>  
>  	DRM_INFO("Replacing VGA console driver\n");
>  
>  	console_lock();
> -	ret = do_take_over_console(&dummy_con, 0, MAX_NR_CONSOLES - 1, 1);
> +	if (con_is_bound(&vga_con))
> +		ret = do_take_over_console(&dummy_con, 0, MAX_NR_CONSOLES - 1, 1);
>  	if (ret == 0) {
>  		ret = do_unregister_con_driver(&vga_con);
>  
> 

