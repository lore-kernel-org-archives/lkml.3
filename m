Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab3LPJOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:14:46 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:56042 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab3LPJOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:14:37 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1312091812440.4127@tamien>
References: <alpine.DEB.2.02.1312091812440.4127@tamien>
Date: Mon, 16 Dec 2013 14:44:36 +0530
Message-ID: <CAKohpo=8ejsO4ZSp6yPiV9P1VjFJQKT329SR3vqGM8AaYsbHLw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: omap: clk_round_rate() can return a zero upon error
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-omap@vger.kernel.org,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 December 2013 07:48, Paul Walmsley <pwalmsley@nvidia.com> wrote:
> Treat both negative and zero return values from clk_round_rate() as errors.
> This is needed since subsequent patches will convert clk_round_rate()'s
> return value to be an unsigned type, rather than a signed type, since some
> clock sources can generate rates higher than (2^31)-1 Hz.
>
> Eventually, when calling clk_round_rate(), only a return value of
> zero will be considered a error.  All other values will be
> considered valid rates.  The comparison against values less than
> 0 is kept to preserve the correct behavior in the meantime.
>
> This patch also removes a bogus usage of IS_ERR_VALUE(), which is intended
> to be used only on combination pointer/error code return values; a
> side-benefit.
>
> Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
