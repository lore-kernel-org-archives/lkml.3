Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935903Ab3BTUYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:24:13 -0500
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:55141 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935700Ab3BTUYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:24:11 -0500
X-SENDER-IP: [85.230.168.206]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AghGAMcvJVFV5qjOPGdsb2JhbABFhWCFILVfgQEXAwEBAQE4NIIfAQEEAScTHCMFCwgDISUPBQ0YChoTiAADCQq2eA2JWhWMIoJXB4JfYQOUUYFahgKFRYgd
X-IronPort-AV: E=Sophos;i="4.84,704,1355094000"; 
   d="scan'208";a="206336561"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 20 Feb 2013 21:25:31 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] HID: multitouch: remove usbhid dependency
Message-ID: <20130220202531.GA1413@polaris.bitmath.org>
References: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
 <1360334256-22127-7-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360334256-22127-7-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-multitouch.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Since removing the transport layer dependency has a rationale, it
might be good to mention that here.

Also, what about the explicit usb dependency, was that going to be
moved to a usbhid quirk?

> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 32258ba..184ac0a 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -32,7 +32,6 @@
>  #include <linux/slab.h>
>  #include <linux/usb.h>
>  #include <linux/input/mt.h>
> -#include "usbhid/usbhid.h"
>  
>  
>  MODULE_AUTHOR("Stephane Chatty <chatty@enac.fr>");
> @@ -907,7 +906,7 @@ static int mt_resume(struct hid_device *hdev)
>  
>  	intf = to_usb_interface(hdev->dev.parent);
>  	interface = intf->cur_altsetting;
> -	dev = hid_to_usb_dev(hdev);
> +	dev = interface_to_usbdev(intf);
>  
>  	/* Some Elan legacy devices require SET_IDLE to be set on resume.
>  	 * It should be safe to send it to other devices too.
> -- 
> 1.8.1
> 

Thanks,
Henrik
