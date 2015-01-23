Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbbAWQUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:20:39 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:56813 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbbAWQUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:20:30 -0500
MIME-Version: 1.0
In-Reply-To: <54C270C4.4010407@roeck-us.net>
References: <1421882243-3631-1-git-send-email-dianders@chromium.org>
	<20150122132200.4729d38b@xhacker>
	<CAD=FV=UMmfNAEQVKCxTBapwO=pgno+cWUJNiMS7_uFK7NPevkw@mail.gmail.com>
	<54C270C4.4010407@roeck-us.net>
Date: Fri, 23 Jan 2015 08:20:23 -0800
X-Google-Sender-Auth: uDhR1EqXDGmUMuco-IFqnUs96k8
Message-ID: <CAD=FV=U1dg8w+_J0A3Q_O6-9qMmiTm=qO-uH9vo3gQCyM1fM4Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] watchdog: dw_wdt: pat the watchdog before enabling it
From: Doug Anderson <dianders@chromium.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jisheng Zhang <jszhang@marvell.com>, Wim Van Sebroeck <wim@iguana.be>,
        Heiko Stuebner <heiko@sntech.de>,
        Lunxue Dai <lunxue.dai@rock-chips.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter,

On Fri, Jan 23, 2015 at 8:03 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 01/22/2015 09:09 AM, Doug Anderson wrote:
>>
>> Jisheng,
>>
>> On Wed, Jan 21, 2015 at 9:22 PM, Jisheng Zhang <jszhang@marvell.com>
>> wrote:
>>>
>>> Dear Doug,
>>>
>>> On Wed, 21 Jan 2015 15:17:22 -0800
>>> Doug Anderson <dianders@chromium.org> wrote:
>>>
>>>> On some dw_wdt implementations the "top" register may be initted to 0
>>>> at bootup.  In such a case, each "pat" of the watchdog will reset the
>>>> timer to 0xffff.  That's pretty short.
>>>
>>>
>>> + Guenter Roeck
>>>
>>> This should have been fixed by dfa07141e7a792("watchdog: dw_wdt:
>>> initialise
>>> TOP_INIT in dw_wdt_set_top()")
>>
>>
>> I will admit that I'm testing on a tree that doesn't have your patch
>> (I'm on a 3.14 kernel with lots of backports).  ...but I did try
>> cherry-picking your patch before I wrote up mine and it didn't fix my
>> problem.  I believe that the watchdog that's in Rockchip rk3288 must
>> be a slightly different version of the IP block than you're working
>> with.
>>
>> Specifically I see the register WDT_TORR that has an offset of 0x4.
>> That's the RANGE_REG in your code.  It shows bits 3:0 set the timeout
>> period (0 = 0xffff and 15 = 0x7fffffff).  It shows bits 31:4 as
>> "reserved".
>>
> Not sure where that leaves us. Does that mean the driver supports different
> hardware with different register sets ?

Apparently so.  I've only seen the documentation from rk3288, but it's
clearly different than what you saw.

>  Should that be documented in the
> driver,

Probably not a terrible idea.

> and should we have (or do we need) different compatible statements for those
> variants, and conditional code in the driver ?

I'm not sure we actually need any conditional code.  I've put the
other patch on rk3288 and it didn't hurt to write those reserved bits.
I also can't quite believe that the extra pat will hurt on other
hardware.


> And does it mean we need both patches, at least for some of the hardware
> variants ? If so, what happens if those patches are applied and the
> resulting
> driver runs on the other hardware ?

I think it should be fine.


Do you want me to spin my patch and add some extra comments (but
otherwise keep it roughly unchanged?).  We can get Jisheng to add his
Tested-by...

-Doug
