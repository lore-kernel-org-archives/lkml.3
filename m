Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaE3DwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 23:52:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40886 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbaE3DwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 23:52:07 -0400
Message-ID: <53880047.7070804@ti.com>
Date: Fri, 30 May 2014 09:21:35 +0530
From: Satish Patel <satish.patel@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v3 1/5] sc_phy:SmartCard(SC) PHY interface to SC controller
References: <1401267437-22489-1-git-send-email-satish.patel@ti.com>	<1401267437-22489-2-git-send-email-satish.patel@ti.com>	<20140528185334.GA30763@kroah.com>	<5386F0FE.7040003@ti.com> <CAL_Jsq+E7a=wh_yzQyaSEVAwfa34BYZ4DxvLOfJGFVDsf1dZ+A@mail.gmail.com>
In-Reply-To: <CAL_Jsq+E7a=wh_yzQyaSEVAwfa34BYZ4DxvLOfJGFVDsf1dZ+A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/29/2014 7:17 PM, Rob Herring wrote:
> On Thu, May 29, 2014 at 3:34 AM, Satish Patel <satish.patel@ti.com> wrote:
>>
>>
>> On 5/29/2014 12:23 AM, Greg KH wrote:
>>>
>>> On Wed, May 28, 2014 at 02:27:13PM +0530, Satish Patel wrote:
>>>>
>>>> SmartCard controller uses this interface to communicate with
>>>> SmartCard via PHY
>>>>
>>>> Some SmartCard PHY has multiple slots for cards.
>>>> This inerface also enables controller to communicate
>>>> with one or more SmartCard connected over phy.
>>>>
>>>> interface structure includes following APIs
>>>> - set/get config
>>>> - activate/deactivate smart card
>>>> - warm reset
>>>> - register_notify (for card insert/remove/overheat)
>>>> - unregister_notify
>>>>
>>>> Signed-off-by: Satish Patel <satish.patel@ti.com>
>>>> ---
>>>>    Documentation/sc_phy.txt |  171
>>>> ++++++++++++++++++++++++++++++++++++++++++++++
>>>>    include/linux/sc_phy.h   |  136 ++++++++++++++++++++++++++++++++++++
>>>>    2 files changed, 307 insertions(+)
>>>>    create mode 100644 Documentation/sc_phy.txt
>>>>    create mode 100644 include/linux/sc_phy.h
>>>
>>>
>>> These are .h files, but where is the "api" functions that use
>>> these structures defined at?
>>>
>> This is like template/wrappers, smart card phy driver will write API
>> functions. And smartcard controller will call these functions.
>> With proposed approach, smartcard controller can communicate with any smart
>> card phy (TI/NxP) without change in code. Using DT entry smartcard and PHY
>> will gets connected with each other.
>> Refer diagram given @Documentation/sc_phy.txt.
>>
>>
>>> confused,
>
> I believe the api Greg is wondering about is the notifier which as I
> commented is not a good design.
>
> There is now a phy subsystem. I don't know if it has what you need,
> but you should look at it to determine if it will work or could be
> extended to work.
>
I have given my comments on notifier, it is required to notify real time 
events like card insert/remove to the smart card controller. As this 
interrupts tied to phy (in case phy is present) not with controller.

Existing phy subsystem does not support generic operations for the phy. 
If at all it adds supports for these, in future I am ok to get align 
with it.

> Rob
>
