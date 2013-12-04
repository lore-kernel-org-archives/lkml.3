Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363Ab3LDUsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:48:23 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:62406 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933277Ab3LDUsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:48:21 -0500
Date: Wed, 4 Dec 2013 12:48:18 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com,
        wim@iguana.be, nsekhar@ti.com, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, Pawel.Moll@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, galak@kernel.crashing.org,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, grygorii.strashko@ti.com
Subject: Re: [PATCH v5 1/5] watchdog: davinci: change driver to use WDT core
Message-ID: <20131204204818.GA3096@roeck-us.net>
References: <1386185970-14488-1-git-send-email-ivan.khoronzhuk@ti.com>
 <1386185970-14488-2-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386185970-14488-2-git-send-email-ivan.khoronzhuk@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 09:39:26PM +0200, Ivan Khoronzhuk wrote:
> To reduce code duplicate and increase code readability use WDT core
> code to handle WDT interface.
> 
> Remove io_lock as the WDT core uses mutex to lock each wdt device.
> Remove wdt_state as the WDT core tracks state with its own variable.
> 
> The watchdog_init_timeout() can read timeout value from timeout-sec
> property if the passed value is out of bounds. The heartbeat is
> initialized in next way. If heartbeat is not set thought module
> parameter, try to read it's value from WDT node timeout-sec property.
> If node has no one, use default value.
> 
> The heartbeat is hold in wdd->timeout by WDT core, so use it in
> order to set timeout period.
> 
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>

Looks good, except you did not explain ...

>  
> -	dev_info(dev, "heartbeat %d sec\n", heartbeat);
> +	watchdog_set_nowayout(wdd, 1);
>  
why nowayout is enforced.

Thanks,
Guenter
