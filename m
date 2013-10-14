Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab3JNTsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:48:22 -0400
Received: from netrider.rowland.org ([192.131.102.5]:54722 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757480Ab3JNTsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:48:20 -0400
Date: Mon, 14 Oct 2013 15:48:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
cc: gregkh@linuxfoundation.org, <sarah.a.sharp@linux.intel.com>,
        <tianyu.lan@intel.com>, <broonie@linaro.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb/hcd: remove unnecessary local_irq_save
In-Reply-To: <525B63AB.8070601@free-electrons.com>
Message-ID: <Pine.LNX.4.44L0.1310141545430.6851-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Oct 2013, Michael Opdenacker wrote:

> Hi Alan,
> 
> On 10/13/2013 05:35 PM, Alan Stern wrote:
> > On Sun, 13 Oct 2013, Michael Opdenacker wrote:
> >
> >> Remove the use of local_irq_save() and IRQF_DISABLED, no longer needed since
> >> interrupt handlers are always run with interrupts disabled on the
> >> current CPU.
> >>
> >> Tested successfully with 3.12.0-rc4 on my PC. Didn't find
> >> any issue because of this change.
> >>
> >> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> >> ---
> >>  drivers/usb/core/hcd.c | 15 ---------------
> >>  1 file changed, 15 deletions(-)
> > How about removing all the other unnecessary usages of IRQF_DISABLED
> > under drivers/usb while you're at it?
> I believe I already did, through patches sent on Oct. 6:
> 
> drivers/usb/gadget/mv_u3d_core.c:               IRQF_DISABLED |
> IRQF_SHARED, driver_name, u3d)) {
> => Sent fix on Oct. 6, 2013
> 
> drivers/usb/host/uhci-platform.c:       ret = usb_add_hcd(hcd,
> pdev->resource[1].start, IRQF_DISABLED |
> => Sent fix on Oct. 6, 2013

Ah, I had forgotten about those submissions.  No further objections.

Alan Stern

