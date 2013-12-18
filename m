Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab3LRSVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:21:43 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:53766 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755609Ab3LRSVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:21:37 -0500
Date: Wed, 18 Dec 2013 13:21:36 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: George Cherian <george.cherian@ti.com>, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: phy: am335x: Enable USB remote wakeup using PHY
 wakeup
In-Reply-To: <20131218163329.GH4970@saruman.home>
Message-ID: <Pine.LNX.4.44L0.1312181317500.1029-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013, Felipe Balbi wrote:

> Alan, any suggestions on how to handle wakeup correctly ? I mean, it
> should be enabled by default during runtime PM and disabled during
> system sleep.

During system sleep, it should be set according to the value of 
device_may_wakeup().

>  But when it comes to default state of can_wakeup field,
> what should we do ? Should the driver be fiddling with that ? Leave it
> to the bus driver ? Any tips ?

If the bus driver knows whether the hardware is capable of issuing a
wakeup request, it should set can_wakeup appropriately.  In most cases
the device driver doesn't need to worry about it.

There are a few exceptions, though.  If the bus code doesn't know 
enough about the hardware, or if some hardware has a quirk that the 
driver knows about but the bus code doesn't, for example.

Alan Stern

