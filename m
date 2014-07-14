Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbaGNOTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:19:40 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:14591 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754506AbaGNOTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:19:32 -0400
Date: Mon, 14 Jul 2014 15:19:04 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
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
Message-ID: <20140714141904.GA1112@arm.com>
References: <1405265431-4561-1-git-send-email-linux@roeck-us.net>
 <1405265431-4561-6-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405265431-4561-6-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2014 at 04:30:29PM +0100, Guenter Roeck wrote:
> diff --git a/drivers/watchdog/moxart_wdt.c b/drivers/watchdog/moxart_wdt.c
> index 4aa3a8a..5080b50 100644
> --- a/drivers/watchdog/moxart_wdt.c
> +++ b/drivers/watchdog/moxart_wdt.c
[...]
> -static void moxart_wdt_restart(enum reboot_mode reboot_mode, const char *cmd)
> +static int moxart_restart_notify(struct notifier_block *this,
> +				 unsigned long mode, void *cmd)
>  {
> -	writel(1, moxart_restart_ctx->base + REG_COUNT);
> -	writel(0x5ab9, moxart_restart_ctx->base + REG_MODE);
> -	writel(0x03, moxart_restart_ctx->base + REG_ENABLE);
> +	struct moxart_wdt_dev *moxart_wdt = container_of(this,
> +							 struct moxart_wdt_dev,
> +							 restart_notifier);
> +	writel(1, moxart_wdt->base + REG_COUNT);
> +	writel(0x5ab9, moxart_wdt->base + REG_MODE);
> +	writel(0x03, moxart_wdt->base + REG_ENABLE);
> +
> +	return NOTIFY_DONE;
>  }

Wondering whether NOTIFY_OK or even NOTIFY_STOP_MASK is better here.

-- 
Catalin
