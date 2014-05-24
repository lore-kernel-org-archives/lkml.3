Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbaEXMl4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 08:41:56 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:7610 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750845AbaEXMlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 08:41:55 -0400
Message-ID: <5380938E.5010408@itdev.co.uk>
Date: Sat, 24 May 2014 13:41:50 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Yufeng Shen <miletus@chromium.org>
CC: Benson Leung <bleung@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH 20/51] Input: atmel_mxt_ts - Set default irqflags when
 there is no pdata
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>	<1372337366-9286-21-git-send-email-nick.dyer@itdev.co.uk>	<20130718171744.GC32381@polaris.bitmath.org>	<20130916022533.GA6468@core.coreip.homeip.net>	<537E09D6.7050604@itdev.co.uk> <CAPDwgkP5KjP6PcZBeYTMPuewO4exyUFfCX8rhzmgDO65ti=3Mg@mail.gmail.com>
In-Reply-To: <CAPDwgkP5KjP6PcZBeYTMPuewO4exyUFfCX8rhzmgDO65ti=3Mg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yufeng Shen wrote:
> On Thu, May 22, 2014 at 10:29 AM, Nick Dyer <nick.dyer@itdev.co.uk> wrote:
>> Dmitry Torokhov wrote:
>>>>> Make the irqflags default to be IRQF_TRIGGER_FALLING if no platform data is
>>>>> provided.
>>>
>>> I think if there is no platform data we should use 0 as IRQ falgs and
>>> assume that IRQ line is properly configured by the board code or via
>>> device tree.
>>
>> Benson/Yufeng - do you still have a requirement to probe without platform
>> data or device tree? I'm just merging in some changes to add device tree
>> support, and it would simplify things a bit if I can drop this patch.
> 
> It has been working for quite a while for boards/devices that don't 
> provide platform data. If we drop the default IRQ flags, sure we can add
> code for each board to configure the IRQ separately, but that's just
> adding extra work. Is there strong reason why we should not do the
> default setting in the driver if it is not already configured in
> platform data?

OK, I will keep it in my tree for the moment, since you are using it.

The reason I checked is that in general, I would like to be conservative
about what is pushed upstream, because it will need maintaining for a long
time.

The other reason is that in fact Atmel recommend IRQF_TRIGGER_LOW for these
chips, not IRQF_TRIGGER_FALLING, so there is a bit of an inconsistency here.
