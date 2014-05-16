Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbaEPQVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:21:35 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:47169 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757846AbaEPQVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:21:33 -0400
MIME-Version: 1.0
In-Reply-To: <1400032874-3423-1-git-send-email-fwu@marvell.com>
References: <1400032874-3423-1-git-send-email-fwu@marvell.com>
Date: Fri, 16 May 2014 18:21:33 +0200
Message-ID: <CACRpkdaTX_SyWXrpysaJGLee+SnLPxdQQkvE-5Xy+OmHCcseVw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: add params in disable_setting for different usage
From: Linus Walleij <linus.walleij@linaro.org>
To: FanWu <fwu@marvell.com>, ext Tony Lindgren <tony@atomide.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, Chao Xie <cxie4@marvell.com>,
        ylmao@marvell.com, njiang1@marvell.com, tianxf@marvell.com,
        fswu@marvell.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 4:01 AM,  <fwu@marvell.com> wrote:

> From: Fan Wu <fwu@marvell.com>
>
> The patch added params in disable_setting to differ the two possible usage,
> 1.Only want to disable the pin setting in SW aspect, param can be set to "0"
> 2.Want to disable the pin setting in both HW and SW aspect, param can be set to "1";
>
> The reason why to do this is that:
> To avoid duplicated enable_setting operation without disabling operation which will
> let Pin's desc->mux_usecount keep being added.
>
> In the following case, the issue can be reproduced:
> 1)There is a driver need to switch Pin state dynamicly, E.g. b/t "sleep" and
> "default" state
> 2)The Pin setting configuration in the two state is same, like the following one:
> component a {
>         pinctrl-names = "default", "sleep";
>         pinctrl-0 = <&a_grp_setting &c_grp_setting>;
>         pinctrl-1 = <&b_grp_setting &c_grp_setting>;
> }
> The "c_grp_setting" config node is totaly same, maybe like following one:

Hm this is a quite interesting thing if we can get it in place, but
I need Stephen's consent, also Tony should have a look at this as
I know he's had the same problem as you in pinctrl-single.

Yours,
Linus Walleij
