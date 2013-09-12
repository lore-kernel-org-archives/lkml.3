Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab3ILGWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:22:07 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49992 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab3ILGWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:22:05 -0400
Message-ID: <52315D84.10703@gmail.com>
Date: Thu, 12 Sep 2013 08:21:56 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130827 Icedove/17.0.8
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Stephen Warren <swarren@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH RFC v2 13/16] ARM: tegra: split tegra_pmc_init() in two
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1377638890-371-14-git-send-email-sebastian.hesselbarth@gmail.com> <5230CAF7.6010103@wwwdotorg.org>
In-Reply-To: <5230CAF7.6010103@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 09:56 PM, Stephen Warren wrote:
> On 08/27/2013 03:28 PM, Sebastian Hesselbarth wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> Tegra's board file currently initializes clocks much earlier than those
>> for most other ARM SoCs. The reason is:
>>
>> * The PMC HW block is involved in the path of some interrupts (i.e. it
>> inverts, or not, the IRQ input pin dedicated to the PMIC).
>>
>> * So, that part of the PMC must be initialized early so that the IRQ
>> polarity is correct.
>>
>> * The PMC initialization is currently monolithic, and the PMC has some
>> clock inputs, so the init routine ends up calling of_clk_get_by_name(),
>> and hence clocks must be set up early too.
>>
>> In order to defer clock initialization to the more typical location,
>> split out the portions of tegra_pmc_init() that are truly IRQ-related
>> into a separate tegra_pmc_init_irq(), which can be called from the
>> machine descriptor's .init_irq() function, and defer the rest until
>> the machine descriptor's .init_machine() function. With arch/arm calling
>> of_clk_init(NULL) from time_init() this also allows the removal of
>> .init_time() hook.
>
> Sebastian, I assume you're targeting v3.13 or later for this patch
> series? If so, it might be a good idea if I apply this patch myself to
> the Tegra tree so that I can base any future Tegra patches on top of it
> to avoid any possible conflicts. I can put this patch first in the
> cleanup branch so you can merge it into whatever tree you use for the
> rest of this series. Does that work for you? If so, let me know. Thanks.

Yes, I was waiting for v3.12-rc1 to drop to have something stable with
the new machs inside. I haven't made up my mind who will finally take
the patches but I guess it's either arm-soc or each individual
maintainer.

Currently, the patch set includes your original patch and another one to
remove .init_time when the arch-wide default callback is available. If
you want to take it now, I can add the corresponding dependency to the
cover letter and drop the patch from my set.

If Arnd, Olof, and Mike say that current mainline head is stable with
respect to arm-soc and clk, I can also send it today or tomorrow.

Sebastian
