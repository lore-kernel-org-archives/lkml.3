Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbaLVVEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 16:04:55 -0500
Received: from netrider.rowland.org ([192.131.102.5]:48038 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754868AbaLVVEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 16:04:53 -0500
Date: Mon, 22 Dec 2014 16:04:53 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Doug Anderson <dianders@google.com>
cc: Wu Liang feng <wulf@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Tao Huang <huangtao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        Eddie Cai <eddie.cai@rock-chips.com>, Roy Li <roy.li@rock-chips.com>,
        Chris <zyw@rock-chips.com>, Julius Werner <jwerner@google.com>,
        Pawel Osciak <posciak@google.com>, Tomasz Figa <tfiga@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 2/2] USB: ehci-platform: Support ehci reset after resume
 quirk
In-Reply-To: <CAD=FV=UWOOwr3K6vPbAiHTUuv1DdbVRQ1yKKWWS6KOv6J4B51w@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1412221553230.32109-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2014, Doug Anderson wrote:

> Alan,
> 
> On Mon, Dec 22, 2014 at 8:06 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Mon, 22 Dec 2014, Wu Liang feng wrote:
> >
> >> The EHCI controller doesn't properly detect the case when
> >
> > "The" EHCI controller?  I don't know what EHCI controller you're
> > talking about, but my controllers don't have any trouble detecting
> > device removal during suspend.
> 
> This is specifically the EHCI controller on rk3288.  Not sure why Wu
> Liang feng removed that part of the description.

Maybe it could be put back in.

> > Isn't this solution too extreme?  What if the device was a flash
> > storage drive and it wasn't unplugged during suspend?  This patch would
> > force it to be removed, messing up any mounted filesystems, when there
> > was no need.
> 
> I'm told by Julius (CCed, who knows the USB stack infinitely better
> than I do) that you can work around this using "persist".  I would
> imagine that anyone on a machine using hibernation would run into the
> same problem, right?

> We asked a lot about this and you can find a whole set of detailed
> discussion at:
> 
> https://chromium-review.googlesource.com/#/c/232077/1/drivers/usb/host/ehci-platform.c
> 
> 
> Since I don't know the USB subsystem particularly well, my review
> isn't terribly meaningful, but just in case:
> 
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> 
> 
> On rk3288-pinky I have tested that without this patch the EHCI
> controller flips out when a USB webcam is plugged into the port and is
> power cycled across suspend/resume.  With this patch the controller
> properly unplugs / replugs the webcam.
> 
> Tested-by: Doug Anderson <dianders@chromium.org>

I assume you also tested the case where the webcam is _not_ 
power-cycled during the suspend.

On Mon, 22 Dec 2014, Julius Werner wrote:

> As Doug said, I think persist is the solution. We have essentially the
> same case: all we know is that there is now a device connected to the 
> same port that a device had been connected during suspend... but with 
> no guarantees whether it is the same device or in the same state. By  
> forcing people to use persist, we acknowledge that this has the same  
> risks (e.g. data corruption if a mounted mass storage device was
> swapped out for another one), and we benefit from the same safety
> checks like comparing the serial number.

Okay, I see.  This makes sense.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

