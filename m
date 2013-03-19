Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933653Ab3CSSTC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 14:19:02 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56271 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933316Ab3CSSTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 14:19:00 -0400
Date: Tue, 19 Mar 2013 14:18:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Vetter <daniel.vetter@ffwll.ch>
cc: Chris Wilson <chris@chris-wilson.co.uk>, Jiri Kosina <jkosina@suse.cz>,
        Greg KH <greg@kroah.com>, Harald Arnesen <skogtun.linux@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Meyer <thomas@m3y3r.de>, Shawn Starr <shawn.starr@rogers.com>,
        USB list <linux-usb@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Imre Deak <imre.deak@intel.com>,
        Daniel Kurtz <djkurtz@chromium.org>, <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        <x86@kernel.org>, Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: gm45 intel gfx can generate non-MSI irq# in MSI mode (was Re:
 [PATCH] drm/i915: stop using GMBUS IRQs on Gen4 chips (was Re: [3.9-rc1]
 irq 16: nobody cared (was [3.9-rc1] very poor interrupt respo
In-Reply-To: <CAKMK7uGtLcuSsoumAgdB7ri+fR5ReNYcZELbqDcSueXVsewppg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1303191417440.1302-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Mar 2013, Daniel Vetter wrote:

> > That might be misleading.  It's possible that the erroneous IRQs _are_
> > being issued but you're simply not aware of them.  If the kernel thinks
> > that no device is using IRQ 16 then it will leave that IRQ disabled.
> 
> I guess I should have phrased it more precisely, but that's exactly
> what I expect is happening on my machine: I don't have anything on
> irq16 (i.e. in non-msi mode the gfx interrupt isn't shared) and hence
> the irq is completely disabled. Which obviously makes it impossible
> for me to reproduce the issue. To test that theory, is there a quick
> way to force-enable a given interrupt, short of just hacking up a 2nd
> dummy irq handler in my driver?

I don't know of any way.  In fact, I have been thinking of writing a 
test driver module, with a module parameter telling it which IRQ number 
to register for.  It seems like the sort of thing that would be useful 
to have, from time to time.

Alan Stern

