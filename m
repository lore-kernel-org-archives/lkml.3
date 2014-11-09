Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaKIUBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 15:01:50 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:43476 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaKIUBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 15:01:48 -0500
Date: Sun, 9 Nov 2014 12:01:42 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Sebastian Reichel <sre@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, B38611@freescale.com,
        jg1.han@samsung.com, linux-input@vger.kernel.org
Subject: Re: tsc2005 touchscreen: implement disable attribute
Message-ID: <20141109200142.GA37384@dtor-ws>
References: <20141109115636.GA3106@amd>
 <20141109124025.GA21763@earth.universe>
 <201411091349.20116@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201411091349.20116@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2014 at 01:49:19PM +0100, Pali Rohár wrote:
> On Sunday 09 November 2014 13:40:25 Sebastian Reichel wrote:
> > Hi,
> > 
> > On Sun, Nov 09, 2014 at 12:56:37PM +0100, Pavel Machek wrote:
> > > Implement disable attribute for tsc2005 touchscreen. It is
> > > useful to avoid wakeups when phone is in the pocket.
> > 
> > I don't think this should be some driver specific sysfs node.
> > Instead a generic method from the input subsystem should be
> > used.
> > 
> > -- Sebastian
> 
> Yes. I would like to see generic method to turn off input device 
> (or just "mute" it if device does not support turn off). Similar 
> problem is also on laptops or other portable devices. E.g when I 
> close LID of my laptop I want to turn off internal input devices 
> (keyboard, touchpad, trackstick) without need to unload evdev 
> Xserver drivers (or killing Xserver). Another use case is to turn 
> off keyboard (also from kernel tty on Ctrl+Alt+Fx) which cannot 
> be unplugged (internal laptop keyboard).
> 
> CCed Dmitry, what do you think about it?

Actually I'd like it to be not limited to input devices but rater try
doing it at the device core level, if possible. I am sure there are IIO
and other devices that could be forcibly turned off/put into low power
mode under certain circumstances.

There were some talks about it with Rafael, but we never come with
anything concrete.

Thanks.

-- 
Dmitry
