Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab3KAQIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:08:44 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:55145 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab3KAQIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:08:42 -0400
MIME-Version: 1.0
In-Reply-To: <20131101005840.GB8413@kartoffel>
References: <1381872071-23455-1-git-send-email-linus.walleij@linaro.org>
	<20131101005840.GB8413@kartoffel>
Date: Fri, 1 Nov 2013 09:08:41 -0700
Message-ID: <CACRpkdY3XCJSEK88sDBSQFUyPUkSVNdbpMKzOWUdqt3O7rm=XA@mail.gmail.com>
Subject: Re: [PATCH 4/5] input: tc3589x-keypad: support probing from device tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 5:58 PM, Mark Rutland <mark.rutland@arm.com> wrote:

>> +     plat = devm_kzalloc(dev, sizeof(*plat), GFP_KERNEL);
>> +     if (!plat)
>> +             return ERR_PTR(-ENOMEM);
>> +
>> +     of_property_read_u8(np, "keypad,num-columns", &plat->kcol);
>> +     of_property_read_u8(np, "keypad,num-rows", &plat->krow);
>
> These look wrong to me, as almost every single use of of_property_read_u8 (or
> of_property_read_u16) do. They read _packed_ values out of the dt, and do not
> read (u32) cells as u8s or u16s.

Yes...

> The matrix-keymap binding doesn't define these as 8-bit, and the example
> binding they are u32 cells. Either the binding document or this code is wrong.

The biding is in patch titled:
"mfd: tc3589x: Add device tree bindings"
and yes, you are right, this seems wrong. (The example in that patch
is wrong too.)

> I'm confused as to how this can work. Are you using /bits/ 8 in your dts?

Yes indeed I do. So it was working fine...

I'll adjust this to use u32:s, even if it seems odd supporting keypads
with 255+ columns and rows... well it's in there.

Yours,
Linus Walleij
