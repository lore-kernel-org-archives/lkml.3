Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab3CHUqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 15:46:15 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:60512 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab3CHUqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 15:46:14 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] usb/core/devio.c: Don't use GFP_KERNEL while we cannot reset a storage device
Date: Fri, 08 Mar 2013 21:46:29 +0100
Message-ID: <2925850.6XPAdGF0iQ@linux-5eaq.site>
User-Agent: KMail/4.8.5 (Linux/3.8.0-rc7-12-desktop+; KDE/4.8.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1303081248090.17427-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1303081248090.17427-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 March 2013 12:55:08 Alan Stern wrote:
> On Sat, 9 Mar 2013, Alexey Khoroshilov wrote:
> 
> > As it was described by Oliver Neukum in commit acbe2fe
> > "USB: Don't use GFP_KERNEL while we cannot reset a storage device":
> > 
> >   Memory allocations with GFP_KERNEL can cause IO to a storage device
> >   which can fail resulting in a need to reset the device. Therefore
> >   GFP_KERNEL cannot be safely used between usb_lock_device()
> >   and usb_unlock_device(). Replace by GFP_NOIO.
> > 
> > The patch fixes the same issue in usb/core/devio.c.
> > All the allocations fixed are under usb_lock_device() from usbdev_do_ioctl().
> > 
> > Found by Linux Driver Verification project (linuxtesting.org).
> 
> I don't know if this is a good idea.  People can and do submit 
> transfers requiring a lot of buffer space.  Switching to GFP_NOIO 
> will make those allocations a lot more likely to fail.
> 
> Oliver, what do you think?

Ideally we'd split memory allocation and use, by it fixes a bug.
Better allocation failure than deadlock.

	Regards
		Oliver

