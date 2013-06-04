Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab3FDEgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 00:36:32 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:55135 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3FDEga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 00:36:30 -0400
Date: Tue, 4 Jun 2013 07:36:20 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Jamie Iles <jamie@jamieiles.com>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        John Stultz <john.stultz@linaro.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] clocksource: dw_apb_timer_of: use clocksource_of_init
Message-ID: <20130604043620.GU11798@tarshish>
References: <201306032157.40488.heiko@sntech.de>
 <201306032159.55685.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201306032159.55685.heiko@sntech.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On Mon, Jun 03, 2013 at 09:59:55PM +0200, Heiko Stübner wrote:
> dw_apb_timer_init used to search the devicetree for matching timer
> devices, making calls to it from board files necessary.
> 
> Change the dw_apb_timer_init to work with CLOCKSOURCE_OF_DECLARE.
> With this change the function gets called once for each timer node
> and tracks these number of calls to attach clockevent and clocksource
> devices to the nodes.
> 
> Also remove the calls to dw_apb_timer_init from all previous users, as
> clocksource_of_init is the default for init_time now.
> 
> Tested on the upcoming rk3066 code.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/mach-picoxcell/Kconfig       |    1 +
>  arch/arm/mach-picoxcell/common.c      |    2 -
>  arch/arm/mach-socfpga/Kconfig         |    1 +
>  arch/arm/mach-socfpga/socfpga.c       |    2 -
>  drivers/clocksource/dw_apb_timer_of.c |   41 ++++++++++++++++-----------------
>  include/linux/dw_apb_timer.h          |    1 -
>  6 files changed, 22 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/arm/mach-picoxcell/Kconfig b/arch/arm/mach-picoxcell/Kconfig
> index 13bae78..3ef6bbe 100644
> --- a/arch/arm/mach-picoxcell/Kconfig
> +++ b/arch/arm/mach-picoxcell/Kconfig
> @@ -6,6 +6,7 @@ config ARCH_PICOXCELL
>  	select CPU_V6K
>  	select DW_APB_TIMER
>  	select DW_APB_TIMER_OF
> +	select CLKSRC_OF

Shouldn't DW_APB_TIMER 'select CLKSRC_OF if OF' instead of selecting is for 
each and every platform? While at it we can do the same to DW_APB_TIMER_OF.

baruch


-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
