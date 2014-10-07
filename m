Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbaJGUbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 16:31:01 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:53276 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaJGUa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 16:30:59 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbi4iDwAF674vm+yogv0ocXV+Pv6tq06i5YSgsJMv_PAg@mail.gmail.com>
References: <1411514246-6163-1-git-send-email-dianders@chromium.org>
	<CACRpkdbQ_21BcaK9T8aTHoDdXQpb-6KKZwcJzJJdBK0ztcG=ww@mail.gmail.com>
	<CAD=FV=Xq5XtskHW8B2QcpSSh3apK9a+eBCg07cfPL3tFqXntWA@mail.gmail.com>
	<CACRpkdbi4iDwAF674vm+yogv0ocXV+Pv6tq06i5YSgsJMv_PAg@mail.gmail.com>
Date: Tue, 7 Oct 2014 13:30:58 -0700
X-Google-Sender-Auth: iTO6ntFTVwj6fFzgOZQDRqsPNjU
Message-ID: <CAD=FV=W=TE5o22NuhdaXr_H2Xg56hr0UcErM8BFt=Rh1JwxTuw@mail.gmail.com>
Subject: Re: [RFC PATCH] pwm: Add the concept of an "active" pinctrl
From: Doug Anderson <dianders@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, Mark Brown <broonie@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Chris Zhong <zyw@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>, Sonny Rao <sonnyrao@chromium.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Tue, Oct 7, 2014 at 6:15 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Sep 25, 2014 at 10:26 PM, Doug Anderson <dianders@chromium.org> wrote:
>> On Thu, Sep 25, 2014 at 12:31 AM, Linus Walleij
>> <linus.walleij@linaro.org> wrote:
>>> On Wed, Sep 24, 2014 at 1:17 AM, Doug Anderson <dianders@chromium.org> wrote:
>
>>> The device core will handle three states for you: "default", "sleep", "idle".
>>
>> Except it will handle only one state unless "CONFIG_PM" is defined,
>> right?  In other words "sleep" and "idle" totally don't exist in the
>> "!CONFIG_PM" case.
>
> Yes. Because the intent of these settings is usually to save power.
> So by disabling the PM config, you can test if the system works
> without PM. Even hairy stuff like power-related pin control. It has
> this nice orthogonal debug feature to it...
>
>> Normally it should be considered "safe" (though high power)
>> to disable CONFIG_PM, right?
>
> Yeah. If your usecase makes it unsafe to have just "default",
> you should not rely on these state names but invent new ones.

I thought about it a bit more and I decided that a new state made the
most sense.  I put another RFC up there at
<https://patchwork.kernel.org/patch/5049041/>.  Feel free to have a
look at it.

-Doug
