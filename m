Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaIPWkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:40:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37099 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaIPWkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:40:14 -0400
Message-ID: <5418BC5C.5020108@wwwdotorg.org>
Date: Tue, 16 Sep 2014 16:40:28 -0600
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
References: <1409693701-16520-1-git-send-email-abrestic@chromium.org>	<CAAObsKAYqpJMJnxSMxhkkRtnoEwLwgUa1y7ij5ZHvHf1jRok+Q@mail.gmail.com>	<CAL1qeaF7U9aoBp5gQPS=r+pe6krKmXdP1qak2gjhNqQMoHFB8A@mail.gmail.com>	<CAAObsKAXO-pBtqd1jNj8faXqpE+5Wb0RFzPp+jn9FH0B=dHq8g@mail.gmail.com>	<CAL1qeaEk_r5XAKvvJfwXN9+Wi9EjC_2MgBfoP92TK=F+Ou9QTA@mail.gmail.com>	<CAAObsKAwgfx1g2p7PQP+=HudvAHHpcPi47gEH6BrxEgLu6w2VQ@mail.gmail.com>	<CAL1qeaEC9O8-jgjGC44cFctoZPpp4dRVfQ=mhSb_2on7GgiU0w@mail.gmail.com>	<54172B3F.9030901@wwwdotorg.org>	<CAL1qeaEK=C4j+G5CA_91xJNe25d=-y47EyZAYnaMh46fNYVDAw@mail.gmail.com>	<54185698.7020600@wwwdotorg.org> <CAL1qeaGf6JSuq=ekZY7Pp2zSAB0+0S9fZ70xWpct2MJ=pTSmug@mail.gmail.com>
In-Reply-To: <CAL1qeaGf6JSuq=ekZY7Pp2zSAB0+0S9fZ70xWpct2MJ=pTSmug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 10:57 AM, Andrew Bresticker wrote:
> On Tue, Sep 16, 2014 at 8:26 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 09/15/2014 01:30 PM, Andrew Bresticker wrote:
>>>
>>> On Mon, Sep 15, 2014 at 11:09 AM, Stephen Warren <swarren@wwwdotorg.org>
>>> wrote:
>>>>
>>>> On 09/15/2014 11:06 AM, Andrew Bresticker wrote:
>>>>>
>>>>> On Mon, Sep 15, 2014 at 12:00 AM, Tomeu Vizoso <tomeu@tomeuvizoso.net>
>>>>> wrote:
>>>>>>
>>>>>> On 12 September 2014 18:37, Andrew Bresticker <abrestic@chromium.org>
>>>>>> wrote:
>>>>>>>
>>>>>>> On Tue, Sep 9, 2014 at 1:21 AM, Tomeu Vizoso <tomeu@tomeuvizoso.net>
>>>>>>> wrote:
>>>>>>>>
>>>>>>>> On 8 September 2014 18:22, Andrew Bresticker <abrestic@chromium.org>
>>>>>>>> wrote:
>>>>>>>>>
>>>>>>>>> On Mon, Sep 8, 2014 at 8:34 AM, Tomeu Vizoso <tomeu@tomeuvizoso.net>
>>>>>>>>> wrote:
>>>>>>>>>>
>>>>>>>>>> On 2 September 2014 23:34, Andrew Bresticker
>>>>>>>>>> <abrestic@chromium.org> wrote:
>>>>>>>>>>>
>>>>>>>>>>> Tested on Venice2, Jetson TK1, and Big with a variety of USB2.0
>>>>>>>>>>> and
>>>>>>>>>>> USB3.0 memory sticks and ethernet dongles using controller
>>>>>>>>>>> firmware
>>>>>>>>>>> recently posted by Andrew Chew [2].
>>
>> ...
>>>>>
>>>>> Stephen, Thierry, have either of you had a chance to test this series?
>>>>
>>>>
>>>> I haven't had a chance to yet. I just went to try it out, and found that it
>>>> depends on a whole slew of other patches that I don't have. Is there a git
>>>> branch somewhere to save me having to track down all the dependencies?
>>>
>>> Yes, Tomeu has the branch he used for testing here:
>>> http://cgit.collabora.com/git/user/tomeu/linux.git/log/?h=3.17rc4-xhci
>>
>> Hmm. That git server was quite reluctant to cough up its bits, but it did
>> eventually.
>>
>>> You'll also need the firmware Andrew Chew posted:
>>> https://patchwork.ozlabs.org/patch/384013/
>>
>> The XHCI driver can't load its firmware unless it's a module; if I make it
>> built-in, it fails immediately with error -2 during "Direct firmware
>> loading". The driver needs to work with either immediate or deferred
>> firmware loading.
>
> If you want the driver to be built-in, you'll either need to build the
> firmware in as well (i.e. EXTRA_FIRMWARE) or enable
> FW_LOADER_USER_HELPER_FALLBACK to load with userspace/uevent (though
> apparently this is deprecated).

Hmm. I didn't have to do that for the Atmel touchpad driver to work, but 
perhaps it's just ignoring a firmware loading error, and continuing with 
whatever is in the device's flash already.

It seems odd that such a fundamental feature would require a deprecated 
Kconfig option. Is there some replacement that does the same thing that 
isn't deprecated? The Kconfig help for the option doesn't say anything 
useful...

Oh, this option doesn't actually seem to work. I see the following in dmesg:

> [root@swarren-dt ~]# dmesg|grep -i -e xhci -e firmware
> [    1.461773] xhci-tegra 70090000.usb: Failed to get supply 'avddio-pex': -517
> [    1.468930] platform 70090000.usb: Driver xhci-tegra requests probe deferral
> [    2.567966] xhci-tegra 70090000.usb: Direct firmware load for nvidia/tegra124/xusb.bin failed with error -2
> [    2.577786] xhci-tegra 70090000.usb: Falling back to user helper

... but:

[root@swarren-dt ~]# lsusb
unable to initialize libusb: -99

Perhaps systemd-udevd doesn't implement firmware loading; is it 
user-space udev that's deprecated implementing user-space firmware 
loading, rather than the kernel deprecating support for calling out to 
user space?

This sucks, because now I can't just TFTP boot kernels but somehow have 
to get updated kernel modules onto my device every time before testing a 
new kernel build. That's a huge time-sink, unless I work out NFS root, 
which probably isn't properly or easily supported by any distro.
