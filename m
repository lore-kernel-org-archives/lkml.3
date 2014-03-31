Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbaCaJ0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 05:26:47 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34311 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753520AbaCaJ0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 05:26:45 -0400
Date: Mon, 31 Mar 2014 12:26:40 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH/RFC 1/8] leds: Add sysfs and kernel internal API for
 flash LEDs
Message-ID: <20140331092640.GB4522@valkosipuli.retiisi.org.uk>
References: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
 <1395327070-20215-2-git-send-email-j.anaszewski@samsung.com>
 <20140323231833.GA2054@valkosipuli.retiisi.org.uk>
 <5335958B.80107@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5335958B.80107@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

On Fri, Mar 28, 2014 at 04:30:19PM +0100, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> Thanks for the review.
> 
> On 03/24/2014 12:18 AM, Sakari Ailus wrote:
> >Hi Jacek,
> >
> >Thanks for the patchset. It's very nice in general. I have a few comments
> >below.
> 
> [...]
> 
> >>diff --git a/include/linux/leds.h b/include/linux/leds.h
> >>index 0287ab2..1bf0ab3 100644
> >>--- a/include/linux/leds.h
> >>+++ b/include/linux/leds.h
> >>@@ -17,6 +17,14 @@
> >>  #include <linux/rwsem.h>
> >>  #include <linux/timer.h>
> >>  #include <linux/workqueue.h>
> >>+#include <linux/mutex.h>
> >
> >mutex.h should be earlier in the list of included files.
> >
> >>+#include <media/v4l2-device.h>
> >>+
> >>+#define LED_FAULT_OVER_VOLTAGE		(1 << 0)
> >>+#define LED_FAULT_TIMEOUT		(1 << 1)
> >>+#define LED_FAULT_OVER_TEMPERATURE	(1 << 2)
> >>+#define LED_FAULT_SHORT_CIRCUIT		(1 << 3)
> >>+#define LED_FAULT_OVER_CURRENT		(1 << 4)
> >
> >This patch went in to the media-tree some time ago. I wonder if the relevant
> >bits should be added here now as well.
> >
> >commit 935aa6b2e8a911e81baecec0537dd7e478dc8c91
> >Author: Daniel Jeong <gshark.jeong@gmail.com>
> >Date:   Mon Mar 3 06:52:08 2014 -0300
> >
> >     [media] v4l2-controls.h: Add addtional Flash fault bits
> >
> >     Three Flash fault are added. V4L2_FLASH_FAULT_UNDER_VOLTAGE for the case low
> >     voltage below the min. limit. V4L2_FLASH_FAULT_INPUT_VOLTAGE for the case
> >     falling input voltage and chip adjust flash current not occur under voltage
> >     event. V4L2_FLASH_FAULT_LED_OVER_TEMPERATURE for the case the temperature
> >     exceed the maximun limit
> >
> >     Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
> >     Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> >     Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> 
> As it will not cause a build break and any runtime problems, even if
> the patch is not merged, I added these bits to my implementation.
> 
> BTW I have doubts about V4L2_FLASH_FAULT_INDICATOR and
> V4L2_CID_FLASH_INDICATOR_INTENSITY control. I did not take them
> into account in my implementation because it is not clear for
> me how an indicator led is related to a torch led. There is
> a control for setting indicator intensity but there is not
> one for enabling it. Could you shed some light on this issue?

The indicator isn't related to the torch mode in any way. Some flash
controllers contain an additional output for indicator, also called privacy
led. These faults are related to that.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
