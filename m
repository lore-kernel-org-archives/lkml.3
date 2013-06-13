Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab3FMMpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:45:22 -0400
Received: from multi.imgtec.com ([194.200.65.239]:32300 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864Ab3FMMpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:45:21 -0400
Message-ID: <51B9BE95.6090604@imgtec.com>
Date: Thu, 13 Jun 2013 13:44:05 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: <linux-kernel@vger.kernel.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Arnd Bergmann <arnd@arndb.de>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v2 1/9] metag: of_platform_populate from arch generic
 code
References: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com> <1369412476-14245-2-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1369412476-14245-2-git-send-email-james.hogan@imgtec.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_06_13_13_45_19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/05/13 17:21, James Hogan wrote:
> If no init_machine callback is provided, call of_platform_populate()
> instead. This allows a board/SoC that only needs to call
> of_platform_populate to omit the callback altogether.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: devicetree-discuss@lists.ozlabs.org

I've applied this patch for v3.11

Cheers
James

> ---
>  arch/metag/kernel/setup.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/metag/kernel/setup.c b/arch/metag/kernel/setup.c
> index 4f5726f..e18cebb 100644
> --- a/arch/metag/kernel/setup.c
> +++ b/arch/metag/kernel/setup.c
> @@ -20,6 +20,7 @@
>  #include <linux/memblock.h>
>  #include <linux/mm.h>
>  #include <linux/of_fdt.h>
> +#include <linux/of_platform.h>
>  #include <linux/pfn.h>
>  #include <linux/root_dev.h>
>  #include <linux/sched.h>
> @@ -424,6 +425,9 @@ static int __init customize_machine(void)
>  	/* customizes platform devices, or adds new ones */
>  	if (machine_desc->init_machine)
>  		machine_desc->init_machine();
> +	else
> +		of_platform_populate(NULL, of_default_bus_match_table, NULL,
> +				     NULL);
>  	return 0;
>  }
>  arch_initcall(customize_machine);
> 

