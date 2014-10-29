Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbaJ2KFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:05:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756216AbaJ2KFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:05:31 -0400
Date: Wed, 29 Oct 2014 11:05:28 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Hans de Goede <hdegoede@redhat.com>, Bastien Nocera <hadess@hadess.net>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] HID: usbhid: prevent unwanted events to be sent when
 re-opening the device
In-Reply-To: <1412101702-2752-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1410291104550.20256@pobox.suse.cz>
References: <1412101702-2752-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014, Benjamin Tissoires wrote:

> When events occurs while no one is listening to the node (hid->open == 0
> and usb_kill_urb() called) some events are still stacked somewhere in
> the USB (kernel or device?) stack. When the node gets reopened, these
> events are drained, and this results in spurious touch down/up, or mouse
> button clicks.
> 
> The problem was spotted with touchscreens in fdo bug #81781 [1], but it
> actually occurs with any mouse using hid-generic or touchscreen.
> 
> A way to reproduce it is to call:
> 
> $ xinput disable 9 ; sleep 5 ; xinput enable 9
> 
> With 9 being the device ID for the touchscreen/mouse. During the "sleep",
> produce some touch events or click events. When "xinput enable" is called,
> at least one click is generated.
> 
> This patch tries to fix this by draining the queue for 50 msec and
> during this time frame, not forwarding these old events to the hid layer.
> 
> Hans completed the explanation:
> """
> Devices like mice (basically any hid device) will have a fifo
> on the device side, when we stop submitting urbs to get hid reports from
> it, that fifo will fill up, and when we resume we will get whatever
> is there in that fifo.
> """
> 
> [1] https://bugs.freedesktop.org/show_bug.cgi?id=81781
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> 
> OK, I know this is uggly, but I could not find a better way :(

I have been thinking about this quite a lot, but unfortunately wasn't able 
to come up with anything better either, so I am queuing this now.

Thanks.

-- 
Jiri Kosina
SUSE Labs
