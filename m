Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab3AOXxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:53:30 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41522 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932777Ab3AOXx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 18:53:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: enable common clk on x86
Date: Wed, 16 Jan 2013 00:59:17 +0100
Message-ID: <1474259.FsoB54Sm0k@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358174788-24439-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1358174788-24439-1-git-send-email-mika.westerberg@linux.intel.com> <1358174788-24439-2-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 14, 2013 04:46:26 PM Mika Westerberg wrote:
> We are starting to see traditional SoC peripherals also in the x86 world,
> things like UART, I2C and SPI controllers that might already have a working
> device driver. These drivers typically take advantage of the Linux clk
> framework to control and retrieve information about the peripheral clock.
> 
> There hasn't been a standard way on x86 to pass the clock rate from
> whatever configuration system is used to the driver, but instead different
> variations have emerged, like adding this information to the platform data.
> 
> In order to use the standard Linux way we enable the common clk subsystem
> also on x86. This allows us to re-use the drivers with little or no
> modification wrt. clock API usage.
> 
> This patch was originally proposed by Mark Brown.

Are there any side effects of selecting COMMON_CLK by an arch and if so then
what are they?

Rafael


> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  arch/x86/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 79795af..decda04 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -114,6 +114,7 @@ config X86
>  	select MODULES_USE_ELF_RELA if X86_64
>  	select CLONE_BACKWARDS if X86_32
>  	select GENERIC_SIGALTSTACK
> +	select COMMON_CLK
>  
>  config INSTRUCTION_DECODER
>  	def_bool y
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
