Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab3FDQ6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:58:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35390 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757075Ab3FDQ6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:58:31 -0400
Date: Tue, 4 Jun 2013 12:58:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC 2/2] USB: host: make USB_ARCH_HAS_?HCI obsolete
In-Reply-To: <1624672.VBbVgzJXAH@wuerfel>
Message-ID: <Pine.LNX.4.44L0.1306041257250.1093-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jun 2013, Arnd Bergmann wrote:

> On Tuesday 04 June 2013 11:22:01 Alan Stern wrote:
> > 
> > Instead of doing this, it makes more sense to enable USB_ARCH_HAS_HCD
> > whenever host-side USB is enabled.  In other words,
> > 
> >         def_bool USB
> 
> The problem with this is that a lot of drivers (24 to be exact) are defined
> like
> 
> config INPUT_ATI_REMOTE2
>         tristate "ATI / Philips USB RF remote control"
>         depends on USB_ARCH_HAS_HCD
>         select USB

Oops.  That's a problem.

> so that would create a circular dependency unless we change all of them
> at once. I did that when creating this patch, but then decided to
> revert it for now and do smaller steps.

Okay.  Changing those 24 should be the next step.

> We could do
> 
> config USB_ARCH_HAS_HCD
> 	def_bool USB_SUPPORT
> 
> or
> 
> config USB_ARCH_HAS_HCD
> 	def_bool y
> 
> which would both have the exact same behavior as 'def_bool HAS_IOMEM'.

I'm in favor of "def_bool y".

Alan Stern

