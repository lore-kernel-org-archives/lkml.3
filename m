Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372AbaKUMaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:30:07 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:37936 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbaKUMaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:30:02 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-f8-546f3046a665
Message-id: <546F3046.30209@samsung.com>
Date: Fri, 21 Nov 2014 21:29:58 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>, addy ke <addy.ke@rock-chips.com>
Cc: Doug Anderson <dianders@chromium.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "tgih.jun@samsung.com" <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Dinh Nguyen <dinguyen@altera.com>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Alexandru Stan <amstan@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org,
        "zhenfu.fang" <zhenfu.fang@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, lintao <lintao@rock-chips.com>,
        chenfen <chenfen@rock-chips.com>, zyf <zyf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Chris Zhong <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>, Lin Huang <hl@rock-chips.com>
Subject: Re: [PATCH] mmc: dw_mmc: try pick the exact same voltage as vmmc for
 vqmmc
References: <1415109789-7046-1-git-send-email-addy.ke@rock-chips.com>
 <1415678573-6093-1-git-send-email-addy.ke@rock-chips.com>
 <CAPDyKFqUoBjhsbz8rkLa9PY_dpgMxnimz3k7OoA5WVhi7MacPQ@mail.gmail.com>
 <CAD=FV=VQHZ6YmcoeAb1OEVLYRrYBnc_dM5Kjt1TZX_CQJC=EfA@mail.gmail.com>
 <5464152E.7040209@rock-chips.com>
 <CAPDyKFrzGfDew0eLLEcA+_iS_mo-O2bFU58fjirfXXA8AJ9UYQ@mail.gmail.com>
In-reply-to: <CAPDyKFrzGfDew0eLLEcA+_iS_mo-O2bFU58fjirfXXA8AJ9UYQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SW0xTWRSGs88+53DoQNx2xNkSbyHeYhwHtcia1BjjgzkxmpiIEC9RK3MC
	BihNC0RfFIkQqRELXhoRC8V6w0KxouBEBDo4XEaJbRXRYZDAZCQUYiOIyIi1F014+9de3/7X
	v5IlYPkgFy0cVmdJWrUqPYaXsdY5Cs3PW2IzE2LNb5fBdd9HBnKHSjjIPzXMw9Cldg4M7noE
	5a1dHDy93sJDm+sqhrMjZg58Ax4OHntesDBZ24mhruIjhq7hWwh6pgo4uG/8xEOZdz/YB7s5
	MBdYWHD/XsZDq+8sgvf9PgzXXjoZ6Hw5xoPBWM3CaK+RhfzG1jD498klBN43Tgxt1UlQUiGH
	KzUWHl4Xv/LzI0MYTv4/yEB5fwPetETMbzTwotVkReLlXCcruovOMOKtG+O8ePfmStFeVciL
	vd0P/ZXluPi8PY8Te4bNjDhd2sSKRXVVSKzvNmFxzL5wx6w9sg2/SemHcyTtLxsPylJrbY+w
	pkN2pOPBH1wusgl6FC5QoqCFrpqwkJ5Ln/XZeD2SCXJyDVFPZRn/HTK5T4SFGkZEq8ut3ygP
	okO3XcHvkWQFHa++wOmRILBkKTV35gSeebKK1k+0MQEdRRKpo8DEhPDZdPJcHxvQc8hW+vCG
	Cwc8Mcn7gTr1tiD0I9lFvYVNKDRsiqFfzp9HgUY42Ukb7k0HNSbLaYmpEof0InrXOhp0omQ4
	nDY/6g6mYwmhE+ccbCAdJQuovRmHVptHW272sAY0t3RGqNIZtqUzbCsQrkJRkiZZozuUolWs
	1qkydNnqlNXJmRl25L+9v778Z2hAfc1KByICiomI9BrVCXJOlaM7muFAcf4UxTg6KjnTf67q
	rANr1q1fC3GKuHVr439dH/NTpCf60045SVFlSWmSpJG0B7TZ6ZLOgRghPDoXXdS3Cg6tccnu
	5KK9/R+q3K+PvtvYMXXs7yRl1534sTR35Ynt5pHsBwWTJCljuke5beD54obmWlfTCmd+Xvxb
	JfnTxpki3rQxyvEXn/trajUTiXdaxuveFXG+xjDLKW6rfP6R1NOzBhSFoxFeXWa7pfefzb6p
	xGLi2/943+hsnothdamqNSuxVqf6CpBAWBB2AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLJsWRmVeSWpSXmKPExsVy+t9jQV03g/wQg5kHpCyW/f/OZNHwYhKr
	RWvHKzaLFzNPsFpMuLyd0WL+kXOsFmeXHWSzOH5pMbNF/5uFrBb/H71mtTj6+iqLxY8Np5gt
	tiz4zmxx7tVKRosbv9pYLbZN/8lmMedDnMWmx9dYLRa2LWGxuLxrDpvFkf/9jBafHvxntlh6
	/SKTxanrn9ksJkxfy2Lx9s50FovWvUfYLZ6cmclo8eH+RWaL42vDLSYtELKYu24Jm8WtiTeB
	6t+8YLZo+f2YyWL+gx3MDioerXsnsHmsmbeG0WN2w0UWj8t9vUweK5d/YfPYvELLY9OqTjaP
	O9f2AHlL6j2unGhi9bjxaiGTx99Z+1k8+rasYvTYfm0es8fnTXIB/FENjDYZqYkpqUUKqXnJ
	+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5wFBUUihLzCkFCgUkFhcr6dth
	mhAa4qZrAdMYoesbEgTXY2SABhLWMGZsWL+PueAkV8XJnYdZGxjXc3QxcnJICJhIzLvcyA5h
	i0lcuLeerYuRi0NIYDqjxNr5a6Cc14wSL1ZfAqviFdCQ+LJ2KmsXIwcHi4CqxMJTZSBhNgEd
	ie3fjjOB2KICYRKH2uYxQZQLSvyYfI8FxBYR8JLYs/wSM8hMZoEmbomLXevBioQFQiU+dO5n
	hFj2i0ni35QpjCAJToFgiR1b/4LZzALqEpPmLWKGsOUlNq95yzyBUWAWkiWzkJTNQlK2gJF5
	FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwUn0mtYNxZYPFIUYBDkYlHt4P0/NChFgTy4or
	cw8xSnAwK4nwlgvnhwjxpiRWVqUW5ccXleakFh9iNAUGwURmKdHkfGDCzyuJNzQ2MTOyNDI3
	tDAyNlcS571xMzdESCA9sSQ1OzW1ILUIpo+Jg1OqgVHV+3bGs72rruc8Wu6m76f5WPHLXac9
	k2ZPi/+6h0Ui4jPjimC2z2VOZ47UrLS5eF/hn1/L5rm/vSYEaR9wqzSLevTLuHL9bWWfPZzT
	p9ReODBpncKqGQl3PVKa1uxZULQ5Jy/MiE8n0mb26jfluqL7HV4rXqnz4+a5ahIRmdi05X6q
	UuCL+BtKLMUZiYZazEXFiQCK3X5qwAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2014 09:06 PM, Ulf Hansson wrote:
> [...]
> 
>> Sure
>> If the first card is sd2.0 since startup, dw_mci_switch_voltage will not be called,
> 
> That can't be right. mmc_power_up() should trigger
> dw_mci_switch_voltage() to be invoked.

Since dw_mci_switch_voltage() is invoked, voltage is changed from 1.8v to 2.7v (minimum value 2.7-3.6v), isn't?

> 
>> and card can be identified. But if UHS card is pulgged in first, the vqmmc will be down to 1.8v.
>>
>> when sd2.0 card is pulgged in, mmc core will call dw_mci_switch_voltage to change vqmmc to 3.3v
>> (MMC_SINGLE_VOTAGE_330). So vqmmc will be set 2.7v, if we request 2.7-3.6v.
>>
>> But vmmc is always 3.3v,becuase it be set min_volt = max_volt = 3.3v in dt tables.

vmmc is fixed voltage?

>>
>> So the result:
>> vmmc = 3.3v and vqmmc = 2.7v, and sd2.0 card is failed to identify in my test.
> 
> Hmm. I wonder why it works the first time? Could it be that your
> regulator have voltage ramp up time that isn't properly considered?

if oscilloscope can use, can we know more exactly?

Best Regards,
Jaehoon Chung
> 
> Kind regards
> Uffe
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

