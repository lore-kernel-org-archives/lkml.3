Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbaJGP3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:29:18 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:44146 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbaJGP3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:29:16 -0400
MIME-Version: 1.0
In-Reply-To: <20141003231515.GM10233@codeaurora.org>
References: <1412255097-15928-1-git-send-email-tomeu.vizoso@collabora.com>
 <1412255097-15928-2-git-send-email-tomeu.vizoso@collabora.com> <20141003231515.GM10233@codeaurora.org>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Tue, 7 Oct 2014 17:28:55 +0200
X-Google-Sender-Auth: oQ0UcyJxAMlL9HrwTA-XZKu1c-M
Message-ID: <CAAObsKD6=xRqR9m8dNATUAuiky-HZW4LHJtnG1BbpO8dsBBJPg@mail.gmail.com>
Subject: Re: [PATCH 1/2] clk: Make clk API return per-user struct clk instances
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Paul Walmsley <paul@pwsan.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 October 2014 01:15, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 10/02, Tomeu Vizoso wrote:
>> +
>>  #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
>
> These ifdefs look useless.
>
>>  struct clk *of_clk_get_by_clkspec(struct of_phandle_args *clkspec);
>>  struct clk *__of_clk_get_from_provider(struct of_phandle_args *clkspec);
>>  void of_clk_lock(void);
>>  void of_clk_unlock(void);
>>  #endif
>> +
>> +#if defined(CONFIG_COMMON_CLK)
>
> So we shouldn't need this one either.

Actually, i had to put it back so clkdev.c builds on
!CONFIG_COMMON_CLK. Do you have another idea on how to deal with this?

Sorry, but I forgot to CC you on v2 (just sent):
https://lkml.org/lkml/2014/10/7/430

Thanks,

Tomeu
