Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3IUPMM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 11:12:12 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:52841 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3IUPMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 11:12:09 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Andrew Bresticker <abrestic@chromium.org>,
        linux-samsung-soc@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        linux-doc@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
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
Subject: Re: [PATCH 2/6] clk: exynos-audss: allow input clocks to be specified in device tree
Date: Sat, 21 Sep 2013 17:12:04 +0200
Message-ID: <9856196.dhfL7qQoq1@flatron>
User-Agent: KMail/4.11.1 (Linux/3.11.1-gentoo; KDE/4.11.1; x86_64; ; )
In-Reply-To: <1379711637-5226-2-git-send-email-abrestic@chromium.org>
References: <1379711637-5226-1-git-send-email-abrestic@chromium.org> <1379711637-5226-2-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Friday 20 of September 2013 14:13:53 Andrew Bresticker wrote:
> This allows the input clocks to the Exynos AudioSS block to be
> specified via device-tree bindings.  Default names will be used
> when an input clock is not given.
[snip]
> +Optional Properties:
> +
> +- clocks:
> +  - pll_ref: Fixed rate PLL reference clock, parent of mout_audss.
> "fin_pll" +    is used if not specified.
> +  - pll_in: Input PLL to the AudioSS block, parent of mout_audss.
> "fout_epll" +    is used if not specified.
> +  - cdclk: External i2s clock, parent of mout_i2s. "cdclk0" is used if
> not +    specified.
> +  - sclk_audio: Audio bus clock, parent of mout_i2s. "sclk_audio0" is
> used if +    not specified.
> +  - sclk_pcm_in: PCM clock, parent of sclk_pcm.  "sclk_pcm0" is used if
> not +    specified.
> +
> +- clock-names: Aliases for the above clocks. They should be "pll_ref",
> +  "pll_in", "cdclk", "sclk_audio", and "sclk_pcm_in" respectively.

I'd say that it should be preferred to specify all the input clocks 
appropriate for particular SoCs to fully represent the hardware. So the 
properties above should be marked as required (depending on SoC probably).

The fallback to default names in the driver should stay, though, to 
support older device trees.

Best regards,
Tomasz

