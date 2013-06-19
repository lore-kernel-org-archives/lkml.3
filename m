Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934866Ab3FSRaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:30:03 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:62340 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab3FSRaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:30:00 -0400
Message-ID: <51C1EA99.2020401@cogentembedded.com>
Date: Wed, 19 Jun 2013 21:30:01 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: stern@rowland.harvard.edu, tony@atomide.com, balbi@ti.com,
        ruslan.bilovol@ti.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 6/6] ARM: OMAP3: Enable Hardware Save and Restore
 for USB Host
References: <1371650753-11452-1-git-send-email-rogerq@ti.com> <1371650753-11452-7-git-send-email-rogerq@ti.com>
In-Reply-To: <1371650753-11452-7-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/19/2013 06:05 PM, Roger Quadros wrote:

> To ensure hardware context is restored while resuming from
> OFF mode we need to enable the Hardware SAR bit for the
> USB Host power domain.

> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>   arch/arm/mach-omap2/powerdomains3xxx_data.c |    8 +-------
>   1 files changed, 1 insertions(+), 7 deletions(-)

> diff --git a/arch/arm/mach-omap2/powerdomains3xxx_data.c b/arch/arm/mach-omap2/powerdomains3xxx_data.c
> index f0e14e9..9554d2b 100644
> --- a/arch/arm/mach-omap2/powerdomains3xxx_data.c
> +++ b/arch/arm/mach-omap2/powerdomains3xxx_data.c
> @@ -289,13 +289,7 @@ static struct powerdomain usbhost_pwrdm = {
>   	.prcm_offs	  = OMAP3430ES2_USBHOST_MOD,
>   	.pwrsts		  = PWRSTS_OFF_RET_ON,
>   	.pwrsts_logic_ret = PWRSTS_RET,
> -	/*
> -	 * REVISIT: Enabling usb host save and restore mechanism seems to
> -	 * leave the usb host domain permanently in ACTIVE mode after
> -	 * changing the usb host power domain state from OFF to active once.
> -	 * Disabling for now.
> -	 */
> -	/*.flags	  = PWRDM_HAS_HDWR_SAR,*/ /* for USBHOST ctrlr only */
> +	.flags	  = PWRDM_HAS_HDWR_SAR, /* for USBHOST ctrlr only */

    Looks like you're not indenting = right, in accordance to the other 
fields...

>   	.banks		  = 1,
>   	.pwrsts_mem_ret	  = {
>   		[0] = PWRSTS_RET, /* MEMRETSTATE */
>

WBR, Sergei

