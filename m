Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbaGVRP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 13:15:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54776 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbaGVRP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 13:15:26 -0400
Message-ID: <53CE9C29.5030508@wwwdotorg.org>
Date: Tue, 22 Jul 2014 11:15:21 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/6] clk: tegra: make tegra_clocks_apply_init_table arch_initcall
References: <1405437890-6468-1-git-send-email-pdeschrijver@nvidia.com> <1405437890-6468-3-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1405437890-6468-3-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 09:24 AM, Peter De Schrijver wrote:
> tegra_clocks_apply_init_table needs to be called after the udelay loop has
> been calibrated (see 441f199a37cfd66c5dd8dd45490bd3ea6971117d why that is).

Instead of just the commit ID, can you please mention the commit subject
too:

441f199a37cf "clk: tegra: defer application of init table"

> On existing Tegra SoCs this was done by calling tegra_clocks_apply_init_table
> from tegra_dt_init. To make this also work on ARM64, we need to
> change this into an initcall. tegra_dt_init is called from customize_machine
> which is an arch_initcall. Therefore this should also work on existing 32bit
> Tegra SoCs.

I still strongly dislike performing this basic initialization from
random separate initcalls. I think we should create a single initcall
for all the Tegra initialization, even if it isn't able to be a machine
descriptor hook function any more.

That said, discussions re: that are ongoing in other threads, so it's no
worth reworking this patch yet.
