Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbaHFGyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 02:54:38 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39237 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753338AbaHFGyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 02:54:36 -0400
Date: Wed, 6 Aug 2014 09:53:58 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com
Subject: Re: [PATCH/RFC v4 00/21] LED / flash API integration
Message-ID: <20140806065358.GC16460@valkosipuli.retiisi.org.uk>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

On Fri, Jul 11, 2014 at 04:04:03PM +0200, Jacek Anaszewski wrote:
...
> 1) Who should register V4L2 Flash sub-device?
> 
> LED Flash Class devices, after introduction of the Flash Manager,
> are not tightly coupled with any media controller. They are maintained
> by the Flash Manager and made available for dynamic assignment to
> any media system they are connected to through multiplexing devices.
> 
> In the proposed rough solution, when support for V4L2 Flash sub-devices
> is enabled, there is a v4l2_device created for them to register in.
> This however implies that V4L2 Flash device will not be available
> in any media controller, which calls its existence into question.
> 
> Therefore I'd like to consult possible ways of solving this issue.
> The option I see is implementing a mechanism for moving V4L2 Flash
> sub-devices between media controllers. A V4L2 Flash sub-device
> would initially be assigned to one media system in the relevant
> device tree binding, but it could be dynamically reassigned to
> the other one. However I'm not sure if media controller design
> is prepared for dynamic modifications of its graph and how many
> modifications in the existing drivers this solution would require.

Do you have a use case where you would need to strobe a flash from multiple
media devices at different times, or is this entirely theoretical? Typically
flash controllers are connected to a single source of hardware strobe (if
there's one) since the flash LEDs are in fact mounted next to a specific
camera sensor.

If this is a real issue the way to solve it would be to have a single media
device instead of many.

> 2) Consequences of locking the Flash Manager during flash strobe
> 
> In case a LED Flash Class device depends on muxes involved in
> routing the other LED Flash Class device's strobe signals,
> the Flash Manager must be locked for the time of strobing
> to prevent reconfiguration of the strobe signal routing
> by the other device.

I wouldn't be concerned of this in particular. It's more important we do
actully have V4L2 flash API supported by LED flash drivers and that they do
implement the API correctly.

It's at least debatable whether you should try to prevent user space from
doing silly things or not. With complex devices it may relatively easily
lead to wrecking havoc with actual use cases which we certainly do not want.

In this case, if you just prevent changing the routing (do you have a use
case for it?) while strobing, someone else could still change the routing
just before you strobe.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
