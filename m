Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab3BKVXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 16:23:49 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:40496 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605Ab3BKVXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 16:23:48 -0500
Message-ID: <51196161.7020901@wwwdotorg.org>
Date: Mon, 11 Feb 2013 14:23:45 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Laurent Meunier <laurent.meunier@st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl/pinconfig: add debug interface
References: <1360527070-18430-1-git-send-email-linus.walleij@stericsson.com> <51195A63.7080706@wwwdotorg.org> <20130211210041.GW4801@atomide.com> <51195F00.4020309@wwwdotorg.org> <20130211212105.GX4801@atomide.com>
In-Reply-To: <20130211212105.GX4801@atomide.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 02:21 PM, Tony Lindgren wrote:
> * Stephen Warren <swarren@wwwdotorg.org> [130211 13:17]:
>> On 02/11/2013 02:00 PM, Tony Lindgren wrote:
>>> * Stephen Warren <swarren@wwwdotorg.org> [130211 12:57]:
>>>> On 02/10/2013 01:11 PM, Linus Walleij wrote:
>>>>> From: Laurent Meunier <laurent.meunier@st.com>
>>>>>
>>>>> This update adds a debugfs interface to modify a pin configuration
>>>>> for a given state in the pinctrl map. This allows to modify the
>>>>> configuration for a non-active state, typically sleep state.
>>>>> This configuration is not applied right away, but only when the state
>>>>> will be entered.
>>>>>
>>>>> This solution is mandated for us by HW validation: in order
>>>>> to test and verify several pin configurations during sleep without
>>>>> recompiling the software.
>>>>
>>>> I never understood why HW engineers can't just recompile the kernel.
>>>> Besides, it's just a device tree change these days - no recompile even
>>>> required, right?
>>>
>>> Typically when bringing up a new board you do not have the driver
>>> specific mux settings verified. For developers, it's easiest to tweak
>>> the muxing during runtime do the drivers as a loadable module, then
>>> export the verified mux configuration into a .dts file.
>>
>> Well HW engineers typically just write to the HW registers directly
>> rather than screwing around with the Linux pinctrl tables and
>> unloading/reloading drivers.
> 
> I've seen cases where most of the mux register configuration are
> done correctly by HW engineers.. But there's always been some pieces
> of the pin configuration wrong initially and that needs to be fixed by
> the driver people to get things working.
> 
> Being able to set the mux configuration via debugfs is also very
> useful for the case of adding external devices to your proto boards
> like beagle etc.

This patch won't work for that, since it doesn't support adding new
entries to the mux table, just editing existing entries.

