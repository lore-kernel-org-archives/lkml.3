Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbbAOKEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:04:08 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:44693 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbbAOKEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:04:05 -0500
MIME-Version: 1.0
In-Reply-To: <1421313626.19448.8.camel@AMDC1943>
References: <1421054585-9032-1-git-send-email-k.kozlowski@samsung.com>
	<CAPDyKFpGiaDJ3zjCSSbcia6iLS2+FLBRjGAheQAzvFsAkJax+A@mail.gmail.com>
	<1421313626.19448.8.camel@AMDC1943>
Date: Thu, 15 Jan 2015 11:04:04 +0100
Message-ID: <CAPDyKFqe7UxSrQxuvGw7UWFQhvX0NZ83rvLrAEMZFpA4n0GcNg@mail.gmail.com>
Subject: Re: [RFC 0/3] mmc: Add dynamic frequency scaling
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Chris Ball <chris@printf.net>, Jaehoon Chung <jh80.chung@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Kukjin Kim <kgene@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 January 2015 at 10:20, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:
> On czw, 2015-01-15 at 09:20 +0100, Ulf Hansson wrote:
>> + Mike, Stephen (Clock maintainers)
>>
>> On 12 January 2015 at 10:23, Krzysztof Kozlowski
>> <k.kozlowski@samsung.com> wrote:
>> > Hi,
>> >
>> >
>> > I would like to hear some comments about idea of scaling MMC clock
>> > frequency. The basic idea is to lower the clock when device is
>> > completely idle or not busy enough.
>>
>> We already have host drivers that implements runtime PM support.
>> Typically that would mean the clock will be gated once the device
>> becomes runtime PM suspended.
>>
>> Why should we decrease the frequency of an already gated clock?
>
> In case of idle state you're right that clkgate would be better. But
> what about finding a compromise between high performance (high
> frequency) and energy saving for different loads on MMC?

I guess a compromise could be beneficial for some SOC and use cases.
At least I remember, ST-Ericsson's UX500 SOC had such an out of tree
hack to track MMC load.

>
> The frequency scaling could help in that case. Anyway I should prepare
> some more benchmarks for such conditions.

Seems reasonable and please do!

Kind regards
Uffe
