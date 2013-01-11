Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab3AKVky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 16:40:54 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58722 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab3AKVkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 16:40:53 -0500
Message-ID: <50F086E2.6010806@wwwdotorg.org>
Date: Fri, 11 Jan 2013 14:40:50 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 7/9] clk: tegra: add clock support for tegra30
References: <1357890387-23245-1-git-send-email-pgaikwad@nvidia.com> <1357890387-23245-8-git-send-email-pgaikwad@nvidia.com> <20130111141725.ce3177ad04fc700186dc694d@nvidia.com>
In-Reply-To: <20130111141725.ce3177ad04fc700186dc694d@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 05:17 AM, Hiroshi Doyu wrote:
> On Fri, 11 Jan 2013 08:46:25 +0100
> Prashant Gaikwad <pgaikwad@nvidia.com> wrote:
> 
>> Add tegra30 clock support based on common clock framework.
>>
>> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
> .......
>> +static void __init tegra30_pll_init(void)
>> +{
>> +       struct clk *clk;
>> +
>> +       /* PLLC */
>> +       clk = tegra_clk_pll("pll_c", "pll_ref", clk_base, pmc_base, 0,
>> +                           0, &pll_c_params,
>> +                           TEGRA_PLL_HAS_CPCON | TEGRA_PLL_USE_LOCK,
>> +                           pll_c_freq_table, NULL);
>> +       clk_register_clkdev(clk, "pll_c", NULL);
>> +       clks[pll_c] = clk;
> 
> Just I noticed that there are quite many same itegration of:
> 
> 	clk_register_clkdev(clk, <ID name>, ?);
> 	clks[<ID>] = clk;
> 
> ID == <ID name>
> 
> Can any macro/func do the above at once?

To my mind, a macro would obfuscate this fairly simple code, unless
there is a table somewhere the maps <ID> to <ID name> which would allow
saving some code space (I just looked; I don't think there is).
Eventually (later cleanup), I wouldn't be surprised if both parameters
to clk_register_clkdev() became NULL in most cases, since most lookups
are through DT by the end of this series.
