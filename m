Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934654Ab3CZPUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:20:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:26185 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934635Ab3CZPUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:20:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,913,1355126400"; 
   d="scan'208";a="219045867"
Date: Tue, 26 Mar 2013 15:20:29 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Danny Baumann <dannybaumann@web.de>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/1] drm/i915: Allow specifying a minimum brightness
 level for sysfs control.
Message-ID: <20130326152029.GA993@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Danny Baumann <dannybaumann@web.de>,
	David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <1364298525-4337-1-git-send-email-dannybaumann@web.de>
 <1364298525-4337-2-git-send-email-dannybaumann@web.de>
 <20130326151313.GU9021@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326151313.GU9021@phenom.ffwll.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 04:13:13PM +0100, Daniel Vetter wrote:
> On Tue, Mar 26, 2013 at 12:48:45PM +0100, Danny Baumann wrote:
> > When controlling backlight devices via sysfs interface, user space
> > generally assumes the minimum level (0) still providing a brightness
> > that is usable by the user (probably due to the most commonly used
> > backlight device, acpi_videoX, behaving exactly like that). This doesn't
> > match the current behaviour of the intel_backlight control, though, as
> > the value 0 means 'backlight off'.
> > 
> > In order to make intel_backlight consistent to other backlight devices,
> > introduce a module parameter that allows shifting the 0 level of the
> > intel_backlight device. It's expressed in percentages of the maximum
> > level. The default is 5, which provides a backlight level that is barely
> > readable. Setting it to 0 restores the old behaviour.
> > 
> > Signed-off-by: Danny Baumann <dannybaumann@web.de>
> 
> Thus far our assumption always was that the acpi backlight works better
> than the intel native backlight. So everything only uses the intel
> backlight if there's no other backlight driver by default.

There are machines, such as the pnv netbook on my desk, on which
intel_backlight does nothing and the only control is through
acpi_backlight0. Generalising expected behaviour based on one firmware
implementation is fraught with danger.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
