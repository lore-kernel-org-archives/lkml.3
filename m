Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab3CKQIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:08:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50257 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751526Ab3CKQIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:08:47 -0400
Date: Mon, 11 Mar 2013 12:08:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <tom.leiming@gmail.com>
cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ldv-project@linuxtesting.org>
Subject: Re: [PATCH] usb/core/devio.c: Don't use GFP_KERNEL while we cannot
 reset a storage device
In-Reply-To: <CACVXFVN6zm2gG4v1jhV=8EwAtKs=bg3urJ7dRiOgPGHtKXHYxA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1303111206100.2246-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Mar 2013, Ming Lei wrote:

> On Mon, Mar 11, 2013 at 11:32 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> >
> > Of course you have to lock the device before changing its driver.  What
> > would happen if two different threads tried to change a device's driver
> > at the same time?
> 
> Yes, claim/release interface need device lock, but the patch doesn't
> touch claim/release command handling.

Then why did you ask?  You wrote: "Looks device lock isn't required for
USB transfer of kernel driver."


> > usbdev_do_ioctl() needs to acquire the device lock in order to prevent
> > races with driver_disconnect() and usbdev_remove().
> 
> Looks the patch basically converts the allocation inside URB submit path,
> and actually I mean why we need to hold device lock in submitting
> URB path?  Device lock isn't required before submitting URBs
> in kernel driver.

In general it isn't, no.  But usbfs uses the lock to prevent races with 
driver_disconnect() -- it is invalid to submit URBs after the 
disconnect routine has returned.

Alan Stern

