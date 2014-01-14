Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaANCZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 21:25:22 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33451 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaANCZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 21:25:18 -0500
Message-ID: <52D4A00D.8000702@codeaurora.org>
Date: Mon, 13 Jan 2014 18:25:17 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 02/15] clk: Allow drivers to pass in a regmap
References: <1387847559-18330-1-git-send-email-sboyd@codeaurora.org> <1387847559-18330-3-git-send-email-sboyd@codeaurora.org> <20140109015158.7168.60274@quantum> <52CE055C.5030103@codeaurora.org> <20140110054424.7168.46289@quantum> <20140110070517.GE14405@codeaurora.org>
In-Reply-To: <20140110070517.GE14405@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/14 23:05, Stephen Boyd wrote:
> It feels another key point is being missed though. The regmap
> pointer and the enable_reg/enable_mask is embedded in clk_hw to
> allow the same code to be used by different types of surrounding
> structs. Each struct: clk_pll, clk_rcg, and clk_branch in this
> series use the regmap interface to enable/disable the clock and
> they can easily do so by passing something that's always
> available from struct clk_hw (be it via a wrapper struct, private
> data member, or addition of new fields to clk_hw). If the regmap
> members move into each specific type of clock we can't just pass
> a single pointer to the enable/disable regmap functions anymore.
> This is the reason why I suggested a driver data pointer or
> container struct so that everything regmap related is contained
> within one type.
>

Any thoughts?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

