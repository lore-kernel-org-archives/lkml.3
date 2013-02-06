Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab3BFNC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 08:02:27 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:62815 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3BFNCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 08:02:25 -0500
Message-ID: <51125447.5010209@mvista.com>
Date: Wed, 06 Feb 2013 17:01:59 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: gregkh@linuxfoundation.org, tony@atomide.com, linux@arm.linux.org.uk,
        eballetbo@gmail.com, javier@dowhile0.org, b-cousson@ti.com,
        balbi@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/5] ARM: OMAP: devices: create device for usb part of
 control module
References: <1360130294-5976-1-git-send-email-kishon@ti.com> <1360130294-5976-3-git-send-email-kishon@ti.com>
In-Reply-To: <1360130294-5976-3-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06-02-2013 9:58, Kishon Vijay Abraham I wrote:

> A seperate driver has been added to handle the usb part of control
> module. A device for the above driver is created here, using the register
> address information to be used by the driver for powering on the PHY and
> for writing to the mailbox.

> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>
> ---
>   arch/arm/mach-omap2/devices.c |   45 +++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 45 insertions(+)

> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> index 626f3ea..6cda103 100644
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@ -20,6 +20,7 @@
[...]
> @@ -254,6 +255,49 @@ static inline void omap_init_camera(void)
[...]
> +static struct platform_device omap4_control_usb = {
> +	.name		= "omap-control-usb",
> +	.id		= -1,
> +	.dev = {
> +		.platform_data = &omap4_control_usb_pdata,
> +	},
> +	.num_resources = 2,
> +	.resource = omap4_control_usb_res,

    Either align = or not, not both at once.

> +};

WBR, Sergei

