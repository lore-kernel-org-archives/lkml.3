Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab3EQDm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 23:42:26 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:44017 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab3EQDmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 23:42:24 -0400
Date: Thu, 16 May 2013 17:42:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Julius Werner <jwerner@chromium.org>
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org, Vincent Palatin <vpalatin@chromium.org>,
        Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH v3] usb: ehci: Only sleep for post-resume handover if
 devices use persist
Message-ID: <20130517004231.GA32618@kroah.com>
References: <1366906107-22669-1-git-send-email-jwerner@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366906107-22669-1-git-send-email-jwerner@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 09:08:27AM -0700, Julius Werner wrote:
> The current EHCI code sleeps a flat 110ms in the resume path if there
> was a USB 1.1 device connected to its companion controller during
> suspend, waiting for the device to reappear and reset so that it can be
> handed back to the companion. This is necessary if the device uses
> persist, so that the companion controller can actually see it during its
> own resume path.
> 
> However, if the device doesn't use persist, this is entirely
> unnecessary. We might just as well ignore it and have the normal device
> detection/reset/handoff code handle it asynchronously when it eventually
> shows up. As USB 1.1 devices are almost exclusively HIDs these days (for
> which persist has no value), this can allow distros to shave another
> tenth of a second off their resume time.
> 
> In order to enable this optimization, the patch also adds a new
> usb_for_each_dev() iterator that is exported by the USB core and wraps
> bus_for_each_dev() with the logic to differentiate between struct
> usb_device and struct usb_interface on the usb_bus_type bus.
> 
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> ---
>  drivers/usb/core/usb.c      | 33 +++++++++++++++++++++++++++++++++
>  drivers/usb/host/ehci-hub.c | 17 +++++++++++++++++
>  include/linux/usb.h         |  1 +
>  3 files changed, 51 insertions(+)

This patch is corrupted somehow, but I can't figure out how.

I'm getting the error:
	checking file drivers/usb/core/usb.c
	checking file drivers/usb/host/ehci-hub.c
	patch: **** malformed patch at line 164: @@ -56,6 +63,16 @@ static void ehci_handover_companion_ports(struct ehci_hcd *ehci)

when trying to apply it.  git also doesn't like it.

Care to fix this up and resend it so I can apply it?

thanks,

greg k-h
