Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab3H1M6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:58:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43273 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab3H1M6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:58:01 -0400
Date: Wed, 28 Aug 2013 14:57:56 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: David Barksdale <dbarksdale@uplogix.com>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: [PATCH RESEND] HID: New hid-cp2112 driver.
In-Reply-To: <1377615715-25699-1-git-send-email-dbarksdale@uplogix.com>
Message-ID: <alpine.LNX.2.00.1308281455350.4557@pobox.suse.cz>
References: <1377615715-25699-1-git-send-email-dbarksdale@uplogix.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ adding Benjamin to CC ]

On Tue, 27 Aug 2013, David Barksdale wrote:

> This patch adds support for the Silicon Labs CP2112
> "Single-Chip HID USB to SMBus Master Bridge."
> 
> I wrote this to support a USB temperature and humidity
> sensor I've been working on. It's been tested by using
> SMBus byte-read, byte-data-read/write, and word-data-read
> transfer modes to talk to an I2C sensor. The other
> transfer modes have not been tested.
> 
> Signed-off-by: David Barksdale <dbarksdale@uplogix.com>
> 
> ---
>  drivers/hid/Kconfig      |   6 +
>  drivers/hid/Makefile     |   1 +
>  drivers/hid/hid-core.c   |   3 +
>  drivers/hid/hid-cp2112.c | 504 +++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 514 insertions(+)
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 14ef6ab..1833948 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -175,6 +175,12 @@ config HID_PRODIKEYS
>  	  multimedia keyboard, but will lack support for the musical keyboard
>  	  and some additional multimedia keys.
>  
> +config HID_CP2112
> +	tristate "Silicon Labs CP2112 HID USB-to-SMBus Bridge support"
> +	depends on USB_HID
> +	---help---
> +	Support for Silicon Labs CP2112 HID USB to SMBus Master Bridge.
> +

Hi David,

this is rather difficult to get by quickly looking at the code, so I'd 
like to have a slightly better overview of what the device really is.

Is it talking HID protocol on the SMBus? (if so, there is a hid-i2c 
transport driver for it already).
But I guess this is not really the case, as you seem to be using the USB 
HID functionality as well.

Thanks in advance for some more background.

-- 
Jiri Kosina
SUSE Labs
