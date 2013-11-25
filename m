Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab3KYOQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:16:57 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48047 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757831Ab3KYOQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:16:48 -0500
Message-ID: <52935BAD.9080908@ti.com>
Date: Mon, 25 Nov 2013 09:16:13 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mark.rutland@arm.com>,
        <wim@iguana.be>, <nsekhar@ti.com>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <galak@kernel.crashing.org>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <grygorii.strashko@ti.com>
Subject: Re: [PATCH v3 1/6] watchdog: davinci: change driver to use WDT core
References: <1385388285-10553-1-git-send-email-ivan.khoronzhuk@ti.com> <1385388285-10553-2-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1385388285-10553-2-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan,

On Monday 25 November 2013 09:04 AM, Ivan Khoronzhuk wrote:
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
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Minor suggestion regarding the SOB line which applies to
rest of the series as well. Typically your SOB line
should be the last one like below.

Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>

No need to repost the series just for that. The last
patch as I commented earlier, needs to be separate
patch which will go via linux-keystone tree.

Once the watchdog maintainer is happy with rest of the
series and applies it, I will pick last patch.

Regards,
Santosh

