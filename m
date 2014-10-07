Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbaJGSn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 14:43:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36363 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020AbaJGSnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 14:43:23 -0400
Message-ID: <54343449.1020605@codeaurora.org>
Date: Tue, 07 Oct 2014 11:43:21 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Paul Walmsley <paul@pwsan.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH 1/2] clk: Make clk API return per-user struct clk instances
References: <1412255097-15928-1-git-send-email-tomeu.vizoso@collabora.com> <1412255097-15928-2-git-send-email-tomeu.vizoso@collabora.com> <20141003231515.GM10233@codeaurora.org> <CAAObsKD6=xRqR9m8dNATUAuiky-HZW4LHJtnG1BbpO8dsBBJPg@mail.gmail.com>
In-Reply-To: <CAAObsKD6=xRqR9m8dNATUAuiky-HZW4LHJtnG1BbpO8dsBBJPg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 08:28 AM, Tomeu Vizoso wrote:
> On 4 October 2014 01:15, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> On 10/02, Tomeu Vizoso wrote:
>>> +
>>>   #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
>> These ifdefs look useless.
>>
>>>   struct clk *of_clk_get_by_clkspec(struct of_phandle_args *clkspec);
>>>   struct clk *__of_clk_get_from_provider(struct of_phandle_args *clkspec);
>>>   void of_clk_lock(void);
>>>   void of_clk_unlock(void);
>>>   #endif
>>> +
>>> +#if defined(CONFIG_COMMON_CLK)
>> So we shouldn't need this one either.
> Actually, i had to put it back so clkdev.c builds on
> !CONFIG_COMMON_CLK. Do you have another idea on how to deal with this?

What's the error? Probably need to add a forward declaration for struct 
clk, struct of_phandle_args, and struct clk_hw.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

