Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaHTQmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:42:42 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:55651 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaHTQml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:42:41 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 19/19] Documentation: ACPI for ARM64
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi-private@linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
In-Reply-To: <1406206825-15590-20-git-send-email-hanjun.guo@linaro.org>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
	<1406206825-15590-20-git-send-email-hanjun.guo@linaro.org>
Date: Wed, 20 Aug 2014 11:42:27 -0500
Message-Id: <20140820164227.E0F4BC41204@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2014 21:00:25 +0800, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> +Clocks
> +------
> +
> +Like clocks that are part of the power resources there is no standard way
> +to represent a clock tree in ACPI 5.1 in a similar manner to how it is
> +described in DT.
> +
> +Devices affected by this include things like UARTs, SoC driven LCD displays,
> +etc.
> +
> +The firmware for example UEFI should initialise these clocks to fixed working
> +values before the kernel is executed. If a driver requires to know rates of
> +clocks set by firmware then they can be passed to kernel using _DSD.
> +
> +example :-
> +
> +Device (CLK0) {
> +	...
> +
> +	Name (_DSD, Package() {
> +		ToUUID("XXXXX"),
> +		Package() {
> +			Package(2) {"#clock-cells", 0},
> +			Package(2) {"clock-frequency", "10000"}
> +		}
> +	})
> +
> +	...
> +}
> +
> +Device (USR1) {
> +	...
> +
> +	Name (_DSD, Package() {
> +		ToUUID("XXXXX"),
> +		Package() {
> +			Package(2) {"clocks", Package() {1, ^CLK0}}},
> +		}
> +	})
> +
> +	...
> +}

Really? This looks wrong. The above example goes right back to
conceptually putting the clock tree into ACPI. I would expect the ACPI
way to expose current clock rate to an individual device driver is to
expose a clock rate method that internally knows how to return the
currently set rate.

g.

