Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab3LQWeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:34:15 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:39021 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab3LQWeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:34:13 -0500
MIME-Version: 1.0
In-Reply-To: <4641687.OeSyoZmW7s@avalon>
References: <20131217023745.24573.3660.sendpatchset@w520>
	<20131217023814.24573.91649.sendpatchset@w520>
	<4641687.OeSyoZmW7s@avalon>
Date: Wed, 18 Dec 2013 07:34:11 +0900
Message-ID: <CANqRtoR-AF2HSdNiBHK7eFkxp1ZRSr++rRfBo773wfXoaU3qOw@mail.gmail.com>
Subject: Re: [PATCH 03/05 v2] pinctrl: sh-pfc: r7s72100 single pin macros
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "Simon Horman [Horms]" <horms@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Thanks for your feedback.

On Wed, Dec 18, 2013 at 1:01 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Magnus,
>
> Thank you for the patches.
>
> On Tuesday 17 December 2013 11:38:14 Magnus Damm wrote:
>> From: Magnus Damm <damm@opensource.se>
>>
>> Introduce macros that allow description of one pin per line.
>> Compared to the other ways of doing this, using this style
>> we can compresses the description of each pin from 9 to 1 line.
>>
>> Signed-off-by: Magnus Damm <damm@opensource.se>
>> ---
>>
>>  This patch uses RZ_PMX_GROUP and RZ_GROUPS, thanks Laurent!
>>
>>  drivers/pinctrl/sh-pfc/pfc-r7s72100.c |   21 +++++++++++++++++++++
>>  1 file changed, 21 insertions(+)
>>
>> --- 0003/drivers/pinctrl/sh-pfc/pfc-r7s72100.c
>> +++ work/drivers/pinctrl/sh-pfc/pfc-r7s72100.c        2013-12-16
> 19:14:30.000000000
>> +0900 @@ -98,9 +98,30 @@ static struct sh_pfc_pin pinmux_pins[] =
>>
>>  #define RZ_PORT_PIN(bank, pin) (((bank) * 16) + (pin))
>>
>> +#define __RZ_STR(pfx, hw, bank, pin, sfx)            \
>> +     pfx##_##hw##_p##bank##_##pin####sfx
>
> Do you mean s/####sfx/##sfx/ ?

Yes, thanks for catching that.

>> +
>> +#define RZ_PIN_AND_MUX(pfx, hw, bank, pin, fn)                               \
>> +static const unsigned int __RZ_STR(pfx, hw, bank, pin, _pins)[] = {  \
>> +     RZ_PORT_PIN(bank, pin),                                         \
>> +};                                                                   \
>> +static const unsigned int __RZ_STR(pfx, hw, bank, pin, _mux)[] = {   \
>> +     P_##bank##_##pin##_MARK_FN##fn,                                 \
>> +};
>
> I would have preferred keeping the trailing semicolon (and comma in the
> RZ_GROUPS macro) out of the macro, but that won't be possible as the
> RZ_PIN_AND_MUX and RZ_GROUPS macros are used as arguments to the SCIF macros
> in the next patch.

That's correct. As much as I like semicolons, having a
single-line-per-pin must be better than duplicating stuff and use
semicolons.

>> +
>> +#define RZ_PMX_GROUP(pfx, hw, bank, pin, fn) \
>> +     SH_PFC_PIN_GROUP(pfx##_##hw##_p##bank##_##pin),
>> +
>> +#define __RZ_GROUPS(x) #x
>
> Can't you replace __RZ_GROUPS() by __stringify() ?

I'll try!

>> +#define RZ_GROUPS(pfx, hw, bank, pin, fn) \
>> +     __RZ_GROUPS(pfx##_##hw##_p##bank##_##pin),
>> +
>>  static const struct sh_pfc_pin_group pinmux_groups[] = {
>>  };
>>
>> +static const char * const scif2_groups[] = {
>> +};
>
> I think this should be part of patch 04/05.

Yes, so it seems.

Thanks,

/ magnus
