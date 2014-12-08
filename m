Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbaLHRxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:53:45 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:62176 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaLHRxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:53:43 -0500
Message-ID: <5485E5A4.9070805@gmail.com>
Date: Mon, 08 Dec 2014 20:53:40 +0300
From: Dmitry Tunin <hanipouspilot@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: platform-driver-x86@vger.kernel.org
CC: linux-kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] ideapad_laptop: Lenovo G50-30 fix rfkill always reports
 wireless blocked
References: <547753DE.9050809@gmail.com>
In-Reply-To: <547753DE.9050809@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is anything wrong with this patch?
It was made against last mainline kernel at the moment.
If a patch against linux-next needed, I can make it.
Without this patch wireless is always blocked.

Regards,

Dmitry.

27.11.2014 19:39, Dmitry Tunin пишет:
> Rfkill always shows wireless blocked unless ideapad_laptop is blacklisted.
> Add a quirk.
>
> Cc: stable@vger.kernel.org
> BugLink:https://bugs.launchpad.net/bugs/1397021
> Signed-off-by: Dmitry Tunin <hanipouspilot@gmail.com>
> ---
>   drivers/platform/x86/ideapad-laptop.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
> index ed494f3..9958de6 100644
> --- a/drivers/platform/x86/ideapad-laptop.c
> +++ b/drivers/platform/x86/ideapad-laptop.c
> @@ -844,6 +844,13 @@ static const struct dmi_system_id no_hw_rfkill_list[] = {
>               DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo YOGA 3 Pro-1370"),
>           },
>       },
> +    {
> +        .ident = "Lenovo G50-30",
> +        .matches = {
> +            DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> +            DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo G50-30"),
> +        },
> +    },
>       {}
>   };
>
