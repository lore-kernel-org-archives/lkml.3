Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821Ab3CHRzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 12:55:11 -0500
Received: from netrider.rowland.org ([192.131.102.5]:38404 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933621Ab3CHRzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 12:55:09 -0500
Date: Fri, 8 Mar 2013 12:55:08 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Oliver Neukum <oliver@neukum.org>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <ldv-project@linuxtesting.org>
Subject: Re: [PATCH] usb/core/devio.c: Don't use GFP_KERNEL while we cannot
 reset a storage device
In-Reply-To: <1362761447-24643-1-git-send-email-khoroshilov@ispras.ru>
Message-ID: <Pine.LNX.4.44L0.1303081248090.17427-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Mar 2013, Alexey Khoroshilov wrote:

> As it was described by Oliver Neukum in commit acbe2fe
> "USB: Don't use GFP_KERNEL while we cannot reset a storage device":
> 
>   Memory allocations with GFP_KERNEL can cause IO to a storage device
>   which can fail resulting in a need to reset the device. Therefore
>   GFP_KERNEL cannot be safely used between usb_lock_device()
>   and usb_unlock_device(). Replace by GFP_NOIO.
> 
> The patch fixes the same issue in usb/core/devio.c.
> All the allocations fixed are under usb_lock_device() from usbdev_do_ioctl().
> 
> Found by Linux Driver Verification project (linuxtesting.org).

I don't know if this is a good idea.  People can and do submit 
transfers requiring a lot of buffer space.  Switching to GFP_NOIO 
will make those allocations a lot more likely to fail.

Oliver, what do you think?

Alan Stern

