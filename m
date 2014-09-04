Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbaIDWii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 18:38:38 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:55647 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755358AbaIDWig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 18:38:36 -0400
Message-ID: <1409870314.5546.128.camel@x220>
Subject: Re: [PATCH v2] ARM: msm: Update the references to DEBUG_MSM_UARTx
From: Paul Bolle <pebolle@tiscali.nl>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: galak@codeaurora.org, iivanov@mm-sol.com, arm@kernel.org,
        khilman@linaro.org, arnd@arndb.de, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, olof@lixom.net, davidb@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, agross@codeaurora.org,
        linus.walleij@linaro.org, srinivas.kandagatla@linaro.org
Date: Fri, 05 Sep 2014 00:38:34 +0200
In-Reply-To: <1403165772.23136.17.camel@x220>
References: <1401116287.6068.15.camel@x220>
	 <1401122260-12002-1-git-send-email-gdjakov@mm-sol.com>
	 <1403165772.23136.17.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Sep 2014 22:38:34.0141 (UTC) FILETIME=[F5C814D0:01CFC890]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 10:16 +0200, Paul Bolle wrote:
> On Mon, 2014-05-26 at 19:37 +0300, Georgi Djakov wrote:
> > The Kconfig options DEBUG_MSM_UART1, DEBUG_MSM_UART2, DEBUG_MSM_UART3,
> > MSM_DEBUG_UART1, MSM_DEBUG_UART2 and MSM_DEBUG_UART3 are removed, but 
> > they are still referenced in the following files:
> > 	arch/arm/mach-msm/io.c,
> > 	arch/arm/mach-msm/board-trout.c
> > 	arch/arm/mach-msm/board-trout-gpio.c
> > 
> > Fix this by updating the reference to the new Kconfig option.
> > 
> > Reported-by: Paul Bolle <pebolle@tiscali.nl>
> > Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> > ---
> 
> This patch is included neither in v3.16-rc1 nor in next-20140619.

Still true for v3.17-rc3 and next-20140904.

>  Did it run into problems or is it already queued somewhere?

This issue was reported three months ago but is still present. Should I
perhaps submit the trivial patch that removes the checks for these
macros and the code they now hide?

> > Changes since v1:
> >  - Fixed similar issue in board-trout.c and board-trout-gpio.c
> > 
> >  Applies to next-20140526.
> > 
> >  arch/arm/mach-msm/board-trout-gpio.c |    2 +-
> >  arch/arm/mach-msm/board-trout.c      |    2 +-
> >  arch/arm/mach-msm/io.c               |    6 ++----
> >  3 files changed, 4 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/arm/mach-msm/board-trout-gpio.c b/arch/arm/mach-msm/board-trout-gpio.c
> > index 87e1d01..e24930e 100644
> > --- a/arch/arm/mach-msm/board-trout-gpio.c
> > +++ b/arch/arm/mach-msm/board-trout-gpio.c
> > @@ -94,7 +94,7 @@ static int trout_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
> >  	}
> >  
> >  static struct msm_gpio_chip msm_gpio_banks[] = {
> > -#if defined(CONFIG_MSM_DEBUG_UART1)
> > +#if defined(CONFIG_DEBUG_MSM_UART) && (CONFIG_DEBUG_UART_PHYS == 0xa9a00000)
> >  	/* H2W pins <-> UART1 */
> >  	TROUT_GPIO_BANK("MISC2", 0x00,   TROUT_GPIO_MISC2_BASE, 0x40),
> >  #else
> > diff --git a/arch/arm/mach-msm/board-trout.c b/arch/arm/mach-msm/board-trout.c
> > index 015d544..8369dfd 100644
> > --- a/arch/arm/mach-msm/board-trout.c
> > +++ b/arch/arm/mach-msm/board-trout.c
> > @@ -90,7 +90,7 @@ static void __init trout_map_io(void)
> >  	msm_map_common_io();
> >  	iotable_init(trout_io_desc, ARRAY_SIZE(trout_io_desc));
> >  
> > -#ifdef CONFIG_MSM_DEBUG_UART3
> > +#if defined(CONFIG_DEBUG_MSM_UART) && (CONFIG_DEBUG_UART_PHYS == 0xa9c00000)
> >  	/* route UART3 to the "H2W" extended usb connector */
> >  	writeb(0x80, TROUT_CPLD_BASE + 0x00);
> >  #endif
> > diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
> > index 34e0947..b042dca 100644
> > --- a/arch/arm/mach-msm/io.c
> > +++ b/arch/arm/mach-msm/io.c
> > @@ -57,8 +57,7 @@ static struct map_desc msm_io_desc[] __initdata = {
> >  		.length =   MSM_SHARED_RAM_SIZE,
> >  		.type =     MT_DEVICE,
> >  	},
> > -#if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
> > -		defined(CONFIG_DEBUG_MSM_UART3)
> > +#if defined(CONFIG_DEBUG_MSM_UART)
> >  	{
> >  		/* Must be last: virtual and pfn filled in by debug_ll_addr() */
> >  		.length = SZ_4K,
> > @@ -76,8 +75,7 @@ void __init msm_map_common_io(void)
> >  	 * pages are peripheral interface or not.
> >  	 */
> >  	asm("mcr p15, 0, %0, c15, c2, 4" : : "r" (0));
> > -#if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
> > -		defined(CONFIG_DEBUG_MSM_UART3)
> > +#if defined(CONFIG_DEBUG_MSM_UART)
> >  #ifdef CONFIG_MMU
> >  	debug_ll_addr(&msm_io_desc[size - 1].pfn,
> >  		      &msm_io_desc[size - 1].virtual);


Paul Bolle

