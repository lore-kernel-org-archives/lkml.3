Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761035Ab3JPRC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:02:26 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51259 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab3JPRCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:02:24 -0400
Message-ID: <525EC69C.5040004@wwwdotorg.org>
Date: Wed, 16 Oct 2013 11:02:20 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 08/19] clk: tegra: add common infra for DT clocks
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com> <1381848794-11761-9-git-send-email-pdeschrijver@nvidia.com> <525D9117.9050009@wwwdotorg.org> <20131016143448.GK5643@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20131016143448.GK5643@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 08:34 AM, Peter De Schrijver wrote:
> On Tue, Oct 15, 2013 at 09:01:43PM +0200, Stephen Warren wrote:
>> On 10/15/2013 08:52 AM, Peter De Schrijver wrote:
>>> Introduce a common infrastructure for sharing clock initialization between
>>> SoCs.
>>
>>> diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
>>
>>> +struct clk ** __init tegra_lookup_dt_id(int clk_id,
>>> +					struct tegra_clk *tegra_clk)
>>> +{
>>> +	if (tegra_clk[clk_id].present)
>>> +		return &clks[tegra_clk[clk_id].dt_id];
>>> +	else
>>> +		return NULL;
>>
>> Does this need range-checking? Or do we assume that since this is an
>> internal function, "clk_id" will never be out-of-range?
> 
> That was my assumption indeed. I could add a range check if you think that's
> useful.

It's probably OK if it's a purely internal function; I just wanted to
double-check.

