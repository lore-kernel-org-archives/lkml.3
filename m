Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab3LMSPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 13:15:54 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:60508 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752732Ab3LMSPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 13:15:53 -0500
Date: Fri, 13 Dec 2013 13:15:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dan Williams <dan.j.williams@intel.com>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Julius Werner <jwerner@chromium.org>,
        Vikas Sajjan <sajjan.linux@gmail.com>,
        Vikas Sajjan <vikas.sajjan@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Ksenia Ragiadakou <burzalodowa@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Douglas Anderson <dianders@chromium.org>, Felipe Balbi <balbi@ti.com>,
        sunil joshi <joshi@samsung.com>
Subject: Re: [PATCH] USB: core: Add warm reset while reset-resuming SuperSpeed
 HUBs
In-Reply-To: <CAPcyv4jvh_3ech7iCCcHyjwUjO=ki5oZo_bT-odt6_765oTi8Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1312131312230.1185-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec 2013, Dan Williams wrote:

> > I'm actually leaning towards enabling the check for warm reset broadly.
> > It seems like it wouldn't hurt to issue a warm reset on the USB 3.0
> > ports if they're in compliance, poll, or rx.detect.  So, let's enable
> > this broadly in xhci_resume, mark the patch for stable, but ask for the
> > backport to be delayed until 3.13.3 is out, to allow for more testing.
> > If anyone complains of xHCI behavior changes, we'll change the code to
> > add a quirk.
> 
> Is there a clean way to make this per-port rather than globally at
> xhci_resume()?  I am looking to hook into this for port power recovery
> as Tianyu's testing encountered "warm reset required" conditions at
> runtime_resume.  I'm still on the hunt for a solid reproducer, but it
> indicates this is a more general quirk with power session recovery.

There's no reason you can't do per-port testing inside xhci_resume
(assuming you know what to test for) as well as putting a warm reset in
the port-power handler of xhci_hub_control.

Of course, doing simultaneous warm resets on multiple ports will use 
less time than resetting each port individually, in sequence.

Alan Stern

