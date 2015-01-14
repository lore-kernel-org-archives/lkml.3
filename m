Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbbANWZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 17:25:17 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34623 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbbANWZN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 17:25:13 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
User-Agent: alot/0.3.5
To: Stephen Boyd <sboyd@codeaurora.org>,
        "Krzysztof Kozlowski" <k.kozlowski@samsung.com>,
        "Sylwester Nawrocki" <s.nawrocki@samsung.com>,
        "Tomasz Figa" <tomasz.figa@gmail.com>, "Kukjin Kim" <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1420451561-12360-1-git-send-email-k.kozlowski@samsung.com>
 <1420451561-12360-2-git-send-email-k.kozlowski@samsung.com>
 <54AEF541.1090700@codeaurora.org>
In-Reply-To: <54AEF541.1090700@codeaurora.org>
Message-ID: <20150114222504.22722.49023@quantum>
Subject: Re: [PATCH 2/2] clk: exynos-audss: Fix memory leak on driver unbind or probe
 failure
Date: Wed, 14 Jan 2015 14:25:04 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Boyd (2015-01-08 13:23:13)
> On 01/05/2015 01:52 AM, Krzysztof Kozlowski wrote:
> > The memory allocated by basic clock divider/gate/mux (struct clk_gate,
> > clk_divider and clk_mux) was leaking. During driver unbind or probe
> > failure the driver only unregistered the clocks.
> >
> > Use clk_unregister_{gate,divider,mux} to release all resources.
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> >
> 
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

I've applied both patches to clk-next. Krzysztof, let me know if you
would prefer to take the audss patch through the samsung clock branch
instead (to include it in a later pull request).

Regards,
Mike

> 
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
