Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab3EPEeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 00:34:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64357 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3EPEeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 00:34:04 -0400
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="47680097"
Message-ID: <519461BB.3010209@codeaurora.org>
Date: Wed, 15 May 2013 21:34:03 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mike Turquette <mturquette@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/2] clk: Disable unused clocks after deferred probing
 is done
References: <1368124502-18830-1-git-send-email-skannan@codeaurora.org>
In-Reply-To: <1368124502-18830-1-git-send-email-skannan@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2013 11:35 AM, Saravana Kannan wrote:
> With deferred probing, late_initcall() is too soon to declare a clock as
> unused. Wait for deferred probing to finish before declaring a clock as
> unused. Since deferred probing is done in late_initcall(), do the unused
> check to late_initcall_sync.
>
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> ---
>   drivers/clk/clk.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index fe4055f..5ecb64c 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -534,7 +534,7 @@ static int clk_disable_unused(void)
>
>   	return 0;
>   }
> -late_initcall(clk_disable_unused);
> +late_initcall_sync(clk_disable_unused);
>
>   /***    helper functions   ***/

Mike,

Thoughts? Picking it up? Removing the existing auto-disable code (I 
think they are still useful)?

-Saravana


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
