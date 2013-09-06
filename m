Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab3IFT3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 15:29:39 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48943 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab3IFT3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 15:29:35 -0400
Message-ID: <522A2D1B.3010508@wwwdotorg.org>
Date: Fri, 06 Sep 2013 13:29:31 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Tomasz Figa <t.figa@samsung.com>,
        Dave Martin <Dave.Martin@arm.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        gnurou@gmail.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 1/5] ARM: add basic Trusted Foundations support
References: <1378351680-14696-1-git-send-email-acourbot@nvidia.com> <1378351680-14696-2-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1378351680-14696-2-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 09:27 PM, Alexandre Courbot wrote:
> Trusted Foundations is a TrustZone-based secure monitor for ARM that
> can be invoked  using a consistent SMC-based API on all supported
> platforms. This patch adds initial basic support for Trusted
> Foundations using the ARM firmware API. Current features are limited
> to the ability to boot secondary processors.

> diff --git a/arch/arm/firmware/trusted_foundations.c b/arch/arm/firmware/trusted_foundations.c
...
> +void of_register_trusted_foundations(void)
> +{
> +	struct device_node *node;
> +	struct trusted_foundations_platform_data pdata;
> +	int err;
> +
> +	node = of_find_compatible_node(NULL, NULL, "tl,trusted-foundations");
> +
> +	if (!node)
> +		return;

If you're going to revise this patch for the comment below, then I would
suggest removing the blank line before that if statement.

> diff --git a/arch/arm/include/asm/trusted_foundations.h b/arch/arm/include/asm/trusted_foundations.h

Do we need to add the following here:

#if !IS_ENABLED(CONFIG_OF)
static inline void register_trusted_foundations(...) {}
#endif

So that there is a dummy no-op function for the non-DT-support case? I
guess Tegra always has CONFIG_OF enabled so that call from
mach-tegra/common.c in patch 2 will never be an issue, but perhaps it
might if anyone else uses this?
