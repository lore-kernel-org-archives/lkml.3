Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891Ab3B0Xn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 18:43:59 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34402 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab3B0Xn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 18:43:57 -0500
Message-ID: <512E9A39.3070207@wwwdotorg.org>
Date: Wed, 27 Feb 2013 16:43:53 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Barry Song <baohua.song@csr.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCHv2] ARM: Push selects for TWD/SCU into machine entries
References: <1362007694-3419-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1362007694-3419-1-git-send-email-sboyd@codeaurora.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 04:28 PM, Stephen Boyd wrote:
> The TWD and SCU configs are selected by default as long as
> MSM_SCORPIONMP is false and/or MCT is false. Implementing the
> logic this way certainly saves lines in the Kconfig but it
> precludes those machines which select MSM_SCORPIONMP or MCT from
> participating in the single zImage effort because when those
> machines are combined with other SMP capable machines the TWD and
> SCU are no longer selected by default.
> 
> Push the select out to the machine entries so that we can compile
> these machines together and still select the appropriate configs.

> Resending to collect some more acks.

Seems simple enough it doesn't really need many, but for Tegra,
Acked-by: Stephen Warren <swarren@nvidia.com>

Which kernel is this going into? It's possible Tegra will get converted
to multi-platform in 3.10, which might move that main ARCH_TEGRA block
from arch/arm/Kconfig into arch/arm/mach-tegra/Kconfig, although I
suppose it doesn't /have/ to move it. I think some/all(?) other
multi-platform conversions have moved their main Kconfig option like
that though.
