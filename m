Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab3G2OSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:18:30 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:64021 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab3G2OS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:18:28 -0400
MIME-Version: 1.0
In-Reply-To: <51F63516.8090000@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
 <51F28370.6050304@gmail.com> <51F2996B.6000406@overkiz.com>
 <51F2A556.8020109@overkiz.com> <CACQ1gAgw-v3z_sWcsk7SqFFW-ERLjS0RS5GTgAdd5Y1tj3Z1FA@mail.gmail.com>
 <51F63516.8090000@overkiz.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Mon, 29 Jul 2013 16:18:06 +0200
Message-ID: <CACQ1gAi53KN=zE8zDxQO=+BY2zvQXakD=OSuzUqc0VLwWLySCA@mail.gmail.com>
Subject: Re: [PATCH v2 00/42] ARM: at91: move to common clk framework
To: boris brezillon <b.brezillon@overkiz.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/29 boris brezillon <b.brezillon@overkiz.com>:
> On 29/07/2013 10:00, Richard Genoud wrote:
>>
>> 2013/7/26 boris brezillon <b.brezillon@overkiz.com>:
>>>
>>> On 26/07/2013 17:44, boris brezillon wrote:
>>> I found 2 bugs:
>>> 1) the main frequency ready test in recalc_rate function is wrong
>>> 2) the common clk framework uses the first match for dt clk registration
>>>     and main clk has this compatible property:
>>>     compatible = "atmel,at91rm9200-clk-main", "fixed-clock";
>>>     As a result the main clk is always bound to the fixed-clock driver
>>>     which set the clock frequency to 0 if 'clock-frequency' property is
>>>     missing.
>>>
>>> These bugs will be fixed in next version.
>>> Tell me if you want need thesse patches for testing purpose.
>>
>> Hi Boris,
>>
>> I tested your patch, the clock is not at 0 anymore:
>> AT91: PIT: mck rate = 8333333
>>
>> And it's booting correctly.
>> There's a small bug I found in the at91sam9x5 dtsi file (ssc id is 28,
>> not 27). (patch attached)
>>
>> And yes, I could use your patches for some more tests !
>>
>> Thanks,
>>
>> Richard.
>
> Hi Richard,
>
> Thanks for the bug report.
>
> You'll find in attachements the pre-v3 series fixing the detected bugs
> (including the ssc clock id bug).
>
> If you need anything else please let me know.

Working on sam9g35ek !
you can add my:
Tested-by: Richard Genoud <richard.genoud@gmail.com>


One remark though:
Maybe it would be interesting to keep using the defines in the device
tree for peripheral IDs.
For instance, in arch/arm/boot/dts/at91sam9x5.dtsi : (patch 33)
ssc_clk@28 {
	id = <28>;
};
May be more readable with the SSC id AT91SAM9X5_ID_SSC, as it was
defined in arch/arm/mach-at91/at91sam9x5.c (removed with patch 20)

IMHO, all AT91SAM9X5_ID_xxx in
arch/arm/mach-at91/include/mach/at91sam9x5.h can me moved in
include/dt-bindings/ and used in at91sam9x5.dtsi

Best regards,
Richard.
