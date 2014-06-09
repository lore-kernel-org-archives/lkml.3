Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbaFIR4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 13:56:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50945 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbaFIR4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 13:56:30 -0400
Message-ID: <5395F54C.3080806@codeaurora.org>
Date: Mon, 09 Jun 2014 10:56:28 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephane Viau <sviau@codeaurora.org>
CC: robdclark@gmail.com, dri-devel@lists.freedesktop.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/msm/hdmi: set hdp clock rate before prepare_enable
 call
References: <1402063412-10407-1-git-send-email-sviau@codeaurora.org>
In-Reply-To: <1402063412-10407-1-git-send-email-sviau@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/14 07:03, Stephane Viau wrote:
> The clock driver usually complains when a clock is being prepared
> before setting its rate. It is the case here for "core_clk" which
> needs to be set at 19.2 MHz before we attempt a prepare_enable().

That's only true in the downstream vendor kernel. Upstream we detect all
rates when clocks are registered. Given that 19.2Mhz is the default rate
out of reset for this clock this patch is fairly useless.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

