Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934322Ab3E1O0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:26:10 -0400
Received: from matrix.voodoobox.net ([75.127.97.206]:43971 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934123Ab3E1O0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:26:07 -0400
X-Greylist: delayed 3315 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 May 2013 10:26:07 EDT
Message-ID: <1369747847.3675.3.camel@obelisk.thedillows.org>
Subject: Re: [PATCH] HID: fold ps3remote driver into generic Sony driver
From: David Dillow <dave@thedillows.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 28 May 2013 09:30:47 -0400
In-Reply-To: <alpine.LNX.2.00.1305281035370.3914@pobox.suse.cz>
References: <alpine.LNX.2.00.1305281035370.3914@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-28 at 10:38 +0200, Jiri Kosina wrote:
> Let's follow the structure we are trying to keep for most of the specific 
> HID drivers, and let the separation follow the producing vendor.
> Merge functionality provided by ps3remote driver into hid-sony.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---

I've not had a chance to test yet, but I noticed one issue:
 
> @@ -548,6 +722,11 @@ static const struct hid_device_id sony_devices[] = {
>  		.driver_data = BUZZ_CONTROLLER },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_WIRELESS_BUZZ_CONTROLLER),
>  		.driver_data = BUZZ_CONTROLLER },
> +	/* PS3 BD Remote Control */
> +	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_BDREMOTE),
> +		.driver_data = PS3REMOTE },
> +	/* Logitech Harmony Adapter for PS3 */
> +	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_HARMONY_PS3) },

I think you need .driver_data = PS3REMOTE for the Harmony as well; it
uses the same protocol.

Also, have you given any thought to making 'make oldconfig' work? Those
of us that build are own kernels are likely to have some fun tracking
down why our remotes don't work any more...

