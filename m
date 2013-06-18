Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab3FRATh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 20:19:37 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57500 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337Ab3FRATg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 20:19:36 -0400
X-Sasl-enc: Uvzx0hpcvF0syZ3zeYMVwTgwKLj0ddeoU7d2E2yAmNhu 1371514775
Date: Mon, 17 Jun 2013 21:19:33 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Adam Lee <adam.lee@canonical.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Alex Hung <alex.hung@canonical.com>, Bjorn Mork <bjorn@mork.no>
Subject: Re: [PATCH 2/3] thinkpad_acpi: add the ability setting
 TPACPI_LED_NONE by quirk
Message-ID: <20130618001933.GD27654@khazad-dum.debian.net>
References: <1370593209-21358-1-git-send-email-adam.lee@canonical.com>
 <1370593209-21358-3-git-send-email-adam.lee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370593209-21358-3-git-send-email-adam.lee@canonical.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Jun 2013, Adam Lee wrote:
> Some new Lenovo or ThinkPad laptops don't have EC controllable LEDs,
> their LED quirks are 0. This patch set led_supported=TPACPI_LED_NONE
> when quirk equals 0.
> 
> Signed-off-by: Adam Lee <adam.lee@canonical.com>

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

> ---
>  drivers/platform/x86/thinkpad_acpi.c |   13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
> index bea57ae..2fb1f1c 100644
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -5327,6 +5327,16 @@ static int __init led_init(struct ibm_init_struct *iibm)
>  
>  	led_supported = led_init_detect_mode();
>  
> +	if (led_supported != TPACPI_LED_NONE) {
> +		useful_leds = tpacpi_check_quirks(led_useful_qtable,
> +				ARRAY_SIZE(led_useful_qtable));
> +
> +		if (!useful_leds) {
> +			led_handle = NULL;
> +			led_supported = TPACPI_LED_NONE;
> +		}
> +	}
> +
>  	vdbg_printk(TPACPI_DBG_INIT, "LED commands are %s, mode %d\n",
>  		str_supported(led_supported), led_supported);
>  
> @@ -5340,9 +5350,6 @@ static int __init led_init(struct ibm_init_struct *iibm)
>  		return -ENOMEM;
>  	}
>  
> -	useful_leds = tpacpi_check_quirks(led_useful_qtable,
> -					  ARRAY_SIZE(led_useful_qtable));
> -
>  	for (i = 0; i < TPACPI_LED_NUMLEDS; i++) {
>  		if (!tpacpi_is_led_restricted(i) &&
>  		    test_bit(i, &useful_leds)) {

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
