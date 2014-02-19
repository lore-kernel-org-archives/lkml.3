Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbaBSURI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 15:17:08 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51707 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbaBSURF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 15:17:05 -0500
Date: Wed, 19 Feb 2014 12:17:03 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] clk: qcom: Add missing clock at index GCC_XO_CLK for
 MSM8974
Message-ID: <20140219201703.GG14769@codeaurora.org>
References: <1392819521-25734-1-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392819521-25734-1-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> Accessing GCC on MSM8974 trough <&gcc GCC_XO_CLK> lead to NULL

s/trough/through/

> pointer dereference. Fix this.
> 

I think you want to get the XO clock from the not yet upstreamed
RPM clock driver. This #define is for a gate that is internal to
the SoC sitting between the pin for XO and all downstream users
of the XO clock within the SoC. Futhermore, linux is not allowed
to control this gate because it's essential to the entire system.

This patch will work for now but we'll need to change the DTS in
the future to get the clock from the RPM node and then revert
this patch.

It may be better to just move the XO and sleep_clk_src clocks to
DT and make them fixed-rate clocks that get added by
of_clk_init(). Then when the RPM node is added we can remove the
XO node and update the usb node at the same time.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
