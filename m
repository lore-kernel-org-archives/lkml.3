Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486AbaKYB3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 20:29:45 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:55912 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaKYB3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 20:29:43 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1411221043060.23393-100000@netrider.rowland.org>
References: <CANLzEkuPr0hhjecVHaMkGfX7_DZr4wUV=-yP2+V6uBaYdAkhXw@mail.gmail.com>
	<Pine.LNX.4.44L0.1411221043060.23393-100000@netrider.rowland.org>
Date: Mon, 24 Nov 2014 17:29:42 -0800
X-Google-Sender-Auth: -tIn6ZwZWQE8-5Bt-WE6-HhQZFA
Message-ID: <CANLzEkuZYrF_tLq5k3xBBkSmtszL851ZK7VW8Jav3vKdw9JLMA@mail.gmail.com>
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

Hi Alan,


On Sat, Nov 22, 2014 at 7:55 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> There is no USB wrapper for pm_runtime_idle calls, but one could be
> added.  Still, in the meantime can you check to see what happens if you
> add
>
>         pm_runtime_idle(&usbhid->intf->dev);
>
> in usbhid_close() just after needs_remote_wakeup is set to 0?  You can
> do the same thing in usbhid_stop() if you want.

I tried using this in lieu of usb_autopm_get/put_interface:

    usbhid->intf->needs_remote_wakeup = 0;
    pm_runtime_idle(&usbhid->intf->dev);
    pm_runtime_idle(usbhid->intf->dev.parent);

It did not work. I see the autosuspend_check() that was kicked off as
a result of hid_hw_power, which falls into the "remote wakeup needed
for autosuspend" branch, but I don't see another autosuspend_check()
that picks up the updated value of  needs_remote_wakeup.

-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
