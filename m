Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab3G3C0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 22:26:42 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:55477 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab3G3C0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 22:26:41 -0400
MIME-Version: 1.0
X-Originating-IP: [218.173.168.142]
In-Reply-To: <20130730022603.GA1430@Robin-OptiPlex-780>
References: <1375082774.7272.1.camel@phoenix>
	<CAFRkauB35ERLgakua7=Q+xoRx-N83BTD4f_8HyvbGjAxhEZvUg@mail.gmail.com>
	<20130729092809.GA319@Robin-OptiPlex-780>
	<CAFRkauCKMjNxZatNmOVc95XUuuDNzW0+7razK4tmHKwf+JyS0A@mail.gmail.com>
	<20130730022603.GA1430@Robin-OptiPlex-780>
Date: Tue, 30 Jul 2013 10:26:40 +0800
Message-ID: <CAFRkauBF3EeCKqkvmt0E9Wifo8GD615X2LzqE59E-YoSVEFMaA@mail.gmail.com>
Subject: Re: regulator: pfuze100: A few small questions
From: Axel Lin <axel.lin@ingics.com>
To: Robin Gong <b38343@freescale.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/30 Robin Gong <b38343@freescale.com>:
> On Mon, Jul 29, 2013 at 11:44:40PM +0800, Axel Lin wrote:
>> >> Current code adjust min_uV and uV_step when SW2~SW4 high bit is set.
>> >> I'm wondering if n_voltages is correct or not in this case because
>> >> the n_voltages is calculated by original equation (max-min/step + 1).
>> >> What is the max_uV when SW2~SW4 high bit is set?
>> >>
>> > If high bit set(bit6, bit0~5:vsel), min_uV/step will change from 0.4V/25mV to
>> > 0.8V/50mV,but the n_voltages will kept the same.
>> > For example,SW2 will vary from 0.4V to 1.975V(0x0~0x3f),if bit6 set 0(high bit)
>> > SW2 will vary from 0.8V to 3.3V(0x40~0x72,0x72~0x7f:reversed).
>> > Please ignore bit7 or consider it as 0.
>>
>> Hi Robin,
>> According to your description:
>> BIT6 is clear: 0.4V ~ 1.975V , step 25mV (0x0~0x3f)
>> BIT6 is set:   0.8V ~ 3.3V, step 50mV    (0x40~0x72,0x72~0x7f:reversed)
>>
>> For SW2/SW3A/SW3B/SW4:
>> I think current implementation is wrong.
>> The supported voltage range should cover the whole range: 0.4V ~ 3.3V.
>>
> Hi Alex,
Errh... It's "Axel".

> Yes,the default setting of SW2 ~SW4in the regulator array is 0.4V~1.975V
> (Bit6 clear),and my code will check the true setting of Bit6. If Bit6=1
> I will change min_uV from 0.4V to 0.8V ,step from 25mV to 50mV as what
> hardware define. I don't think we should mix the two define as what you
> mean 0.4V~3.3V. Because for every pfuze100 chip, the voltage of SW2~SW4
> is 0.4V~1.975V or 0.8V~3.3V, not 0.4V~3.3V(from software view,Bit6 only
> readable).
Well, if Bit6 is read-only then current code make sense.

Regards,
Axel
