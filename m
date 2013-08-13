Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab3HMJf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:35:57 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:59710 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab3HMJfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:35:55 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130813092554.GA4519@cantiga.alporthouse.com>
References: <CA+icZUWmee5nTZCGvFb4vLpna5vUn+RJ-V9pHpKPFaTc96BG5Q@mail.gmail.com>
	<20130813092554.GA4519@cantiga.alporthouse.com>
Date: Tue, 13 Aug 2013 11:35:53 +0200
Message-ID: <CA+icZUUrJt_sJqp0CNMuM_b36tvv_rUskegLY5zcnm0w+JcW5Q@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 13 [ screen corruption in graphical mode ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>, DRI <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Cc: "s.dilek" <s.dilek@jpberlin.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 11:25 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Tue, Aug 13, 2013 at 11:10:18AM +0200, Sedat Dilek wrote:
>> Hi,
>>
>> with today's next-20130813 I cannot see 1/10 of my desktop-screen's
>> top, it's simply black.
>> I can estimate the URL line in Firefox (or open a new tab blindly and
>> get a known URL from my autocompleted history).
>
> Can you attach a photograph?
>

It's a black bar on the top of my desktop-screen - approx. 1/10.

It looks like this is also in the VT on bootup before entering LightDM.

>> My Xorg stack did not change: libdrm-2.4.46 | mesa-9.16 | intel-ddx-2.4.14.
>> next-20130808 was OK - no screen corruptions.
>>
>> Any idea, hint?
>
> Can you please try:
>
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index af1b2f0..b0f181d 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -1837,7 +1837,7 @@ intel_pin_and_fence_fb_obj(struct drm_device *dev,
>                 break;
>         case I915_TILING_X:
>                 /* pin() will align the object as required by fence */
> -               alignment = 0;
> +               alignment = 256 * 1024;
>                 break;
>         case I915_TILING_Y:
>                 /* Despite that we check this in framebuffer_init userspace can
>
> --

NO, that did not help.

After a logout from my "BROKEN" Unity-2D session - the login-screen
for LightDM seems to be OK.
Then entering my Unity-2D desktop is OK - no screen corruptions.

- Sedat -
