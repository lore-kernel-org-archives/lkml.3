Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3JHSFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 14:05:39 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:27560 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752415Ab3JHSFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 14:05:38 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+1NbPg2z8VJIbNo7F1iNbB
Date: Tue, 8 Oct 2013 11:05:26 -0700
From: Tony Lindgren <tony@atomide.com>
To: Majunath Goudar <csmanjuvijay@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, nataraja.km@lge.com,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] ARM: mach-omap1: Fix omap1510_fpga_init_irq() implicit
 declarations.
Message-ID: <20131008180526.GD8313@atomide.com>
References: <1381228141-16213-1-git-send-email-csmanjuvijay@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1381228141-16213-1-git-send-email-csmanjuvijay@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Majunath Goudar <csmanjuvijay@gmail.com> [131008 03:37]:
> This patch adds a omap1510_fpga_init_irq() inline dummy implementations
> in arch/arm/mach-omap1/common.h. Without this patch,build system can
> lead to issues. This was discovered during randconfig testing,in which
> other than CONFIG_ARCH_OMAP15XX was enabled the leading to the following
> error:
> 
> CC      arch/arm/mach-omap1/board-innovator.o
> arch/arm/mach-omap1/board-innovator.c: In function ‘innovator_init’:
> arch/arm/mach-omap1/board-innovator.c:377:3: error: implicit declaration of
> function ‘omap1510_fpga_init_irq’ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[1]: *** [arch/arm/mach-omap1/board-innovator.o] Error 1
> make: *** [arch/arm/mach-omap1] Error 2

Thanks, I'll apply this into omap-for-v3.13/fixes-not-urgent
as it's been there for quite a while.

Regards,

Tony
 
> Signed-off-by: Manjunath Goudar <csmanjuvijay@gmail.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-omap@vger.kernel.org
> ---
>  arch/arm/mach-omap1/common.h |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm/mach-omap1/common.h b/arch/arm/mach-omap1/common.h
> index abec019..732f8ee 100644
> --- a/arch/arm/mach-omap1/common.h
> +++ b/arch/arm/mach-omap1/common.h
> @@ -46,6 +46,9 @@ static inline void omap7xx_map_io(void)
>  void omap1510_fpga_init_irq(void);
>  void omap15xx_map_io(void);
>  #else
> +static inline void omap1510_fpga_init_irq(void)
> +{
> +}
>  static inline void omap15xx_map_io(void)
>  {
>  }
> -- 
> 1.7.9.5
> 
