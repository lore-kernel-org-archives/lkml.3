Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab3IKT4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:56:45 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42578 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030Ab3IKT4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:56:42 -0400
Message-ID: <5230CAF7.6010103@wwwdotorg.org>
Date: Wed, 11 Sep 2013 13:56:39 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Stephen Warren <swarren@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 13/16] ARM: tegra: split tegra_pmc_init() in two
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1377638890-371-14-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1377638890-371-14-git-send-email-sebastian.hesselbarth@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 03:28 PM, Sebastian Hesselbarth wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Tegra's board file currently initializes clocks much earlier than those
> for most other ARM SoCs. The reason is:
> 
> * The PMC HW block is involved in the path of some interrupts (i.e. it
> inverts, or not, the IRQ input pin dedicated to the PMIC).
> 
> * So, that part of the PMC must be initialized early so that the IRQ
> polarity is correct.
> 
> * The PMC initialization is currently monolithic, and the PMC has some
> clock inputs, so the init routine ends up calling of_clk_get_by_name(),
> and hence clocks must be set up early too.
> 
> In order to defer clock initialization to the more typical location,
> split out the portions of tegra_pmc_init() that are truly IRQ-related
> into a separate tegra_pmc_init_irq(), which can be called from the
> machine descriptor's .init_irq() function, and defer the rest until
> the machine descriptor's .init_machine() function. With arch/arm calling
> of_clk_init(NULL) from time_init() this also allows the removal of
> .init_time() hook.

Sebastian, I assume you're targeting v3.13 or later for this patch
series? If so, it might be a good idea if I apply this patch myself to
the Tegra tree so that I can base any future Tegra patches on top of it
to avoid any possible conflicts. I can put this patch first in the
cleanup branch so you can merge it into whatever tree you use for the
rest of this series. Does that work for you? If so, let me know. Thanks.
