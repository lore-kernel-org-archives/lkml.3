Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaGHOEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:04:54 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:64628 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaGHOEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:04:52 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-b5-53bbfa813df1
Message-id: <53BBFA61.1030602@samsung.com>
Date: Tue, 08 Jul 2014 16:04:17 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Pankaj Dubey'" <pankaj.dubey@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Mark Brown'" <broonie@kernel.org>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Daniel Drake'" <drake@endlessm.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>
Subject: Re: [PATCH v2 0/4] Add support for Exynos clock output configuration
References: <1403626107-12073-1-git-send-email-t.figa@samsung.com>
 <026001cf9061$5fef9d00$1fced700$@samsung.com>
 <20140703001452.7440.8476@quantum>
In-reply-to: <20140703001452.7440.8476@quantum>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsVy+t/xq7qNv3YHG+ybaGgx9eETNotH8x8z
	W/QuuMpmsenxNVaLy7vmsFnMOL+PyWLtkbvsFkuvX2SyeDrhIpvFoq1f2C2mLDrMatG69wi7
	xeE37awWq3b9YXTg81gzbw2jx6LvWR47Z91l99i0qpPN4861PWwem5fUe/RtWcXo8XmTXABH
	FJdNSmpOZllqkb5dAlfG1XXtbAU/hSsm3dzK2MC4nK+LkZNDQsBE4kXXCVYIW0ziwr31bF2M
	XBxCAksZJQ5fWMgM4XxmlHi6ex8LSBWvgJbE5scPgDo4OFgEVCUmt8uDhNkE1CQ+NzxiA7H5
	gUrWNF1nASkRFYiQeHxBCKJTUOLH5HtgYRGBYon7X8pBpjMLHGCWeDjxMDNIjbCAr8ShnTNZ
	INZOZ5TovreJHSTBKaAvsavpPNgJzALqEpPmLWKGsOUlNq95yzyBUXAWkh2zkJTNQlK2gJF5
	FaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZIdH3dwbj0mNUhRgEORiUeXoPzu4OFWBPLiitz
	DzFKcDArifB+OQUU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwMh0iaMz/0/qWo1nF/zFLts6neaZ
	oZs0oWWPKLfE2z26V9bMr+yK8ew33f3dYfbng62iCvsMnktlPt4Yr9gZqW5SdOP1z74tmXv3
	3+UwvTMrOotrvbaO1TvF88HftvxysLcWOaa7UvvNs4e3hYQFhfoLfjwusf36Ov3V75qt6rFp
	PYkB84K7OpVYijMSDbWYi4oTAUnYwReMAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.07.2014 02:14, Mike Turquette wrote:
> Quoting Kukjin Kim (2014-06-25 03:36:51)
>> Tomasz Figa wrote:
>>>
>> Hi Tomasz,
>>
>>> On all Exynos SoCs there is a dedicated CLKOUT pin that allows many of
>>> internal SoC clocks to be output from the SoC. The hardware structure
>>
>> Yeah, because the CLKOUT pin is used for measure of the clock for debug on all
>> of exynos SoCs commonly.
>>
>>> of CLKOUT related clocks looks as follows:
>>>
>>>       CMU     |---> clock0 ---------> |       PMU     |
>>>               |                       |               |
>>>     several   |---> clock1 ---------> |       mux     |
>>>     muxes     |                       |       +       |---> CLKOUT
>>>     dividers  |       ...             |       gate    |
>>>     and gates |                       |               |
>>>               |---> clockN ---------> |               |
>>>
>>> Since the block responsible for handling the pin is PMU, not CMU,
>>> a separate driver, that binds to PMU node is required and acquires
>>> all input clocks by standard DT clock look-up. This way we don't need
>>> any cross-IP block drivers and cross-driver register sharing or
>>> nodes for fake devices.
>>>
>> BTW, upcoming exynos5 SoCs have two muxs for CLKOUT and each mux is controlled
>> by CMU and PMU, so
>>
>> The mux1 for CLKOUT in CMU is used to decide which clock in each sub-domain
>> will be out and the mux2 in PMU is used to decide which sub-domain will be out
>> via CLKOUT. So I want you to consider of all of exynos SoCs including upcoming
>> SoCs.
> 
> clkout for debug is very useful indeed. For SoCs with high speed clocks
> that I have worked with, I have often observed that the clkout logic
> introduces buffers or dividers. This is needed so that you can get a
> (relatively) clean clock signal on your oscilloscope. Otherwise that
> 2GHz ARM clk is just going to be noise ;-)
> 
> These divider values can modeled in the clk framework. Do you know if
> you have such stuff on your chip?

I believe this is what I have already implemented in my series.

The final CLKOUT mux and gates are implemented by separate driver,
because they reside in another IP block, while per-domain CLKOUT
dividers along with muxes and gates are registered by normal SoC clock
driver, because they are part of the clock controller. See patch 2/4
adding the whole hierarchy for Exynos4 SoCs.

I don't have boards to test CLKOUT on Exynos5 SoCs, so they are up to
interested people.

Best regards,
Tomasz
