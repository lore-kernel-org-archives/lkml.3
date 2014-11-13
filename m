Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934323AbaKMVSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:18:52 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37301 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934175AbaKMVSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:18:49 -0500
Date: Thu, 13 Nov 2014 16:18:47 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Benson Leung <bleung@chromium.org>
cc: johan@kernel.org, Jiri Kosina <jkosina@suse.cz>,
        <linux-usb@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH] HID: usbhid: get/put around clearing needs_remote_wakeup
In-Reply-To: <CANLzEksGg0KyWOS+WYv_U8GzSJ4C_H0LTpdXvz8Ae-8mH6K41w@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1411131611001.945-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014, Benson Leung wrote:

> On Thu, Nov 13, 2014 at 12:41 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > usbhid_stop probably doesn't need it.  And it should be possible to fix
> > usbhid_close more easily just by interchanging the two lines:
> >
> > -                       usb_kill_urb(usbhid->urbin);
> >                         usbhid->intf->needs_remote_wakeup = 0;
> > +                       usb_kill_urb(usbhid->urbin);
> >
> > Have you tried this?
> 
> Yes, I tried that as well, and that does work.
> 
> I used the get/put because that's the way it was done in other
> drivers, for example in synusb_close() in
> drivers/input/mouse/synaptics_usb.c

In the patch description, you wrote:

> When a usbhid device that does not support remote wake
> ( i.e. !device_can_wakeup() ) is closed, we fail out of
> autosuspend_check() because the autosuspend check is called
> before the flag is cleared as a result of usb_kill_urb(usbhid->urbin);

If you interchange the two lines then the flag _will_ be cleared before
usb_kill_urb() and autosuspend_check() can run.  This means your patch
description is bogus.

Alan Stern

