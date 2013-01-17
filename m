Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab3AQQfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 11:35:23 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43403 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090Ab3AQQfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 11:35:21 -0500
Message-ID: <50F82846.2030008@wwwdotorg.org>
Date: Thu, 17 Jan 2013 09:35:18 -0700
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
References: <1357890387-23245-3-git-send-email-pgaikwad@nvidia.com><20130116.171242.2189136612266237422.hdoyu@nvidia.com><50F7096C.7020803@wwwdotorg.org> <20130117.070327.1625310713330263780.hdoyu@nvidia.com>
In-Reply-To: <20130117.070327.1625310713330263780.hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 10:03 PM, Hiroshi Doyu wrote:
> Stephen Warren <swarren@wwwdotorg.org> wrote @ Wed, 16 Jan 2013 21:11:24 +0100:
> 
>>>> +static int clk_frac_div_set_rate(struct clk_hw *hw, unsigned long rate,
>>>> +                               unsigned long parent_rate)
>>>> +{
>>>> +       struct tegra_clk_frac_div *divider = to_clk_frac_div(hw);
>>>> +       int div;
>>>> +       unsigned long flags = 0;
>>>
>>> nit, is "flags" not needed to initialize here?
>>
>> It avoids a compiler warning; the compiler doesn't that the if condition
>> that guards the path that uses flags is the same condition as the path
>> that initializes it. Or, it may be related to the fact that
>> spin_lock_irqsave() writes to the value through a pointer parameter, and
>> the compiler doesn't know it's an out-only parameter.
> 
> It might be better to append the special comment /* GCC */[1] on that line.
> 
> [1] https://lwn.net/Articles/529954/

I note that patch hasn't actually been merged though, so I think I'll
avoid doing that for now.

