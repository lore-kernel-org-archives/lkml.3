Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbbAGRdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:33:32 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:11508 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbbAGRd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:33:29 -0500
X-IronPort-AV: E=Sophos;i="5.07,715,1413270000"; 
   d="scan'208";a="54496224"
Message-ID: <54AD6DE5.20601@broadcom.com>
Date: Wed, 7 Jan 2015 09:33:25 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Matt Porter <mporter@linaro.org>,
        Alex Elder <elder@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        "Scott Branden" <sbranden@broadcom.com>,
        <linux-kernel@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCH v2 4/5] clk: cygnus: add clock support for Broadcom Cygnus
References: <1420500076-18302-5-git-send-email-rjui@broadcom.com> <2048376.BFrtW5tszK@wuerfel> <54AC99F3.8040703@broadcom.com> <2938966.fY2WjearG6@wuerfel>
In-Reply-To: <2938966.fY2WjearG6@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/7/2015 1:11 AM, Arnd Bergmann wrote:
> On Tuesday 06 January 2015 18:29:07 Ray Jui wrote:
>> On 1/6/2015 12:21 PM, Arnd Bergmann wrote:
>>> On Monday 05 January 2015 15:21:15 Ray Jui wrote:
>>>> +static const struct iproc_asiu_gate asiu_gate[BCM_CYGNUS_NUM_ASIU_CLKS] = {
>>>> +	[BCM_CYGNUS_ASIU_KEYPAD_CLK] =
>>>> +		asiu_gate_val(0x0, 7),
>>>> +	[BCM_CYGNUS_ASIU_ADC_CLK] =
>>>> +		asiu_gate_val(0x0, 9),
>>>> +	[BCM_CYGNUS_ASIU_PWM_CLK] =
>>>> +		asiu_gate_val(IPROC_CLK_INVALID_OFFSET, 0),
>>>> +};
>>>
>>> Here I think a better binding would be to pass the gate value in the
>>> clock specifier, rather than an artificial index. That would let
>>> you get rid of the BCM_CYGNUS_ASIU_KEYPAD_CLK/BCM_CYGNUS_ASIU_ADC_CLK
>>> macros.
>>>
>> You meant to pass in both the gate register offset and its bit shift
>> through the clock specifier? But isn't the current ASIU clock code much
>> more consistent with the rest of the iProc clock code?
> 
> For simple devices that don't need an index macro, I would always
> prefer not defining them, because they are a pain to maintain.
> For a simple gate clock controller, we could compute both the offset
> and bit number from a single integer.
> 
> However, I now saw upon taking a closer look that the asiu has both
> a gate and a divider, and the latter one is not as simple, so
> my comment doesn't apply here.
> 
> 	Arnd
> 
Okay. I'll leave this as it is and make other changes based on the
review. Thanks!
