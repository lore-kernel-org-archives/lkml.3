Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab3GJJst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 05:48:49 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:65247 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab3GJJss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 05:48:48 -0400
MIME-Version: 1.0
In-Reply-To: <20130709150543.GE27646@sirena.org.uk>
References: <1373372929-17800-1-git-send-email-richard.genoud@gmail.com>
 <1373379933-32749-1-git-send-email-richard.genoud@gmail.com>
 <1373379933-32749-4-git-send-email-richard.genoud@gmail.com> <20130709150543.GE27646@sirena.org.uk>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Wed, 10 Jul 2013 11:48:27 +0200
Message-ID: <CACQ1gAhK2yN2uhewq8XGOidLCDfOhgRvzE1o0b1krK1DjYj-dA@mail.gmail.com>
Subject: Re: [PATCH v4 3/7] Documentation: DT: update atmel SSC with DMA binding
To: Mark Brown <broonie@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Bo Shen <voice.shen@atmel.com>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/9 Mark Brown <broonie@kernel.org>:
> On Tue, Jul 09, 2013 at 04:25:29PM +0200, Richard Genoud wrote:
>
>>  - reg: Should contain SSC registers location and length
>>  - interrupts: Should contain SSC interrupt
>> +For dma transfer:
>> +- dmas: DMA specifier, consisting of a phandle to DMA controller node,
>> +  the memory interface and SSC DMA channel ID (for tx and rx).
>> +  See Documentation/devicetree/bindings/dma/atmel-dma.txt for details.
>> +- dma-names: Must be "tx", "rx".
>
> This is added as a required property so...
>
>> -Example:
>> +Examples:
>>  ssc0: ssc@fffbc000 {
>>       compatible = "atmel,at91rm9200-ssc";
>>       reg = <0xfffbc000 0x4000>;
>>       interrupts = <14 4 5>;
>>  };
>
> ...this first example is now invalid and should probably just be being
> extended with the new required properties.

Well, I have to rewrite that to make it clearer.
The thing is:
with "atmel,at91rm9200-ssc" the SSC doesn't work with DMA.
with "atmel,at91sam9g45-ssc", the SSC work ONLY with DMA.

So the dmas/dma-names properties are only required for g45-ssc, and
useless for rm9200-ssc

Maybe the best will be to write a paragraph for g45-ssc and another
for rm9200-ssc, even if there's some identical lines between them.


Thanks !

Richard.
