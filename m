Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaKKFri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 00:47:38 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:47113 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaKKFrg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 00:47:36 -0500
MIME-Version: 1.0
In-Reply-To: <22835729.YDXmW0qp6M@diego>
References: <1415368177-6637-1-git-send-email-zyw@rock-chips.com>
	<7hwq76pqyz.fsf@deeprootsystems.com>
	<22835729.YDXmW0qp6M@diego>
Date: Mon, 10 Nov 2014 21:47:35 -0800
X-Google-Sender-Auth: RfN3zCRQEPFtEolawt7ZpRWgVdc
Message-ID: <CAD=FV=UJAzVgZedrJJaxCc+3FdJp__NV9-9pY=wTH_ZydXrQcg@mail.gmail.com>
Subject: Re: [PATCH v7 0/5] This is the 1st version of suspend for RK3288.
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Chris Zhong <zyw@rock-chips.com>, Kevin Hilman <khilman@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Tony Xie <xxx@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Nov 10, 2014 at 4:40 PM, Heiko Stübner <heiko@sntech.de> wrote:
> Hi Chris,
>
> Am Freitag, 7. November 2014, 14:48:20 schrieb Kevin Hilman:
>> Chris Zhong <zyw@rock-chips.com> writes:
>> > RK3288 can shut down the cpu, gpu and other device controllers in suspend,
>> > and it will pull the GLOBAL_PWROFF pin to high in the final stage of the
>> > process of suspend, pull the pin to low again when resume.
>>
>> The cover letter still doesn't state what this series applies to, or
>> what its dependencies are for testing, even though it was requested in
>> earlier reviews[1].  I discovered (again) by trial and error it applies
>> to current linux-next.  I also discovered (as was earlier discussed[2])
>> that it still does not resume using current upstream code, and those
>> dependencies are not described here either.  These are the kinds of
>> things that are crucial in a cover letter in order to help reviewers and
>> testers not have to spend time digging through the archives trying to
>> remember from the previous round of reviews.
>>
>> Please, please list the out-of-tree dependencies, and how to test,
>> including how you tested it, and on what hardware.
>
> I'll second what Kevin said.
>
> I guess the regulator suspend handling [0] is one of the requirements, but I'd
> think there is more. And while Doug had a quite long list of suspend-related
> patches in his try, for now we'll need the minimal set to enable this series
> to sucessfully wake the system again after going to suspend.

With the current series we have in the Chrome OS tree, the WIP power
domain patches are a requirement, which makes testing very hard.  I've
suggested that Chris try going back to leaving the GPU on his patches.
It's possible you could get basic suspend/resume without power domain
patches in that case.  Once power domain stuff is in good shape then
we can turn off the GPU, I think.

...all of those things are needed to actually get the system into the
lowest power state, but starting simple makes a lot of sense.

-Doug
