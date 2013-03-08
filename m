Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab3CHU7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 15:59:06 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:57751 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab3CHU7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 15:59:04 -0500
Date: Fri, 8 Mar 2013 12:59:40 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] usb/core/devio.c: Don't use GFP_KERNEL while we cannot
 reset a storage device
Message-ID: <20130308205940.GA15806@kroah.com>
References: <1362761447-24643-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362761447-24643-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 09, 2013 at 12:50:47AM +0800, Alexey Khoroshilov wrote:
> As it was described by Oliver Neukum in commit acbe2fe
> "USB: Don't use GFP_KERNEL while we cannot reset a storage device":
> 
>   Memory allocations with GFP_KERNEL can cause IO to a storage device
>   which can fail resulting in a need to reset the device. Therefore
>   GFP_KERNEL cannot be safely used between usb_lock_device()
>   and usb_unlock_device(). Replace by GFP_NOIO.
> 
> The patch fixes the same issue in usb/core/devio.c.

But that's for userspace drivers, why does it matter here for them?

> All the allocations fixed are under usb_lock_device() from usbdev_do_ioctl().

I really don't want to have usbfs using GFP_NOIO as it is known for
allocating a lot of memory already.  Given that no one has ever reported
a problem like this, I don't think it deserves to change, sorry.

greg k-h
