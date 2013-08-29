Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab3H2Jge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:36:34 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:48133 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab3H2Jgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:36:32 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbN70wBQ2Euy5yFj4OhKh1ctDKgUVz7Um8WLzQ3acLbTA@mail.gmail.com>
References: <1377066607-19061-1-git-send-email-sonic.adi@gmail.com>
	<52150AD9.3040808@wwwdotorg.org>
	<CAJxxZ0O77bgP8_rkRm-EgjAJ45SY2Pd3AGVSMhFxbsfNUmiqGg@mail.gmail.com>
	<52167900.3040502@wwwdotorg.org>
	<CACRpkdbN70wBQ2Euy5yFj4OhKh1ctDKgUVz7Um8WLzQ3acLbTA@mail.gmail.com>
Date: Thu, 29 Aug 2013 17:36:32 +0800
Message-ID: <CAJxxZ0O1dEVdJorb5kLJJQEgG8rqbx4_QxQ9U7r2h-_Auvhcxg@mail.gmail.com>
Subject: Re: [PATCH 1/3 v3] pinctrl: ADI PIN control driver for the GPIO
 controller on bf54x and bf60x.
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@linaro.org>,
        Steven Miao <realmz6@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, Aug 29, 2013 at 4:19 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Aug 22, 2013 at 10:48 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 08/22/2013 01:07 AM, Sonic Zhang wrote:
>>>
>>> There are 6 to 9 GPIO HW blocks in one Blackfin SoC. Function
>>> pinmux_enable_setting() in current pinctrl framework assumes the
>>> function mux setting of one peripheral pin group is configured in one
>>> pinctrl device. But, the function mux setting of one blackfin
>>> peripheral may be done among different GPIO HW blocks. So, I have to
>>> separate the pinctrl driver from the GPIO block driver add the ranges
>>> of all GPIO blocks into one pinctrl device for Blackfin.
>>
>> I don't think you need separate device; the pin control mapping table
>> entries for a particular state simply needs to include entries for
>> multiple pin controllers.
>
> So splitting each block into a separate pin control device is definately
> one way to skin the cat.
>
> The ux500 would then have 9 pin controller instances (after a
> big fat refactoring, but whatever) instead of 9 GPIO instances
> and one pinctrl instance referencing them. Also this solves
> the problem of registering GPIO ranges from the wrong end
> of the pin controller.
>
> Hm, I should try this and see where it goes... What do you
> think about this Sonic?

As I discussed with Stephen:

To separate the pinctrl_settings of one peripheral to multiple pinctrl
devices, multiple pinctrl group arrays and function arrays should be
defined in the soc data file. This change increases the code size of
the soc data file a lot without get any real benefits.

The pin controller device can be defined as a logic device to cover
many gpio devices, which are mapped into the same pin id space without
collision. All overhead in the soc data file can be removed in this
way. GPIO devices with pin id region collision should be put into
different pin controller devices.

So, I think it is fine to either binding pinctrl device to gpio device
or leave it as a logic device.

Regards,

Sonic
