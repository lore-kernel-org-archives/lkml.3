Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760496Ab3ICSk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 14:40:26 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47998 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594Ab3ICSkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 14:40:24 -0400
Message-ID: <52262D14.4000907@wwwdotorg.org>
Date: Tue, 03 Sep 2013 12:40:20 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>,
        gnurou@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/5] ARM: add basic Trusted Foundations support
References: <1377770268-14014-1-git-send-email-acourbot@nvidia.com> <1377770268-14014-2-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1377770268-14014-2-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 03:57 AM, Alexandre Courbot wrote:
> Trusted Foundations is a TrustZone-based secure monitor for ARM that
> can be invoked  using a consistent smc-based API on all supported

Nit: s/smc/SMC/?

> diff --git a/arch/arm/include/asm/trusted_foundations.h b/arch/arm/include/asm/trusted_foundations.h

> +#if IS_ENABLED(CONFIG_TRUSTED_FOUNDATIONS)
> +
> +void register_trusted_foundations(struct trusted_foundations_platform_data *pd);
> +void of_register_trusted_foundations(void);
> +
> +#else
> +
> +static inline void register_trusted_foundations(
> +				   struct trusted_foundations_platform_data *pd)
> +{
> +	pr_crit("No support for Trusted Foundations, stopping...\n");
> +	BUG();
> +}
> +
> +static inline void of_register_trusted_foundations(void)
> +{
> +	register_trusted_foundations(NULL);

That will cause a hard-fail. I assume that should only happen if the TL
DT node is present; if there's no DT node, it's fine for a kernel
without any TL support to run.

> +}
> +
> +#endif /* IS_ENABLED(CONFIG_TRUSTED_FOUNDATIONS) */

