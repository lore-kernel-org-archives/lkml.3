Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbaKSO4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:56:16 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:39947 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbaKSO4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:56:15 -0500
MIME-Version: 1.0
In-Reply-To: <20141114070646.GA11808@codeaurora.org>
References: <1414666135-14313-1-git-send-email-tomeu.vizoso@collabora.com>
 <1414666135-14313-7-git-send-email-tomeu.vizoso@collabora.com> <20141114070646.GA11808@codeaurora.org>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Wed, 19 Nov 2014 15:55:53 +0100
X-Google-Sender-Auth: JEjv3NaCx1n_-g7o0eSw8HSBpLg
Message-ID: <CAAObsKAZAe6QqmtB8JKyGxJ=yH9XUuhN+NjTRFTEMM=y00XOvg@mail.gmail.com>
Subject: Re: [PATCH v5 6/7] clk: Make clk API return per-user struct clk instances
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 November 2014 08:06, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 10/30, Tomeu Vizoso wrote:
>> Moves clock state to struct clk_core, but takes care to change as little API as
>> possible.
>>
>> struct clk_hw still has a pointer to a struct clk, which is the
>> implementation's per-user clk instance, for backwards compatibility.
>>
>> The struct clk that clk_get_parent() returns isn't owned by the caller, but by
>> the clock implementation, so the former shouldn't call clk_put() on it.
>>
>> Because some boards in mach-omap2 still register clocks statically, their clock
>> registration had to be updated to take into account that the clock information
>> is stored in struct clk_core now.
>>
>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>
> It would be good to have Russell at least ack the clkdev bits.
> There's still more work to do in the future here, but
>
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

Thanks, Stephen.

Russell, do you think we could have your ack?

Regards,

Tomeu
