Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab3HEP0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 11:26:40 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:56528 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab3HEP0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 11:26:38 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH] ARM: fix wrong address when loading PRM_FRAC_INCREMENTOR_DENUMERATOR_RELOAD
From: Chen Baozi <baozich@gmail.com>
In-Reply-To: <1375356474-24203-1-git-send-email-baozich@gmail.com>
Date: Mon, 5 Aug 2013 23:26:28 +0800
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <C635EF21-CD18-4633-AA39-16209F8EE231@gmail.com>
References: <1375356474-24203-1-git-send-email-baozich@gmail.com>
To: Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping?

On Aug 1, 2013, at 7:27 PM, Chen Baozi <baozich@gmail.com> wrote:

> The denominator should be load from INCREMENTOR_DENUMERATOR_RELOAD_OFFSET
> rather than INCREMENTER_NUMERATOR_OFFSET.
> 
> Signed-off-by: Chen Baozi <baozich@gmail.com>
> ---
> arch/arm/mach-omap2/timer.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> index b37e1fc..9265e03 100644
> --- a/arch/arm/mach-omap2/timer.c
> +++ b/arch/arm/mach-omap2/timer.c
> @@ -537,7 +537,7 @@ static void __init realtime_counter_init(void)
> 	reg |= num;
> 	__raw_writel(reg, base + INCREMENTER_NUMERATOR_OFFSET);
> 
> -	reg = __raw_readl(base + INCREMENTER_NUMERATOR_OFFSET) &
> +	reg = __raw_readl(base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET) &
> 			NUMERATOR_DENUMERATOR_MASK;
> 	reg |= den;
> 	__raw_writel(reg, base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET);
> -- 
> 1.8.1.4
> 

