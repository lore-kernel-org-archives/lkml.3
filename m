Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab3IES3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 14:29:37 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:65474 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab3IES3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 14:29:35 -0400
MIME-Version: 1.0
In-Reply-To: <52277DBF.7080104@wwwdotorg.org>
References: <1377150793-27864-1-git-send-email-mturquette@linaro.org>
 <1377150793-27864-4-git-send-email-mturquette@linaro.org> <2A930389-012E-45C3-93EB-6B4A41DB2EF5@codeaurora.org>
 <20130829011425.8231.78802@quantum> <39BAF1F8-41AD-4667-BF76-22BDF709415A@codeaurora.org>
 <20130830203334.10934.10011@quantum> <522110AA.7040700@wwwdotorg.org>
 <20130903232219.10934.67434@quantum> <52277DBF.7080104@wwwdotorg.org>
From: Mike Turquette <mturquette@linaro.org>
Date: Thu, 5 Sep 2013 11:29:14 -0700
Message-ID: <CAPtuhThWHP61FzDBCH5SSFx6kV7==VdF3-M=Lke+cgnrOQL7JQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] clk: dt: binding for basic multiplexer clock
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Matt Sealey <neko@bakuhatsu.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 11:36 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 09/03/2013 05:22 PM, Mike Turquette wrote:
>> Quoting Stephen Warren (2013-08-30 14:37:46)
>>> On 08/30/2013 02:33 PM, Mike Turquette wrote:
> ...
>>>> The clock _data_ seems to always have some churn to it. Moving it out to
>>>> DT reduces that churn from Linux. My concern above is not about kernel
>>>> data size.
>>>
>>> That sounds like the opposite of what we should be doing.
>>>
>>> It's fine for kernel code/data to change; that's a natural part of
>>> development. Obviously, we should minimize churn, through thorough
>>> review, domain knowledge, etc.
>>
>> And with the "clock mapping" style bindings we'll end up changing both
>> the DT binding definition and the kernel. Not great.
>
> What's a "clock mapping" style binding? I guess that means the style
> where you have a single DT node that provides multiple clocks, rather
> than one DT node per clock?
>
> If the kernel driver changes its internal data, I don't see why that
> would have any impact at all on the DT binding definition. We should be
> able to use one DT binding definition with arbitrary drivers.

Yes, I'm referring to a single node providing multiple clocks. As an
example see the Exynos 5420 binding:
Documentation/devicetree/bindings/clock/exynos5420-clock.txt

The clock id's are stored as part of the binding definition resulting
in a mapping scheme that can be fragile. There have already been
patches to fix the id's assigned in the binding, which isn't supposed
to happen because it's a stable interface. If clock phandles are
created by individual nodes in DT then the binding definition need
never be updated due to merge conflicts or renaming which plagues the
mapping scenario.

>
>> And I'll respond to your points below but the whole "relocate the
>> problem to DT" argument is simply not my main point. What I want to do
>> is increase the usefulness of DT by allowing register-level details into
>> the binding which can
>
> Can you expand upon why a DT that encodes register-level details is more
> useful? I can't see why there would be any difference in usefulness.
>

Sure. The usefulness comes out of the fact that we do not need to
maintain data synchronization across dts and clock provider drivers.
The data lives in one place and only one place. We absolutely need a
phandle to a clock in DT link clock consumer devices to their input
clocks, so there is no question that should be in DT. Since we're
already doing that, why not do away with trying to keep dts and C
files in sync and just put all of the data in dts? It's a pure
separation of logic and data. The Linux clock provider driver is
purely logic and no data, which I imagine would appease the mind of
many a computer scientist.

Can you return the favor and tell me why putting register level
details into DT is inherently a bad idea? I'll drop my case if I can
be convinced that putting that level is detail into DT is The Wrong
Way, but I'll need more to go on than tradition and status quo.

Thanks,
Mike
