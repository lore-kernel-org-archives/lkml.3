Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbaHYMpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 08:45:22 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64963 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbaHYMpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 08:45:19 -0400
Date: Mon, 25 Aug 2014 14:45:39 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Mark Rutland <mark.rutland@arm.com>, linux-pwm@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <pawel.moll@arm.com>,
        devicetree@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Rob Herring <robh+dt@kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Bo Shen <voice.shen@atmel.com>, Kumar Gala <galak@codeaurora.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 00/11] drm: add support for Atmel HLCDC Display
 Controller
Message-ID: <20140825124539.GC15520@phenom.ffwll.local>
Mail-Followup-To: Thierry Reding <thierry.reding@gmail.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Mark Rutland <mark.rutland@arm.com>, linux-pwm@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>,
	Pawel Moll <pawel.moll@arm.com>, devicetree@vger.kernel.org,
	Lee Jones <lee.jones@linaro.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Rob Herring <robh+dt@kernel.org>,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Bo Shen <voice.shen@atmel.com>, Kumar Gala <galak@codeaurora.org>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Andrew Victor <linux@maxim.org.za>,
	linux-arm-kernel@lists.infradead.org
References: <1406034695-15534-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140821081619.GZ2452@ldesroches-Latitude-E6320>
 <20140821103706.2349915d@bbrezillon>
 <20140821090406.GA13733@ulmo>
 <20140821114159.319e741b@bbrezillon>
 <20140821095202.GA21848@ulmo>
 <20140821150600.37788d82@bbrezillon>
 <20140821131552.GA19293@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821131552.GA19293@ulmo.nvidia.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 03:16:08PM +0200, Thierry Reding wrote:
> On Thu, Aug 21, 2014 at 03:06:00PM +0200, Boris BREZILLON wrote:
> > On Thu, 21 Aug 2014 11:52:03 +0200
> > Thierry Reding <thierry.reding@gmail.com> wrote:
> > 
> > > On Thu, Aug 21, 2014 at 11:41:59AM +0200, Boris BREZILLON wrote:
> > > > On Thu, 21 Aug 2014 11:04:07 +0200
> > > > Thierry Reding <thierry.reding@gmail.com> wrote:
> > > > 
> > > > > On Thu, Aug 21, 2014 at 10:37:06AM +0200, Boris BREZILLON wrote:
> > > > > > Hi Ludovic,
> > > > > > 
> > > > > > On Thu, 21 Aug 2014 10:16:19 +0200
> > > > > > Ludovic Desroches <ludovic.desroches@atmel.com> wrote:
> > > > > > 
> > > > > > > Hi Boris,
> > > > > > > 
> > > > > > > You can add
> > > > > > > 
> > > > > > > Tested-by: Ludovic Desroches <ludovic.desroches@atmel.com>
> > > > > > 
> > > > > > Thanks for testing this driver.
> > > > > > 
> > > > > > > 
> > > > > > > Only one issue but not related to your patches, you can't display
> > > > > > > quickly the bootup logo since the panel detection takes too much
> > > > > > > time.
> > > > > > 
> > > > > > Yes, actually this is related to the device probe order: the
> > > > > > hlcdc-display-controller device is probed before the simple-panel, thus
> > > > > > nothing is detected on the RGB connector (I use of_drm_find_panel to
> > > > > > check for panel availability) when the display controller is
> > > > > > instantiated. I rely on the default polling infrastructure provided by
> > > > > > the DRM/KMS framework which polls for a new connector every 10s, and
> > > > > > this is far more than you kernel boot time.
> > > > > > 
> > > > > > Do anyone see a solution to reduce this delay (without changing the
> > > > > > polling interval). I thought we could add a notifier infrastructure to
> > > > > > the DRM panel framework, but I'm not sure this is how you want things
> > > > > > done...
> > > > > 
> > > > > Other drivers return -EPROBE_DEFER when a panel hasn't been registered
> > > > > yet. This will automatically take care of ordering things in a way that
> > > > > DRM/KMS will only be initialized after the panel has been probed.
> > > > 
> > > > Actually I'd like to avoid doing this with a deferred probe, because,
> > > > AFAIU, the remote endpoint is not tightly linked with the display
> > > > controller driver (I mean the display controller can still be
> > > > initialized without having a display connected on it).
> > > > Moreover the atmel dev kit I'm using has an HDMI bridge connected on
> > > > the same RGB connector and I'd like to use it in a near future.
> > > > Returning -EPROBE_DEFER in case of several devices connected on the
> > > > same connector implies that I'll have to wait for all the remote
> > > > end-points to be available before my display controller could be
> > > > instantiated.
> > > > 
> > > > While this could be acceptable when all drivers are statically linked
> > > > in the kernel, it might be problematic when you're using modules,
> > > > meaning that you won't be able to display anything on your LCD panel
> > > > until your HDMI bridge module has been loaded.
> > > 
> > > No. HDMI should be using proper hotplugging anyway, hence it should be
> > > always be loaded anyway. You're in for a world of pain if you think you
> > > can run DRM with a driver that's composed of separate kernel modules.
> > 
> > I was talking about the external RGB to HDMI encoder, should the driver
> > for this encoder (which is not on On Chip block) be compiled
> > statically too ?
> > 
> > > 
> > > Also if you don't want to use deferred probe, then you're in for the
> > > full hotplugging panel dance and that implies that you need to fix a
> > > bunch of things in DRM (one being the framebuffer console instantiation
> > > that I referred to in the other thread).
> > 
> > For now, I wait until there is a device connected on the RGB connector
> > (connector status set to connector_status_connected) before creating an
> > fbdev. It might not be the cleanest way to solve this issue, but it
> > works :-).
> 
> Yeah, I guess that's one way to do it. But it's tricky to get right when
> you have several outputs. Which one should be considered the primary and
> trigger fbdev creation?

We could just reallocate the fbdev backing storage (probably only increase
it for safety since fbdev is bonghits) when new outputs show up. There has
been (and maybe still is) some provisions in the fbdev helper library to
do just that.

Mostly it would mean to split out drm_fb_helper_single_fb_probe so that
drivers could call it from their hotplug work. And then adjust the
->fb_probe callback of drivers which do this to reallocate the fbdev
buffer if it's only a resize. Overall this shouldn't be too much fuzz to
get going. Of course only as an opt-in, but imo that's the only sane way
to do this anyway.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
