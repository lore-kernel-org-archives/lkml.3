Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab3LSTmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:42:24 -0500
Received: from 4.mo6.mail-out.ovh.net ([87.98.184.159]:60785 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755513Ab3LSTmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:42:21 -0500
Message-ID: <52B34BE3.7000208@overkiz.com>
Date: Thu, 19 Dec 2013 20:41:23 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, Rob Landley <rob@landley.net>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaQ==?= =?UTF-8?B?Zw==?= 
	<u.kleine-koenig@pengutronix.de>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 1/2] clk: add clk accuracy retrieval support
References: <1387290983-6236-1-git-send-email-b.brezillon@overkiz.com> <1387290983-6236-2-git-send-email-b.brezillon@overkiz.com> <20131219060431.18119.64699@quantum> <52B2B42F.9010202@overkiz.com> <20131219193633.18119.57678@quantum>
In-Reply-To: <20131219193633.18119.57678@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 5461177500003694620
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 19/12/2013 20:36, Mike Turquette a écrit :
> Quoting boris brezillon (2013-12-19 00:54:07)
>> Hello Mike,
>>
>> On 19/12/2013 07:04, Mike Turquette wrote:
>>> Quoting Boris BREZILLON (2013-12-17 06:36:22)
>>>> +unsigned long __clk_get_accuracy(struct clk *clk)
>>>> +{
>>>> +       unsigned long ret;
>>>> +
>>>> +       if (!clk)
>>>> +               return 0;
>>>> +
>>>> +       return clk->accuracy;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(__clk_get_accuracy);
>>> Any reason for exporting this?
>> This might be used by clk drivers to choose the most accurate clk
>> among its parent clks (within the determinate_rate callback).
>>
>> And as some clk drivers might be compiled as modules we need
>> to export the symbol (__clk_get_name helper function is exported
>> too).
> Does your driver need this or is this just following the existing
> __clk_get_rate / clk_get_rate model?

No, I don't need this for my driver, at least for the moment.

Do you want me to drop this EXPORT_SYMBOL ?
>
> Regards,
> Mike
>
>> Best Regards,
>>
>> Boris
>>> Regards,
>>> Mike
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

