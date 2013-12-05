Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab3LEAEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:04:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:38105 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab3LEAEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:04:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,829,1378882800"; 
   d="scan'208";a="419559328"
Date: Wed, 4 Dec 2013 16:04:09 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Cortes, Alexis" <alexis.cortes@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Benson Leung <bleung@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: Re: [PATCH] usb: hub: Use correct reset for wedged USB3 devices that
 are NOTATTACHED
Message-ID: <20131205000409.GA10678@xanatos>
References: <CAODwPW8j2wGGgH_HjuXuH=95jd_B1iqWeifoT89xgJoEZRvphw@mail.gmail.com>
 <Pine.LNX.4.44L0.1311071026480.1401-100000@iolanthe.rowland.org>
 <20131114233055.GR10371@xanatos>
 <31F406F20B26204E8066CA524505279A269C6840@DFLE12.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31F406F20B26204E8066CA524505279A269C6840@DFLE12.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, Nov 19, 2013 at 02:53:22PM +0000, Cortes, Alexis wrote:
> Hi Sarah,
> 
> Sorry for my delayed response, I just saw your e-mail (it got filtered somehow). About your question: actually I'm not sure, I'll have to check that to confirm it. I'll get back to you with an answer as soon as I have it.

Ping, Alexis: any info on this question?

Sarah Sharp

> -----Original Message-----
> From: Sarah Sharp [mailto:sarah.a.sharp@linux.intel.com] 
> Sent: Thursday, November 14, 2013 5:31 PM
> To: Alan Stern
> Cc: Julius Werner; Greg Kroah-Hartman; LKML; linux-usb@vger.kernel.org; Benson Leung; Vincent Palatin; Cortes, Alexis
> Subject: Re: [PATCH] usb: hub: Use correct reset for wedged USB3 devices that are NOTATTACHED
> 
> On Thu, Nov 07, 2013 at 10:32:33AM -0500, Alan Stern wrote:
> > On Wed, 6 Nov 2013, Julius Werner wrote:
> > 
> > > > What if the device is in USB_STATE_SUSPENDED?
> > > 
> > > I'm not sure that is possible at that point in hub_events(), I don't 
> > > know of a way that could lead to this situation. I could still add 
> > > the check just to be sure if you want it, though.
> > 
> > I don't know either.  But Sarah has said that ports can spontaneously 
> > go into Compliance Mode for no apparent reason.  If that can happen, 
> > maybe it can happen while the port is in U3 and the device is 
> > suspended.  In such cases, though, you'd need to do a reset-resume 
> > rather than a simple reset.
> 
> Looking at commits c3897aa5386faba77e5bbdf94902a1658d3a5b11 and 71c731a296f1b08a3724bd1b514b64f1bda87a23, it seems that the TI host controllers' ports can go into compliance mode only when a device is inserted.  Once the device is link trained by the redriver, the port shouldn't go into compliance mode.  So we should never see compliance mode on a port with an attached USB device in suspend.
> 
> Alex, can you confirm that the TI host's port won't go into compliance mode while a connected device is suspended?
> 
> > > > Not at all.  If a device is unplugged, its state changes to 
> > > > NOTATTACHED before the driver is unbound.  During that time, the 
> > > > driver will see all its URBs failing, so it may very well try to reset the device.
> > > > (For example, usbhid behaves like this.)  That isn't a bug.
> > > 
> > > Oh, okay, I wasn't quite sure how that plays together. Would you 
> > > think it's still valuable to print it out (maybe as dev_info() 
> > > instead of
> > > dev_warn()) instead of just silently ignoring the reset request? It 
> > > would have certainly been useful for me to find this problem faster, 
> > > but I can take it out again if you think it would result in too much 
> > > noise.
> > 
> > I think keeping dev_dbg() is best.  If you're searching for the 
> > solution to a problem, you should have debugging enabled and so you 
> > ought to see the message.
> > 
> > Alan Stern
> > 
