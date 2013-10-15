Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536Ab3JOSwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 14:52:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50257 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773Ab3JOSwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 14:52:53 -0400
Message-ID: <525D8F01.8010603@wwwdotorg.org>
Date: Tue, 15 Oct 2013 12:52:49 -0600
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
        Hiroshi Doyu <hdoyu@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 03/19] clk: tegra: common periph_clk_enb_refcnt and
 clks
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com> <1381848794-11761-4-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1381848794-11761-4-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 08:52 AM, Peter De Schrijver wrote:
> This patch makes periph_clk_enb_refcnt a global array, dynamically allocated
> at boottime. It simplifies the macros somewhat and allows clocks common to
> several Tegra SoCs to be defined in a separate files. Also the clks array
> becomes global and dynamically allocated which allows the DT registration to
> be moved to a generic funcion.

> diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c

> +struct clk ** __init tegra_clk_init(int num, int banks)
>  {
> +	if (banks > ARRAY_SIZE(periph_regs)) {
> +		WARN_ON(1);

I think that can just be:

	if (WARN_ON(banks > ARRAY_SIZE(periph_regs))) {

