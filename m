Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934111AbaKMUov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 15:44:51 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:64310 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933888AbaKMUot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 15:44:49 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1411131539330.929-100000@iolanthe.rowland.org>
References: <1415909806-23848-1-git-send-email-bleung@chromium.org>
	<Pine.LNX.4.44L0.1411131539330.929-100000@iolanthe.rowland.org>
Date: Thu, 13 Nov 2014 12:44:48 -0800
X-Google-Sender-Auth: cemqX1PTPikXF8aLM2m0zbQ7CAE
Message-ID: <CANLzEksGg0KyWOS+WYv_U8GzSJ4C_H0LTpdXvz8Ae-8mH6K41w@mail.gmail.com>
Subject: Re: [PATCH] HID: usbhid: get/put around clearing needs_remote_wakeup
From: Benson Leung <bleung@chromium.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: johan@kernel.org, Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sameer Nanda <snanda@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 12:41 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> usbhid_stop probably doesn't need it.  And it should be possible to fix
> usbhid_close more easily just by interchanging the two lines:
>
> -                       usb_kill_urb(usbhid->urbin);
>                         usbhid->intf->needs_remote_wakeup = 0;
> +                       usb_kill_urb(usbhid->urbin);
>
> Have you tried this?

Yes, I tried that as well, and that does work.

I used the get/put because that's the way it was done in other
drivers, for example in synusb_close() in
drivers/input/mouse/synaptics_usb.c

-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
