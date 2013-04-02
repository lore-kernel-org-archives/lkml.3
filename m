Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762129Ab3DBSdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:33:39 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54635 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762102Ab3DBSdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:33:37 -0400
Date: Tue, 2 Apr 2013 14:33:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florian Fainelli <florian@openwrt.org>
cc: linux-kernel@vger.kernel.org, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 3/5 v2] USB: enclose EHCI HCD drivers within an if
 USB_EHCI_HCD block
In-Reply-To: <1364922626-32407-4-git-send-email-florian@openwrt.org>
Message-ID: <Pine.LNX.4.44L0.1304021427450.1314-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013, Florian Fainelli wrote:

> Thist patch removes the depends on USB_EHCI_HCD that the various USB
> EHCI HCD drivers use and encloses every driver within an if USB_EHCI_HCD
> / endif block. The EHCI HCD platform and Octeon drivers have been moved
> around to remain enclosed within this block.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>

Okay except for two things.  First, you missed the
USB_EHCI_BIG_ENDIAN_DESC entry.  Second, the Kconfig file has this
right in the middle of the section you changed:

config USB_FSL_MPH_DR_OF
	tristate

It's probably a mistake to put this under the "if USB_EHCI_HCD"
umbrella.  I guess it should be moved out of the way.

Alan Stern

