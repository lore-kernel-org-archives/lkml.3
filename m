Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaIJKZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 06:25:08 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35351 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaIJKZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 06:25:04 -0400
Message-ID: <541026F5.9000609@collabora.com>
Date: Wed, 10 Sep 2014 12:24:53 +0200
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>
CC: Stephen Warren <swarren@wwwdotorg.org>,
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
References: <1409693701-16520-1-git-send-email-abrestic@chromium.org>	<CAAObsKAYqpJMJnxSMxhkkRtnoEwLwgUa1y7ij5ZHvHf1jRok+Q@mail.gmail.com>	<CAL1qeaF7U9aoBp5gQPS=r+pe6krKmXdP1qak2gjhNqQMoHFB8A@mail.gmail.com>	<CAAObsKAXO-pBtqd1jNj8faXqpE+5Wb0RFzPp+jn9FH0B=dHq8g@mail.gmail.com> <CAL1qeaFUaqs9SDv1p+dYDYLn9hwDxdTQ=K-wo+Qa5+KGY=U47w@mail.gmail.com>
In-Reply-To: <CAL1qeaFUaqs9SDv1p+dYDYLn9hwDxdTQ=K-wo+Qa5+KGY=U47w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 07:09 PM, Andrew Bresticker wrote:
> On Tue, Sep 9, 2014 at 1:21 AM, Tomeu Vizoso <tomeu@tomeuvizoso.net> wrote:
>> On 8 September 2014 18:22, Andrew Bresticker <abrestic@chromium.org> wrote:
>>> On Mon, Sep 8, 2014 at 8:34 AM, Tomeu Vizoso <tomeu@tomeuvizoso.net> wrote:
>>>> On 2 September 2014 23:34, Andrew Bresticker <abrestic@chromium.org> wrote:
>>>>>
>>>>> Tested on Venice2, Jetson TK1, and Big with a variety of USB2.0 and
>>>>> USB3.0 memory sticks and ethernet dongles using controller firmware
>>>>> recently posted by Andrew Chew [2].
>>>>
>>>> I have had mixed results when testing this on a Jetson TK1 board. Of 8
>>>> USB devices I tested with, about half where probed correctly, but the
>>>> other half repeatedly fail in hub_port_init because in the GET_STATUS
>>>> right after the reset, the C_PORT_CONNECTION bit is set.
>>>>
>>>> I don't see any correlation between the failure and the kind of usb
>>>> device, but I don't have much experience with USB implementations
>>>> either.
>>>
>>> Hmm... I haven't seen that before.  Which particular devices were you using?
>>
>> Here they are:
>>
>> work:
>>
>> Genius keyboard: 05d5:6782
>> Logitech mouse: 046d:c06a
>> Denver MP3 player: 10d6:1100
>> Atheros Bluetooth dongle: 0cf3:3005
>>
>> don't work:
>>
>> MCS7830 ethernet dongle: 9710:7830
>> Genesys Logic hub: 05e3:0608
>> Alcor flash drive: 058f:6387
>> JMicron SATA bridge: 152d:2329
> 
> I have the same SATA bridge and it is enumerating fine for me, but
> I've ordered the hub as well and will check that out.
> 
> Did you have any other patches applied when testing these?

Here is the branch, including the .config I used:

http://cgit.collabora.com/git/user/tomeu/linux.git/log/?h=3.17rc4-xhci

> Were you
> using either SATA or PCIe at the same time?

Nope, haven't even tried those yet.

> Just trying to figure out
> if there's anything else different between our setups.

Yeah, I'm afraid I don't have any good suggestion to make. But maybe you
will find some error on my part in how I have applied the patches or in
the config.

Regards,

Tomeu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

