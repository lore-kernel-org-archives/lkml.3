Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab3LQW0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:26:21 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:39550 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab3LQW0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:26:18 -0500
MIME-Version: 1.0
In-Reply-To: <1746928.Q6f1iPMsKL@avalon>
References: <20131217023745.24573.3660.sendpatchset@w520>
	<20131217023823.24573.98585.sendpatchset@w520>
	<1746928.Q6f1iPMsKL@avalon>
Date: Wed, 18 Dec 2013 07:26:15 +0900
Message-ID: <CANqRtoSJAik-QV9WFfgsVGPAVBCRasuQz9kOHOueDM562PwJMg@mail.gmail.com>
Subject: Re: [PATCH 04/05 v2] pinctrl: sh-pfc: r7s72100 SCIF support
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Wed, Dec 18, 2013 at 1:08 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Magnus,
>
> Thank you for the patch.
>
> On Tuesday 17 December 2013 11:38:23 Magnus Damm wrote:
>> From: Magnus Damm <damm@opensource.se>
>>
>> Add support for SCIF functions SCK, TXD, RXD, CTS and RTS to the
>> r7s72100 PINCTRL code. There are two possible pins that can be used
>> for TXD (Port 3 Pin 0 Function 6 and Port 3 Pin 1 Function 4) and
>> because of that are pins broken out into separate functions.
>>
>> Signed-off-by: Magnus Damm <damm@opensource.se>
>> ---
>>
>>  drivers/pinctrl/sh-pfc/pfc-r7s72100.c |  158 ++++++++++++++++++++++++++++++
>>  1 file changed, 158 insertions(+)
>>
>> --- 0006/drivers/pinctrl/sh-pfc/pfc-r7s72100.c
>> +++ work/drivers/pinctrl/sh-pfc/pfc-r7s72100.c        2013-12-17
> 01:09:20.000000000
>> +0900 @@ -117,12 +117,170 @@ static const unsigned int __RZ_STR(pfx,
>>  #define RZ_GROUPS(pfx, hw, bank, pin, fn) \
>>       __RZ_GROUPS(pfx##_##hw##_p##bank##_##pin),
>>
>> +#define SCIF0(fn)                    \
>> +     fn(scif0, clk, 2, 13, 6)        \
>> +     fn(scif0, txd, 2, 14, 6)        \
>> +     fn(scif0, rxd, 2, 15, 6)        \
>> +     fn(scif0, clk, 4, 8, 7)         \
>> +     fn(scif0, txd, 4, 9, 7)         \
>> +     fn(scif0, rxd, 4, 10, 7)        \
>> +     fn(scif0, clk, 6, 8, 5)         \
>> +     fn(scif0, txd, 6, 9, 5)         \
>> +     fn(scif0, rxd, 6, 10, 5)
>
> The SCIF0 SCK, TXD and RXD pins are grouped together with three options to
> choose from. Unlike the PFC devices we support so far, the driver allows
> picking pins individually. This allows greater flexibility, at the cost of a
> more verbose PFC DT node.

You need more detailed PFC data, yes, but I'm not sure if "Unlike the
PFC devices we support so far" is a correct statement. =)

> I assume that this is correct, but could you please confirm that the SoC
> really allows picking pins individually (for instance using P2.14 as SCIF0 TXD
> together with P6.10 as SCIF0 RXD) ?

Your example would work just fine, yes. I don't have any hardware to
test that though. I suspect the same would be fine on all of our SoCs
actually, unless

> I also wonder whether other currently supported SoCs wouldn't happen to also
> support picking pins from different groups, even though they name the groups
> differently.

It seems to me that in general the hardware has much more flexibility
than what the PINCTRL groups actually expose today. In the end it
depends on the actual hardware, so its a case by case thing:

A) RZ series: Individual per-pin settings always available

B) R-Mobile series (PORTnCR + MSELnCR): Individual per-pin settings
usually available

C) R-Car series (IPSRnn + MOD_SEL): Shared to some degree, but often
still allows individual control.

So with the current PINCTRL interface it looks like we have introduced
some artificial limitation based on software grouping even though the
actual hardware often can handle per-pin settings.

Cheers,

/ magnus
