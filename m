Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144Ab3CSK5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 06:57:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44621 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab3CSK5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 06:57:41 -0400
Message-ID: <51484485.3090503@ti.com>
Date: Tue, 19 Mar 2013 16:27:09 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Murali Karicheri <m-karicheri2@ti.com>, <mturquette@linaro.org>,
        <arnd@arndb.de>, <akpm@linux-foundation.org>, <shawn.guo@linaro.org>,
        <rob.herring@calxeda.com>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-keystone@list.ti.com>
Subject: Re: [PATCH v3 02/11] clk: davinci - add PSC clock driver
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com> <1351181518-11882-3-git-send-email-m-karicheri2@ti.com> <CACRpkdaNfv13xxHyA0p9M7oqRqb7j0J9gvyYvYhgCs7-z4ifhQ@mail.gmail.com>
In-Reply-To: <CACRpkdaNfv13xxHyA0p9M7oqRqb7j0J9gvyYvYhgCs7-z4ifhQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 12:54 AM, Linus Walleij wrote:
> On Thu, Oct 25, 2012 at 6:11 PM, Murali Karicheri <m-karicheri2@ti.com> wrote:
> 
>> This is the driver for the Power Sleep Controller (PSC) hardware
>> found on DM SoCs as well Keystone SoCs (c6x). This driver borrowed
>> code from arch/arm/mach-davinci/psc.c and implemented the driver
>> as per common clock provider API. The PSC module is responsible for
>> enabling/disabling the Power Domain and Clock domain for different IPs
>> present in the SoC. The driver is configured through the clock data
>> passed to the driver through struct clk_psc_data.
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Here is some pedantic stuff if you're really bored:
> 
>> diff --git a/drivers/clk/davinci/clk-psc.c b/drivers/clk/davinci/clk-psc.c
> (...)
>> +               ptcmd = 1 << domain;
> 
> ptcmd = BIT(domain);
> 
>> +               pdctl = readl(psc_base + PDCTL + 4 * domain);
>> +               pdctl |= 0x100;
> 
> pdctl |= BIT(8); /* and here a comment explaing what on earth that means */

It turns out this piece of code is superfluous and the exact same thing
is being done again just down below.

Thanks,
Sekhar
