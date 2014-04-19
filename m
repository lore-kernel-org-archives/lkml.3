Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284AbaDST2p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 15:28:45 -0400
Received: from 6.mo68.mail-out.ovh.net ([46.105.63.100]:58847 "EHLO
	mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751095AbaDST2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 15:28:37 -0400
X-Greylist: delayed 1522 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Apr 2014 15:28:37 EDT
MIME-Version: 1.0
In-Reply-To: <CAOCHtYiCq6SBadzashe+mwKmx8_23=-++zyhRM=dtjEbgrQ98w@mail.gmail.com>
References: <1397814309-32160-1-git-send-email-jjhiblot@traphandler.com>
	<1397814309-32160-2-git-send-email-jjhiblot@traphandler.com>
	<535126D2.4080406@free-electrons.com>
	<CAOCHtYiCq6SBadzashe+mwKmx8_23=-++zyhRM=dtjEbgrQ98w@mail.gmail.com>
Date: Sat, 19 Apr 2014 21:03:10 +0200
Message-ID: <CACh+v5OoGqsF8bU=y-ToX8q+vv=6t0soLtMM3ZvC4DsE=0MbZg@mail.gmail.com>
Subject: Re: [RFC 1/3] atmel: drm: added drm driver for the atmel hlcd controller
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Robert Nelson <robertcnelson@gmail.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        dri-devel@lists.freedesktop.org, airlied@linux.ie,
        Rob Clark <robdclark@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-Ovh-Tracer-Id: 14443044005579872280
X-Ovh-Remote: 209.85.223.171 (mail-ie0-f171.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejvddrtdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejvddrtdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patch Robert.
I've just noticed that I actually worked with an old version of the
kernel (v3.14-rc3) when I thought it based on 3.15.

JJ

2014-04-18 16:31 GMT+02:00 Robert Nelson <robertcnelson@gmail.com>:
>
> On Fri, Apr 18, 2014 at 8:21 AM, Boris BREZILLON
> <boris.brezillon@free-electrons.com> wrote:
>> Hi JJ,
>>
>> On 18/04/2014 11:45, Jean-Jacques Hiblot wrote:
>>> +
>>> +static void update_scanout(struct drm_crtc *crtc)
>>> +{
>>> +     struct atmel_hlcdc_crtc *hlcdc_crtc = to_atmel_hlcdc_crtc(crtc);
>>> +     struct drm_device *dev = crtc->dev;
>>> +     struct atmel_hlcdc_drm_private *priv = dev->dev_private;
>>> +     struct drm_framebuffer *fb = crtc->fb;
>>> +
>>
>> I guess you meant
>>
>> struct drm_framebuffer *fb = hclcd_crtc->fb;
>>
>>
>> because otherwise you get an error when compiling (there are similar
>> issues below).
>
> This fixes this with v3.15-rc1
>
> diff --git a/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_crtc.c
> b/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_crtc.c
> index 649fa19..a111d69 100644
> --- a/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_crtc.c
> +++ b/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_crtc.c
> @@ -81,7 +81,7 @@ static void update_scanout(struct drm_crtc *crtc)
>   struct atmel_hlcdc_crtc *hlcdc_crtc = to_atmel_hlcdc_crtc(crtc);
>   struct drm_device *dev = crtc->dev;
>   struct atmel_hlcdc_drm_private *priv = dev->dev_private;
> - struct drm_framebuffer *fb = crtc->fb;
> + struct drm_framebuffer *fb = crtc->primary->fb;
>
>   struct drm_gem_cma_object *gem;
>   struct atmel_hlcd_dma_desc *desc = hlcdc_crtc->dma_descs[DMA_BASE];
> @@ -188,7 +188,7 @@ static int atmel_hlcdc_crtc_page_flip(struct drm_crtc *crtc,
>   return -EBUSY;
>   }
>
> - crtc->fb = fb;
> + crtc->primary->fb = fb;
>   atmel_hlcdc_crtc->event = event;
>   update_scanout(crtc);
>   return 0;
> @@ -397,7 +397,7 @@ static int atmel_hlcdc_crtc_mode_set(struct drm_crtc *crtc,
>   hlcdc_write(dev, ATMEL_LCDC_BASECFG0,
>      LCDC_BASECFG0_BLEN_AHB_INCR16 | LCDC_BASECFG0_DLBO);
>
> - drm_fb_get_bpp_depth(crtc->fb->pixel_format, &depth, &bpp);
> + drm_fb_get_bpp_depth(crtc->primary->fb->pixel_format, &depth, &bpp);
>   hlcdc_write(dev, ATMEL_LCDC_BASECFG1,
>      atmel_hlcdfb_get_rgbmode(dev->dev, depth, bpp));
>   hlcdc_write(dev, ATMEL_LCDC_BASECFG2, 0);
>
> Tested-by: Robert Nelson <robertcnelson@gmail.com>
>
> digs out my 31/33/34, should have a patch for them in a bit...
>
> Regards,
>
> --
> Robert Nelson
> http://www.rcn-ee.com/
