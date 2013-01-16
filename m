Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab3APSg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 13:36:26 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:64100 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757354Ab3APSgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 13:36:23 -0500
Message-ID: <50F700C7.2020101@mvista.com>
Date: Wed, 16 Jan 2013 22:34:31 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: balbi@ti.com, sameo@linux.intel.com, tony@atomide.com, kishon@ti.com,
        bjorn@mork.no, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 11/22] mfd: omap-usb-host: Use devm_kzalloc() and devm_request_and_ioremap()
References: <1358347433-329-1-git-send-email-rogerq@ti.com> <1358347433-329-12-git-send-email-rogerq@ti.com>
In-Reply-To: <1358347433-329-12-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/16/2013 05:43 PM, Roger Quadros wrote:

> Use devm_ variants of kzalloc and ioremap. Also clean up error path.

> Signed-off-by: Roger Quadros <rogerq@ti.com>
[...]

> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index 061366d..0f190b6 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -461,15 +461,20 @@ static int usbhs_omap_probe(struct platform_device *pdev)
[...]
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "uhh");
> +	omap->uhh_base = devm_request_and_ioremap(dev, res);
> +	if (!omap->uhh_base) {
> +		dev_err(dev, "Resource request/ioremap failed\n");
> +		return -ENOMEM;

   Should be -EADDRNOTAVAIL according to the comment to
devm_request_and_ioremap()...

WBR, Sergei

