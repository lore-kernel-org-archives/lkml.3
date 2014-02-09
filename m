Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaBIUEB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 15:04:01 -0500
Received: from mail.active-venture.com ([67.228.131.205]:65183 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbaBIUD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:03:59 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52F7DF2F.5060001@roeck-us.net>
Date: Sun, 09 Feb 2014 12:03:59 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        monstr@monstr.eu
CC: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/10] watchdog: xilinx: Convert driver to the watchdog
 framework
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
In-Reply-To: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 06:18 AM, Michal Simek wrote:
> - Remove uneeded headers, fops functions
> - Use xilinx_wdt prefix in start/stop/keepalive functions
>    and in new structures
>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Hi Michal,

>   static int xwdt_probe(struct platform_device *pdev)
>   {
>   	int rc;
> @@ -314,7 +184,7 @@ static int xwdt_probe(struct platform_device *pdev)
>   					"xlnx,wdt-enable-once", NULL);
>   	if (tmptr == NULL) {
>   		pr_warn("Parameter \"xlnx,wdt-enable-once\" not found in device tree!\n");
> -		xdev.nowayout = WATCHDOG_NOWAYOUT;
> +		watchdog_set_nowayout(&xilinx_wdt_wdd, true);

Sure you want to set this to always true instead of using WATCHDOG_NOWAYOUT ?

Assuming this is what you want:

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Thanks,
Guenter

