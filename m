Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab3CHUw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 15:52:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:36597 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab3CHUwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 15:52:25 -0500
Message-ID: <513A4FA2.6070309@infradead.org>
Date: Fri, 08 Mar 2013 12:52:50 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
CC: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: holtek: Holtek devices depends on USB_HID
References: <1362649709-9608-1-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1362649709-9608-1-git-send-email-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/13 01:48, Benjamin Tissoires wrote:
> In the HID drivers tranport cleanup series, I removed the dependency
> between hid-holtek and usbhid. This was wrong as hid-holtek.c relies
> extensively on usb calls.
> 
> This fixes compilation error when CONFIG_USB_SUPPORT is not enabled.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>


but hid-multitouch build still fails (on 3.9-rc1) when USB_SUPPORT is not enabled:

ERROR: "usb_control_msg" [drivers/hid/hid-multitouch.ko] undefined!


> ---
>  drivers/hid/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 3abb11f..613083a 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -215,7 +215,7 @@ config HID_EZKEY
>  
>  config HID_HOLTEK
>  	tristate "Holtek HID devices"
> -	depends on HID
> +	depends on USB_HID
>  	---help---
>  	Support for Holtek based devices:
>  	  - Holtek On Line Grip based game controller
> 


-- 
~Randy
