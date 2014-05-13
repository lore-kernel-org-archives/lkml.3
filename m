Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbaEMPml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:42:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38795 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbaEMPmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:42:36 -0400
Message-ID: <53723D68.6010808@wwwdotorg.org>
Date: Tue, 13 May 2014 09:42:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: FanWu <fwu@marvell.com>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        Chao Xie <cxie4@marvell.com>, Yilu Mao <ylmao@marvell.com>,
        Ning Jiang <njiang1@marvell.com>, Xiaofan Tian <tianxf@marvell.com>,
        Fangsuo Wu <fswu@marvell.com>
Subject: Re: [Pinctrl] A suggestion to avoid duplicated enabling operation
 on a pin's setting
References: <534B558A.3040504@marvell.com> <534F8B35.7090103@marvell.com> <5366F387.4060402@marvell.com> <5367CD62.7030205@wwwdotorg.org> <5369E891.2020309@marvell.com> <53712D10.40003@wwwdotorg.org> <5371B36E.5030309@marvell.com>
In-Reply-To: <5371B36E.5030309@marvell.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 11:53 PM, FanWu wrote:
...
> About the glitch I mentioned before, I want to make myself clear.
> If there is a case like the following one:
> pinctrl-0 = <&a_grp_settingA>;
> pinctrl-1 = <&a_grp_settingB>;
> "a_grp_settingA" and "a_grp_settingB" are used to described the same
> Pin's different mux and function configuration
> In my understanding,
> When there is a need to switch Pin group state, the current code will
> disable "a_grp_settingA" first ahead of enabling "a_grp_settingB", right ?

Yes.

> Do you mean the case I mentioned will not be a glitch ?

I guess you're talking about that:

>> In the original code, the Pin setting will be changed to the
>> disabled/safe state when Pin state is switched if the old setting is not
>> existed in new state rather than directly switched to the new Pin
>> setting. Also a possible glitch?

Yes, in this case, there is no glitch. However, there is certainly a
change in HW configuration. A glitch is a temporary short-term
accidental change in output value or configuration. In the case quoted
immediately above, the change is permanent - at least until some other
state is activated later. Hence, there is no glitch. However, there
certainly is a change in HW configuration, and that could be just as
problematic, depending on the HW and exact pin configuration.
