Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3FRAMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 20:12:41 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55239 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337Ab3FRAMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 20:12:39 -0400
X-Sasl-enc: RJLQCSJReYEiYlsJc42fSOxSpyzpXPGJW7xbDpyokCAT 1371514358
Date: Mon, 17 Jun 2013 21:12:34 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Adam Lee <adam.lee@canonical.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Alex Hung <alex.hung@canonical.com>, Bjorn Mork <bjorn@mork.no>
Subject: Re: [PATCH 1/3] thinkpad_acpi: return -NODEV while operating
 uninitialized LEDs
Message-ID: <20130618001234.GA27654@khazad-dum.debian.net>
References: <1370593209-21358-1-git-send-email-adam.lee@canonical.com>
 <1370593209-21358-2-git-send-email-adam.lee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370593209-21358-2-git-send-email-adam.lee@canonical.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Jun 2013, Adam Lee wrote:
> Not all 0-15 LEDs are available for all models, sometimes it's even not
> safe. This patch return -NODEV while operating uninitialized LEDs.
> 
> Signed-off-by: Adam Lee <adam.lee@canonical.com>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

> ---
>  drivers/platform/x86/thinkpad_acpi.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
> index 54d31c0..bea57ae 100644
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -5401,9 +5401,12 @@ static int led_write(char *buf)
>  		return -ENODEV;
>  
>  	while ((cmd = next_cmd(&buf))) {
> -		if (sscanf(cmd, "%d", &led) != 1 || led < 0 || led > 15)
> +		if (sscanf(cmd, "%d", &led) != 1)
>  			return -EINVAL;
>  
> +		if (!tpacpi_leds[led].led)
> +			return -ENODEV;
> +
>  		if (strstr(cmd, "off")) {
>  			s = TPACPI_LED_OFF;
>  		} else if (strstr(cmd, "on")) {

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
