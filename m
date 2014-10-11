Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaJKAU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 20:20:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53001 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaJKAU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 20:20:57 -0400
Date: Fri, 10 Oct 2014 17:20:56 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ccross@android.com, Barry Song <baohua@kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.linux@gmail.com>
Subject: Re: [PATCH v2 4/4] clk: Use ww_mutexes for clk_prepare_{lock/unlock}
Message-ID: <20141011002056.GJ5493@codeaurora.org>
References: <1409792466-5092-1-git-send-email-sboyd@codeaurora.org>
 <1409792466-5092-5-git-send-email-sboyd@codeaurora.org>
 <20140928024131.19023.40641@quantum>
 <5429F555.9030108@codeaurora.org>
 <54348EC2.3040300@codeaurora.org>
 <20141009025923.4379.66113@quantum>
 <20141010082434.GF29637@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010082434.GF29637@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10, Peter De Schrijver wrote:
> > > drivers/clk/tegra/clk-pll.c:732:    unsigned long input_rate = 
> > > clk_get_rate(clk_get_parent(hw->clk));
> > > drivers/clk/tegra/clk-pll.c:1288:    unsigned long input_rate = 
> > > clk_get_rate(clk_get_parent(hw->clk));
> 
> This is not so easy to change unfortunately. I will have to think of a solution.
> 

Thanks. Does the input parent rate change at runtime or is it
fixed at boot? I'm hoping we can call _get_table_rate() once
before we register the clock or something.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
