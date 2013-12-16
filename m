Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab3LPO7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 09:59:07 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54805 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573Ab3LPO7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 09:59:01 -0500
Message-ID: <52AF1532.6030904@ti.com>
Date: Mon, 16 Dec 2013 09:58:58 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Paul Walmsley <pwalmsley@nvidia.com>
CC: Viresh Kumar <viresh.kumar@linaro.org>, <linux-omap@vger.kernel.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: omap: clk_round_rate() can return a zero upon
 error
References: <alpine.DEB.2.02.1312091812440.4127@tamien>
In-Reply-To: <alpine.DEB.2.02.1312091812440.4127@tamien>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 December 2013 09:18 PM, Paul Walmsley wrote:
> 
> Treat both negative and zero return values from clk_round_rate() as errors.  This is needed since subsequent patches will convert clk_round_rate()'s return value to be an unsigned type, rather than a signed type, since some clock sources can generate rates higher than (2^31)-1 Hz.
> 
> Eventually, when calling clk_round_rate(), only a return value of
> zero will be considered a error.  All other values will be
> considered valid rates.  The comparison against values less than
> 0 is kept to preserve the correct behavior in the meantime.
> 
> This patch also removes a bogus usage of IS_ERR_VALUE(), which is intended to be used only on combination pointer/error code return values; a side-benefit.
> 
> Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>


