Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3JAVoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:44:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51657 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab3JAVoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:44:07 -0400
Message-ID: <524B4220.1070209@wwwdotorg.org>
Date: Tue, 01 Oct 2013 15:44:00 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
CC: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Naour Romain <romain.naour@openwide.fr>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Tarek Dakhran <t.dakhran@samsung.com>
Subject: Re: [PATCH 2/6] clk: exynos5410: register clocks using common clock
 framework
References: <1380644227-12244-1-git-send-email-v.tyrtov@samsung.com> <1380644227-12244-3-git-send-email-v.tyrtov@samsung.com>
In-Reply-To: <1380644227-12244-3-git-send-email-v.tyrtov@samsung.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 10:17 AM, Vyacheslav Tyrtov wrote:
> From: Tarek Dakhran <t.dakhran@samsung.com>
> 
> The EXYNOS5410 clocks are statically listed and registered
> using the Samsung specific common clock helper functions.

> diff --git a/Documentation/devicetree/bindings/clock/exynos5410-clock.txt b/Documentation/devicetree/bindings/clock/exynos5410-clock.txt

> +       [Core Clocks]
> +  [Clock Gate for Special Clocks]
> +   [Peripheral Clock Gates]

These headers/titles for the sections/lists aren't consistently aligned.

> +  [Clock Gate for Special Clocks]
> +
> +  Clock			ID
> +  ----------------------------
> +  sclk_uart0		128
> +  sclk_uart1		129
> +  sclk_uart2		130
> +  sclk_uart3		131
> +  sclk_mmc0		132
> +  sclk_mmc1		133
> +  sclk_mmc2		134
> +
> +   [Peripheral Clock Gates]
> +
> +  Clock			ID
> +  ----------------------------
> +
> +  uart0			257
> +  uart1			258
> +  uart2			259
> +  uart3			260
> +  mct			315
> +  mmc0			351
> +  mmc1			352
> +  mmc2			353

That's not many clocks. I assume you're planning on adding more IDs
later, in a backwards-compatible fashion? I suppose that's OK since it
won't break any existing usage, as long as there's no need to renumber
any existing values.

On that topic, are any of those clock IDs derived from HW, e.g. register
numbers, or bit numbers in an array of registers? Numbering clocks in a
HW-derived fashion would make it easier or more obvious how to add new
clock IDs later while maintaining some consistency and without
introducing the desire to break any ABI.

Finally, how about creating a header file such as
include/dt-bindings/clock/exynos5410.h to define those clock IDs, so
that both *.dts and the clock driver can share the values without having
to manually write them?

