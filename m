Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3ISUth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 16:49:37 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54555 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab3ISUtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 16:49:35 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>, gnurou@gmail.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 1/5] ARM: add basic support for Trusted Foundations
References: <1379238028-7960-1-git-send-email-acourbot@nvidia.com>
	<1379238028-7960-2-git-send-email-acourbot@nvidia.com>
Date: Thu, 19 Sep 2013 13:49:31 -0700
In-Reply-To: <1379238028-7960-2-git-send-email-acourbot@nvidia.com> (Alexandre
	Courbot's message of "Sun, 15 Sep 2013 18:40:24 +0900")
Message-ID: <87d2o4edus.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Courbot <acourbot@nvidia.com> writes:

> Trusted Foundations is a TrustZone-based secure monitor for ARM that
> can be invoked using the same SMC-based API on all supported
> platforms. This patch adds initial basic support for Trusted
> Foundations using the ARM firmware API. Current features are limited
> to the ability to boot secondary processors.

[...]

> +#if IS_ENABLED(CONFIG_OF)
> +void of_register_trusted_foundations(void)
> +{
> +	struct device_node *node;
> +	struct trusted_foundations_platform_data pdata;
> +	int err;
> +
> +	node = of_find_compatible_node(NULL, NULL, "tl,trusted-foundations");
> +	if (!node)
> +		return;
> +
> +	err = of_property_read_u32(node, "version-major", &pdata.version_major);
> +	if (err != 0)
> +		panic("Trusted Foundation: missing version-major property\n");

Do really need to panic() the whole kernel for a missing property?
Surely this can more gracefully recover, or assume some defaults?  

Same comment for the other uses of panic() in this patch.

Kevin

