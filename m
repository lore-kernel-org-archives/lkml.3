Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab3GYQpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:45:44 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47654 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab3GYQpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:45:43 -0400
Date: Thu, 25 Jul 2013 09:45:42 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>, linux-arm-msm@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>,
        Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 04/14] clk: Add set_rate_and_parent() op
Message-ID: <20130725164542.GF29694@codeaurora.org>
References: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org>
 <1374713022-6049-5-git-send-email-sboyd@codeaurora.org>
 <4582949.WCP5JfKYES@flatron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4582949.WCP5JfKYES@flatron>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25, Tomasz Figa wrote:
> On Wednesday 24 of July 2013 17:43:32 Stephen Boyd wrote:
> > Some of Qualcomm's clocks can change their parent and rate at the
> > same time with a single register write. Add support for this
> > hardware to the common clock framework by adding a new
> > set_rate_and_parent() op. When the clock framework determines
> > that both the parent and the rate are going to change during
> > clk_set_rate() it will call the .set_rate_and_parent() op if
> > available and fall back to calling .set_parent() followed by
> > .set_rate() otherwise.
> 
> This is strange. Does you hardware support switching parent and rate 
> separately or you always need to set both and so all the fuss here?

It supports setting the parent or setting the rate, or setting
both at the same time.

> 
> If the latter is the case, then maybe you can simply keep parent index and 
> rate cached inside driver data of your clock driver and use them on any 
> .set_rate() or .set_parent() calls?

This will not work. In fact, doing that would cause us to
overclock hardware for a short time between switching the parent
and the rate.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
