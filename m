Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab3GOFw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 01:52:28 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:63471 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3GOFw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 01:52:27 -0400
Message-ID: <51E2A603.1000805@linaro.org>
Date: Sun, 14 Jul 2013 14:22:11 +0100
From: Kevin Hilman <khilman@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: stern@rowland.harvard.edu, gregkh@linuxfoundation.org, balbi@ti.com,
        sergei.shtylyov@cogentembedded.com, tony@atomide.com,
        ruslan.bilovol@ti.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 4/6] mfd: omap-usb-host: Put pins in IDLE state on suspend
References: <1373473081-27181-1-git-send-email-rogerq@ti.com> <1373473380-27515-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1373473380-27515-1-git-send-email-rogerq@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 05:23 PM, Roger Quadros wrote:
> In order to support wake up from suspend use the pinctrl
> framework to put the USB host pins in IDLE state during suspend.
> 
> CC: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>

[...]

> @@ -608,6 +618,14 @@ static int usbhs_omap_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> +	if (!dev->pins || !dev->pins->idle_state) {
> +		/* If IDLE pins are not available, we can't remote wakeup,
> +		 * so prevent idling in that case.
> +		 */

nit: multi-line comment style

Also, if there are no pins, aren't the pinctrl ops nops anyways?  IOW,
not sure the need
for this is clear, and it's not mentioned in the changelog.

Kevin

