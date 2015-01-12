Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbbALN1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:27:37 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36077 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbbALN1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:27:35 -0500
Date: Mon, 12 Jan 2015 14:27:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC v10 15/19] media: Add registration helpers for V4L2
 flash sub-devices
Message-ID: <20150112132726.GB15838@amd>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-16-git-send-email-j.anaszewski@samsung.com>
 <20150109205432.GP18076@amd>
 <54B397F2.6060205@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B397F2.6060205@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>+	 * the state of V4L2_CID_FLASH_INDICATOR_INTENSITY control only.
> >>+	 * Therefore it must be possible to set it to 0 level which in
> >>+	 * the LED subsystem reflects LED_OFF state.
> >>+	 */
> >>+	if (cdata_id != INDICATOR_INTENSITY)
> >>+		++__intensity;
> >
> >And normally we'd do i++ instead of ++i, and avoid __ for local
> >variables...?
> 
> Pre-incrementation operator is favourable over the post-incrementation
> one if we don't want to have an access to the value of a variable before
> incrementation, which is the case here.

That may be some old C++ convention, but I'm pretty sure gcc does not
care.

> Maybe gcc detects the cases when the value of a variable is not assigned
> and doesn't copy it before incrementing, however I haven't found any
> reference. I see that often in the for loops the i++ version
> is used, but I am not sure if this is done because developers are
> aware that gcc will optimize it anyway or it is just an omission.

The code is equivalent, and normally the n++ version is used. gcc will
get it right.

> >>+struct v4l2_flash_ctrl_config {
> >>+	struct v4l2_ctrl_config intensity;
> >>+	struct v4l2_ctrl_config flash_intensity;
> >>+	struct v4l2_ctrl_config flash_timeout;
> >>+	u32 flash_faults;
> >>+	bool has_external_strobe:1;
> >>+	bool indicator_led:1;
> >>+};
> >
> >I don't think you are supposed to do boolean bit arrays.
> 
> These bit fields allow to reduce memory usage. If they were not bit
> fields, the address of the next variable would be aligned to the
> multiply of the CPU word size.
> Please look e.g. at struct dev_pm_info in the file include/linux/pm.h.
> It also contains boolean bit fields.

Looks like you are right. I guess I confused bool foo:1 with int
foo:1.

Thanks,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
