Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab3CKSzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:55:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51298 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754205Ab3CKSzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:55:52 -0400
Date: Mon, 11 Mar 2013 14:55:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <tom.leiming@gmail.com>
cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ldv-project@linuxtesting.org>
Subject: Re: [PATCH] usb/core/devio.c: Don't use GFP_KERNEL while we cannot
 reset a storage device
In-Reply-To: <CACVXFVOwjHOSd=VeJSKDHOCp5vveLVx8ZnLby4fnW4GeHEnu-g@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1303111450550.2246-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Mar 2013, Ming Lei wrote:

> > In general it isn't, no.  But usbfs uses the lock to prevent races with
> > driver_disconnect() -- it is invalid to submit URBs after the
> > disconnect routine has returned.
> 
> If so, we may introduce another lock to avoid the race.
> 
> So I think we may figure out to decrease the device lock
> scope in devio.c, and most of ioctl commands might not require it
> at all, then the problem addressed by the patch can be fixed too.

That might work.  A mutex could be added to the dev_state structure.  
The mutex would be locked whenever an URB was being submitted and
during driver_disconnect, and perhaps a few other places too, but not
when memory was being allocated.  The device itself would remain 
unlocked most of the time.

Alan Stern

