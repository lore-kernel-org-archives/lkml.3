Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161743AbaDPOtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:49:22 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:54567 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161406AbaDPOtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:49:17 -0400
MIME-Version: 1.0
In-Reply-To: <534E892B.6090409@samsung.com>
References: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com>
	<1396967803-28868-2-git-send-email-gautam.vivek@samsung.com>
	<534529B2.2020107@samsung.com>
	<CAFp+6iEzaxCQNkGZWuBnAaAHk0uXrX4KhjVbaJfZFChB6uzk4A@mail.gmail.com>
	<53454C11.7060607@samsung.com>
	<CAFp+6iHU0YXj18ajDwOqPh_SJWr6GkMPRr6qaGdmPoCc0+tz5g@mail.gmail.com>
	<CAFp+6iH7-O8pNNMrk7Yhg1u+DXcXD1Tp9RYdiFg+-Om5Toojfw@mail.gmail.com>
	<534E892B.6090409@samsung.com>
Date: Wed, 16 Apr 2014 20:19:16 +0530
X-Google-Sender-Auth: QT30T7hr6Wq1y1uPA-wVmyZHJlc
Message-ID: <CAFp+6iGYfz+ZT9zxgeVefLhtb0mb-=K4faUZC+1FtQoO0hMoqw@mail.gmail.com>
Subject: Re: [PATCH V4 1/5] phy: Add new Exynos5 USB 3.0 PHY driver
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Wed, Apr 16, 2014 at 7:14 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Vivek,
>
>
> On 15.04.2014 08:09, Vivek Gautam wrote:
>>
>> Hi Tomasz,
>>
>>
>> On Thu, Apr 10, 2014 at 5:09 PM, Vivek Gautam <gautamvivek1987@gmail.com>
>> wrote:
>>>
>>> On Wed, Apr 9, 2014 at 7:03 PM, Tomasz Figa <t.figa@samsung.com> wrote:
>>>>
>>>> On 09.04.2014 13:49, Vivek Gautam wrote:
>>>>>
>>>>>
>>>>> Hi,
>>>>>
>>>>>
>>>>> On Wed, Apr 9, 2014 at 4:36 PM, Tomasz Figa <t.figa@samsung.com> wrote:
>>>>>>
>>>>>>
>>>>>> Hi Vivek,
>>>>>>
>>>>>> Please see my comments inline.
>>>>>>
>>>>>>
>>>>>> On 08.04.2014 16:36, Vivek Gautam wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
>>>>>>> The new driver uses the generic PHY framework and will interact
>>>>>>> with DWC3 controller present on Exynos5 series of SoCs.
>>>>>>> Thereby, removing old phy-samsung-usb3 driver and related code
>>>>>>> used untill now which was based on usb/phy framework.
>>>>>>>
>>>>>>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>>>>>>> ---
>>>>>>>     .../devicetree/bindings/phy/samsung-phy.txt        |   42 ++
>>>>>>>     drivers/phy/Kconfig                                |   11 +
>>>>>>>     drivers/phy/Makefile                               |    1 +
>>>>>>>     drivers/phy/phy-exynos5-usbdrd.c                   |  668
>>>>>>> ++++++++++++++++++++
>>>>>>>     4 files changed, 722 insertions(+)
>>>>>>>     create mode 100644 drivers/phy/phy-exynos5-usbdrd.c
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> [snip]
>>>>>>
>>>>>>
>>>>>>> +       Additional clock required for Exynos5420:
>>>>>>> +       - usb30_sclk_100m: Additional special clock used for PHY
>>>>>>> operation
>>>>>>> +                          depicted as 'sclk_usbphy30' in CMU of
>>>>>>> Exynos5420.
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> Are you sure this isn't simply a gate for the ref clock, as it can be
>>>>>> found
>>>>>> on another SoC that is not upstream yet? I don't have documentation
>>>>>> for
>>>>>> Exynos 5420 so I can't tell, but I'd like to ask you to recheck this.
>>>>>
>>>>>
>>>>>
>>>>>>  From what i can see in the manual :
>>>>>
>>>>>
>>>>> sclk_usbphy30 is derived from OSCCLK.
>>>>> It is coming from a MUX (default input line to this is OSCCLK)  and
>>>>> then through a DIV
>>>>> there's this gate.
>>>>>
>>>>>         {OSCCLK  + other sources} --->[MUX] ---> [DIV] --> [GATE for
>>>>> sclk_usbphy30]
>>>>>
>>>>> the {rate of sclk_usbphy30} == OSCCLK
>>>>>
>>>>> However the 'ref' clock that we have been using is the actual
>>>>> oscillator
>>>>> clock.
>>>>> And on SoC Exynos5250, we don't have any such gate (sclk_usbphy30).
>>>>> So should this mean that ref clock and sclk_usbphy30 are still be
>>>>> controlled by
>>>>> two different gates ?
>>>>>
>>>>
>>>> Is there maybe a diagram of PHY input clocks in the datasheet, like for
>>>> USB
>>>> 2.0 PHY in Exynos4210/4412/5250 datasheets in the chapter about USB2.0
>>>> Device? Something like:
>>>>
>>>>                       ____________________________________
>>>>                      |                                    |
>>>>                      |                         ___________|
>>>> XusbXTI             |   Phy_fsel[2:0]        |  _______  |
>>>>     _______[X]_______|    |         __________|_|___|\__|_|
>>>>    |                 |   _v___     |  _____   ^ |   |/  | |
>>>> _____               |  |     |    | |     |  | |  ___  | |
>>>>   ___                |  |     |    | |     |  | | |   |_|_|
>>>> |___|               |  | X 0 |____|_| PLL |__|_|_|CLK|_|_|
>>>> _____               |  |     |      |     |    | |DIV|_|_|
>>>>    |_______[X]       |  |_____| 12   |_____|480 | |___| | |
>>>>                      |          MHz         MHz |Digital| |
>>>> XusbXTO             |   USB PHY                |_______| |
>>>>                      |____________________________________|
>>>>
>>>>
>>>
>>> Below is the block diagram given for DRD controller.
>>>
>>> ___________________
>>> |                                |
>>> |      ____________     |
>>> |      | PHY           |      |
>>> |      | controller
>>> |-----|-----------------------------------------------
>>> |      |__________  |     |
>>> |
>>> |                                |
>>>            |
>>> |         USB 3.0           |
>>> V
>>> |           DRD              |
>>> -----------------------
>>> |        Controller          |                                      |
>>>                       |
>>> |                                |    USB30_SCLK_100M    | USB 3.0 DRD  |
>>> |      ----------------          |           ----------------------->
>>> |       PHY         |
>>> |     | Link cont. |         |                                      |
>>>                       |
>>> |      -------------             |
>>>   |                       |
>>> |___________________|                                     |_____________|
>>>
>>> Does this help ?
>>>
>>> So, USB30_SCLK_100M is the SCLK that we are talking in the driver. I
>>> don't see any reference to XXTI in the USB 3.0 DRD controller chapter
>>> (in both Exynos5250 and 5420)
>>> In addition to this there's one more point to be noticed here.
>>> On Exynos5420 system, the sclk_usbphy300 (which is the sclk_usbphy30
>>> for USB DRD channel 0), is also the PICO phy clock, i.e. USB 2.0 phy
>>> clock.
>>> So we should add a similar clk_get() for this clock in the
>>> phy-exynos5250-usb2 driver too, to support Exynos5420.
>>
>>
>> Is something clear from the above block diagram ? (although the
>> diagram looks weird - space and tabs problem :-(  )
>> Basically there's the clock USB30_SCLK_100M which is going into the
>> USB 3.0 DRD PHY controller.
>> And this is the only sclk mentioned in the block diagram for USB 3.0
>> DRD controller in Exynos5420.
>> Same is not there in the block diagram in Exynos5250 UM.
>
>
> From what I can see in the documentation, there are 4 USB 3.0 related clocks
> generated in CMU:
>
>  - sclk_usbphy300,
>  - sclk_usbphy301,
>  - sclk_usbdrd300,
>  - sclk_usbdrd301,
>
> They are all rated to max. 24 MHz and the recommended operating frequency is
> 24 MHz, so it looks exactly like USB PHY reference, which is usually a 24
> MHz clock.
>
> To me, this looks like on Exynos5420 a separate special clock path is used
> instead of xusbxti as reference of USB 3.0 PHY and so the sclk should be
> simply passed as the "ref" clock.

Ok, i will clear on this with the hardware engineer also once.
May be Jingoo can help me with this.

Jingoo,
Can you please enquire about the clock path of usbphy30 reference
clocks on Exynos5420.
As mentioned by Tomasz above, we have sclk_usbphy300 and
sclk_usbphy301 as the reference clocks for USB3.0 DRD phy. *Also*
sclk_usbphy300 is used for Pico phy (which is the USb 2.0 phy used by
ehci/ohci controller on Exynos5420).
It will be of great help.


Thanks
Vivek
