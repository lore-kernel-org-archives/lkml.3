Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab3A1VM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 16:12:26 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:32898 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752418Ab3A1VMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 16:12:24 -0500
Date: Mon, 28 Jan 2013 22:12:22 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: linux-watchdog@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH 3/4] watchdog: add support for ux500_wdt watchdog
Message-ID: <20130128211222.GA3338@spo001.leaseweb.com>
References: <1358509214-22407-1-git-send-email-fabio.baltieri@linaro.org> <1358509214-22407-4-git-send-email-fabio.baltieri@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358509214-22407-4-git-send-email-fabio.baltieri@linaro.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

> This patch adds support for the ux500_wdt watchdog that is found in
> ST-Ericsson Ux500 platform.  The driver is based on PRCMU APIs.
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>

> +static int timeout = WATCHDOG_TIMEOUT;
> +module_param(timeout, int, 0);
> +MODULE_PARM_DESC(timeout,
> +	"Watchdog timeout in seconds. default="
> +				__MODULE_STRING(WATCHDOG_TIMEOUT) ".");

We should go for unsigned int timeout values...

> +static int nowayout = WATCHDOG_NOWAYOUT;
> +module_param(nowayout, int, 0);
> +MODULE_PARM_DESC(nowayout,
> +	"Watchdog cannot be stopped once started (default="
> +				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");

nowayout is a boolean value so please change this to
static bool nowayout = WATCHDOG_NOWAYOUT;

The rest is OK by me. So if bowayout get's fixed then you have my acked-by.

Kind regards,
Wim.

