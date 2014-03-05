Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbaCEQFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:05:38 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42538 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755865AbaCEQFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:05:35 -0500
Date: Wed, 5 Mar 2014 11:05:34 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jagdish Gedia <jvgediya@gmail.com>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: USB remote wakeup through gpio interrupt
In-Reply-To: <CAOAoqGuicMKJ8e6kmQ92fL73UpvBzfXx9kafP4tCbUKkiT2=vA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1403051101430.1629-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2014, Jagdish Gedia wrote:

> Hi,
> There is some inconsistency in remote wakeup functionality in my
> custom board. so I want to wakeup the runtime suspended USB host
> through interrupt. My USB device is connected to the board through USB
> interface and some gpios. device will give interrupt on processor gpio
> when it needs attention of USB host. What should i do so that i can
> wakeup the usb host when i get interrupt from the device.

Have your gpio interrupt handler call pm_request_resume() for the host
controller device.

However, this may not do what you want.  Since the root hub will remain
suspended, the host controller will go back to low-power immediately
after it is resumed.  You really need to resume the USB device itself,
not the host controller.

> My idea was to apply power management related hooks from the interrupt
> handler, but I am not getting the clear idea.
> 
> My main doubt is,
> Will this mechanism be efficient as remote wakeup functionality?

That's a hard question to answer without measurements.  But it 
shouldn't matter, because you probably won't get more than one wakeup 
per second, right?

Alan Stern

