Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaA1B0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 20:26:15 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:47890 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbaA1B0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 20:26:13 -0500
Date: Mon, 27 Jan 2014 17:26:09 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jakub Bogusz <qboosh@pld-linux.org>
Cc: Miloslav Trmac <mitr@volny.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] wistron_btns: FS AMILO Pro 8210 support
Message-ID: <20140128012609.GA17871@core.coreip.homeip.net>
References: <20130702152048.GB6668@stranger.qboosh.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130702152048.GB6668@stranger.qboosh.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jakub,

On Tue, Jul 02, 2013 at 05:20:48PM +0200, Jakub Bogusz wrote:
> (sorry, I forgot to attach the actual patch in my previous message)
> 
> Hello,
> 
> The attached patch adds Fujitsu-Siemens AMILO Pro 8210 support to
> wistron_btns driver.
> 
> I already sent it in 2011, but there was no feedback.
> It still applies to linux 3.10 sources.

I just stumbled upon your patch in my LKML archives. It looks quite
reasonable, I will be applying it.

Thanks.

> 
> 
> -- 
> Jakub Bogusz    http://qboosh.pl/

> This patch adds Fujitsu-Siemens AMILO Pro 8210 support to wistron_btns driver.
> 
> Functions are very similar to already supported AMILO Pro 3505, but 8210
> has WIFI led.
> 
> Such functionality is needed to enable WiFi under Linux on 8210 when it cold
> boots with hardware rfkill enabled, without booting another operating system
> or running custom utility that calls appropriate BIOS function.
> 
> Signed-off-by: Jakub Bogusz <qboosh@pld-linux.org>
> 
> --- linux-2.6.37/drivers/input/misc/wistron_btns.c.orig	2011-01-05 01:50:19.000000000 +0100
> +++ linux-2.6.37/drivers/input/misc/wistron_btns.c	2011-02-19 07:51:36.000000000 +0100
> @@ -278,6 +278,16 @@
>  	{ KE_END,       0 }
>  };
>  
> +static struct key_entry keymap_fs_amilo_pro_v8210[] __initdata = {
> +	{ KE_KEY,       0x01, {KEY_HELP} },          /* Fn+F1 */
> +	{ KE_KEY,       0x06, {KEY_DISPLAYTOGGLE} }, /* Fn+F4 */
> +	{ KE_BLUETOOTH, 0x30 },                      /* Fn+F10 */
> +	{ KE_KEY,       0x31, {KEY_MAIL} },          /* mail button */
> +	{ KE_KEY,       0x36, {KEY_WWW} },           /* www button */
> +	{ KE_WIFI,      0x78 },                      /* satelite dish button */
> +	{ KE_END,       FE_WIFI_LED }
> +};
> +
>  static struct key_entry keymap_fujitsu_n3510[] __initdata = {
>  	{ KE_KEY, 0x11, {KEY_PROG1} },
>  	{ KE_KEY, 0x12, {KEY_PROG2} },
> @@ -655,6 +665,15 @@
>  		.driver_data = keymap_fs_amilo_pro_v3505
>  	},
>  	{
> +		/* Fujitsu-Siemens Amilo Pro Edition V8210 */
> +		.callback = dmi_matched,
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Pro Series V8210"),
> +		},
> +		.driver_data = keymap_fs_amilo_pro_v8210
> +	},
> +	{
>  		/* Fujitsu-Siemens Amilo M7400 */
>  		.callback = dmi_matched,
>  		.matches = {


-- 
Dmitry
