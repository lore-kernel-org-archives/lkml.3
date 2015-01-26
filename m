Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbbAZKKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:10:00 -0500
Received: from mx-guillaumet.finsecur.com ([91.217.234.131]:48033 "EHLO
	guillaumet.finsecur.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbbAZKJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:09:58 -0500
Date: Mon, 26 Jan 2015 11:09:55 +0100
From: Sylvain Rochet <sylvain.rochet@finsecur.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: nicolas.ferre@atmel.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@free-electrons.com, peda@axentia.se
Message-ID: <20150126100955.GA18907@gradator.net>
References: <1422265005-22937-1-git-send-email-wenyou.yang@atmel.com>
 <1422265331-23236-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1422265331-23236-1-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 172.16.8.13
X-SA-Exim-Mail-From: sylvain.rochet@finsecur.com
Subject: Re: [PATCH v2 07/12] pm: at91: the standby mode uses the same sram
 function as the suspend to memory mode
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on guillaumet.finsecur.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wenyou,


On Mon, Jan 26, 2015 at 05:42:11PM +0800, Wenyou Yang wrote:
> +static int at91_pm_verify_clocks(suspend_state_t state)
>  {
>  	unsigned long scsr;
>  	int i;
>  
> +	/* For PM_SUSPEND_STANDBY, skip verifying the clock */
> +	if (state == PM_SUSPEND_STANDBY)
> +		return 1;
> +

In my opinion we should use the select() already in place in 
at91_pm_enter() to do that:

>  static int at91_pm_enter(suspend_state_t state)
>  {
>  	at91_pinctrl_gpio_suspend();
>  
>  	switch (state) {
     (...)
> +	case PM_SUSPEND_MEM:

	/*
	 * Ensure that clocks are in a valid state.
	 */
	if (!at91_pm_verify_clocks())
		goto error;
	/* FALLTHROUGH */

> +	case PM_SUSPEND_STANDBY:
>  		/*
> -		 * Suspend-to-RAM is like STANDBY plus slow clock mode, so


Sylvain
