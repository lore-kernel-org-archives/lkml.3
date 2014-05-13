Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbaEMSKC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 14:10:02 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50859 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaEMSJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 14:09:54 -0400
Message-ID: <53725FED.7050303@wwwdotorg.org>
Date: Tue, 13 May 2014 12:09:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] clk: tegra: Implement Tegra124 shared/cbus clks
References: <1399990023-30318-1-git-send-email-pdeschrijver@nvidia.com> <1399990023-30318-4-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1399990023-30318-4-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 08:06 AM, Peter De Schrijver wrote:
> Add shared and cbus clocks to the Tegra124 clock implementation.

> diff --git a/include/dt-bindings/clock/tegra124-car.h b/include/dt-bindings/clock/tegra124-car.h

> +#define TEGRA124_CLK_C2BUS 401
> +#define TEGRA124_CLK_C3BUS 402
> +#define TEGRA124_CLK_GR3D_CBUS 403
> +#define TEGRA124_CLK_GR2D_CBUS 404
...

I worry about this a bit. IIUC, these clocks don't actually exist in HW,
but are more a way of SW applying policy to the clock that do exist in
HW. As such, I'm not convinced it's a good idea to expose these clock
IDS to DT, since DT is supposed to represent the HW, and not be
influenced by internal SW implementation details.

Do any DTs actually need to used these new clock IDs? I don't think we
could actually use these value in e.g. tegra124.dtsi's clocks
properties, since these clocks don't exist in HW. Was it your intent to
do that? If not, can't we just define these SW-internal clock IDs in the
header inside the Tegra clock driver, so the values are invisible to DT?
