Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab3KYL6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 06:58:03 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:60725 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab3KYL56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 06:57:58 -0500
Message-ID: <52933AE4.3070608@ti.com>
Date: Mon, 25 Nov 2013 17:26:20 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Wim Van Sebroeck <wim@iguana.be>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Strashko Grygorii <grygorii.strashko@ti.com>
Subject: Re: [PATCH 1/6] watchdog: davinci: change driver to use WDT core
References: <1384795139-19466-1-git-send-email-ivan.khoronzhuk@ti.com> <1384795139-19466-2-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1384795139-19466-2-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 November 2013 10:48 PM, Ivan Khoronzhuk wrote:
> @@ -211,29 +129,34 @@ static int davinci_wdt_probe(struct platform_device *pdev)
>  
>  	clk_prepare_enable(wdt_clk);
>  
> -	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
> -		heartbeat = DEFAULT_HEARTBEAT;
> +	wdd			= &wdt_wdd;
> +	wdd->info		= &davinci_wdt_info;
> +	wdd->ops		= &davinci_wdt_ops;
> +	wdd->min_timeout 	= 1;
> +	wdd->max_timeout 	= MAX_HEARTBEAT;

Some checkpatch warnings. Please fix.

WARNING: please, no space before tabs
#273: FILE: drivers/watchdog/davinci_wdt.c:135:
+^Iwdd->min_timeout ^I= 1;$

WARNING: please, no space before tabs
#274: FILE: drivers/watchdog/davinci_wdt.c:136:
+^Iwdd->max_timeout ^I= MAX_HEARTBEAT;$

total: 0 errors, 2 warnings, 0 checks, 249 lines checked

Thanks,
sekhar
