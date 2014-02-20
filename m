Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaBTHp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 02:45:26 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:52915 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbaBTHpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 02:45:25 -0500
Message-ID: <1392882243.17130.75.camel@iivanov-dev>
Subject: Re: [PATCH] clk: qcom: Add missing clock at index GCC_XO_CLK for
 MSM8974
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Thu, 20 Feb 2014 09:44:03 +0200
In-Reply-To: <20140219201703.GG14769@codeaurora.org>
References: <1392819521-25734-1-git-send-email-iivanov@mm-sol.com>
	 <20140219201703.GG14769@codeaurora.org>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-19 at 12:17 -0800, Stephen Boyd wrote: 
> On 02/19, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > Accessing GCC on MSM8974 trough <&gcc GCC_XO_CLK> lead to NULL
> 
> s/trough/through/
> 
> > pointer dereference. Fix this.
> > 
> 
> I think you want to get the XO clock from the not yet upstreamed
> RPM clock driver. This #define is for a gate that is internal to
> the SoC sitting between the pin for XO and all downstream users
> of the XO clock within the SoC. Futhermore, linux is not allowed
> to control this gate because it's essential to the entire system.
> 
> This patch will work for now but we'll need to change the DTS in
> the future to get the clock from the RPM node and then revert
> this patch.
> 
> It may be better to just move the XO and sleep_clk_src clocks to
> DT and make them fixed-rate clocks that get added by
> of_clk_init(). Then when the RPM node is added we can remove the
> XO node and update the usb node at the same time.


I see. I'll leave you to decide what is the right solution here,

Regards,
Ivan


