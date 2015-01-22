Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbbAVWm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:42:58 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59833 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbbAVWmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:42:55 -0500
Date: Thu, 22 Jan 2015 14:42:51 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v12 3/6] clk: Make clk API return per-user struct clk
 instances
Message-ID: <20150122224250.GP27202@codeaurora.org>
References: <1421943207-5180-1-git-send-email-tomeu.vizoso@collabora.com>
 <1421943207-5180-4-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421943207-5180-4-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22, Tomeu Vizoso wrote:
> Moves clock state to struct clk_core, but takes care to change as little API as
> possible.
> 
> struct clk_hw still has a pointer to a struct clk, which is the
> implementation's per-user clk instance, for backwards compatibility.
> 
> The struct clk that clk_get_parent() returns isn't owned by the caller, but by
> the clock implementation, so the former shouldn't call clk_put() on it.
> 
> Because some boards in mach-omap2 still register clocks statically, their clock
> registration had to be updated to take into account that the clock information
> is stored in struct clk_core now.
> 
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> 
> ---

My comment on v11 still stands about __clk_create_clk() in
clkdev.c, but otherwise I don't see problems. You can have my
reviewed-by anyway.

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
