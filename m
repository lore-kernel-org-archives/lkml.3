Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3JHNle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:41:34 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38668 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751682Ab3JHNlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:41:32 -0400
Date: Tue, 8 Oct 2013 14:41:00 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] ARM: l2x0: add Marvell Tauros3 compatible
Message-ID: <20131008134100.GD1412@e106331-lin.cambridge.arm.com>
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1381235073-17134-4-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381235073-17134-4-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 01:24:28PM +0100, Sebastian Hesselbarth wrote:
> This add a compatible for the Marvell Tauros3 cache controller which
> is compatible with l2x0 cache controllers. While updating the binding
> documentation, clean up the list of possible compatibles.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: devicetree@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  Documentation/devicetree/bindings/arm/l2cc.txt |   22 +++++++++++-----------
>  arch/arm/mm/cache-l2x0.c                       |    1 +
>  2 files changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt b/Documentation/devicetree/bindings/arm/l2cc.txt
> index c0c7626..a1d0cbd 100644
> --- a/Documentation/devicetree/bindings/arm/l2cc.txt
> +++ b/Documentation/devicetree/bindings/arm/l2cc.txt
> @@ -7,20 +7,20 @@ The ARM L2 cache representation in the device tree should be done as follows:
>  Required properties:
>  
>  - compatible : should be one of:
> -	"arm,pl310-cache"
> -	"arm,l220-cache"
> -	"arm,l210-cache"
> -	"marvell,aurora-system-cache": Marvell Controller designed to be
> +  "arm,pl310-cache"
> +  "arm,l220-cache"
> +  "arm,l210-cache"
> +  "bcm,bcm11351-a2-pl310-cache": DEPRECATED by "brcm,bcm11351-a2-pl310-cache"
> +  "brcm,bcm11351-a2-pl310-cache": For Broadcom bcm11351 chipset where an
> +     offset needs to be added to the address before passing down to the L2
> +     cache controller
> +  "marvell,aurora-system-cache": Marvell Controller designed to be
>       compatible with the ARM one, with system cache mode (meaning
>       maintenance operations on L1 are broadcasted to the L2 and L2
>       performs the same operation).
> -	"marvell,"aurora-outer-cache: Marvell Controller designed to be
> -	 compatible with the ARM one with outer cache mode.
> -	"brcm,bcm11351-a2-pl310-cache": For Broadcom bcm11351 chipset where an
> -	offset needs to be added to the address before passing down to the L2
> -	cache controller
> -	"bcm,bcm11351-a2-pl310-cache": DEPRECATED by
> -	                               "brcm,bcm11351-a2-pl310-cache"
> +  "marvell,aurora-outer-cache": Marvell Controller designed to be
> +     compatible with the ARM one with outer cache mode.
> +  "marvell,tauros3-cache": Marvell Tauros3 cache controller.

How does the tauros3 cache differ from the other caches supported by the
l2x0 driver?

>  - cache-unified : Specifies the cache is a unified cache.
>  - cache-level : Should be set to 2 for a level 2 cache.
>  - reg : Physical base address and size of cache controller's memory mapped
> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
> index 447da6f..90c776e 100644
> --- a/arch/arm/mm/cache-l2x0.c
> +++ b/arch/arm/mm/cache-l2x0.c
> @@ -929,6 +929,7 @@ static const struct of_device_id l2x0_ids[] __initconst = {
>  	  .data = (void *)&aurora_no_outer_data},
>  	{ .compatible = "marvell,aurora-outer-cache",
>  	  .data = (void *)&aurora_with_outer_data},
> +	{ .compatible = "marvell,tauros3-cache", .data = (void *)&l2x0_data },

Are we intending to handle this differently later? 

Or is it 100% compatible with the pl210 or pl220? We could just require
an entry later in the compatible string list instead...

Cheers,
Mark.
