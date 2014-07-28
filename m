Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaG1NlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:41:12 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:51690 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbaG1NlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:41:08 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH/RFC v4 07/21] of: add of_node_ncmp wrapper
To: Jacek Anaszewski <j.anaszewski@samsung.com>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Simek <monstr@monstr.eu>
In-Reply-To: <1405087464-13762-8-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
	<1405087464-13762-8-git-send-email-j.anaszewski@samsung.com>
Date: Mon, 28 Jul 2014 07:41:00 -0600
Message-Id: <20140728134100.86C07C408A9@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014 16:04:10 +0200, Jacek Anaszewski <j.anaszewski@samsung.com> wrote:
> The wrapper for strnicmp is required for checking whether a node has
> expected prefix.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Michal Simek <monstr@monstr.eu>
> ---
>  include/linux/of.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 692b56c..9a53eea 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -199,6 +199,7 @@ static inline unsigned long of_read_ulong(const __be32 *cell, int size)
>  #define of_compat_cmp(s1, s2, l)	strcasecmp((s1), (s2))
>  #define of_prop_cmp(s1, s2)		strcmp((s1), (s2))
>  #define of_node_cmp(s1, s2)		strcasecmp((s1), (s2))
> +#define of_node_ncmp(s1, s2, n)		strnicmp((s1), (s2), (n))
>  #endif

Don't forget to add an of_node_ncmp() define to
arch/sparc/include/asm/prom.h. Sparc has its own rules.

g.

