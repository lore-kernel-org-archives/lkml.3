Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab3BEFmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 00:42:33 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10732 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab3BEFmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 00:42:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 04 Feb 2013 21:41:55 -0800
Message-ID: <51109BB3.8000706@nvidia.com>
Date: Tue, 5 Feb 2013 11:12:11 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 01/10] clk: tegra: Refactor PLL programming code
References: <1359713962-16822-1-git-send-email-pdeschrijver@nvidia.com> <1359713962-16822-2-git-send-email-pdeschrijver@nvidia.com> <510F4FF7.3050502@nvidia.com> <20130204143233.GV2364@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20130204143233.GV2364@tbergstrom-lnx.Nvidia.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 February 2013 08:02 PM, Peter De Schrijver wrote:
> On Mon, Feb 04, 2013 at 07:06:47AM +0100, Prashant Gaikwad wrote:
>> On Friday 01 February 2013 03:48 PM, Peter De Schrijver wrote:
> ...
>
>>> -static int clk_pll_wait_for_lock(struct tegra_clk_pll *pll,
>>> -                                void __iomem *lock_addr, u32 lock_bit_idx)
>>> +static int clk_pll_wait_for_lock(struct tegra_clk_pll *pll)
>>>    {
>>>           int i;
>>> -       u32 val;
>>> +       u32 val, lock_bit;
>>> +       void __iomem *lock_addr;
>>>
>>>           if (!(pll->flags & TEGRA_PLL_USE_LOCK)) {
>>>                   udelay(pll->params->lock_delay);
>>>                   return 0;
>>>           }
>>>
>>> +       lock_addr = pll->clk_base + pll->params->base_reg;
>> This will not work for PLLE. Lock bit for PLLE is in misc register.
>>
>>> +       lock_bit = BIT(pll->params->lock_bit_idx);
>>> +
>>>           for (i = 0; i < pll->params->lock_delay; i++) {
>>>                   val = readl_relaxed(lock_addr);
>>> -               if (val & BIT(lock_bit_idx)) {
>>> +               if (val & lock_bit) {
>> Need to change the lock bit idx parameter for Tegra20 and Tegra30 PLLs
>> else this patch will break those.
>>
> Looking at commit 37c26a906527b8a6a252614ca83d21ad318c4e84 and commit
> b08e8c0ecc42afa3a2e1019851af741980dd5a6b, these fields seem correctly
> initialized for both Tegra20 and Tegra30? Or am I missing something?

Ohh, I missed to read

lock_bit = BIT(pll->params->lock_bit_idx);


Am I missing something about PLLE lock_addr also?

> Thanks,
>
> Peter.

