Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab3BDVBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 16:01:15 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33436 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab3BDVBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 16:01:14 -0500
Message-ID: <51102195.9050604@wwwdotorg.org>
Date: Mon, 04 Feb 2013 14:01:09 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 09/10] clk: tegra: Implement clocks for Tegra114
References: <1359713962-16822-1-git-send-email-pdeschrijver@nvidia.com> <1359713962-16822-10-git-send-email-pdeschrijver@nvidia.com> <510F5E87.90801@nvidia.com> <20130204104531.GQ2364@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20130204104531.GQ2364@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 03:45 AM, Peter De Schrijver wrote:
> On Mon, Feb 04, 2013 at 08:08:55AM +0100, Prashant Gaikwad wrote:

>>> +       /* xusb_hs_src */
>>> +       val = readl(clk_base + CLK_SOURCE_XUSB_SS_SRC);
>>> +       val |= BIT(25); /* always select PLLU_60M */
>>> +       writel(val, clk_base + CLK_SOURCE_XUSB_SS_SRC);
>>> +
>>> +       clk = clk_register_fixed_factor(NULL, "xusb_hs_src", "pll_u_60M", 0,
>>> +                                       1, 1);
>>> +       clks[xusb_hs_src] = clk;
>>> +
>>
>> With device tree we can directly use pll_u_60M, no need to register 
>> clock with fixed factor 1.
> 
> This is true for now. In the future these clocks will need to be dvfs aware
> though. I think it makes sense to have a separate clock then?

Why does DVFS-awareness require it to be a different clock/ID?
