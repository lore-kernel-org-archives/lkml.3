Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaJMIXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 04:23:31 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12633 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaJMIXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 04:23:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 13 Oct 2014 01:23:05 -0700
Date: Mon, 13 Oct 2014 11:23:22 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Mike Turquette <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <ccross@android.com>,
        Barry Song <baohua@kernel.org>, Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.linux@gmail.com>
Subject: Re: [PATCH v2 4/4] clk: Use ww_mutexes for clk_prepare_{lock/unlock}
Message-ID: <20141013082322.GD32045@tbergstrom-lnx.Nvidia.com>
References: <1409792466-5092-1-git-send-email-sboyd@codeaurora.org>
 <1409792466-5092-5-git-send-email-sboyd@codeaurora.org>
 <20140928024131.19023.40641@quantum>
 <5429F555.9030108@codeaurora.org>
 <54348EC2.3040300@codeaurora.org>
 <20141009025923.4379.66113@quantum>
 <20141010082434.GF29637@tbergstrom-lnx.Nvidia.com>
 <20141011002056.GJ5493@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141011002056.GJ5493@codeaurora.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 05:20:56PM -0700, Stephen Boyd wrote:
> On 10/10, Peter De Schrijver wrote:
> > > > drivers/clk/tegra/clk-pll.c:732:    unsigned long input_rate = 
> > > > clk_get_rate(clk_get_parent(hw->clk));
> > > > drivers/clk/tegra/clk-pll.c:1288:    unsigned long input_rate = 
> > > > clk_get_rate(clk_get_parent(hw->clk));
> > 
> > This is not so easy to change unfortunately. I will have to think of a solution.
> > 
> 
> Thanks. Does the input parent rate change at runtime or is it
> fixed at boot? I'm hoping we can call _get_table_rate() once
> before we register the clock or something.

It can change at runtime.

Cheers,

Peter.
