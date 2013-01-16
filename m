Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab3APSor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 13:44:47 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:57957 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab3APSoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 13:44:46 -0500
Message-ID: <50F6F513.1030806@wwwdotorg.org>
Date: Wed, 16 Jan 2013 11:44:35 -0700
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
Subject: Re: [PATCH v4 2/9] clk: tegra: Add tegra specific clocks
References: <1357890387-23245-1-git-send-email-pgaikwad@nvidia.com><1357890387-23245-3-git-send-email-pgaikwad@nvidia.com> <20130116.143151.1531468192773974887.hdoyu@nvidia.com>
In-Reply-To: <20130116.143151.1531468192773974887.hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 05:31 AM, Hiroshi Doyu wrote:
> Prashant Gaikwad <pgaikwad@nvidia.com> wrote @ Fri, 11 Jan 2013 08:46:20 +0100:
> ...
>> +struct clk *tegra_clk_periph(const char *name, const char **parent_names,
>> +                            int num_parents, struct tegra_clk_periph *periph,
>> +                            void __iomem *clk_base, u32 offset)
...
>> +struct clk *tegra_clk_periph_nodiv(const char *name, const char **parent_names,
>> +                             int num_parents, struct tegra_clk_periph *periph,
>> +                             void __iomem *clk_base, u32 offset)
...
>
> The above two functions are almost duplicate, can we take the common part from them?

Sure, that looks reasonable.

> struct clk *__tegra_clk_periph(const char *name, const char **parent_names,
> 			    int num_parents, struct tegra_clk_periph *periph,
> 			    void __iomem *clk_base, u32 offset, int div)

>        periph->divider.reg = clk_base + offset;

That will also need to be conditional.

>        periph->divider.hw.clk = div ? NULL : clk;

And that test is inverted.

> static inline struct clk *tegra_clk_periph(const char *name, const char **parent_names,
> 			    int num_parents, struct tegra_clk_periph *periph,
> 			    void __iomem *clk_base, u32 offset)

I'd rather just make these regular functions in the .c file; otherwise
they have to go into the header file, which means prototyping
__tegra_clk_periph() there and it just gets messy.
