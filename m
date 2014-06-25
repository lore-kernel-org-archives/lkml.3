Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbaFYKvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:51:11 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:65422 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbaFYKvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:51:08 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-cb-53aaa99a3e94
Message-id: <53AAA982.9050308@samsung.com>
Date: Wed, 25 Jun 2014 12:50:42 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Mike Turquette'" <mturquette@linaro.org>,
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
In-reply-to: <026001cf9061$5fef9d00$1fced700$@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsVy+t/xy7qzVq4KNpi9k89i6sMnbBaP5j9m
	tuhdcJXNYtPja6wWl3fNYbOYcX4fk8XaI3fZLZZev8hk8XTCRTaLRVu/sFtMWXSY1aJ17xF2
	i8Nv2lktVu36w+jA57Fm3hpGj0Xfszx2zrrL7rFpVSebx51re9g8Ni+p9+jbsorR4/MmuQCO
	KC6blNSczLLUIn27BK6MLcdKC+7zVvRse8TUwLiNq4uRk0NCwERi68uJ7BC2mMSFe+vZuhi5
	OIQEljJK3Nt4iRnC+cwo8erZDxaQKl4BLYnHt/vAOlgEVCXaZn9jA7HZBNQkPjc8ArP5gWrW
	NF0HqufgEBWIkHh8QQiiVVDix+R7YGNEBDwlPpw/ATafWeANs8SkLf1gM4UFfCUO7ZwJViQk
	UCRxecJVVhCbU8BKomH3J0YQm1lAR2J/6zQ2CFteYvOat8wTGAVnIdkxC0nZLCRlCxiZVzGK
	ppYmFxQnpeca6RUn5haX5qXrJefnbmKERNfXHYxLj1kdYhTgYFTi4Q3gWRUsxJpYVlyZe4hR
	goNZSYTXcQ5QiDclsbIqtSg/vqg0J7X4ECMTB6dUA2PU2c7dS45djj/edKp5TX/sNKsrvVaH
	BV/u5YyvzPfQ3/Xgc3zU887ah0bv8tvtv9Xt+n783I4nRv3pis8/1ewV1Xgzr+XzC09Nj3t7
	7UOLBFI+a93t3M23VIit9Pt1LQVWFz7VbbOOlMTaOQbbMXl37IprkG3MVJi8WiS8N3Hae+kO
	8dyVwUosxRmJhlrMRcWJADV1BYCMAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

On 25.06.2014 12:36, Kukjin Kim wrote:
> Tomasz Figa wrote:
>>
> Hi Tomasz,
> 
>> On all Exynos SoCs there is a dedicated CLKOUT pin that allows many of
>> internal SoC clocks to be output from the SoC. The hardware structure
> 
> Yeah, because the CLKOUT pin is used for measure of the clock for debug on all
> of exynos SoCs commonly.
> 
>> of CLKOUT related clocks looks as follows:
>>
>> 	CMU	|---> clock0 --------->	|	PMU	|
>> 		|			|		|
>>     several	|---> clock1 ---------> |	mux	|
>>     muxes	|			|	+	|---> CLKOUT
>>     dividers	|       ...		|	gate	|
>>     and gates	|			|		|
>> 		|---> clockN ---------> |		|
>>
>> Since the block responsible for handling the pin is PMU, not CMU,
>> a separate driver, that binds to PMU node is required and acquires
>> all input clocks by standard DT clock look-up. This way we don't need
>> any cross-IP block drivers and cross-driver register sharing or
>> nodes for fake devices.
>>
> BTW, upcoming exynos5 SoCs have two muxs for CLKOUT and each mux is controlled
> by CMU and PMU, so
> 
> The mux1 for CLKOUT in CMU is used to decide which clock in each sub-domain
> will be out and the mux2 in PMU is used to decide which sub-domain will be out
> via CLKOUT. So I want you to consider of all of exynos SoCs including upcoming
> SoCs.

Is it something similar to what I implemented for Exynos4 in patch 2/4?
The same has to be done for other Exynos SoCs as well, but i don't have
any board on which I could test this, so I just added a subset of
available inputs of PMU mux in current implementation.

Anyway, anything in CMU can be handled in normal SoC clock driver, so I
don't think this poses any problem for this series.

Best regards,
Tomasz
