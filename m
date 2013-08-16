Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab3HPRQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 13:16:44 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35568 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab3HPRQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 13:16:40 -0400
Subject: Re: [PATCH v1 03/14] clk: Add of_clk_match() for device drivers
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <0181ACFD-4F25-493C-9143-E197C53282DF@codeaurora.org>
Date: Fri, 16 Aug 2013 12:16:38 -0500
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <852016EB-D977-49AE-A80A-B4AEC4E19711@codeaurora.org>
References: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org> <1374713022-6049-4-git-send-email-sboyd@codeaurora.org> <20130812202347.5348.76490@quantum> <20130813054839.GF14845@codeaurora.org> <20130815050226.4443.39100@quantum> <0181ACFD-4F25-493C-9143-E197C53282DF@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 16, 2013, at 11:43 AM, Kumar Gala wrote:

> 
> On Aug 15, 2013, at 12:02 AM, Mike Turquette wrote:
> 
>>> Right now we have
>>> 
>>>       pll8: pll8 {
>>>               #clock-cells = <0>;
>>>               compatible = "qcom,pll";
>>>               clocks = <&pxo>;
>>>       };
>>> 
>>> in DT and
>>> 
>>>       static struct pll_desc pll8_desc = {
>>>               .l_reg = 0x3144,
>>>               .m_reg = 0x3148,
>>>               .n_reg = 0x314c,
>>>               .config_reg = 0x3154,
>>>               .mode_reg = 0x3140,
>>>               .status_reg = 0x3158,
>>>               .status_bit = 16,
>>>       };
>>> 
>>> in C. Do you want everything to be in DT? Something like:
>>> 
>>>       pll8: pll8@3140 {
>>>               #clock-cells = <0>;
>>>               compatible = "qcom,pll";
>>>               clocks = <&pxo>;
>>>               reg = <0x3140 0x20>;
>>>       };
>>> 
>>> and then assume that all those registers are offset from the base
>>> register and that the status bit is 16 (it usually is but not
>>> always)?
> 
> I think its reasonable to put the various regs associated with a clock in the .dts like the example you show, but we should be going down to bit level details.  If we think of each clock as its own device its reasonable that the clock would have some set of registers associated with it.


oops, we should NOT be going down to bit level.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

