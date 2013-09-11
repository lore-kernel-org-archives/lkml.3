Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab3IKSNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:13:05 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34994 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3IKSNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:13:01 -0400
Date: Wed, 11 Sep 2013 13:12:26 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-arm-msm@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: msm: Add support for MSM8974 Dragonboard
Message-ID: <20130911181226.GU808@joshc.qualcomm.com>
References: <1375743779-24993-1-git-send-email-rvaswani@codeaurora.org>
 <1375780486.2725.7.camel@iivanov-dev.int.mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375780486.2725.7.camel@iivanov-dev.int.mm-sol.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Ivan-

On Tue, Aug 06, 2013 at 12:14:46PM +0300, Ivan T. Ivanov wrote:
[..]
> Enable low-level debug print routines to direct their
> output to the serial port on MSM 8974 devices.
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  arch/arm/Kconfig.debug                     |    8 ++++++++
>  arch/arm/mach-msm/board-dt-8974.c          |    2 ++
>  arch/arm/mach-msm/include/mach/msm_iomap.h |    4 ++++
>  3 files changed, 14 insertions(+)
[..]
> diff --git a/arch/arm/mach-msm/board-dt-8974.c b/arch/arm/mach-msm/board-dt-8974.c
> index 697623e..0ce016a 100644
> --- a/arch/arm/mach-msm/board-dt-8974.c
> +++ b/arch/arm/mach-msm/board-dt-8974.c
> @@ -12,6 +12,7 @@
>  
>  #include <linux/of_platform.h>
>  #include <asm/mach/arch.h>
> +#include <asm/mach/map.h>
>  
>  static const char * const msm8974_dt_match[] __initconst = {
>  	"qcom,msm8974-db",
> @@ -20,4 +21,5 @@ static const char * const msm8974_dt_match[] __initconst = {
>  
>  DT_MACHINE_START(MSM8974_DT, "Qualcomm MSM (Flattened Device Tree)")
>  	.dt_compat = msm8974_dt_match,
> +	.map_io = debug_ll_io_init,

If/when you get this patch cooked up ontop of Rohit's, changes to this
file (renamed to board-dt.c) should not be necessary.  As of bc37324
("ARM: mmu: Call debug_ll_io_init if no map_io function is specified"),
the debug ll uart mapping is setup automatically.

Thanks,
  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
