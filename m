Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab3BUPuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 10:50:55 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55948 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755458Ab3BUPux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:50:53 -0500
Date: Thu, 21 Feb 2013 10:50:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Valdis.Kletnieks@vt.edu
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: Wonky PS2-USB converter issues...
In-Reply-To: <26591.1361405698@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.44L0.1302211048390.1529-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013 Valdis.Kletnieks@vt.edu wrote:

> On Wed, 20 Feb 2013 16:07:49 -0800, Greg Kroah-Hartman said:
> 
> > PS-2 connectors can not normally handle hotplugging, the protocol
> > doesn't allow it, and for some unlucky devices, it could actually fry
> > the motherboard or the PS-2 device.
> >
> > So that's probably the issue here, the device just doesn't support it,
> > sorry.
> 
> You mis-understood the problem.
> 
> This works:
> 
> PS/2 keyboard plugged into this device:
> Bus 006 Device 002: ID 0e8f:0020 GreenAsia Inc. USB to PS/2 Adapter
> USB side of device plugged into USB port on the Latitude laptop.
> Power up, boot - the keyboard works.
> 
> If you plug the USB side of the GreenAsia adapter into a USB slot on
> the dock, the keyboard is dead and not recognized by the system.  However,
> replugging the USB, or unplug/plug the PS/2 side, and it becomes recognized
> and starts working.
> 
> This tells me that the dock is doing something busted with USB that the laptop
> does correctly, and not enumerating devices until something happens to whack it
> upside the head. I was hoping to identify it and maybe quirk it.

What happens if you prevent ehci-hcd from being loaded during boot and 
then load it manually afterward?  Does the keyboard/adapter/dock 
combination work then?

If it doesn't, try recording a usbmon trace.

Alan Stern

