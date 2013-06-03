Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab3FCVIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 17:08:19 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38291 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755833Ab3FCVIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 17:08:18 -0400
X-Sasl-enc: /WASSISGH8lPSkN0vOL//7IA2IJbnNWv2TZDEc3Todob 1370293697
Date: Mon, 3 Jun 2013 14:08:16 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Hannes Weisbach <hannes_weisbach@gmx.net>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lp: implement proper detach function for parport_driver
 lp
Message-ID: <20130603210816.GA22677@kroah.com>
References: <2009349A-75FD-4D5F-8F25-F8FD78F1A5D8@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2009349A-75FD-4D5F-8F25-F8FD78F1A5D8@gmx.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 01, 2013 at 10:02:21PM +0200, Hannes Weisbach wrote:
> From: Hannes Weisbach <hannes_weisbach@gmx.net>
> 
> The lp pardevice driver does not have a proper detach function. Consequently, parport_unregister_device() is not called when the underlying parport driver calls parport_remove_port(). As a result, the ref count of the parport driver's module does not go to zero and the driver module cannot be unloaded.
> The attached patch unregisters all lp pardevices which are on the to-be-detached parport.

Please wrap your changelog comments at 72 columns or so.

> Signed-off-by: Hannes Weisbach <hannes_weisbach@gmx.net>
> ---
> Granted, for normal parport drivers this is usually not an issue,
> because the device does not go away. However, I am currently writing a
> Linux device driver for a USB to parallel port converter [0] and
> therefore need proper detaching. Additionally, the wrong ref count
> keeps me from simply rmmod my driver and insmod a new version while
> developing and testing.

Really?  We already have a usb to parallel port driver in the kernel
tree that seems to work just fine.  It's been there since the 2.3 kernel
days, so either it has the same problem, or your driver is doing
something odd.

Can you test the in-kernel driver and let me know if it has the same
problem?

thanks,

greg k-h
