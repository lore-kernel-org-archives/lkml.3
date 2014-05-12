Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbaELUUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 16:20:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55629 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaELUUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 16:20:35 -0400
Message-ID: <53712D10.40003@wwwdotorg.org>
Date: Mon, 12 May 2014 14:20:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: FanWu <fwu@marvell.com>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        Chao Xie <cxie4@marvell.com>, Yilu Mao <ylmao@marvell.com>,
        Ning Jiang <njiang1@marvell.com>, Xiaofan Tian <tianxf@marvell.com>,
        Fangsuo Wu <fswu@marvell.com>
Subject: Re: [Pinctrl] A suggestion to avoid duplicated enabling operation
 on a pin's setting
References: <534B558A.3040504@marvell.com> <534F8B35.7090103@marvell.com> <5366F387.4060402@marvell.com> <5367CD62.7030205@wwwdotorg.org> <5369E891.2020309@marvell.com>
In-Reply-To: <5369E891.2020309@marvell.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 02:02 AM, FanWu wrote:
...
> I think the glitch you mentioned is indeed a problem for the vendors who
> define the "pinctrl-single,function-off" which will be activated when
> disabling setting.

"pinctrl-single,function-off" is one specific driver's way of
configuring what happens when a mux option is disabled. The issue
applies to all drivers that implement a mux option disable function.

...
> I considered my previous option 1 of avoiding duplicated calling
> enable_setting. If we want to avoid too much iteration in this solution,
> some mark variables need to be introduced, which may make code more
> complicated than the previous one.

Probably the best thing is to just remove the concept of "disable a mux
option". It doesn't make sense. All you can do with mux options is to
select some specific mux option. Disabling a mux option isn't something
that's logically possible. On some HW, perhaps you can do something
similar by tri-stating the pin or something, but that should be an
explicit part of the pinctrl state definition rather than an automatic
side-effect.

...
> Maybe another topic:
> In the original code, the Pin setting will be changed to the
> disabled/safe state when Pin state is switched if the old setting is not
> existed in new state rather than directly switched to the new Pin
> setting. Also a possible glitch?

That's not a glitch, since it's not a temporary state. The mux setting
starts out as configured by the old state, then switches one time to
whatever the disable function sets it to. After that, it won't switch
again, unless there's an explicit SW action to enable a new state.
