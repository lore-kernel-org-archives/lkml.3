Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223Ab3CGPhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:37:53 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57165 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab3CGPhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:37:52 -0500
Date: Thu, 7 Mar 2013 15:37:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-pm@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-samsung-soc@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Inderpal Singh <inderpal.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 1/4] cpufreq: exynos: Adding cpufreq driver for
	exynos5440
Message-ID: <20130307153736.GC4977@n2100.arm.linux.org.uk>
References: <1362629627-10012-1-git-send-email-amit.daniel@samsung.com> <5138B200.7060906@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5138B200.7060906@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 04:28:00PM +0100, Sylwester Nawrocki wrote:
> On 03/07/2013 05:13 AM, Amit Daniel Kachhap wrote:
> > +	dvfs_info->cpu_clk = devm_clk_get(dvfs_info->dev, "armclk");
> > +	if (IS_ERR_OR_NULL(dvfs_info->cpu_clk)) {
> 
> devm_clk_get() return value needs to be checked with IS_ERR(),
> not IS_ERR_OR_NULL().
> 
> > +		pr_err("Failed to get cpu clock\n");
> > +		ret = PTR_ERR(dvfs_info->cpu_clk);
> > +		goto err_free_table;

Amit, to illustrate why this is wrong, consider this:
1. Set cpu_clk to NULL.
2. Realise IS_ERR_OR_NULL(NULL) is true.
3. What is the value of PTR_ERR(NULL) ?
4. What effect does that have when you jump to err_free_table ?
5. What value is returned from this function in that case ?
6. What does that return value mean to the driver core ?
