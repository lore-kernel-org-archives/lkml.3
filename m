Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaEBLHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 07:07:36 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49844 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751784AbaEBLH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 07:07:26 -0400
Date: Fri, 2 May 2014 14:06:51 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH/RFC v3 5/5] media: Add registration helpers for V4L2
 flash sub-devices
Message-ID: <20140502110651.GX8753@valkosipuli.retiisi.org.uk>
References: <1397228216-6657-1-git-send-email-j.anaszewski@samsung.com>
 <1397228216-6657-6-git-send-email-j.anaszewski@samsung.com>
 <20140416182141.GG8753@valkosipuli.retiisi.org.uk>
 <534F9044.6080508@samsung.com>
 <20140423152435.GJ8753@valkosipuli.retiisi.org.uk>
 <535E3A95.6010206@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535E3A95.6010206@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

On Mon, Apr 28, 2014 at 01:25:09PM +0200, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> On 04/23/2014 05:24 PM, Sakari Ailus wrote:
> >Hi Jacek,
> >
> >On Thu, Apr 17, 2014 at 10:26:44AM +0200, Jacek Anaszewski wrote:
> >>Hi Sakari,
> >>
> >>Thanks for the review.
> >>
> >>On 04/16/2014 08:21 PM, Sakari Ailus wrote:
> >>>Hi Jacek,
> >>>
> >>>Thanks for the update!
> >>>
> >>[...]
> >>>>+static inline enum led_brightness v4l2_flash_intensity_to_led_brightness(
> >>>>+					struct led_ctrl *config,
> >>>>+					u32 intensity)
> >>>
> >>>Fits on a single line.
> >>>
> >>>>+{
> >>>>+	return intensity / config->step;
> >>>
> >>>Shouldn't you first decrement the minimum before the division?
> >>
> >>Brightness level 0 means that led is off. Let's consider following case:
> >>
> >>intensity - 15625
> >>config->step - 15625
> >>intensity / config->step = 1 (the lowest possible current level)
> >
> >In V4L2 controls the minimum is not off, and zero might not be a possible
> >value since minimum isn't divisible by step.
> >
> >I wonder how to best take that into account.
> 
> I've assumed that in MODE_TORCH a led is always on. Switching
> the mode to MODE_FLASH or MODE_OFF turns the led off.
> This way we avoid the problem with converting 0 uA value to
> led_brightness, as available torch brightness levels start from
> the minimum current level value and turning the led off is
> accomplished on transition to MODE_OFF or MODE_FLASH, by
> calling brightness_set op with led_brightness = 0.

I'm not sure if we understood the issue the same way. My concern was that if
the intensity isn't a multiple of step (but intensity - min is), the above
formula won't return a valid result (unless I miss something).

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
