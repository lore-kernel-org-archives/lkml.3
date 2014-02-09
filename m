Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaBIPSw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 10:18:52 -0500
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1961 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaBIPSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 10:18:51 -0500
Message-ID: <52F79C37.5030000@xs4all.nl>
Date: Sun, 09 Feb 2014 16:18:15 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] si4713: Remove "select SI4713"
References: <1391957777.25424.15.camel@x220>
In-Reply-To: <1391957777.25424.15.camel@x220>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2014 03:56 PM, Paul Bolle wrote:
> Commits 7391232e1215 ("[media] si4713: Reorganized drivers/media/radio
> directory") and b874b39fcd2f ("[media] si4713: Added the USB driver for
> Si4713") both added a "select SI4713". But there's no Kconfig symbol
> SI4713, so these selects are nops. It's not clear why they were added
> but it's safe to remove them anyway.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

USB_SI4713 and PLATFORM_SI4713 both depend on I2C_SI4713. So the select
should be I2C_SI4713. If you can post a patch fixing that, then I'll pick
it up for 3.14.

With the addition of the USB si4713 driver things moved around and were
renamed, and these selects were missed.

Regards,

	Hans

> ---
> Untested!
> 
>  drivers/media/radio/si4713/Kconfig | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/media/radio/si4713/Kconfig b/drivers/media/radio/si4713/Kconfig
> index a7c3ba8..ed51ed0 100644
> --- a/drivers/media/radio/si4713/Kconfig
> +++ b/drivers/media/radio/si4713/Kconfig
> @@ -1,7 +1,6 @@
>  config USB_SI4713
>  	tristate "Silicon Labs Si4713 FM Radio Transmitter support with USB"
>  	depends on USB && RADIO_SI4713
> -	select SI4713
>  	---help---
>  	  This is a driver for USB devices with the Silicon Labs SI4713
>  	  chip. Currently these devices are known to work.
> @@ -16,7 +15,6 @@ config USB_SI4713
>  config PLATFORM_SI4713
>  	tristate "Silicon Labs Si4713 FM Radio Transmitter support with I2C"
>  	depends on I2C && RADIO_SI4713
> -	select SI4713
>  	---help---
>  	  This is a driver for I2C devices with the Silicon Labs SI4713
>  	  chip.
> 

