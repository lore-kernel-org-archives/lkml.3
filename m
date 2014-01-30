Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbaA3Nty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:49:54 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58455 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbaA3Ntw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:49:52 -0500
Message-ID: <52EA5866.3090706@ti.com>
Date: Thu, 30 Jan 2014 15:49:26 +0200
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: keystone: gate: fix clk_init_data initialization
References: <1391081821-13306-1-git-send-email-ivan.khoronzhuk@ti.com> <448912EABC71F84BBCADFD3C67C4BE52A0B4EB@DBDE04.ent.ti.com>
In-Reply-To: <448912EABC71F84BBCADFD3C67C4BE52A0B4EB@DBDE04.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes. As result the clk->flag field contains garbage. In my case it leads
that flag CLK_IGNORE_UNUSED is set for most of clocks.  As result a bunch
of unused clocks cannot be disabled.

On 01/30/2014 03:26 PM, Shilimkar, Santosh wrote:
> Can u capture the issue withiout this fix?
>
> Sent from my Android phone using TouchDown (www.nitrodesk.com)
>
> -----Original Message-----
> *From:* Khoronzhuk, Ivan [ivan.khoronzhuk@ti.com]
> *Received:* Thursday, 30 Jan 2014, 6:37am
> *To:* Shilimkar, Santosh [santosh.shilimkar@ti.com]
> *CC:* mturquette@linaro.org [mturquette@linaro.org];
> linux-arm-kernel@lists.infradead.org [linux-arm-kernel@lists.infradead.org];
> linux-kernel@vger.kernel.org [linux-kernel@vger.kernel.org]; Khoronzhuk, Ivan
> [ivan.khoronzhuk@ti.com]
> *Subject:* [PATCH] clk: keystone: gate: fix clk_init_data initialization
>
> In clk_register_psc() function clk_init_data struct is allocated
> in the stack. All members of this struct should be initialized
> before using otherwise it will contain garbage. So initialize flags
> in this structure too.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
>    drivers/clk/keystone/gate.c | 1 +
>    1 file changed, 1 insertion(+)
>
> diff --git a/drivers/clk/keystone/gate.c b/drivers/clk/keystone/gate.c
> index 17a5983..86f1e36 100644
> --- a/drivers/clk/keystone/gate.c
> +++ b/drivers/clk/keystone/gate.c
> @@ -179,6 +179,7 @@ static struct clk *clk_register_psc(struct device *dev,
>
>            init.name = name;
>            init.ops = &clk_psc_ops;
> +       init.flags = 0;
>            init.parent_names = (parent_name ? &parent_name : NULL);
>            init.num_parents = (parent_name ? 1 : 0);
>
> -- 
> 1.8.3.2
>

