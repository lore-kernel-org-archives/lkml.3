Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbaIQPlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:41:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48508 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670AbaIQPlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:41:01 -0400
Message-ID: <5419AB9C.3000005@wwwdotorg.org>
Date: Wed, 17 Sep 2014 09:41:16 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>
CC: Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
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
References: <1409693701-16520-1-git-send-email-abrestic@chromium.org>	<CAAObsKAYqpJMJnxSMxhkkRtnoEwLwgUa1y7ij5ZHvHf1jRok+Q@mail.gmail.com>	<CAL1qeaF7U9aoBp5gQPS=r+pe6krKmXdP1qak2gjhNqQMoHFB8A@mail.gmail.com>	<CAAObsKAXO-pBtqd1jNj8faXqpE+5Wb0RFzPp+jn9FH0B=dHq8g@mail.gmail.com>	<CAL1qeaEk_r5XAKvvJfwXN9+Wi9EjC_2MgBfoP92TK=F+Ou9QTA@mail.gmail.com>	<CAAObsKAwgfx1g2p7PQP+=HudvAHHpcPi47gEH6BrxEgLu6w2VQ@mail.gmail.com>	<CAL1qeaEC9O8-jgjGC44cFctoZPpp4dRVfQ=mhSb_2on7GgiU0w@mail.gmail.com>	<54172B3F.9030901@wwwdotorg.org>	<CAL1qeaEK=C4j+G5CA_91xJNe25d=-y47EyZAYnaMh46fNYVDAw@mail.gmail.com>	<54185698.7020600@wwwdotorg.org>	<CAL1qeaGf6JSuq=ekZY7Pp2zSAB0+0S9fZ70xWpct2MJ=pTSmug@mail.gmail.com>	<CAL1qeaHms021HBTBCnSkcBCHnCVYC0CnSD=JbBWFo_ZN4AKpOw@mail.gmail.com>	<5418C498.8030208@wwwdotorg.org> <CAL1qeaHhabYHN6B5xCUf-y+ZuEWEBpURDPfmjY=KMpmUbuTg5w@mail.gmail.com>
In-Reply-To: <CAL1qeaHhabYHN6B5xCUf-y+ZuEWEBpURDPfmjY=KMpmUbuTg5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 05:51 PM, Andrew Bresticker wrote:
> On Tue, Sep 16, 2014 at 4:15 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 09/16/2014 04:46 PM, Andrew Bresticker wrote:
>>>
>>> On Tue, Sep 16, 2014 at 9:57 AM, Andrew Bresticker
>>> <abrestic@chromium.org> wrote:
>>>>
>>>> On Tue, Sep 16, 2014 at 8:26 AM, Stephen Warren <swarren@wwwdotorg.org>
>>>> wrote:
>>>>>
>>>>> On 09/15/2014 01:30 PM, Andrew Bresticker wrote:
>>>>>>
>>>>>>
>>>>>> On Mon, Sep 15, 2014 at 11:09 AM, Stephen Warren
>>>>>> <swarren@wwwdotorg.org>
>>>>>> wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 09/15/2014 11:06 AM, Andrew Bresticker wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On Mon, Sep 15, 2014 at 12:00 AM, Tomeu Vizoso
>>>>>>>> <tomeu@tomeuvizoso.net>
>>>>>>>> wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On 12 September 2014 18:37, Andrew Bresticker
>>>>>>>>> <abrestic@chromium.org>
>>>>>>>>> wrote:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On Tue, Sep 9, 2014 at 1:21 AM, Tomeu Vizoso
>>>>>>>>>> <tomeu@tomeuvizoso.net>
>>>>>>>>>> wrote:
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> On 8 September 2014 18:22, Andrew Bresticker
>>>>>>>>>>> <abrestic@chromium.org>
>>>>>>>>>>> wrote:
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> On Mon, Sep 8, 2014 at 8:34 AM, Tomeu Vizoso
>>>>>>>>>>>> <tomeu@tomeuvizoso.net>
>>>>>>>>>>>> wrote:
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> On 2 September 2014 23:34, Andrew Bresticker
>>>>>>>>>>>>> <abrestic@chromium.org> wrote:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Tested on Venice2, Jetson TK1, and Big with a variety of USB2.0
>>>>>>>>>>>>>> and
>>>>>>>>>>>>>> USB3.0 memory sticks and ethernet dongles using controller
>>>>>>>>>>>>>> firmware
>>>>>>>>>>>>>> recently posted by Andrew Chew [2].
>>>>>
>>>>>
>>>>> ...
>>>>>>>>
>>>>>>>>
>>>>>>>> Stephen, Thierry, have either of you had a chance to test this
>>>>>>>> series?
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> I haven't had a chance to yet. I just went to try it out, and found
>>>>>>> that
>>>>>>> it
>>>>>>> depends on a whole slew of other patches that I don't have. Is there a
>>>>>>> git
>>>>>>> branch somewhere to save me having to track down all the dependencies?
>>>>>>
>>>>>>
>>>>>>
>>>>>> Yes, Tomeu has the branch he used for testing here:
>>>>>> http://cgit.collabora.com/git/user/tomeu/linux.git/log/?h=3.17rc4-xhci
>>>>>
>>>>>
>>>>>
>>>>> Hmm. That git server was quite reluctant to cough up its bits, but it
>>>>> did
>>>>> eventually.
>>>>>
>>>>>> You'll also need the firmware Andrew Chew posted:
>>>>>> https://patchwork.ozlabs.org/patch/384013/
>>>>>
>>>>>
>>>>>
>>>>> The XHCI driver can't load its firmware unless it's a module; if I make
>>>>> it
>>>>> built-in, it fails immediately with error -2 during "Direct firmware
>>>>> loading". The driver needs to work with either immediate or deferred
>>>>> firmware loading.
>>>>
>>>>
>>>> If you want the driver to be built-in, you'll either need to build the
>>>> firmware in as well (i.e. EXTRA_FIRMWARE) or enable
>>>> FW_LOADER_USER_HELPER_FALLBACK to load with userspace/uevent (though
>>>> apparently this is deprecated).
>>>>
>>>>> The following USB2 devices had problems:
>>>>>
>>>>> 0b95:7720 ASIX Electronics Corp. AX88772
>>>>>
>>>>>> [  489.140536] usb 1-3: new high-speed USB device number 81 using
>>>>>> xhci-tegra
>>>>>> [  489.260860] usb 1-3: device descriptor read/64, error -71
>>>>>> [  489.370804] xhci-tegra 70090000.usb: Setup ERROR: setup context
>>>>>> command
>>>>>> for slot 1.
>>>>>> [  489.378463] usb 1-3: hub failed to enable device, error -22
>>>>>> [  489.500531] usb 1-3: new high-speed USB device number 82 using
>>>>>> xhci-tegra
>>>>>> [  489.655708] usb 1-3: can't set config #1, error -71
>>>>>> [  489.661231] usb 1-3: USB disconnect, device number 82
>>>>>> [  489.940531] usb 1-3: new high-speed USB device number 83 using
>>>>>> xhci-tegra
>>>>>> [  490.060860] usb 1-3: device descriptor read/64, error -71
>>>>>> [  490.170805] xhci-tegra 70090000.usb: Setup ERROR: setup context
>>>>>> command
>>>>>> for slot 1.
>>>>>> [  490.178462] usb 1-3: hub failed to enable device, error -22
>>>>>
>>>>>
>>>>> (repeats over and over)
>>>>>
>>>>> 15a4:1336 Afatech Technologies, Inc. SDHC/MicroSD/MMC/MS/M2/CF/XD Flash
>>>>> Card
>>>>> Reader
>>>>>
>>>>> The power light comes on, and the activity light just keeps flashing
>>>>> fast.
>>>>> Usually the activity light flashes a couple times and then turns off.
>>>>> There
>>>>> is nothing in dmesg at all for this device.
>>>>>
>>>>> 05e3:0608 Genesys Logic, Inc. USB-2.0 4-Port HUB
>>>>>
>>>>> Not detected. There is nothing in dmesg at all for this device.
>>>>>
>>>>> 1bcf:0c31 Sunplus Innovation Technology Inc. SPIF30x Serial-ATA bridge
>>>>>
>>>>> Not detected. There is nothing in dmesg at all for this device.
>>>>
>>>>
>>>> Thanks, I'll try to figure out what's going on here.
>>>
>>>
>>> Grr... this is due to the unfortunate UTMI pad controller design on Tegra.
>>>
>>> Here's the issue:  When UTMI pad 0 is assigned to the EHCI controller
>>> (as is currently the case on Jetson-TK1), the UTMI parameters from
>>> UTMIP_BIAS_CFG0 in the global UTMI pad register space are used
>>> regardless of the owner of the UTMI pads.  If pad 0 is assigned to the
>>> XUSB controller, then parameters in USB2_BIAS_PAD_CTL0 in the XUSB
>>> register space are used for all UTMI pads (again, regardless of
>>> ownership).
>>>
>>> I wasn't able to reproduce before because I always TFTP booted and
>>> U-Boot programs the UTMI parameters correctly when starting the EHCI
>>> controllers.  I suspect you and Tomeu were booting without starting
>>> the EHCI controllers and thus were stuck with the POR values.
>>
>>
>> I am loading the kernel over the PCIe Ethernet on Jetson TK1. However, the
>> U-Boot boot scripts do "usb start" first, so I would assume all the USB set
>> is already done either way, before U-Boot attempts to probe USB devices.
>
> Interesting - just doing "usb start" made the difference for me.
>
>>> The easiest way to fix this is to just assign UTMI port 0 (i.e. the
>>> OTG port) to the XUSB controller.  AFAIK, device mode on Tegra isn't
>>> supported yet in the kernel, so this shouldn't break any existing use
>>> cases.  If we wanted to support device mode in the future, it would
>>> just have to be done with the XUSB controller instead.  The
>>> alternative is some ugly driver that programs the correct register set
>>> depending on which controller UTMI port 0 is assigned to.
>>>
>>> BTW, here's a patch to assign UTMI port 0 to XUSB:
>>>
>>> diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
>>> b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
>>> index a473750..dacb0d0 100644
>>> --- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
>>> +++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
>>> @@ -1644,7 +1644,7 @@
>>>
>>>                   padctl_default: pinmux {
>>>                           otg {
>>> -                               nvidia,lanes = "otg-1", "otg-2";
>>> +                               nvidia,lanes = "otg-0", "otg-1", "otg-2";
>>>                                   nvidia,function = "xusb";
>>>                           };
>>
>>
>> That's a bit better; I now see dmesg entries when I plug in my hub where
>> before I got none. However, I still get some descriptor read errors etc.,
>
> I see those sometimes with my ethernet dongle too, but it still seems
> to work ok.
>
>> and the USB HDD I have behind the hub isn't fully detected.
>
> Can you post the dmesg output?  Does it work when not behind the hub?
> So far I haven't seen any failures with my pile of USB devices after
> the above change.

Hmm. I think I must have screwed up my testing after applying that 
patch; likely I retested a kernel without that patch.

Today, I retested 4 flash devices, 1 SD reader, 1 HDD, 1 mouse, 1 
keyboard, 1 Ethernet dongle, and 1 hub. All worked fine. I tested the 
HDD/mouse/keyboard/ethernet all together behind the hub too, and with it 
either plugged in at power on, or plugged in after boot, it all worked.

So, I think we're good:-)
