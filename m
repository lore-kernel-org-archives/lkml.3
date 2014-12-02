Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaLBBHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 20:07:43 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:37362 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbaLBBHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 20:07:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAD=FV=V2go5BMFbiFKu73_aVz5ck949W-kJQ6WLkAQRPJbjPVA@mail.gmail.com>
References: <1417423940-1669-1-git-send-email-zyw@rock-chips.com>
	<7htx1f409k.fsf@deeprootsystems.com>
	<CAD=FV=V2go5BMFbiFKu73_aVz5ck949W-kJQ6WLkAQRPJbjPVA@mail.gmail.com>
Date: Mon, 1 Dec 2014 17:07:39 -0800
X-Google-Sender-Auth: 0foLSAwcYTJdMisd9PAaPXakZ-4
Message-ID: <CAD=FV=XuQk17CTNKJY++J+w9Ab9_OUX0ca0A99m7yKPAWSs2=w@mail.gmail.com>
Subject: Re: [PATCH v10 0/4] This suspend patch is only support cut off the
 power of cpu and some external
From: Doug Anderson <dianders@chromium.org>
To: Kevin Hilman <khilman@kernel.org>
Cc: Chris Zhong <zyw@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 1, 2014 at 2:08 PM, Doug Anderson <dianders@chromium.org> wrote:
> Hi,
>
> On Mon, Dec 1, 2014 at 11:51 AM, Kevin Hilman <khilman@kernel.org> wrote:
>> Chris Zhong <zyw@rock-chips.com> writes:
>>
>>> devices, since we still lack power_domain driver, so the other power rail
>>> of rk3288 need keep power on.
>>> I have tested it on rk3288-evb board, atop next-20141112. goto suspend by type
>>> "echo mem > /sys/power/state", vdd_cpu is about 0mv by measuring, so it can be
>>> determined in sleep mode, then press power button to wakeup it.
>>
>> I tested this on top of today's linux-next (next-20141201) and it
>> suspends, but doesn't wake up from any of the button presses.  What
>> wakeup sources are configured for the rk3288-evb-rk808?
>
> Just to close the loop (I talked with Kevin over IM about this, too):
>
> I have a huge description of how I tested this as part of my patch at
> <https://patchwork.kernel.org/patch/5414941/>.  Chris:  I think Kevin
> has asked you several times to include information like this in your
> cover letter.  Please, please, please can you try to remember to do
> this?

Talked to Chris offline.  He said that in his tests the other patches
weren't needed, so he didn't list any other patches.  Things just
worked for him.  ...so I guess he did post the instructions that
worked for him.  Sorry for the complaint.  Possibly things are
different on "next-20141112" and that's where Chris said he tested.

I know that I personally needed some of the extra patches.  I guess
the USB one wasn't truly needed (only needed for hotplug), but for me
things were unhappy without SMP.  It was hanging when trying to turn
off secondary CPUs.  I didn't dig, though.  The clocksource patches
are needed for me because I'm using an old bootloader, but I think
they're also relevant for S2R because (I'm told) we can lose the
virtual offset at suspend time in certain modes.

-Doug

.
