Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaG3VEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:04:10 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:34755 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaG3VEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:04:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAKMK7uGcFhfzeNTPNk=X_N=C4pda0LTtsb51JLGNBZAU5kg6tg@mail.gmail.com>
References: <1406742127-27654-1-git-send-email-benjamin.gaignard@linaro.org>
	<1406742127-27654-12-git-send-email-benjamin.gaignard@linaro.org>
	<CAKMK7uGcFhfzeNTPNk=X_N=C4pda0LTtsb51JLGNBZAU5kg6tg@mail.gmail.com>
Date: Wed, 30 Jul 2014 17:04:07 -0400
Message-ID: <CAF6AEGsA_j1BNP0mwcHPDRJxMRygBP0-GeSYSuTrM9u=RH5guw@mail.gmail.com>
Subject: Re: [PATCH v8 11/11] drm: sti: Add DRM driver itself
From: Rob Clark <robdclark@gmail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 3:48 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Wed, Jul 30, 2014 at 7:42 PM, Benjamin Gaignard
> <benjamin.gaignard@linaro.org> wrote:
>> @@ -87,11 +90,50 @@ static int sti_compositor_bind(struct device *dev, struct device *master,
>>         struct sti_compositor *compo = dev_get_drvdata(dev);
>>         struct drm_device *drm_dev = data;
>>         unsigned int i, crtc = 0, plane = 0;
>> +       struct sti_drm_private *dev_priv = drm_dev->dev_private;
>> +       struct drm_plane *cursor = NULL;
>> +       struct drm_plane *primary = NULL;
>> +
>> +       dev_priv->compo = compo;
>>
>>         drm_vblank_init(drm_dev, crtc);
>
>
> This looks strange - you should pass this the total number of crtcs
> (the same that eventually ends up in dev->mode_config.num_crtc), not
> 0. And the assignement of cursors to crtcs looks a bit strange on

hmm, Benjamin probably should try modetest w/ -v arg..  it does look a
bit like something is missing here..

BR,
-R

> first read-through, but I have no clue about the sti hw. And in any
> case those pointers really only matter for backwards compat with
> existing pageflip and cursor ioctls, so doesn't really matter too
> much.
>
> Anyway didn't spot anything else which would need to be upgrade to
> never kms interfaces, so ack from my side for that. Only looked at
> that since right now I'm refreshing drm docs in those areas ;-)
> -Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
