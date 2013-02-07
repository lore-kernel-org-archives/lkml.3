Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161130Ab3BGS6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:58:09 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:45963 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758751Ab3BGS6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:58:08 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Peter De Schrijver <pdeschrijver@nvidia.com>, <pdeschrijver@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1360254261-23000-1-git-send-email-pdeschrijver@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, <linux-kernel@vger.kernel.org>
References: <1360254261-23000-1-git-send-email-pdeschrijver@nvidia.com>
Message-ID: <20130207185742.11471.19037@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH] clk: tegra: Implement locking for super clock
Date: Thu, 07 Feb 2013 10:57:42 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter De Schrijver (2013-02-07 08:24:14)
> Although tegra_clk_register_super_mux() has a lock parameter, the lock is not
> actually used by the code. Fixed with this patch.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>  drivers/clk/tegra/clk-super.c |   18 +++++++++++++++---
>  1 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/clk/tegra/clk-super.c b/drivers/clk/tegra/clk-super.c
> index 7ad48a8..2fd924d 100644
> --- a/drivers/clk/tegra/clk-super.c
> +++ b/drivers/clk/tegra/clk-super.c
> @@ -73,7 +73,12 @@ static int clk_super_set_parent(struct clk_hw *hw, u8 index)
>  {
>         struct tegra_clk_super_mux *mux = to_clk_super_mux(hw);
>         u32 val, state;
> +       int err = 0;
>         u8 parent_index, shift;
> +       unsigned long flags = 0;

I don't think initializing flags to zero is necessary but it is not a
big deal.  Is gcc throwing a warning?  Otherwise:

Acked-by: Mike Turquette <mturquette@linaro.org>

Regards,
Mike
