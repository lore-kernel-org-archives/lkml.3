Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbaCRNID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:08:03 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32386 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718AbaCRNH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:07:58 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-95-5328452bca73
Message-id: <53284527.8010903@samsung.com>
Date: Tue, 18 Mar 2014 14:07:51 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>,
        Cho KyongHo <pullip.cho@samsung.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 15/27] iommu/exynos: use convenient macro to handle
 gate clocks
References: <20140314140951.3d443a3096e80297c9fecef0@samsung.com>
 <5323078E.4060903@samsung.com>
 <CAK9yfHx_=Os1G46nNO1HDA3tigkRNeHKN1KGCvuN=w7dRTkfjg@mail.gmail.com>
 <20140318200329.cc1dca7541b4b1916e5d9d48@samsung.com>
 <CAK9yfHxcArgmxm4wSipY1afjmG00zugyycdU+BQbuexvL2bmBw@mail.gmail.com>
In-reply-to: <CAK9yfHxcArgmxm4wSipY1afjmG00zugyycdU+BQbuexvL2bmBw@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42I5/e/4NV1tV41gg1krNSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7Bb/eg8yWkxZdJjV4vCb
	dlaLk396GS1m3lrD4sDv8eTgPCaP2Q0XWTz+He5n8rhzbQ+bx+Yl9R6Tbyxn9OjbsorR4/Mm
	OY8rR88wBXBGcdmkpOZklqUW6dslcGWcP/abqWCFYMXcz19ZGhjP8nYxcnJICJhIvN3xihXC
	FpO4cG89WxcjF4eQwFJGiZWbrzFDOJ8ZJf61fwFyODh4BbQkev7mgzSwCKhK/Dr/kBnEZhNQ
	k/jc8IgNxOYHKlnTdJ0FxBYViJCYO3EzWJxXQFDix+R7YHERgQCJE7+XgM1nFrjOIvHs+C52
	kISwQKTE3u4OqMUrmCS+7d8Bdh6nQLDEin9zmUBsZgFriZWTtjFC2PISm9e8ZZ7AKDgLyZJZ
	SMpmISlbwMi8ilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMk6r7uYFx6zOoQowAHoxIP70s2
	9WAh1sSy4srcQ4wSHMxKIrzsVhrBQrwpiZVVqUX58UWlOanFhxiZODilGhglG0O3qWX3X7Pc
	bNoi+PXVz4UTwp9L3+y6dvAoq19BMhvraRGfozrqTVqb327J2XVjunCRm9/y972a7yWZz+27
	xyhQnP34mq6LmobbldXzRQuYbijHChlPlj27NOy6hNFMo/4z26cETFwvt6gm8UqIY+6++PKV
	u1vLl86Pt5wRpPr07IHX1xcrsRRnJBpqMRcVJwIAE+xL4ZgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.03.2014 12:18, Sachin Kamat wrote:
> On 18 March 2014 16:33, Cho KyongHo <pullip.cho@samsung.com> wrote:
>> On Fri, 14 Mar 2014 22:27:59 +0530, Sachin Kamat wrote:
>>>   Hi KyongHo,
>>>
>>> On 14 March 2014 19:13, Tomasz Figa <t.figa@samsung.com> wrote:
>>>> Hi KyongHo,
>>>>
>>>>
>>>> On 14.03.2014 06:09, Cho KyongHo wrote:
>>>>>
>>>>> exynos-iommu driver must care about master H/W's gate clock as well as
>>>>> System MMU's gate clock. To enhance readability of the source code,
>>>>> macros to gate/ungate those clocks are defined.
>>>>>
>>>>> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
>>>>> ---
>>>>>    drivers/iommu/exynos-iommu.c |   34 ++++++++++++++++++++++------------
>>>>>    1 file changed, 22 insertions(+), 12 deletions(-)
>>>>>
>>>>> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
>>>>> index 71e77f1..cef62d0 100644
>>>>> --- a/drivers/iommu/exynos-iommu.c
>>>>> +++ b/drivers/iommu/exynos-iommu.c
>>>>> @@ -101,6 +101,16 @@
>>>>>    #define REG_PB1_SADDR         0x054
>>>>>    #define REG_PB1_EADDR         0x058
>>>>>
>>>>> +#define __clk_gate_ctrl(data, clk, en) do {            \
>>>>> +               if (data->clk)                          \
>>>>> +                       clk_##en##able(data->clk);      \
>>>>> +       } while (0)
>>>>> +
>>>>> +#define __sysmmu_clk_enable(data)      __clk_gate_ctrl(data, clk, en)
>>>>> +#define __sysmmu_clk_disable(data)     __clk_gate_ctrl(data, clk, dis)
>>>>> +#define __master_clk_enable(data)      __clk_gate_ctrl(data, clk_master,
>>>>> en)
>>>>> +#define __master_clk_disable(data)     __clk_gate_ctrl(data, clk_master,
>>>>> dis)
>>>>> +
>>>>
>>>>
>>>> I'd say that such macros only obfuscate code, without any gains, as you can
>>>> see in diffstat - this patch adds more lines than it removes.
>>>>
>>>> Please drop this change.
>>>
>>>   I agree with Tomasz here.
>>>
>>
>> Are you concerning about using macros or more insertions than deletions?
>
> It is just making the code more difficult to read and understand.

Especially when hiding accesses to struct fields inside and doing fancy 
stuff like concatenations.

Best regards,
Tomasz
