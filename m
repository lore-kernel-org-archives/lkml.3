Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbaFBM4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:56:54 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:65480 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbaFBM4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:56:51 -0400
Message-ID: <538C7484.9070801@gmail.com>
Date: Mon, 02 Jun 2014 14:56:36 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
CC: linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/7] ARM: EXYNOS: add support for firmware-assisted
 c15resume
References: <1401712543-14281-1-git-send-email-b.zolnierkie@samsung.com> <1401712543-14281-3-git-send-email-b.zolnierkie@samsung.com>
In-Reply-To: <1401712543-14281-3-git-send-email-b.zolnierkie@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02.06.2014 14:35, Bartlomiej Zolnierkiewicz wrote:
> From: Tomasz Figa <t.figa@samsung.com>
> 
> This change is a preparation for adding secure firmware support to
> EXYNOS cpuidle driver.
> 
> This patch shouldn't cause any functionality changes.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> [bzolnier: splitted out from bigger patch]
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
>  arch/arm/include/asm/firmware.h | 4 ++++
>  arch/arm/mach-exynos/firmware.c | 8 ++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/arch/arm/include/asm/firmware.h b/arch/arm/include/asm/firmware.h
> index c72ec47..70883c7 100644
> --- a/arch/arm/include/asm/firmware.h
> +++ b/arch/arm/include/asm/firmware.h
> @@ -41,6 +41,10 @@ struct firmware_ops {
>  	 * Initializes L2 cache
>  	 */
>  	int (*l2x0_init)(void);
> +	/*
> +	 * Restores coprocessor 15 registers
> +	 */
> +	int (*c15resume)(u32 *regs);

Well, this was just a kind of internal hack, so I'm not sure this is
suitable as a generic firmware operation in mainline.

I'd rather implement this as a part of a wider suspend and resume
firmware operations, where suspend would save values of cp15 registers
and resume would restore them.

Best regards,
Tomasz
