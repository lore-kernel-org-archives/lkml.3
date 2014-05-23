Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaEWOKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:10:23 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:36048 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaEWOKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:10:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140521225226.GE14520@atomide.com>
References: <1400032874-3423-1-git-send-email-fwu@marvell.com>
	<CACRpkdaTX_SyWXrpysaJGLee+SnLPxdQQkvE-5Xy+OmHCcseVw@mail.gmail.com>
	<53766CA7.8000507@wwwdotorg.org>
	<53797279.1010109@marvell.com>
	<537A6FB5.80905@wwwdotorg.org>
	<537AC661.7010400@marvell.com>
	<537BA20A.3080109@wwwdotorg.org>
	<537C4605.2090203@marvell.com>
	<20140521225226.GE14520@atomide.com>
Date: Fri, 23 May 2014 16:10:21 +0200
Message-ID: <CACRpkdbEQZ0-pnjmPgHBGCK=CwuyL=eQPueSKP9t6PEn=jbLHQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: add params in disable_setting for different usage
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: FanWu <fwu@marvell.com>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, Chao Xie <cxie4@marvell.com>,
        Yilu Mao <ylmao@marvell.com>, Ning Jiang <njiang1@marvell.com>,
        Xiaofan Tian <tianxf@marvell.com>, Fangsuo Wu <fswu@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 12:52 AM, Tony Lindgren <tony@atomide.com> wrote:
> * FanWu <fwu@marvell.com> [140520 23:23]:
>> To remove the HW disable function in pinmux_disable_setting is no effect for
>> our SoC platform. I am just not sure whether it has effect for other
>> platform just as I described before.
>> If there is no vendor using the HW disabling operation, I also agree to
>> remove this. :)
>>
>> Could you please give your suggestion about this topic ?
>
> I agree with Stephen that we should remove the disable as at least
> for the SoCs that I've dealt with there is no disable setting. The
> closest I can think of is the safe mode that some omaps have, but
> that too is just one mode. And disabling input logic can be done
> separately from the mux mode typically.

It seems you are right: we should move the pins between different
states and there is really no "disabled" state.

I mean the pin can be tri-stated with pin config but that is not
strictly a mux option, the pin does not fall off the chip package :-P

So we should:
(A) make the disable hook optional
(B) remove the callback from all drivers not really using it
(C) investigate any remaining cases as they are probably
  doing something wrong

Yours,
Linus Walleij
