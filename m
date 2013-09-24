Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab3IXQob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:44:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42574 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab3IXQoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:44:30 -0400
Message-ID: <5241C168.4060100@wwwdotorg.org>
Date: Tue, 24 Sep 2013 10:44:24 -0600
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
Subject: Re: [PATCH 08/12] clk: tegra: move periph clocks to common file
References: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com> <1379515331-19427-9-git-send-email-pdeschrijver@nvidia.com> <5240890F.6050807@wwwdotorg.org> <20130924082004.GJ30013@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20130924082004.GJ30013@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 02:20 AM, Peter De Schrijver wrote:
> On Mon, Sep 23, 2013 at 08:31:43PM +0200, Stephen Warren wrote:
>> On 09/18/2013 08:41 AM, Peter De Schrijver wrote:
>>> Introduce a new file for peripheral clocks common between several Tegra
>>> SoCs and move Tegra114 to this new infrastructure. Also PLLP and the PLLP_OUT
>>> clocks will be initialized here.
>>
>>> diff --git a/drivers/clk/tegra/clk-tegra-periph.c b/drivers/clk/tegra/clk-tegra-periph.c
>>
>> Similarly here: don't the following differences exist between the SoCs:
>>
>> * At least the set of extant peripheral clocks, and perhaps some
>> parameters of those clocks.
> 
> That's what the tegra_clks is for. If the clock isn't in that table, it won't
> be registered.
> 
>> * The set of legal parents for some peripheral clocks (?)
> 
> If they differ for Tegra20 and Tegra30, we will need some extra clocks here,
> which will have a new ID and then only be defined in the tegra_clks for those
> SoCs. Alternatively they can stay in the SoC specific files.

I guess that would work.

However, I'd suggest simply leaving all the SoC-specific stuff in the
SoC-specific files until it actually becomes shared. Otherwise, you're
simply putting all the code into one big file, and parameterizing it to
get the correct SoC-specific clocks registered, when you could just keep
the SoC-specific code in the SoC-specific file/functions, and not need
any of the conditions.
