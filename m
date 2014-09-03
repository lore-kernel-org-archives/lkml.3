Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934656AbaICXpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:45:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35906 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933336AbaICXps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 19:45:48 -0400
Message-ID: <5407A82B.7000602@codeaurora.org>
Date: Wed, 03 Sep 2014 16:45:47 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Stephen Warren <swarren@wwwdotorg.org>, Tomasz Figa <t.figa@samsung.com>,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        rabin@rab.in, Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 4/7] clk: use struct clk only for external API
References: <1409585377-26091-1-git-send-email-tomeu.vizoso@collabora.com> <1409585675-26894-1-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1409585675-26894-1-git-send-email-tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/14 08:34, Tomeu Vizoso wrote:

>
> NOTE: with this patch, clk_get_parent() behaves like clk_get(), i.e. it
> needs to be matched with a clk_put().  Otherwise, memory will leak.
>
[...]
>  }
> +EXPORT_SYMBOL_GPL(clk_provider_get_parent);
> +
> +/**
> + * clk_get_parent - return the parent of a clk
> + * @clk_user: the clk whose parent gets returned
> + *
> + * Simply returns clk->parent.  Returns NULL if clk is NULL.

We should at least document here that clk_put() is expected to be called
when it's not being used. I wonder why it's this way though. Why can't
every clk_core have a private clk pointer to it's parent that's created
during registration time? Then we just hand that out for
clk_get_parent() and destroy it when the clk_core is freed?

> + */
> +struct clk *clk_get_parent(struct clk *clk_user)
> +{
> +	struct clk_core *clk;
> +	struct clk_core *parent;
> +
> +	if (!clk_user)
> +		return NULL;
> +
> +	clk = clk_to_clk_core(clk_user);
> +	parent = clk_provider_get_parent(clk);
> +
> +	return __clk_create_clk(parent);
> +}
>  EXPORT_SYMBOL_GPL(clk_get_parent);
>  

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

