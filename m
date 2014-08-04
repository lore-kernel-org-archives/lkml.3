Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaHDT6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:58:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaHDT6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:58:24 -0400
Date: Mon, 4 Aug 2014 12:58:23 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: Robert Baldyga <r.baldyga@samsung.com>, "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "andrzej.p@samsung.com" <andrzej.p@samsung.com>
Subject: Re: [PATCH v3 00/12] usb: dwc2/gadget: fix series
Message-ID: <20140804195823.GA29162@kroah.com>
References: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304844C400E@US01WEMBX2.internal.synopsys.com>
 <20140804191041.GA27436@kroah.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304844C40CF@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844C40CF@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 07:53:35PM +0000, Paul Zimmerman wrote:
> > From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> > Sent: Monday, August 04, 2014 12:11 PM
> > 
> > On Mon, Aug 04, 2014 at 06:58:23PM +0000, Paul Zimmerman wrote:
> > > > From: Paul Zimmerman
> > > > Sent: Friday, July 18, 2014 12:19 PM
> > > >
> > > > > From: Robert Baldyga [mailto:r.baldyga@samsung.com]
> > > > > Sent: Friday, July 18, 2014 4:39 AM
> > > > >
> > > > > This patchset contains fixes for dwc2 gadget driver. It touches PHY,
> > > > > FIFO configuration, initialization sequence and adds many other small fixes.
> > > > >
> > > > > Best regards
> > > > > Robert Baldyga
> > > > > Samsung R&D Institute Poland
> > > > >
> > > > > Changelog:
> > > > > v3:
> > > > >  - use endpoint index instead of FIFO index for EPFIFO
> > > > >  - extend patch description
> > > > >
> > > > > v2: https://lkml.org/lkml/2014/7/16/199
> > > > >  - add patch usb: dwc2/gadget: avoid disabling ep0
> > > > >  - fix FIFO flushing when it's assigned to endpoint dynamically
> > > > >  - write to proper FIFO in s3c_hsotg_write_fifo() function
> > > > >  - use real FIFO size in kill_all_requests
> > > > >  - fix comment in s3c_hsotg_init_fifo() function
> > > > >
> > > > > v1: https://lkml.org/lkml/2014/6/23/67
> > > > >
> > > > > Andrzej Pietrasiewicz (1):
> > > > >   usb: dwc2/gadget: Fix comment text
> > > > >
> > > > > Kamil Debski (3):
> > > > >   usb: dwc2/gadget: fix phy disable sequence
> > > > >   usb: dwc2/gadget: fix phy initialization sequence
> > > > >   usb: dwc2/gadget: move phy bus legth initialization
> > > > >
> > > > > Marek Szyprowski (5):
> > > > >   usb: dwc2/gadget: hide some not really needed debug messages
> > > > >   usb: dwc2/gadget: ensure that all fifos have correct memory buffers
> > > > >   usb: dwc2/gadget: break infinite loop in endpoint disable code
> > > > >   usb: dwc2/gadget: do not call disconnect method in pullup
> > > > >   usb: dwc2/gadget: delay enabling irq once hardware is configured properly
> > > > >
> > > > > Robert Baldyga (3):
> > > > >   usb: dwc2/gadget: assign TX FIFO dynamically
> > > > >   usb: dwc2/gadget: disable clock when it's not needed
> > > > >   usb: dwc2/gadget: avoid disabling ep0
> > > > >
> > > > >  drivers/usb/dwc2/core.h   |   3 +
> > > > >  drivers/usb/dwc2/gadget.c | 184 +++++++++++++++++++++++++++-------------------
> > > > >  2 files changed, 111 insertions(+), 76 deletions(-)
> > > >
> > > > For the entire series:
> > > >
> > > > Acked-by: Paul Zimmerman <paulz@synopsys.com>
> > >
> > > Hi Greg,
> > >
> > > I don't see this series from Robert in your tree yet. Is it still in
> > > your queue, or should Robert resend it?
> > 
> > I thought this was coming in from Felipe's tree, sorry.  It's too late
> > for 3.17-rc1, I just sent out those patches to Linus.
> > 
> > If someone wants me to take a patch series, please be explicit and say
> > something like "Greg please take these in your tree", otherwise it is
> > very easy to get lost in my inbox...
> 
> Ah, OK. I guess that's my fault.
> 
> Still, the mainline merge window is open for two weeks, right? Any reason
> why you can't still send this series to Linus? I'd hate to see Robert
> lose out due to my screwup.

Patches had to be in my tree for the week _before_ the merge window
opened, to get testing in linux-next.  It's been that way for years,
sorry.

greg k-h
