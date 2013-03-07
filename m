Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526Ab3CGBqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 20:46:46 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:61641 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab3CGBqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 20:46:43 -0500
Date: Wed, 6 Mar 2013 17:46:57 -0800
From: Olof Johansson <olof@lixom.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, linaro-kernel@lists.linaro.org,
        mark.hambleton@broadcom.com, linux-arm-kernel@lists.infradead.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: Re: [PATCH] cpufreq: ARM big LITTLE: Add generic cpufreq driver and
 its DT glue
Message-ID: <20130307014657.GA7426@quad.lixom.net>
References: <f20e3c5e822c4bd28a3b71264d73143cc1f850b0.1362458878.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f20e3c5e822c4bd28a3b71264d73143cc1f850b0.1362458878.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 12:52:41PM +0800, Viresh Kumar wrote:
> +++ b/Documentation/devicetree/bindings/cpufreq/arm_big_little_dt.txt
> @@ -0,0 +1,29 @@
> +Generic ARM big LITTLE cpufreq driver's DT glue
> +-----------------------------------------------
> +
> +It is DT specific glue layer for generic cpufreq driver for big LITTLE systems.
> +
> +Both required and optional properties listed below must be defined under node
> +cluster*. * can be 0 or 1.
> +
> +Required properties:
> +- freqs: List of all supported frequencies.
> +
> +Optional properties:
> +- clock-latency: Specify the possible maximum transition latency for clock, in
> +  unit of nanoseconds.
> +
> +Examples:
> +
> +cluster0: cluster@0 {
> +        ..
> +
> +	freqs = <500000000 600000000 700000000 800000000 900000000 1000000000 1100000000 1200000000>;
> +	clock-latency = <200000>;
> +
> +	..
> +
> +        cores {
> +		..
> +        };
> +};

This binding makes no sense to me. It needs to be substantially better
documented, not just a couple of sentences that people that understand
bit.LITTLE thoroughly can make sense of.

It also duplicates the cpu binding. I suspect this should instead be done
through additions of the cpu bindings instead of duplication. So this needs to
be substantially reworked.


-Olof
