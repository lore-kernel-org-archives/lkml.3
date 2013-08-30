Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab3H3Ioz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 04:44:55 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:55325 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab3H3InY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 04:43:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAJxxZ0O1dEVdJorb5kLJJQEgG8rqbx4_QxQ9U7r2h-_Auvhcxg@mail.gmail.com>
References: <1377066607-19061-1-git-send-email-sonic.adi@gmail.com>
	<52150AD9.3040808@wwwdotorg.org>
	<CAJxxZ0O77bgP8_rkRm-EgjAJ45SY2Pd3AGVSMhFxbsfNUmiqGg@mail.gmail.com>
	<52167900.3040502@wwwdotorg.org>
	<CACRpkdbN70wBQ2Euy5yFj4OhKh1ctDKgUVz7Um8WLzQ3acLbTA@mail.gmail.com>
	<CAJxxZ0O1dEVdJorb5kLJJQEgG8rqbx4_QxQ9U7r2h-_Auvhcxg@mail.gmail.com>
Date: Fri, 30 Aug 2013 10:43:23 +0200
Message-ID: <CACRpkdYum46J1PEhEhhSjnJ3Chmqpw4enqcoH1YSwD5itoRBVA@mail.gmail.com>
Subject: Re: [PATCH 1/3 v3] pinctrl: ADI PIN control driver for the GPIO
 controller on bf54x and bf60x.
From: Linus Walleij <linus.walleij@linaro.org>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@linaro.org>,
        Steven Miao <realmz6@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 11:36 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:
> On Thu, Aug 29, 2013 at 4:19 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

>> So splitting each block into a separate pin control device is definately
>> one way to skin the cat.
>>
>> The ux500 would then have 9 pin controller instances (after a
>> big fat refactoring, but whatever) instead of 9 GPIO instances
>> and one pinctrl instance referencing them. Also this solves
>> the problem of registering GPIO ranges from the wrong end
>> of the pin controller.
(...)
> The pin controller device can be defined as a logic device to cover
> many gpio devices, which are mapped into the same pin id space without
> collision. All overhead in the soc data file can be removed in this
> way. GPIO devices with pin id region collision should be put into
> different pin controller devices.

This is true for your device and if that works for you then go
ahead with this.

In the Nomadik case the registers for GPIO and pin control
are mingled in the same memory range so things are more
complex.

Yours,
Linus Walleij
