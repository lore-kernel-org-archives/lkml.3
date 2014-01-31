Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbaAaOqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 09:46:30 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43718 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496AbaAaOq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 09:46:29 -0500
Message-ID: <52EBB72B.20708@ti.com>
Date: Fri, 31 Jan 2014 09:46:03 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
CC: <mturquette@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] clk: keystone: gate: fix clk_init_data initialization
References: <1391104991-15000-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1391104991-15000-1-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 January 2014 01:03 PM, Ivan Khoronzhuk wrote:
> The clk_init_data struct is allocated in the stack. All members of
> this struct should be initialized before using otherwise it will
> lead to unpredictable situation as it can contain garbage.
> 
> Ultimately the clk->flag field contains garbage. In my case it leads
> that flag CLK_IGNORE_UNUSED is set for most of clocks. As result a
> bunch of unused clocks cannot be disabled.
> 
> So initialize flags in this structure too.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
> Based on
> git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git
> keystone/master
> 
> v1..v2:
> - updated commit description only
> 
Thanks for the update. 

>  drivers/clk/keystone/gate.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/clk/keystone/gate.c b/drivers/clk/keystone/gate.c
> index 17a5983..86f1e36 100644
> --- a/drivers/clk/keystone/gate.c
> +++ b/drivers/clk/keystone/gate.c
> @@ -179,6 +179,7 @@ static struct clk *clk_register_psc(struct device *dev,
>  
>  	init.name = name;
>  	init.ops = &clk_psc_ops;
> +	init.flags = 0;
>  	init.parent_names = (parent_name ? &parent_name : NULL);
>  	init.num_parents = (parent_name ? 1 : 0);
>  
> 

