Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab3IXQrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:47:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38750 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab3IXQrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:47:19 -0400
Message-ID: <5241C212.9030601@wwwdotorg.org>
Date: Tue, 24 Sep 2013 10:47:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 10/12] clk: tegra: move fixed clocks to common file
References: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com> <1379515331-19427-11-git-send-email-pdeschrijver@nvidia.com> <524089C8.4010108@wwwdotorg.org> <20130924083231.GK30013@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20130924083231.GK30013@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 02:32 AM, Peter De Schrijver wrote:
> On Mon, Sep 23, 2013 at 08:34:48PM +0200, Stephen Warren wrote:
>> On 09/18/2013 08:41 AM, Peter De Schrijver wrote:
>>> Introduce a new file for fixed clocks common between several Tegra
>>> SoCs and move Tegra114 to this new infrastructure.
>>
>>> diff --git a/drivers/clk/tegra/clk-tegra-fixed.c b/drivers/clk/tegra/clk-tegra-fixed.c
>>
>>> +void __init tegra_fixed_clk_init(struct tegra_clk *tegra_clks)
>>
>>> +	/* clk_m_div2 */
>>> +	dt_clk = tegra_lookup_dt_id(tegra_clk_clk_m_div2, tegra_clks);
>>> +	if (dt_clk) {
>>> +		clk = clk_register_fixed_factor(NULL, "clk_m_div2", "clk_m",
>>> +					CLK_SET_RATE_PARENT, 1, 2);
>>> +		clk_register_clkdev(clk, "clk_m_div2", NULL);
>>> +		*dt_clk = clk;
>>> +	}
>>
>> I guess "fixed" means "fixed at run-time", not "identical rate in all
>> systems"? Since this is the crystal rate, it can vary between boards,
>> but I supposed if "fixed" means "fixed at run-time", considering this as
>> a fixed clock is fine.
>>
> 
> Fixed means "fixed at run-time" indeed. Although clk_32k is 32768Hz on all
> boards as well.
> 
>> But, isn't clk_m also a fixed clock then? I would expect one or two more
> 
> I guess the code from clk-tegra-osc.c could be moved here if you think that's
> better?

It's probably not a big deal either way, but since both files are quite
tiny, and closely related, merging them seems reasonable.

>> clocks in this file. What about clk_s, or is that known as clk_32k here?
> 
> I don't think we ever had clk_s in upstream?

Looking at the Tegra114 TRM at least, it seems like it's just another
name for clk_32k. But, if there's more to it than that, I guess there's
no need to add it as part of this series if we haven't had a need for it
yet.
