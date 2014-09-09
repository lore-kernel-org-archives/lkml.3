Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaIIXPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 19:15:22 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:65159 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaIIXPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 19:15:21 -0400
Date: Tue, 9 Sep 2014 16:15:18 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Andrew Duggan <aduggan@synaptics.com>, linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Christopher Heiny <cheiny@synaptics.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: synaptics - add support for ForcePads
Message-ID: <20140909231518.GA4908@core.coreip.homeip.net>
References: <20140908165520.GA35051@core.coreip.homeip.net>
 <540EAFD1.2040307@redhat.com>
 <20140909170636.GA28774@core.coreip.homeip.net>
 <540F7A19.3070704@synaptics.com>
 <20140909225725.GA18901@core.coreip.homeip.net>
 <540F8816.5080908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540F8816.5080908@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 01:07:02AM +0200, Hans de Goede wrote:
> Hi,
> 
> On 09/10/2014 12:57 AM, Dmitry Torokhov wrote:
> > On Tue, Sep 09, 2014 at 03:07:21PM -0700, Andrew Duggan wrote:
> >> On 09/09/2014 10:06 AM, Dmitry Torokhov wrote:
> >>> On Tue, Sep 09, 2014 at 09:44:17AM +0200, Hans de Goede wrote:
> >>>> Hi,
> >>>>
> >>>> On 09/08/2014 06:55 PM, Dmitry Torokhov wrote:
> >>>>> ForcePads are found on HP EliteBook 1040 laptops. They lack any kind of
> >>>>> physical buttons, instead they generate primary button click when user
> >>>>> presses somewhat hard on the surface of the touchpad. Unfortunately they
> >>>>> also report primary button click whenever there are 2 or more contacts
> >>>>> on the pad, messing up all multi-finger gestures (2-finger scrolling,
> >>>>> multi-finger tapping, etc). To cope with this behavior we introduce a
> >>>>> delay (currently 50 msecs) in reporting primary press in case more
> >>>>> contacts appear.
> >>>>>
> >>>>> For now we are using DMI matching to detect ForcePads, hopefully we'll
> >>>>> be able to figure a better way down the road.
> >>>> What about using the pnp-id, in my experience with the recent lenovo
> >>>> laptops that tends to be more reliable.
> >>> Not sure. So far I only know of HP 1040 having it. FWIW:
> >>>
> >>> dtor@dtor-glaptop:~$ cat /sys/bus/pnp/drivers/i8042\ aux/00\:07/id
> >>> SYN300d
> >>> SYN0100
> >>> SYN0002
> >>> PNP0f13
> >>>
> >>> I think if we see generalities we can switch over later. I hope
> >>> Chris/Andrew will come with a capability bit though :)
> >>
> >> The ForcePad capabilities bit is 1 << 15.
> > 
> > Awesome, thanks!
> > 
> > Then I guess the patch below is what we'll be needing for these devices.
> 
> Yep, the patch looks good to me.

Thanks, I'll put you down as reviewed-by then.

-- 
Dmitry
