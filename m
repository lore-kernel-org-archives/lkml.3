Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab3GYMzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 08:55:21 -0400
Received: from multi.imgtec.com ([194.200.65.239]:21411 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755526Ab3GYMzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 08:55:17 -0400
Message-ID: <51F1202D.9060403@imgtec.com>
Date: Thu, 25 Jul 2013 13:55:09 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Chao Xie <xiechao.mail@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v5 4/5] clk: add CLK_SET_RATE_NO_REPARENT flag
References: <1371139562-305-1-git-send-email-james.hogan@imgtec.com> <1371139562-305-5-git-send-email-james.hogan@imgtec.com> <51F11B46.7010900@samsung.com>
In-Reply-To: <51F11B46.7010900@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_07_25_13_55_10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester

On 25/07/13 13:34, Sylwester Nawrocki wrote:
> On 06/13/2013 06:06 PM, James Hogan wrote:
>> Add a CLK_SET_RATE_NO_REPARENT clock flag, which will prevent muxes
>> being reparented during clk_set_rate.
>>
>> To avoid breaking existing platforms, all callers of clk_register_mux()
>> are adjusted to pass the new flag. Platform maintainers are encouraged
>> to remove the flag if they wish to allow mux reparenting on set_rate.
> [..]
>> Changes in v3:
>>
>> * rename/invert CLK_SET_RATE_REMUX to CLK_SET_RATE_NO_REPARENT and move
>>   to this new patch.
>> * patch 3: add CLK_SET_RATE_NO_REPARENT flag to all callers of
>>   clk_register_mux. If you don't mind your clocks being reparented in
>>   response to set_rate please let me know and I'll drop the relevant
>>   portion of the patch.
> 
> Why is this better to change current behaviour of the clock core
> and modify all drivers instead of having, e.g. CLK_SET_RATE_REPARENT
> set in drivers of hardware that supports clock re-parenting while
> setting clock rate ?

See this message from Mike Turquette which first suggested it:

http://marc.info/?l=linux-kernel&m=136847508109344&w=2

> Is there intention to just have the automatic clock re-parenting
> as a default feature in the common clock API ?

Yes, that would be the result (except where explicitly disallowed).
Unfortunately where such policy should ideally be defined is still up in
the air.

It's not a property of the hardware, but then it is arguably a property
of the environment the bootloader has configured (like the stuff in the
/chosen device tree node).

Presuming that the usual reason not to reparent a mux is because other
important clocks depend on it, the kernel might know enough to work out
whether it's safe (unless of course there are other cores/threads in the
SoC using the clock that Linux isn't aware of, which brings us back to
it being a bootloader environment thing).

> My apologies if this has already been answered, I haven't been
> following this thread.

No problem :)

Cheers
James

