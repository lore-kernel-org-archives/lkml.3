Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbaIOSIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 14:08:53 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42609 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaIOSIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 14:08:50 -0400
Message-ID: <54172B3F.9030901@wwwdotorg.org>
Date: Mon, 15 Sep 2014 12:09:03 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Thierry Reding <thierry.reding@gmail.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3 0/9] Tegra xHCI support
References: <1409693701-16520-1-git-send-email-abrestic@chromium.org>	<CAAObsKAYqpJMJnxSMxhkkRtnoEwLwgUa1y7ij5ZHvHf1jRok+Q@mail.gmail.com>	<CAL1qeaF7U9aoBp5gQPS=r+pe6krKmXdP1qak2gjhNqQMoHFB8A@mail.gmail.com>	<CAAObsKAXO-pBtqd1jNj8faXqpE+5Wb0RFzPp+jn9FH0B=dHq8g@mail.gmail.com>	<CAL1qeaEk_r5XAKvvJfwXN9+Wi9EjC_2MgBfoP92TK=F+Ou9QTA@mail.gmail.com>	<CAAObsKAwgfx1g2p7PQP+=HudvAHHpcPi47gEH6BrxEgLu6w2VQ@mail.gmail.com> <CAL1qeaEC9O8-jgjGC44cFctoZPpp4dRVfQ=mhSb_2on7GgiU0w@mail.gmail.com>
In-Reply-To: <CAL1qeaEC9O8-jgjGC44cFctoZPpp4dRVfQ=mhSb_2on7GgiU0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 11:06 AM, Andrew Bresticker wrote:
> On Mon, Sep 15, 2014 at 12:00 AM, Tomeu Vizoso <tomeu@tomeuvizoso.net> wrote:
>> On 12 September 2014 18:37, Andrew Bresticker <abrestic@chromium.org> wrote:
>>> On Tue, Sep 9, 2014 at 1:21 AM, Tomeu Vizoso <tomeu@tomeuvizoso.net> wrote:
>>>> On 8 September 2014 18:22, Andrew Bresticker <abrestic@chromium.org> wrote:
>>>>> On Mon, Sep 8, 2014 at 8:34 AM, Tomeu Vizoso <tomeu@tomeuvizoso.net> wrote:
>>>>>> On 2 September 2014 23:34, Andrew Bresticker <abrestic@chromium.org> wrote:
>>>>>>>
>>>>>>> Tested on Venice2, Jetson TK1, and Big with a variety of USB2.0 and
>>>>>>> USB3.0 memory sticks and ethernet dongles using controller firmware
>>>>>>> recently posted by Andrew Chew [2].
>>>>>>
>>>>>> I have had mixed results when testing this on a Jetson TK1 board. Of 8
>>>>>> USB devices I tested with, about half where probed correctly, but the
>>>>>> other half repeatedly fail in hub_port_init because in the GET_STATUS
>>>>>> right after the reset, the C_PORT_CONNECTION bit is set.
>>>>>>
>>>>>> I don't see any correlation between the failure and the kind of usb
>>>>>> device, but I don't have much experience with USB implementations
>>>>>> either.
>>>>>
>>>>> Hmm... I haven't seen that before.  Which particular devices were you using?
>>>>
>>>> Here they are:
>>>>
>>>> work:
>>>>
>>>> Genius keyboard: 05d5:6782
>>>> Logitech mouse: 046d:c06a
>>>> Denver MP3 player: 10d6:1100
>>>> Atheros Bluetooth dongle: 0cf3:3005
>>>>
>>>> don't work:
>>>>
>>>> MCS7830 ethernet dongle: 9710:7830
>>>> Genesys Logic hub: 05e3:0608
>>>
>>> I tried the hub and it works just fine for me... Have you tried this
>>> on any other boards like Big or Blaze?
>>
>> I have a Blaze here, but haven't been able to get the external ports
>> to power up. I don't have schematics nor a strong interest to get that
>> fixed myself, as I can test my code just fine with the Blaze's
>> internal camera and the devices that do work on the Jetson.
>
> Ok, since Blaze has been announced, hopefully we can post a
> device-tree for it soon.
>
>> I'm using the firmware file that was posted recently:
>>
>> xhci-tegra 70090000.usb: Firmware timestamp: 2014-05-02 02:22:50 UTC,
>> Falcon state 0x20
>
> Yup, I'm using the same firmware.
>
>> If things work for you with the same sources, .config and firmware, I
>> can only think of the hw being different (other hw revision?).
>
> That, or perhaps bootloader differences?  I'm using mainline U-Boot.
>
> Stephen, Thierry, have either of you had a chance to test this series?

I haven't had a chance to yet. I just went to try it out, and found that 
it depends on a whole slew of other patches that I don't have. Is there 
a git branch somewhere to save me having to track down all the dependencies?

Thierry is on vacation right now. I think he was expecting to return 
sometime this week, but the start of his vacation was delayed, so 
perhaps he'll be back a bit later too.

