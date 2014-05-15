Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbaEOOHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:07:36 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58411 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbaEOOHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:07:33 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-52-5374ca210ffa
Message-id: <5374CA1C.8000207@samsung.com>
Date: Thu, 15 May 2014 16:07:24 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Rahul Sharma <rahul.sharma@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, sunil joshi <joshi@samsung.com>
Subject: Re: [PATCH 1/4] clk: samsung: out: Add infrastructure to register
 CLKOUT
References: <1399640410-30957-1-git-send-email-tushar.behera@linaro.org>
 <1399640410-30957-2-git-send-email-tushar.behera@linaro.org>
 <536DA243.6000600@samsung.com> <53705243.1030704@linaro.org>
 <CAPdUM4N=k-pPxdhPQgVHh0fb+nqkgs7StwM2Pb6C8gcjx6dw-w@mail.gmail.com>
In-reply-to: <CAPdUM4N=k-pPxdhPQgVHh0fb+nqkgs7StwM2Pb6C8gcjx6dw-w@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e/4NV3FUyXBBg++sFjMP3KO1aL/zUJW
	i3OvVjJafN/1hd2id8FVNotNj6+xWlzeNYfNYsb5fUwWS69fZLJ4OuEim8WirUAlE6avZbGY
	sugwq0Xr3iPsFu1/97I58HusmbeG0eNyXy+Tx8rlX9g8Nq3qZPO4c20Pm8fmJfUefVtWMXp8
	3iQXwBHFZZOSmpNZllqkb5fAlTFvTTtbwW3eilPXf7A3MH7g6mLk5JAQMJE4+nYNC4QtJnHh
	3no2EFtIYCmjxJwpoV2MXED2Z0aJNVtes4IkeAW0JM4suARWxCKgKjFl9x9GEJtNQE3ic8Mj
	sDg/UM2aputAQzk4RAUiJB5fEIJoFZT4Mfke2C4RgXCJLRuWMoPMZxZ4zCKxf89ysISwQLDE
	gX1zmSEW9zJJXP6xHGwoJ1Ci//FpsCJmAR2J/a3T2CBseYnNa94yT2AUnIVkySwkZbOQlC1g
	ZF7FKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERJrX3YwLj5mdYhRgINRiYe3Y39xsBBrYllx
	Ze4hRgkOZiUR3sbpJcFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGOv/mnUl71Xq93w77wfXTMuG
	l675npcvnJFOmHL4kUG2JFPNCuOfz2pKXBi478+bbpTkvLXmXNx7j75yI+6gDM9VCzY8u/Ku
	d2lWYE3BqqUGGt/N5k5s///yTtsuNwaX4ocKgXuM7ZPaXv4+u+VZ7JnZSwJOHV+h96Fh/daH
	8bnuS5gdHz5ima/EUpyRaKjFXFScCAAU7bxvkwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rahul, Tushar,

On 15.05.2014 15:44, Rahul Sharma wrote:
> Hi Tushar,
> 
> Basically you are adding a new clock-type for Clkout. IMO clkout
> is not a special hardware. Existing clock types can be reused to
> support clkout. I see 3 major problem here:
> 
> 1) Clkout -> (Mux + Gate). You clubbed mux and gate together, and
> exposing as a single clock which is something like a composite clock.
> IMO this is not a recommended way in CCF.
> 
> 2) New Clock Type: Since clkout is just a combination of a simple
> mux and gate which are already supported, it is a unnecessary
> duplication.
> 
> 3) Clkout registered along with CMU: which is not correct. Clkout is in PMU
> (Separate physical IP) and should be registered as a independent Clock
> provider which provides 1 mux and 1 gate clock (As if now). It should also be
> well connected with main CMU.
> 
> I understand the challenge in using regmap interface for a clock provider. But
> we need to identify a clean solution. IMHO a independent clock provider with
> iomap, is relatively cleaner approach till CCF is not ready with regmap based
> reg access for clock registers.
> 
> Experts!! please comment.

It's quite unfortunate that Tushar has duplicated the effort to create a
clkout driver, considering the fact that we did have such driver
internally at SRPOL and it was quite nice and simple.

I will post a cleaned-up version today, that is about 2 times smaller in
terms of lines of added code and provides the same functionality,
without introducing custom clock types. In addition, it models the
clkout properly as a feature of PMU, not CMU (CMU only provides outputs
of particular sub-blocks that are fed into the PMU).

Best regards,
Tomasz
