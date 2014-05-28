Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbaE1MuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 08:50:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39746 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287AbaE1MuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 08:50:20 -0400
Message-ID: <5385DB42.8030900@ti.com>
Date: Wed, 28 May 2014 07:49:06 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tero Kristo <t-kristo@ti.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, Mike Turquette <mturquette@linaro.org>,
        =?UTF-8?B?QmVub8OudCBDb3Vzc29u?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Paul <paul@pwsan.com>
Subject: Re: [PATCH 0/3] ARM: OMAP5+: Support Duty Cycle Correction(DCC)
References: <1400237160-25125-1-git-send-email-nm@ti.com> <20140523210720.23136.65858@quantum> <5382DFE8.1080104@ti.com>
In-Reply-To: <5382DFE8.1080104@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 26 May 2014 01:32:08 AM CDT, Tero Kristo wrote:
> On 05/24/2014 12:07 AM, Mike Turquette wrote:
>> Quoting Nishanth Menon (2014-05-16 03:45:57)
>>> Hi,
>>>
>>> This patch series has been carried over in vendor kernel for quiet
>>> few years now.
>>>
>>> Unfortunately, it was very recently re-discovered and upstream kernel
>>> is noticed to be broken for OMAP5 1.5GHz - at least we are operating
>>> DPLL at frequency higher than what it was intended to be when CPUFreq
>>> is enabled. Thankfully, with nominal voltage(we dont use AVS yet in
>>> upstream for the mentioned platforms) and margins in trimming, we
>>> have so far not crashed - but I strongly suspect this might be some
>>> boundary case survival.
>>
>> DCC also exists in OMAP4. In some cases customers used it, in other
>> cases we just ran the PLL way out of spec and the mpu_clk would divide
>> by 2.
>>
>> Is this broken for OMAP4 as well?
>
> Yes, its broken. This series does not address the OMAP4 needs for it,
> but can be expanded later by just defining a proper clock type with
> OMAP4 specific DCC rate limits etc. for it. We would need properly
> functioning DVFS for OMAP4 panda first though I guess... (support for
> the TPS regulator.)

Panda does not need DCC. Panda uses 4430 and Panda-ES uses 4460. 
neither of which need DCC (DPLLs are trimmed for required frequencies 
there) - 4430 never had DCC, 4460 had broken DCC. 4470 (which is not 
upstream and does not have a panda variant) is the only one needing DCC 
at higher frequencies, and that needs an entirely different 
scheme(compared to OMAP5+) as mentioned by Tero if 4470 ever gets 
supported upstream.

--
Regards,
Nishanth Menon

