Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab3EBKJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:09:26 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42344 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab3EBKJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:09:24 -0400
X-IronPort-AV: E=Sophos;i="4.87,595,1363158000"; 
   d="scan'208";a="43403590"
Message-ID: <f023185a0414961d3c30b3cfaf8b9a51.squirrel@www.codeaurora.org>
In-Reply-To: <1367475929-32166-3-git-send-email-ambresh@ti.com>
References: <1367475929-32166-1-git-send-email-ambresh@ti.com>
    <1367475929-32166-3-git-send-email-ambresh@ti.com>
Date: Thu, 2 May 2013 03:09:24 -0700
Subject: Re: [Patch 2/3] clk: skip re-parenting orphan clk
From: skannan@codeaurora.org
To: "Ambresh K" <ambresh@ti.com>
Cc: "Mike Turquette" <mturquette@linaro.org>, "Nishanth Menon" <nm@ti.com>,
        "Rajendra" <rnayak@ti.com>, linux-kernel@vger.kernel.org,
        "Tero Kristo" <t-kristo@ti.com>, "Ambresh K" <ambresh@ti.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ambresh K wrote:
> From: Ambresh K <ambresh@ti.com>
>
> If clk is same as orphan clk than skip the iteration, there

Typo: than => then

> by avoiding unnecessary look-up.
>
> Signed-off-by: Ambresh K <ambresh@ti.com>
> ---
>  drivers/clk/clk.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index c187321..f4d2c73 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1635,6 +1635,10 @@ int __clk_init(struct device *dev, struct clk *clk)
>  	 * this clock
>  	 */
>  	hlist_for_each_entry_safe(orphan, tmp2, &clk_orphan_list, child_node) {
> +		/* Skip if clk is same as orphan clk */
> +		if (!strcmp(clk->name, orphan->name))
> +			continue;
> +
>  		if (orphan->ops->get_parent) {
>  			i = orphan->ops->get_parent(orphan->hw);
>  			if (i < 0) {
> --
> 1.7.4.1
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>


-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

