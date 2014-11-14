Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965068AbaKNJI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 04:08:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbaKNJIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 04:08:30 -0500
Message-ID: <1415956110.2640.5.camel@linux-0dmf.site>
Subject: Re: [PATCH] HID: usbhid: get/put around clearing needs_remote_wakeup
From: Oliver Neukum <oneukum@suse.de>
To: Benson Leung <bleung@chromium.org>
Cc: johan@kernel.org, jkosina@suse.cz, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        snanda@chromium.org
Date: Fri, 14 Nov 2014 10:08:30 +0100
In-Reply-To: <1415909806-23848-1-git-send-email-bleung@chromium.org>
References: <1415909806-23848-1-git-send-email-bleung@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-13 at 12:16 -0800, Benson Leung wrote:

> In usbhid_open, usb_autopm_get_interface is called
> before setting the needs_remote_wakeup flag, and
> usb_autopm_put_interface is called after hid_start_in.
> 
> However, when the device is closed in usbhid_close, the same
> protection isn't there when clearing needs_remote_wakeup. This will
> add that to usbhid_close as well as usbhid_stop.

Interesting, but this has the side effect of waking devices
that are asleep just to remove the flag.

	Regards
		Oliver

-- 
Oliver Neukum <oneukum@suse.de>

