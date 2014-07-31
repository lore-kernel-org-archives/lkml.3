Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaGaNhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:37:52 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:35801 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaGaNht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:37:49 -0400
Message-ID: <53DA46A3.9080808@gmail.com>
Date: Thu, 31 Jul 2014 15:37:39 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Humberto Naves <hsnaves@gmail.com>
CC: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <ta.omasab@gmail.com>,
        Andreas Farber <afaerber@suse.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [PATCHv2 4/5] clk: samsung: exynos5410: Add fixed rate clocks
References: <1406805732-17372-1-git-send-email-hsnaves@gmail.com> <1406805732-17372-5-git-send-email-hsnaves@gmail.com> <53DA3C36.1040206@gmail.com> <CAEe5pB_7e_5YkpcuRvsaUg6vKfdu6C+XhwRYyY1uUGptxM5zkg@mail.gmail.com>
In-Reply-To: <CAEe5pB_7e_5YkpcuRvsaUg6vKfdu6C+XhwRYyY1uUGptxM5zkg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.07.2014 15:23, Humberto Naves wrote:
> Hi Tomasz,
> 
> I perfectly see your point.
> However my question was why you did you decide to postpone
> Sylwester's? Was there any specific reason?
> I suppose it would break all the dtb compatibility, but besides that,
> was there any other reason?

We discussed this in private (we work in the same office) and I pointed
out certain issues with Sylwester's proposed implementation and we
agreed that one more revision of the patch is needed, but as it happens,
higher priority tasks showed up and this one got lost in action.

The first version of the patch [1] changed the original behavior
breaking DT ABI compatibility and relied on improper assumption that
those clocks are always in "fixed-rate-clocks" node. The thing is that
no code should rely on DT node naming.

Second version [2] was much better in this aspect, but it had some minor
implementation issues - custom clk_ops used instead of generic mux clock
and chipid block being constantly mapped and unmapped in every call to
__fin_pll_mux_get_parent().

I should have reviewed them both on the mailing lists, but at that time
there was no major activity related to Exynos4 outside of our office, so
it was more convenient to just talk together directly.

[1] http://www.spinics.net/lists/arm-kernel/msg333211.html
[2]
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/258490.html

Anyway, I don't think this is all relevant to Exynos5410, which just
uses the generic fixed rate binding and has the thing done right from
the start.

Best regards,
Tomasz

> 
> Best,
> Humberto
> 
> On Thu, Jul 31, 2014 at 2:53 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>> Hi Humberto,
>>
>> You can find my comments inline.
>>
>> On 31.07.2014 13:22, Humberto Silva Naves wrote:
>>> This implements the fixed rate clocks generated either inside or
>>> outside the SoC. It also adds a dt-binding constant for the
>>> sclk_hdmiphy clock, which shall be later used by other drivers,
>>> such as the DRM.
>>>
>>> Since the external fixed rate clock fin_pll is now registered by
>>> the clk-exynos5410 file, the bindings with the device tree file have
>>> changed. It is no longer needed to define fin_pll as a fixed clock,
>>> such as in:
>>>
>>>       fin_pll: xxti {
>>>               compatible = "fixed-clock";
>>>               clock-frequency = <24000000>;
>>>               clock-output-names = "fin_pll";
>>>               #clock-cells = <0>;
>>>       };
>>>
>>> The above lines should be replaced by the following lines:
>>>
>>>       fixed-rate-clocks {
>>>               oscclk {
>>>                       compatible = "samsung,exynos5410-oscclk";
>>>                       clock-frequency = <24000000>;
>>>               };
>>>       };
>>>
>>> This new form of binding was properly documented in the relevant
>>> documentation file.
>>
>> In general this is backwards. This Exynos-specific clock binding was
>> invented before generic fixed rate clock binding showed up and so few
>> drivers still use it to maintain DT ABI compatibility. However new
>> drivers are required to use the new generic binding and so does the one
>> for Exynos5410.
>>
>> Best regards,
>> Tomasz
