Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbaGNOl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:41:27 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64701 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbaGNOlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:41:17 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53C3EC0B.7090702@roeck-us.net>
Date: Mon, 14 Jul 2014 07:41:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <Will.Deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 5/7] watchdog: moxart: Register restart handler with
 restart notifier
References: <1405265431-4561-1-git-send-email-linux@roeck-us.net> <1405265431-4561-6-git-send-email-linux@roeck-us.net> <20140714141904.GA1112@arm.com>
In-Reply-To: <20140714141904.GA1112@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 07:19 AM, Catalin Marinas wrote:
> On Sun, Jul 13, 2014 at 04:30:29PM +0100, Guenter Roeck wrote:
>> diff --git a/drivers/watchdog/moxart_wdt.c b/drivers/watchdog/moxart_wdt.c
>> index 4aa3a8a..5080b50 100644
>> --- a/drivers/watchdog/moxart_wdt.c
>> +++ b/drivers/watchdog/moxart_wdt.c
> [...]
>> -static void moxart_wdt_restart(enum reboot_mode reboot_mode, const char *cmd)
>> +static int moxart_restart_notify(struct notifier_block *this,
>> +				 unsigned long mode, void *cmd)
>>   {
>> -	writel(1, moxart_restart_ctx->base + REG_COUNT);
>> -	writel(0x5ab9, moxart_restart_ctx->base + REG_MODE);
>> -	writel(0x03, moxart_restart_ctx->base + REG_ENABLE);
>> +	struct moxart_wdt_dev *moxart_wdt = container_of(this,
>> +							 struct moxart_wdt_dev,
>> +							 restart_notifier);
>> +	writel(1, moxart_wdt->base + REG_COUNT);
>> +	writel(0x5ab9, moxart_wdt->base + REG_MODE);
>> +	writel(0x03, moxart_wdt->base + REG_ENABLE);
>> +
>> +	return NOTIFY_DONE;
>>   }
>
> Wondering whether NOTIFY_OK or even NOTIFY_STOP_MASK is better here.
>

Personally I would rather call all of them if more than one notifier is
registered to ensure that (at least) one does what it is intended to do,
but I am open to suggestions.

Guenter

