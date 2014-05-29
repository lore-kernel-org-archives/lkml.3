Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086AbaE2Nre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:47:34 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:53683 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932646AbaE2Nrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:47:32 -0400
MIME-Version: 1.0
In-Reply-To: <5386F0FE.7040003@ti.com>
References: <1401267437-22489-1-git-send-email-satish.patel@ti.com>
	<1401267437-22489-2-git-send-email-satish.patel@ti.com>
	<20140528185334.GA30763@kroah.com>
	<5386F0FE.7040003@ti.com>
Date: Thu, 29 May 2014 08:47:31 -0500
Message-ID: <CAL_Jsq+E7a=wh_yzQyaSEVAwfa34BYZ4DxvLOfJGFVDsf1dZ+A@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] sc_phy:SmartCard(SC) PHY interface to SC controller
From: Rob Herring <robherring2@gmail.com>
To: Satish Patel <satish.patel@ti.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 3:34 AM, Satish Patel <satish.patel@ti.com> wrote:
>
>
> On 5/29/2014 12:23 AM, Greg KH wrote:
>>
>> On Wed, May 28, 2014 at 02:27:13PM +0530, Satish Patel wrote:
>>>
>>> SmartCard controller uses this interface to communicate with
>>> SmartCard via PHY
>>>
>>> Some SmartCard PHY has multiple slots for cards.
>>> This inerface also enables controller to communicate
>>> with one or more SmartCard connected over phy.
>>>
>>> interface structure includes following APIs
>>> - set/get config
>>> - activate/deactivate smart card
>>> - warm reset
>>> - register_notify (for card insert/remove/overheat)
>>> - unregister_notify
>>>
>>> Signed-off-by: Satish Patel <satish.patel@ti.com>
>>> ---
>>>   Documentation/sc_phy.txt |  171
>>> ++++++++++++++++++++++++++++++++++++++++++++++
>>>   include/linux/sc_phy.h   |  136 ++++++++++++++++++++++++++++++++++++
>>>   2 files changed, 307 insertions(+)
>>>   create mode 100644 Documentation/sc_phy.txt
>>>   create mode 100644 include/linux/sc_phy.h
>>
>>
>> These are .h files, but where is the "api" functions that use
>> these structures defined at?
>>
> This is like template/wrappers, smart card phy driver will write API
> functions. And smartcard controller will call these functions.
> With proposed approach, smartcard controller can communicate with any smart
> card phy (TI/NxP) without change in code. Using DT entry smartcard and PHY
> will gets connected with each other.
> Refer diagram given @Documentation/sc_phy.txt.
>
>
>> confused,

I believe the api Greg is wondering about is the notifier which as I
commented is not a good design.

There is now a phy subsystem. I don't know if it has what you need,
but you should look at it to determine if it will work or could be
extended to work.

Rob
