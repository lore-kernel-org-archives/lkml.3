Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaJGD3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 23:29:23 -0400
Received: from regular1.263xmail.com ([211.150.99.135]:59213 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaJGD3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 23:29:22 -0400
X-263anti-spam: KSV:0;BIG:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 1
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: broonie@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <98754e1717ec95670bda41280ae0e21b>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <54335E0B.301@rock-chips.com>
Date: Tue, 07 Oct 2014 11:29:15 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
CC: Doug Anderson <dianders@chromium.org>, linux-rockchip@lists.infradead.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: rk808: Fix min_uV for DCDC1 & DCDC2
References: <1412070294-5535-1-git-send-email-zyw@rock-chips.com> <CAD=FV=XViSBFyMEY9kQBMggnn+uA0wYarbseFOuZeakzBxZeqA@mail.gmail.com> <1716911.pj5CzLpxUR@phil> <20140930225241.GO4273@sirena.org.uk>
In-Reply-To: <20140930225241.GO4273@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/01/2014 06:52 AM, Mark Brown wrote:
> On Tue, Sep 30, 2014 at 06:57:51PM +0200, Heiko Stübner wrote:
>> Am Dienstag, 30. September 2014, 09:43:47 schrieb Doug Anderson:
>>> On Tue, Sep 30, 2014 at 2:44 AM, Chris Zhong <zyw@rock-chips.com> wrote:
>>>> -       REGULATOR_LINEAR_RANGE(700000, 0, 63, 12500),
>>>> +       REGULATOR_LINEAR_RANGE(712500, 0, 63, 12500),
>>> I have no problem with this (and the current "dts" file I see don't go
>>> this low anyway), but it doesn't match the datasheet I have right now
>>> which says "0.700 V" is the min.
>> Then it would be problem.
>> The original statement above says, that a register value of "0" equals 700mV,
>> so changing this in this way would mean everything runs 12.5mV above the
>> target voltage.
>> And I can confirm, that the current datasheet lists 700mV as equallying
>> register value 0.
> Has anyone got a voltmeter?
The latest datasheet has fixed this error.
The register value of "0" equals 712.5mV, so the max value can reach 
1.5v but not 1.4875v.

