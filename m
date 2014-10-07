Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbaJGX7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:59:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19964 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbaJGX7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:59:49 -0400
X-AuditID: cbfee68e-f79b46d000002b74-52-54347e73d6b9
Message-id: <54347E72.8010203@samsung.com>
Date: Wed, 08 Oct 2014 08:59:46 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>, Sonny Rao <sonnyrao@chromium.org>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Heiko Stuebner <heiko@sntech.de>, Seungwon Jeon <tgih.jun@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Eddie Cai <eddie.cai@rock-chips.com>, Addy Ke <addy.ke@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: dw_mmc: Reset DMA before enabling IDMAC
References: <1412618020-22278-1-git-send-email-sonnyrao@chromium.org>
 <CAD=FV=W-GW0c8m_5Oaet=ZhJJwmk4RWJ7QurcySB7T8YvKr6Sg@mail.gmail.com>
In-reply-to: <CAD=FV=W-GW0c8m_5Oaet=ZhJJwmk4RWJ7QurcySB7T8YvKr6Sg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsWyRsSkRLe4ziTEYN4vCYtl/78zWZxddpDN
	4sukk6wW/x+9ZrXY9Pgaq8XlXXPYLI7872e0eHJmJqPFh/sXmS2Orw134PKY3XCRxePOtT1s
	HpuX1Hv8nbWfxaNvyypGj+3X5jF7fN4kF8AexWWTkpqTWZZapG+XwJXRcES64CxbxetWlgbG
	daxdjJwcEgImEmee3WeEsMUkLtxbz9bFyMUhJLCUUeLq/a/MMEUH7sxkhEgsYpTYvHExC4Tz
	mlHi6zGQFk4OXgEtib0rroKNZRFQlfi5o5EFxGYT0JHY/u04E4gtKhAmcahtHhNEvaDEj8n3
	wGpEBHwkHh5eBbaNWaCTWeLyJ0MQW1jAUWLC0VYmiGU9jBKbVu8EK+IUCJY4PWEWVIO6xKR5
	i6BseYnNa94ygzRICLxkl2j+fp0N4iIBiW+TDwFt4wBKyEpsOgD1mqTEwRU3WCYwis1CctMs
	JGNnIRm7gJF5FaNoakFyQXFSepGRXnFibnFpXrpecn7uJkZglJ7+96xvB+PNA9aHGAU4GJV4
	eFdoGYcIsSaWFVfmHmI0BbpiIrOUaHI+MBXklcQbGpsZWZiamBobmVuaKYnzJkj9DBYSSE8s
	Sc1OTS1ILYovKs1JLT7EyMTBKdXAODeer8ZOKHTm+xSLLflxzFc2v7OaeH2ZdNIeI7Uvkxem
	MEXMXn1ixs5Hx3/zc1148GJpxpn82glTIkqWcN7n/6z9ZGmy3pRXLfp/33Ec7f0sHD2dd9uK
	6mUSB2oO/WJpjH3oct/9UPKb6/l3O5kF792Ptn+bJv4s8uJJx+9Pn5f0piuoOp78slKJpTgj
	0VCLuag4EQDNDXdqzQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+xgG5xnUmIwe4/AhbL/n9nsji77CCb
	xZdJJ1kt/j96zWqx6fE1VovLu+awWRz5389o8eTMTEaLD/cvMlscXxvuwOUxu+Eii8eda3vY
	PDYvqff4O2s/i0ffllWMHtuvzWP2+LxJLoA9qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7U
	zMBQ19DSwlxJIS8xN9VWycUnQNctMwfoPCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFB
	cD1GBmggYQ1jRsMR6YKzbBWvW1kaGNexdjFyckgImEgcuDOTEcIWk7hwbz1bFyMXh5DAIkaJ
	zRsXs0A4rxklvh4DyXBy8ApoSexdcRWsm0VAVeLnjkYWEJtNQEdi+7fjTCC2qECYxKG2eUwQ
	9YISPybfA6sREfCReHh4FTOIzSzQySxx+ZMhiC0s4Cgx4WgrE8SyHkaJTat3ghVxCgRLnJ4w
	C6pBXWLSvEVQtrzE5jVvmScwCsxCsmMWkrJZSMoWMDKvYhRNLUguKE5KzzXSK07MLS7NS9dL
	zs/dxAhOAc+kdzCuarA4xCjAwajEw7tCyzhEiDWxrLgy9xCjBAezkghvZLRJiBBvSmJlVWpR
	fnxRaU5q8SFGU2AQTGSWEk3OB6anvJJ4Q2MTMyNLI3NDCyNjcyVx3oOt1oFCAumJJanZqakF
	qUUwfUwcnFINjOk2C2e1yKyZcI1p+fJNvzwem+sE7hdsWem+YMKFx0V3g1bzlLDeKDtfPn+N
	ean5jT/8/6v2O7hveWjj08Pew6sZe9a+5wO3/cn3ca73Dz0WrfeV6NLwebD/zO5fS5cJ75IK
	fizfGjLh/8Jt9XxtXN5Ftr4xF12quiy9k3dXxE2p1Hs+X/jreSWW4oxEQy3mouJEAHTQgU0X	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

On 10/07/2014 03:11 AM, Doug Anderson wrote:
> Sonny,
> 
> On Mon, Oct 6, 2014 at 10:53 AM, Sonny Rao <sonnyrao@chromium.org> wrote:
>> We've already got a reset of DMA after it's done.  Add one before we
>> start DMA too.  This fixes a data corruption on Rockchip SoCs which
>> will get bad data when doing a DMA transfer after doing a PIO transfer.
>>
>> We tested this on an Exynos 5800 with HS200 and didn't notice any
>> difference in sequential read throughput.
>>
>> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>>  drivers/mmc/host/dw_mmc.c | 4 ++++
>>  1 file changed, 4 insertions(+)
> 
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Doug Anderson <dianders@chromium.org>
> 

