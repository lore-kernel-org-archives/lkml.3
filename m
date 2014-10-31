Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695AbaJaUxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:53:11 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:62649 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbaJaUxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:53:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 2/2] watchdog: at91rm9200 remove mach/ header dependency
Date: Fri, 31 Oct 2014 21:53:03 +0100
Message-ID: <1840711.B9Yu766vja@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414788359-15759-2-git-send-email-alexandre.belloni@free-electrons.com>
References: <1414788359-15759-1-git-send-email-alexandre.belloni@free-electrons.com> <1414788359-15759-2-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:CS/VES0kTzd88VDqP/xXpxIV+K/DlAD44JaS34CDrY6RG2A1odk
 A7vjVU9IUzMlbfh1JNqSj6KT28tj7CDC+5oI87Y17fy0lbQOKXc7sy+PdhqU6KWxFxwVZOC
 hnVw4iymKs8t5CskEOliLsqWk/4H5FsNmSH3Z+eTaRy/3US9/wMZPE8vzBSpBRNgwb0+MQx
 OQrvwdIp+Ed204RxCEEjQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 October 2014 21:45:59 Alexandre Belloni wrote:
> Remove the mach/ header dependency by including the necessary macros and taking
> the appropriate resources from the system timer.
> 
> Also allow to compile both the at91rm920 and at91sam9 watchdog drivers at the
> same time.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Please list me in the changelog as well, either in free-form or as
Suggested-by.
>  
> +static struct of_device_id at91rm9200_st_timer_ids[] = {
> +	{ .compatible = "atmel,at91rm9200-st" },
> +	{ /* sentinel */ }
> +};
> +
>  static int at91wdt_probe(struct platform_device *pdev)
>  {
> +	struct resource *regs;
> +	struct resource _regs;
>  	int res;
>  
>  	if (at91wdt_miscdev.parent)
>  		return -EBUSY;
>  	at91wdt_miscdev.parent = &pdev->dev;
>  
> +	if (pdev->dev.of_node) {
> +		struct device_node *np;
> +
> +		np = of_find_matching_node(NULL, at91rm9200_st_timer_ids);
> +		if (!np)
> +			return -ENXIO;
> +		if (of_address_to_resource(np, 0, &_regs))
> +			return -ENXIO;
> +		regs = &_regs;
> +	} else {
> +		regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	}

What was wrong with my approach of binding the driver to the
"atmel,at91rm9200-st" node?

	Arnd
