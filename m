Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab3KUFGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 00:06:06 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:58339 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3KUFGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 00:06:04 -0500
Date: Wed, 20 Nov 2013 21:05:51 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Friedrich =?iso-8859-1?Q?Sch=F6ller?= <linux@schoeller.se>
Cc: Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Input: Added thumb detection in BCM5974 multitouch
 driver
Message-ID: <20131121050549.GC4702@core.coreip.homeip.net>
References: <1384988052-31898-1-git-send-email-linux@schoeller.se>
 <1384988052-31898-3-git-send-email-linux@schoeller.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1384988052-31898-3-git-send-email-linux@schoeller.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Friedrich,

On Wed, Nov 20, 2013 at 11:54:12PM +0100, Friedrich Schöller wrote:
> Trackpads with integrated buttons are hard to use when the driver responds to
> movements of the thumb that is resting or clicking on the surface of the
> trackpad. This patch adds rudimentary support to filter out these touch events.
> 
> The feature can be turned on via sysfs:
> 	/sys/class/input/input[0-9]+/thumb_ignore:
> 		Enables thumb detection
> 		Values: 0/1
> 	/sys/class/input/input[0-9]+/thumb_ratio_on:
> 		When the ratio of ABS_MT_TOUCH_MINOR / ABS_MT_TOUCH_MAJOR
> 		times 100 is smaller than this value the touch qualifies
> 		as a thumb.
> 	/sys/class/input/input[0-9]+/thumb_ratio_off:
> 		When the ratio of ABS_MT_TOUCH_MINOR / ABS_MT_TOUCH_MAJOR
> 		times 100 is bigger than this value the touch no longer
> 		qualifies as a thumb.
> 	/sys/class/input/input[0-9]+/thumb_y_on:
> 		When ABS_MT_POSITION_Y is bigger than this value the touch
> 		qualifies as a thumb.
> 	/sys/class/input/input[0-9]+/thumb_y_off:
> 		When ABS_MT_POSITION_Y is smaller than this value the touch
> 		no longer qualifies as a thumb.

I'd rather this been implemented in userspace (synaptics and/or evdev X
drivers).

Thanks.

-- 
Dmitry
