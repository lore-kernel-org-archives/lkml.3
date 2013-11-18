Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab3KRNVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:21:07 -0500
Received: from 3.mo2.mail-out.ovh.net ([46.105.58.226]:59811 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751237Ab3KRNVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:21:04 -0500
Message-ID: <528A1411.6000905@overkiz.com>
Date: Mon, 18 Nov 2013 14:20:17 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Rob Landley <rob@landley.net>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH RESEND 1/2] clk: add clk accuracy retrieval support
References: <1381684631-10835-1-git-send-email-b.brezillon@overkiz.com> <1381684631-10835-2-git-send-email-b.brezillon@overkiz.com> <20131116015946.19193.29895@quantum>
In-Reply-To: <20131116015946.19193.29895@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 1469299379511785500
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrieekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrieekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Nothing related to this thread, but if you have some time, could you 
take a look at
the last version (v5) of the at91 CCF port ?

I know Nicolas was planning to add this for 3.14, and we'd like to have 
your feedback
on the new dt bindings.

Best Regards,

Boris

On 16/11/2013 02:59, Mike Turquette wrote:
> Quoting Boris BREZILLON (2013-10-13 10:17:10)
>> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
>> index 73bdb69..942811d 100644
>> --- a/include/linux/clk-provider.h
>> +++ b/include/linux/clk-provider.h
> ...
>> @@ -194,6 +204,7 @@ struct clk_hw {
>>   struct clk_fixed_rate {
>>          struct          clk_hw hw;
>>          unsigned long   fixed_rate;
>> +       unsigned long   fixed_accuracy;
> This change belongs in patch #2. Please also update the kerneldoc above
> this struct definition.
>
> Regards,
> Mike
>
>>          u8              flags;
>>   };
>>   
>> diff --git a/include/linux/clk.h b/include/linux/clk.h
>> index 9a6d045..2fe3b54 100644
>> --- a/include/linux/clk.h
>> +++ b/include/linux/clk.h
>> @@ -85,6 +85,23 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb);
>>   #endif
>>   
>>   /**
>> + * clk_get_accuracy - obtain the clock accuracy in ppb (parts per billion)
>> + *                   for a clock source.
>> + * @clk: clock source
>> + *
>> + * This gets the clock source accuracy expressed in ppb.
>> + * A perfect clock returns 0.
>> + */
>> +#ifdef CONFIG_HAVE_CLK_GET_ACCURACY
>> +unsigned long clk_get_accuracy(struct clk *clk);
>> +#else
>> +static inline unsigned long clk_get_accuracy(struct clk *clk)
>> +{
>> +       return 0;
>> +}
>> +#endif
>> +
>> +/**
>>    * clk_prepare - prepare a clock source
>>    * @clk: clock source
>>    *
>> -- 
>> 1.7.9.5
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

