Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaIDNe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 09:34:57 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:58473 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaIDNe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:34:56 -0400
Message-ID: <54086A77.6050708@collabora.com>
Date: Thu, 04 Sep 2014 15:34:47 +0200
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>
CC: Stephen Warren <swarren@wwwdotorg.org>, Tomasz Figa <t.figa@samsung.com>,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        rabin@rab.in, Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 4/7] clk: use struct clk only for external API
References: <1409585377-26091-1-git-send-email-tomeu.vizoso@collabora.com> <1409585675-26894-1-git-send-email-tomeu.vizoso@collabora.com> <5407A82B.7000602@codeaurora.org>
In-Reply-To: <5407A82B.7000602@codeaurora.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 01:45 AM, Stephen Boyd wrote:
> On 09/01/14 08:34, Tomeu Vizoso wrote:
> 
>>
>> NOTE: with this patch, clk_get_parent() behaves like clk_get(), i.e. it
>> needs to be matched with a clk_put().  Otherwise, memory will leak.
>>
> [...]
>>  }
>> +EXPORT_SYMBOL_GPL(clk_provider_get_parent);
>> +
>> +/**
>> + * clk_get_parent - return the parent of a clk
>> + * @clk_user: the clk whose parent gets returned
>> + *
>> + * Simply returns clk->parent.  Returns NULL if clk is NULL.
> 
> We should at least document here that clk_put() is expected to be called
> when it's not being used.

Good point.

> I wonder why it's this way though. Why can't
> every clk_core have a private clk pointer to it's parent that's created
> during registration time? Then we just hand that out for
> clk_get_parent() and destroy it when the clk_core is freed?

Well, that wouldn't be a per-user clock any more, right? I see though
how it would be desirable not to burden the caller with having to free
the per-user clk.

Thanks,

Tomeu
