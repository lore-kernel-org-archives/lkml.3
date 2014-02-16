Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaBPUC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 15:02:29 -0500
Received: from netrider.rowland.org ([192.131.102.5]:37209 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753280AbaBPUC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 15:02:28 -0500
Date: Sun, 16 Feb 2014 15:02:27 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Paul Bolle <pebolle@tiscali.nl>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Richard Weinberger <richard@nod.at>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] usb: host: remove USB_ARCH_HAS_?HCI
In-Reply-To: <1392579941.28866.55.camel@x220>
Message-ID: <Pine.LNX.4.44L0.1402161459290.11044-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Feb 2014, Paul Bolle wrote:

> USB_ARCH_HAS_EHCI, USB_ARCH_HAS_OHCI, and USB_ARCH_HAS_XHCI were made
> obsolete in v3.11. They have not been used ever since. Setting them has
> no effect. They can safely be removed.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Tested with "git grep".
> 
> Note that the comment in this Kconfig file (that is also removed)
> suggests to first remove the select statements for these symbols and
> then the symbols themselves. But I think it makes more sense to first
> delete these three symbols and then remove the selects statements (as
> that is removing a second order effect). But it could just as well be
> done with just one patch, I'd say.

There's a simple reason for not getting rid of the symbols first.  
Doing it that way, as you did, leaves a window in which it's possible
to select a non-existent symbol.  If that's not an error, it ought to
be.

Regardless, for both patches:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

