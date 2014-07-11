Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaGKMHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 08:07:52 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:40930 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaGKMHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 08:07:49 -0400
Message-ID: <53BFD38F.5010805@gmail.com>
Date: Fri, 11 Jul 2014 17:37:43 +0530
From: Tushar Behera <trblinux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tushar Behera <tushar.b@samsung.com>
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        robh+dt@kernel.org, grant.likely@linaro.org, kgene.kim@samsung.com,
        mturquette@linaro.org, t.figa@samsung.com
Subject: Re: [PATCH 2/2] clk: exynos-audss: Update as per existing framework
References: <1405071475-31946-1-git-send-email-tushar.b@samsung.com> <1405071475-31946-3-git-send-email-tushar.b@samsung.com> <53BFBF18.3080704@samsung.com>
In-Reply-To: <53BFBF18.3080704@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 04:10 PM, Sylwester Nawrocki wrote:
> Hi Tushar,
> 
> On 11/07/14 11:37, Tushar Behera wrote:
>> Change exynos-audss clock driver as per existing clock framework from
>> the existing module driver framework.
> 
> Can you explain what's the actual issue you're trying to solve with that
> patch ? What's the problem with this driver being a platform driver ?
> It feels we're moving in circles here, see
> 
> commit b37a4224104568198b93fb9831224cfe7d83fff8
> Author: Andrew Bresticker <abrestic@chromium.org>
> Date:   Wed Sep 25 14:12:47 2013 -0700
> 
>     clk: exynos-audss: convert to platform device
> 
>     The Exynos AudioSS clock controller will later be modified to allow
>     input clocks to be specified via device-tree in order to support
>     multiple Exynos SoCs.  This will introduce a dependency on the core
>     SoC clock controller being initialized first so that the AudioSS driver
>     can look up its input clocks, but the order in which clock providers
>     are probed in of_clk_init() is not guaranteed.  Since deferred probing
>     is not supported in of_clk_init() and the AudioSS block is not the core
>     controller, we can initialize it later as a platform device.
> 
>     Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>     Acked-by: Tomasz Figa <t.figa@samsung.com>
>     Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>     Acked-by: Mike Turquette <mturquette@linaro.org>
>     Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>     Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> 
> I realize of_clk_init() now handles better clock provider dependencies,
> nevertheless do we really need all this churn ?
> 

I have sent v2 of the patchset while retaining the platform driver
infrastructure. Awaiting your review comments on that.

> --
> Thanks,
> Sylwester
> 

Thanks,
-- 
Tushar Behera
