Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbaEWSYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:24:35 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:64444 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaEWSYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:24:33 -0400
Message-ID: <537F9267.7090304@cogentembedded.com>
Date: Fri, 23 May 2014 22:24:39 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>
CC: Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND] ARM: trusted_foundations: fix compile error on
 non-SMP
References: <1400804612-11876-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1400804612-11876-1-git-send-email-acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/23/2014 04:23 AM, Alexandre Courbot wrote:

> The setup_max_cpus variable is only defined if CONFIG_SMP is set. Add
> a preprocessor condition to avoid the following compilation error if
> CONFIG_SMP is not set:

>      arch/arm/include/asm/trusted_foundations.h: In function 'register_trusted_foundations':
>      arch/arm/include/asm/trusted_foundations.h:57:2: error: 'setup_max_cpus' undeclared (first use in this function)

> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
> Hi Stephen,

> This patch has been originally submitted through Russell's patch tracker,
> where it has stayed untouched for ~3 weeks now. Considering that this
> fixes a compilation error and should thus be made available quickly, and
> that Tegra is the only user of Trusted Foundations, would you agree to take
> it into your tree?

>   arch/arm/include/asm/trusted_foundations.h | 2 ++
>   1 file changed, 2 insertions(+)

> diff --git a/arch/arm/include/asm/trusted_foundations.h b/arch/arm/include/asm/trusted_foundations.h
> index b5f7705..624e1d4 100644
> --- a/arch/arm/include/asm/trusted_foundations.h
> +++ b/arch/arm/include/asm/trusted_foundations.h
> @@ -54,7 +54,9 @@ static inline void register_trusted_foundations(
>   	 */
>   	pr_err("No support for Trusted Foundations, continuing in degraded mode.\n");
>   	pr_err("Secondary processors as well as CPU PM will be disabled.\n");
> +#if IS_ENABLED(CONFIG_SMP)

	if (IS_ENABLED(CONFIG_SMP))

>   	setup_max_cpus = 0;
> +#endif

WBR, Sergei

