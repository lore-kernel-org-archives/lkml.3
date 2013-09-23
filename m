Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3IWDh2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 23:37:28 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50358 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3IWDh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 23:37:27 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <523FB773.4050408@roeck-us.net>
Date: Sun, 22 Sep 2013 20:37:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Fan Rong <cinifr@gmail.com>, coosty@163.com, daniel.lezcano@linaro.org,
        linux@arm.linux.org.uk, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, pawel.moll@arm.co, rob.herring@calxeda.com,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 1/3] Add smp support for Allwinner A20(sunxi 7i).
References: <1379768716-11672-1-git-send-email-cinifr@gmail.com> <1379768716-11672-2-git-send-email-cinifr@gmail.com> <20130921140059.GA2779@lukather>
In-Reply-To: <20130921140059.GA2779@lukather>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2013 07:00 AM, Maxime Ripard wrote:

[ ... ]

>> +	/* assert cpu core reset */
>> +	writel(0, sunxi7i_cc_base + CPUX_RESET_CTL(cpu));
>> +	/* L1RSTDISABLE hold low */
>> +	pwr_reg = readl(sunxi7i_cc_base + AW_CPUCFG_GENCTL);
>> +	pwr_reg &= ~(1<<cpu);
>> +	writel(pwr_reg, sunxi7i_cc_base + AW_CPUCFG_GENCTL);
>> +	/* DBGPWRDUP hold low */
>> +	pwr_reg = readl(sunxi7i_cc_base + AW_CPUCFG_DBGCTL1);
>> +	pwr_reg &= ~(1<<cpu);
>
> Use BIT(cpu) here. And you should run scripts/checkpatch.pl on your
> patches before sending them.
>

For the record:

$ scripts/checkpatch.pl --strict allwinner.patch
total: 0 errors, 0 warnings, 0 checks, 527 lines checked

allwinner.patch has no obvious style problems and is ready for submission.

This is on top of "v3.12-rc1-336-gd8524ae".

checkpatch.pl does not complain as long as the number of spaces before
and after an operator is the same. There is a patch pending to change
this with the --strict option, but it will still not complain in 'normal'
operation.

Guenter

