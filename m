Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbaIIRJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 13:09:54 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:38637 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918AbaIIRJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 13:09:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAAObsKAXO-pBtqd1jNj8faXqpE+5Wb0RFzPp+jn9FH0B=dHq8g@mail.gmail.com>
References: <1409693701-16520-1-git-send-email-abrestic@chromium.org>
	<CAAObsKAYqpJMJnxSMxhkkRtnoEwLwgUa1y7ij5ZHvHf1jRok+Q@mail.gmail.com>
	<CAL1qeaF7U9aoBp5gQPS=r+pe6krKmXdP1qak2gjhNqQMoHFB8A@mail.gmail.com>
	<CAAObsKAXO-pBtqd1jNj8faXqpE+5Wb0RFzPp+jn9FH0B=dHq8g@mail.gmail.com>
Date: Tue, 9 Sep 2014 10:09:50 -0700
X-Google-Sender-Auth: 2WSATgj_gPUlAbCWI0ARF_owDH0
Message-ID: <CAL1qeaFUaqs9SDv1p+dYDYLn9hwDxdTQ=K-wo+Qa5+KGY=U47w@mail.gmail.com>
Subject: Re: [PATCH v3 0/9] Tegra xHCI support
From: Andrew Bresticker <abrestic@chromium.org>
To: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 1:21 AM, Tomeu Vizoso <tomeu@tomeuvizoso.net> wrote:
> On 8 September 2014 18:22, Andrew Bresticker <abrestic@chromium.org> wrote:
>> On Mon, Sep 8, 2014 at 8:34 AM, Tomeu Vizoso <tomeu@tomeuvizoso.net> wrote:
>>> On 2 September 2014 23:34, Andrew Bresticker <abrestic@chromium.org> wrote:
>>>>
>>>> Tested on Venice2, Jetson TK1, and Big with a variety of USB2.0 and
>>>> USB3.0 memory sticks and ethernet dongles using controller firmware
>>>> recently posted by Andrew Chew [2].
>>>
>>> I have had mixed results when testing this on a Jetson TK1 board. Of 8
>>> USB devices I tested with, about half where probed correctly, but the
>>> other half repeatedly fail in hub_port_init because in the GET_STATUS
>>> right after the reset, the C_PORT_CONNECTION bit is set.
>>>
>>> I don't see any correlation between the failure and the kind of usb
>>> device, but I don't have much experience with USB implementations
>>> either.
>>
>> Hmm... I haven't seen that before.  Which particular devices were you using?
>
> Here they are:
>
> work:
>
> Genius keyboard: 05d5:6782
> Logitech mouse: 046d:c06a
> Denver MP3 player: 10d6:1100
> Atheros Bluetooth dongle: 0cf3:3005
>
> don't work:
>
> MCS7830 ethernet dongle: 9710:7830
> Genesys Logic hub: 05e3:0608
> Alcor flash drive: 058f:6387
> JMicron SATA bridge: 152d:2329

I have the same SATA bridge and it is enumerating fine for me, but
I've ordered the hub as well and will check that out.

Did you have any other patches applied when testing these?  Were you
using either SATA or PCIe at the same time?  Just trying to figure out
if there's anything else different between our setups.
