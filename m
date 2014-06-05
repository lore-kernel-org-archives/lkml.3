Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaFEQEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 12:04:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42604 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751000AbaFEQEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 12:04:37 -0400
Date: Thu, 5 Jun 2014 12:04:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Marcus Nutzinger <marcus.nutzinger@theobroma-systems.com>
cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: gadgetfs: correct dev state
In-Reply-To: <5A6C89E5-92AB-4908-8867-2BE783794E60@theobroma-systems.com>
Message-ID: <Pine.LNX.4.44L0.1406051201040.1103-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2014, Marcus Nutzinger wrote:

> Hi Sergei,
> 
> On Jun 5, 2014, at 4:18 PM, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com> wrote:
> 
> >   Please also specify that commit's summary line in parens.
> 
> I'll resubmit the updated patch in a minute!
> 
> >> +	/* other endpoints were all decoupled from this device */
> >> +	spin_lock_irq(&dev->lock);
> >> +	dev->state = STATE_DEV_DISABLED;
> >> +	spin_unlock_irq(&dev->lock);
> > 
> >   Not sure I understand why you need spinlock here... isn't the assignment atomic already?
> 
> 
> Sure, an assignment might be atomic. However, following the policy of commit 7489d149
> (USB: gadgetfs cleanups) all ep0 state changes shall be protected by spinlocks.

Sometimes an assignment needs to be protected by a lock, even though 
the assignment itself is atomic.  This happens, for example, when some 
other code executes a lock-protected region that expects the variable 
not to change.

I don't know if that's the case here.  But this example shows that in
general, one sometimes needs locks in places where you wouldn't expect
them.

In fact, it may even be necessary to take and release a lock, without
doing anything in between!

Alan Stern

