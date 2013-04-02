Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762016Ab3DBSGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:06:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54613 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760111Ab3DBSGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:06:52 -0400
Date: Tue, 2 Apr 2013 14:06:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florian Fainelli <florian@openwrt.org>, Felipe Balbi <balbi@ti.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>, USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/5 v2] USB: regroup all depends on USB within an if USB
 block
In-Reply-To: <1364922626-32407-2-git-send-email-florian@openwrt.org>
Message-ID: <Pine.LNX.4.44L0.1304021359130.1314-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013, Florian Fainelli wrote:

> This patch removes the depends on USB from all config symbols in
> drivers/usb/host/Kconfig and replace that with an if USB / endif block
> as suggested by Alan Stern. Some source ... Kconfig lines have been
> shuffled around to permit a better regroupment of the Kconfig files
> depending on "config USB" item. No functionnal change is introduced.

This looks almost right.  The only problem I see is in 
drivers/usb/core/Kconfig.  The USB_OTG_WHITELIST and 
USB_OTG_BLACKLIST_HUB symbols don't have to depend on USB or USB_OTG, 
because they can be set if EXPERT is enabled.

To avoid these issues, I think the best approach is to move all the
USB_OTG* entries over to drivers/usb/otg/Kconfig, where by rights they
should have been all along.

Felipe, do you agree?

Alan Stern

