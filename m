Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbaEHOH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:07:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42598 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751309AbaEHOH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:07:26 -0400
Date: Thu, 8 May 2014 10:07:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Hans de Goede <hdegoede@redhat.com>
cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, <kishon@ti.com>,
        Boris Brezillon <boris@free-electrons.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <kevin.z.m.zh@gmail.com>,
        <sunny@allwinnertech.com>, <shuge@allwinnertech.com>,
        <zhuzhenhua@allwinnertech.com>, <linux-sunxi@googlegroups.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 4/7] usb: ehci-platform: add optional reset controller
 retrieval
In-Reply-To: <536B324C.1040806@redhat.com>
Message-ID: <Pine.LNX.4.44L0.1405081002190.1087-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Hans de Goede wrote:

> Hi,
> 
> On 05/08/2014 12:00 AM, Maxime Ripard wrote:
> > On Wed, May 07, 2014 at 10:25:55AM -0400, Alan Stern wrote:
> >> On Tue, 6 May 2014, Maxime Ripard wrote:
> >>
> >>> From: Boris BREZILLON <boris.brezillon@free-electrons.com>
> >>>
> >>> On the Allwinner's A31 SoC the reset line connected to the EHCI IP has to
> >>> be deasserted for the EHCI block to be usable.
> >>>
> >>> Add support for an optional reset controller that will be deasserted on
> >>> power off and asserted on power on.
> >>>
> >>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> >>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> >>
> >> Is this really a _reset_ line?  That is, when you assert the reset 
> >> line, does it actually reset the EHCI controller, or does it merely 
> >> leave the controller in a partially powered-down state?
> > 
> > It actually resets the whole controller.
> > 
> >> The difference is important.  During suspend, the controller is
> >> supposed to remember the state of the port connections as well as other
> >> settings.  If it doesn't, the controller and all attached USB devices
> >> will have to be reinitialized every time the controller resumes, which
> >> will increase the latency.
> > 
> > So you're saying that we should move this to the probe then?
> 
> Yes.

That's right.  The controller should not be reset during suspend, if
you can possibly avoid it.

There isn't any real benefit to asserting the reset signal during 
suspend, is there?  I mean, it won't use any less power, right?

Alan Stern

