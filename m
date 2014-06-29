Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaF2InP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 04:43:15 -0400
Received: from mx02.posteo.de ([89.146.194.165]:35081 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752593AbaF2InB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 04:43:01 -0400
Message-ID: <53AFD16D.10209@posteo.de>
Date: Sun, 29 Jun 2014 10:42:21 +0200
From: Martin Kepplinger <martink@posteo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: rui.zhang@intel.com
CC: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix backlight control for Acer TravelMate B113
References: <1403555446-16863-1-git-send-email-martink@posteo.de>
In-Reply-To: <1403555446-16863-1-git-send-email-martink@posteo.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-06-23 22:30, schrieb Martin Kepplinger:
> Fix backlight control for Acer TravelMate B113 Laptop by adding
> it to the video_dmi_table.
> 
> A workaround before that was to use acpi_osi=Linux or
> acpi_backlight=vendor on boot but even then, only the function-
> keys worked.
> 
> With this change there is no need for boot parameters and DE's
> controls work as well.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> Tested-by: Martin Kepplinger <martink@posteo.de>
> ---
>  drivers/acpi/video.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index f8bc5a7..acb0670 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -528,6 +528,14 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
>  		},
>  	},
>  	{
> +	 .callback = video_set_use_native_backlight,
> +	 .ident = "Acer TravelMate B113",
> +	 .matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate B113"),
> +		},
> +	},
> +	{
>  	.callback = video_set_use_native_backlight,
>  	.ident = "HP ProBook 4340s",
>  	.matches = {
> 

are there objections or advice on this? this would be really good to
have, even if for 3.17.

thanks.
                                martin
