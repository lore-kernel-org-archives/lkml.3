Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966572Ab3DQOOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:14:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54422 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S966321Ab3DQOOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:14:45 -0400
Date: Wed, 17 Apr 2013 10:14:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Joe Perches <joe@perches.com>
cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        usb-storage <usb-storage@lists.one-eyed-alien.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: storage: Add usb_stor_dbg, reduce object size
In-Reply-To: <1366177447.28609.25.camel@joe-AO722>
Message-ID: <Pine.LNX.4.44L0.1304171012270.1623-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Apr 2013, Joe Perches wrote:

> Reduce the size of the objects by consolidating
> the duplicated USB_STORAGE into a single function.
> 
> Add function usb_stor_dbg to emit debugging messages.
> Always validate the format and arguments.
> Reduce the number of uses of CONFIG_USB_STORAGE_DEBUG.
> 
> Reduces size of objects ~7KB when CONFIG_USB_STORAGE_DEBUG
> is set.
> 
> $ size drivers/usb/storage/built-in.o*
>    text	   data	    bss	    dec	    hex	filename
>  140133	  55296	  70312	 265741	  40e0d	drivers/usb/storage/built-in.o.new
>  147494	  55248	  70296	 273038	  42a8e	drivers/usb/storage/built-in.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Is there any reasonable way to change this so that US_DEBUGP gets
converted to a dev_dbg call instead of a printk call?  Not including
the device identifier in the output can be a real problem if there are
multiple mass-storage devices in the system.

Alan Stern


