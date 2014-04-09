Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbaDINdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:33:17 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16536 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781AbaDINdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:33:12 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-db-53454c154f8f
Message-id: <53454C11.7060607@samsung.com>
Date: Wed, 09 Apr 2014 15:33:05 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, kishon <kishon@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kamil Debski <k.debski@samsung.com>, Jingoo Han <jg1.han@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH V4 1/5] phy: Add new Exynos5 USB 3.0 PHY driver
References: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com>
 <1396967803-28868-2-git-send-email-gautam.vivek@samsung.com>
 <534529B2.2020107@samsung.com>
 <CAFp+6iEzaxCQNkGZWuBnAaAHk0uXrX4KhjVbaJfZFChB6uzk4A@mail.gmail.com>
In-reply-to: <CAFp+6iEzaxCQNkGZWuBnAaAHk0uXrX4KhjVbaJfZFChB6uzk4A@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t/xa7qiPq7BBps3ilkcvF9vMf/IOVaL
	tisH2S2aF69ns7i88BKrxY/XF9gsehdcZbO48LSHzWLT42usFgvblrBYXN41h81ixvl9TBaL
	lrUyW8z7vJPJgc9j56y77B77565h99i8pN6jb8sqRo/jN7YzeXzeJBfAFsVlk5Kak1mWWqRv
	l8CVsX/6PcaCjxIV/5eeZmtgXCPQxcjJISFgItH9bAUzhC0mceHeerYuRi4OIYGljBK3b/9m
	hnA+M0o0z7jOCFLFK6Al8fLvdhYQm0VAVaKj8Tg7iM0moCbxueERG4jND1Szpuk6WI2oQITE
	vcbDrBC9ghI/Jt8Di4sIaEtsnzuJFWQBs8A7FontrdPBFggLOEtcnrGEHWLze0aJ6xe/g23g
	FAiWOPv4IdgGZgFriZWTtjFC2PISm9e8ZZ7AKDgLyZJZSMpmISlbwMi8ilE0tTS5oDgpPddQ
	rzgxt7g0L10vOT93EyMknr7sYFx8zOoQowAHoxIPr4KlS7AQa2JZcWXuIUYJDmYlEd677q7B
	QrwpiZVVqUX58UWlOanFhxiZODilGhj51y/9XyDCtesXk9ECZguloy4x6TfPN12TnKr2Ks6J
	VeatnsTTzuw67WdSl8/qmYSJXV2Yq2WTXzr9VMGvUwZ70qb/KGbl3xq9zmfZGtNg92U+HpZC
	PMsmCsq9d8qaGun/31Nr1quXwjozl7mI5VYurPmsXr9Io9Pj7Nbozw5ht18dPX1kpZwSS3FG
	oqEWc1FxIgAeQlTihQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.04.2014 13:49, Vivek Gautam wrote:
> Hi,
>
>
> On Wed, Apr 9, 2014 at 4:36 PM, Tomasz Figa <t.figa@samsung.com> wrote:
>> Hi Vivek,
>>
>> Please see my comments inline.
>>
>>
>> On 08.04.2014 16:36, Vivek Gautam wrote:
>>>
>>> Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
>>> The new driver uses the generic PHY framework and will interact
>>> with DWC3 controller present on Exynos5 series of SoCs.
>>> Thereby, removing old phy-samsung-usb3 driver and related code
>>> used untill now which was based on usb/phy framework.
>>>
>>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>>> ---
>>>    .../devicetree/bindings/phy/samsung-phy.txt        |   42 ++
>>>    drivers/phy/Kconfig                                |   11 +
>>>    drivers/phy/Makefile                               |    1 +
>>>    drivers/phy/phy-exynos5-usbdrd.c                   |  668
>>> ++++++++++++++++++++
>>>    4 files changed, 722 insertions(+)
>>>    create mode 100644 drivers/phy/phy-exynos5-usbdrd.c
>>
>>
>> [snip]
>>
>>
>>> +       Additional clock required for Exynos5420:
>>> +       - usb30_sclk_100m: Additional special clock used for PHY operation
>>> +                          depicted as 'sclk_usbphy30' in CMU of
>>> Exynos5420.
>>
>>
>> Are you sure this isn't simply a gate for the ref clock, as it can be found
>> on another SoC that is not upstream yet? I don't have documentation for
>> Exynos 5420 so I can't tell, but I'd like to ask you to recheck this.
>
>>From what i can see in the manual :
> sclk_usbphy30 is derived from OSCCLK.
> It is coming from a MUX (default input line to this is OSCCLK)  and
> then through a DIV
> there's this gate.
>
>        {OSCCLK  + other sources} --->[MUX] ---> [DIV] --> [GATE for
> sclk_usbphy30]
>
> the {rate of sclk_usbphy30} == OSCCLK
>
> However the 'ref' clock that we have been using is the actual oscillator clock.
> And on SoC Exynos5250, we don't have any such gate (sclk_usbphy30).
> So should this mean that ref clock and sclk_usbphy30 are still be controlled by
> two different gates ?
>

Is there maybe a diagram of PHY input clocks in the datasheet, like for 
USB 2.0 PHY in Exynos4210/4412/5250 datasheets in the chapter about 
USB2.0 Device? Something like:

                      ____________________________________
                     |                                    |
                     |                         ___________|
XusbXTI             |   Phy_fsel[2:0]        |  _______  |
    _______[X]_______|    |         __________|_|___|\__|_|
   |                 |   _v___     |  _____   ^ |   |/  | |
_____               |  |     |    | |     |  | |  ___  | |
  ___                |  |     |    | |     |  | | |   |_|_|
|___|               |  | X 0 |____|_| PLL |__|_|_|CLK|_|_|
_____               |  |     |      |     |    | |DIV|_|_|
   |_______[X]       |  |_____| 12   |_____|480 | |___| | |
                     |          MHz         MHz |Digital| |
XusbXTO             |   USB PHY                |_______| |
                     |____________________________________|


Best regards,
Tomasz
