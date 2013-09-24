Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab3IXTRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 15:17:07 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:33959 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab3IXTRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 15:17:04 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Andrew Bresticker <abrestic@chromium.org>,
        linux-samsung-soc@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tushar Behera <tushar.behera@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <rob.herring@calxeda.com>,
        Mike Turquette <mturquette@linaro.org>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Padmavathi Venna <padma.v@samsung.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH V3 1/6] clk: exynos-audss: convert to platform device
Date: Tue, 24 Sep 2013 12:17:01 -0700 (PDT)
Message-ID: <1706375.1GRhkzSkm0@flatron>
User-Agent: KMail/4.11.1 (Linux/3.11.1-gentoo; KDE/4.11.1; x86_64; ; )
In-Reply-To: <1380046016-5811-1-git-send-email-abrestic@chromium.org>
References: <1379982078-23381-1-git-send-email-abrestic@chromium.org> <1380046016-5811-1-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tuesday 24 of September 2013 11:06:51 Andrew Bresticker wrote:
> The Exynos AudioSS clock controller will later be modified to allow
> input clocks to be specified via device-tree in order to support
> multiple Exynos SoCs.  This will introduce a dependency on the core
> SoC clock controller being initialized first so that the AudioSS driver
> can look up its input clocks, but the order in which clock providers
> are probed in of_clk_init() is not guaranteed.  Since deferred probing
> is not supported in of_clk_init() and the AudioSS block is not the core
> controller, we can initialize it later as a platform device.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> ---
> Changes since v2:
>  - add error handling to probe callback
>  - fixed ordering of of_clk_{add,del}_provider
>  - fixed nits from Tomasz and Sylwester
> Changes since v1:
>  - add clk_unregister() calls to remove callback
>  - fixed minor nits from Tomasz
> ---
>  drivers/clk/samsung/clk-exynos-audss.c | 109
> +++++++++++++++++++++++++++------ 1 file changed, 90 insertions(+), 19
> deletions(-)

For the whole series:

Acked-by: Tomasz Figa <t.figa@samsung.com>

Thanks for addressing all the comments.

Best regards,
Tomasz

