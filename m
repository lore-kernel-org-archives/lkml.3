Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab3DYRq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:46:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38713 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932753Ab3DYRq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:46:58 -0400
Date: Thu, 25 Apr 2013 18:46:35 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Hongbo Zhang <hongbo.zhang@stericsson.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 2/2] thermal: db8500_cpufreq_cooling: remove usage of
	IS_ERR_OR_NULL()
Message-ID: <20130425174635.GB25783@flint.arm.linux.org.uk>
References: <1366899214-22639-1-git-send-email-eduardo.valentin@ti.com> <1366899214-22639-3-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366899214-22639-3-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 10:13:34AM -0400, Eduardo Valentin wrote:
> diff --git a/drivers/thermal/db8500_cpufreq_cooling.c b/drivers/thermal/db8500_cpufreq_cooling.c
> index 21419851..786d192 100644
> --- a/drivers/thermal/db8500_cpufreq_cooling.c
> +++ b/drivers/thermal/db8500_cpufreq_cooling.c
> @@ -37,7 +37,7 @@ static int db8500_cpufreq_cooling_probe(struct platform_device *pdev)
>  	cpumask_set_cpu(0, &mask_val);
>  	cdev = cpufreq_cooling_register(&mask_val);
>  
> -	if (IS_ERR_OR_NULL(cdev)) {
> +	if (IS_ERR(cdev)) {
>  		dev_err(&pdev->dev, "Failed to register cooling device\n");
>  		return PTR_ERR(cdev);

Correct.  cpufreq_cooling_register() returns either an error-pointer or
a valid pointer.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
