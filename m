Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab3JGQ0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:26:49 -0400
Received: from 6.mo4.mail-out.ovh.net ([188.165.36.253]:50463 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755348Ab3JGQ0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:26:46 -0400
Message-ID: <5252DC09.6010207@overkiz.com>
Date: Mon, 07 Oct 2013 18:06:33 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH v3 04/19] clk: at91: add PMC macro file for dt definitions
References: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com> <1375938270-3965-1-git-send-email-b.brezillon@overkiz.com> <5252D0A5.60304@atmel.com>
In-Reply-To: <5252D0A5.60304@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 15860551989070100588
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrvddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrvddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 17:17, Nicolas Ferre wrote:
> On 08/08/2013 07:04, Boris BREZILLON :
>> This patch adds a new macro file for PMC macros.
>>
>> This macro file includes the definitions of SR (status register) bit
>> offsets and will be use to reference PMC irqs.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> ---
>>   include/dt-bindings/clk/at91/common/pmc.h |   20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>   create mode 100644 include/dt-bindings/clk/at91/common/pmc.h
>>
>> diff --git a/include/dt-bindings/clk/at91/common/pmc.h 
>> b/include/dt-bindings/clk/at91/common/pmc.h
>> new file mode 100644
>> index 0000000..edc51d6
>> --- /dev/null
>> +++ b/include/dt-bindings/clk/at91/common/pmc.h
>> @@ -0,0 +1,20 @@
>> +/*
>> + * This header provides constants for AT91 pmc status.
>> + *
>> + * The constants defined in this header are being used in dts.
>
> It is better to add one line about license: for example:
>
>  * Licensed under GPLv2 or later.
>
>
>> + */
>> +
>> +#ifndef _DT_BINDINGS_CLK_AT91_PMC_H
>> +#define _DT_BINDINGS_CLK_AT91_PMC_H
>> +
>> +#define AT91_PMC_MOSCS        0        /* MOSCS Flag */
>> +#define AT91_PMC_LOCKA        1        /* PLLA Lock */
>> +#define AT91_PMC_LOCKB        2        /* PLLB Lock */
>> +#define AT91_PMC_MCKRDY        3        /* Master Clock */
>> +#define AT91_PMC_LOCKU        6        /* UPLL Lock */
>> +#define AT91_PMC_PCKRDY(id)    (8 + id)    /* Programmable Clock */
>
> I prefer with parenthesis around "id" (8 + (id))

Absolutely, I'll fix it.
>
>> +#define AT91_PMC_MOSCSELS    16        /* Main Oscillator Selection */
>> +#define AT91_PMC_MOSCRCS    17        /* Main On-Chip RC */
>> +#define AT91_PMC_CFDEV        18        /* Clock Failure Detector 
>> Event */
>> +
>> +#endif
>>
>
>

