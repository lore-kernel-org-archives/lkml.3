Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbaEPTxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 15:53:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59530 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaEPTxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 15:53:15 -0400
Message-ID: <53766CA7.8000507@wwwdotorg.org>
Date: Fri, 16 May 2014 13:53:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>, FanWu <fwu@marvell.com>,
        ext Tony Lindgren <tony@atomide.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, Chao Xie <cxie4@marvell.com>,
        ylmao@marvell.com, njiang1@marvell.com, tianxf@marvell.com,
        fswu@marvell.com
Subject: Re: [PATCH] pinctrl: add params in disable_setting for different
 usage
References: <1400032874-3423-1-git-send-email-fwu@marvell.com> <CACRpkdaTX_SyWXrpysaJGLee+SnLPxdQQkvE-5Xy+OmHCcseVw@mail.gmail.com>
In-Reply-To: <CACRpkdaTX_SyWXrpysaJGLee+SnLPxdQQkvE-5Xy+OmHCcseVw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 10:21 AM, Linus Walleij wrote:
> On Wed, May 14, 2014 at 4:01 AM,  <fwu@marvell.com> wrote:
> 
>> From: Fan Wu <fwu@marvell.com>
>>
>> The patch added params in disable_setting to differ the two possible usage,
>> 1.Only want to disable the pin setting in SW aspect, param can be set to "0"
>> 2.Want to disable the pin setting in both HW and SW aspect, param can be set to "1";
>>
>> The reason why to do this is that:
>> To avoid duplicated enable_setting operation without disabling operation which will
>> let Pin's desc->mux_usecount keep being added.
>>
>> In the following case, the issue can be reproduced:
>> 1)There is a driver need to switch Pin state dynamicly, E.g. b/t "sleep" and
>> "default" state
>> 2)The Pin setting configuration in the two state is same, like the following one:
>> component a {
>>         pinctrl-names = "default", "sleep";
>>         pinctrl-0 = <&a_grp_setting &c_grp_setting>;
>>         pinctrl-1 = <&b_grp_setting &c_grp_setting>;
>> }
>> The "c_grp_setting" config node is totaly same, maybe like following one:
> 
> Hm this is a quite interesting thing if we can get it in place, but
> I need Stephen's consent, also Tony should have a look at this as
> I know he's had the same problem as you in pinctrl-single.

I only briefly looked at the patch, but it probably solves/hides the
immediate problem.

However, rather than doing this, why not just remove
pinmux_disable_setting() completely. It doesn't make sense to "disable a
mux selection" (some value is always selected in the mux register field)
any more than it does to "disable a drive strength selection". We don't
have a pinconf_disable_setting(), and couldn't really add one if we
wanted. For consistency, let's just remove pinmux_disable_setting(). Do
you agree?
