Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaJGEyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 00:54:44 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:47167 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbaJGEym convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 00:54:42 -0400
MIME-Version: 1.0
In-Reply-To: <54335E0B.301@rock-chips.com>
References: <1412070294-5535-1-git-send-email-zyw@rock-chips.com>
	<CAD=FV=XViSBFyMEY9kQBMggnn+uA0wYarbseFOuZeakzBxZeqA@mail.gmail.com>
	<1716911.pj5CzLpxUR@phil>
	<20140930225241.GO4273@sirena.org.uk>
	<54335E0B.301@rock-chips.com>
Date: Mon, 6 Oct 2014 21:54:41 -0700
X-Google-Sender-Auth: B9OfFBN4kN6ZvOqyvxrTZ1YaySo
Message-ID: <CAD=FV=WpY6jRfAQDVE90ZMOAEtYjfJQVV=RKOYVFwEXYB+UR_w@mail.gmail.com>
Subject: Re: [PATCH] regulator: rk808: Fix min_uV for DCDC1 & DCDC2
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Mark Brown <broonie@kernel.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris and Mark,

On Mon, Oct 6, 2014 at 8:29 PM, Chris Zhong <zyw@rock-chips.com> wrote:
>
> On 10/01/2014 06:52 AM, Mark Brown wrote:
>>
>> On Tue, Sep 30, 2014 at 06:57:51PM +0200, Heiko Stübner wrote:
>>>
>>> Am Dienstag, 30. September 2014, 09:43:47 schrieb Doug Anderson:
>>>>
>>>> On Tue, Sep 30, 2014 at 2:44 AM, Chris Zhong <zyw@rock-chips.com> wrote:
>>>>>
>>>>> -       REGULATOR_LINEAR_RANGE(700000, 0, 63, 12500),
>>>>> +       REGULATOR_LINEAR_RANGE(712500, 0, 63, 12500),
>>>>
>>>> I have no problem with this (and the current "dts" file I see don't go
>>>> this low anyway), but it doesn't match the datasheet I have right now
>>>> which says "0.700 V" is the min.
>>>
>>> Then it would be problem.
>>> The original statement above says, that a register value of "0" equals
>>> 700mV,
>>> so changing this in this way would mean everything runs 12.5mV above the
>>> target voltage.
>>> And I can confirm, that the current datasheet lists 700mV as equallying
>>> register value 0.
>>
>> Has anyone got a voltmeter?
>
> The latest datasheet has fixed this error.
> The register value of "0" equals 712.5mV, so the max value can reach 1.5v
> but not 1.4875v.

OK, that sounds like this is the right change, then.

To Mark's point, I measured voltage using the builtin voltage
measurement feature this board (not 100% sure the accuracy / precision
guarantees on them, but...):

Asked for 1.300 volts on vdd_arm (dcdc1).
* Before: got 1.326
* After: got 1.310

Asked for 1.3 on vdd_gpu (dcdc2):
* Before: 1.326
* After: got 1.314

Asked for 1.0 on vdd_gpu:
* Before: 1.038
* After: got 1.026

Asked for .8 on vdd_gpu
* Before:.836
* After: got .822


It almost sounds like we're still running a little too high for
voltages, but this gets us in the right direction I guess.

-Doug
