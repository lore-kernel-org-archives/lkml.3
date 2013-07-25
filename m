Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab3GYQgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:36:19 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46885 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab3GYQgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:36:03 -0400
Date: Thu, 25 Jul 2013 09:36:02 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>, linux-arm-msm@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 03/14] clk: Add of_clk_match() for device drivers
Message-ID: <20130725163602.GB29694@codeaurora.org>
References: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org>
 <1374713022-6049-4-git-send-email-sboyd@codeaurora.org>
 <52875092.tEWeSbEJZC@flatron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52875092.tEWeSbEJZC@flatron>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25, Tomasz Figa wrote:
> Hi Stephen,
> 
> On Wednesday 24 of July 2013 17:43:31 Stephen Boyd wrote:
> > In similar fashion as of_regulator_match() add an of_clk_match()
> > function that finds an initializes clock init_data structs from
> > devicetree. Drivers should use this API to find clocks that their
> > device is providing and then iterate over their match table
> > registering the clocks with the init data parsed.
> 
> I think all you need here is declaring all your clock drivers using 
> CLK_OF_DECLARE() macro. Then they will be automatically probed by 
> of_clk_init(). See last lines of drivers/clk/clk-fixed-rate.c for an 
> example.
> 

CLK_OF_DECLARE() will not work because it doesn't give the
caller a struct device. I want that struct device to use managed
allocations and clk registrations.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
