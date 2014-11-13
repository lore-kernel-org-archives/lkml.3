Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbaKMAmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 19:42:18 -0500
Received: from regular1.263xmail.com ([211.150.99.133]:60521 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbaKMAmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 19:42:16 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: jwerner@chromium.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <6f1fb44ae25beb134f5b726836d77942>
X-DNS-TYPE: 0
Message-ID: <5463FE5E.906@rock-chips.com>
Date: Thu, 13 Nov 2014 08:42:06 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Paul Zimmerman <paulz@synopsys.com>, Felipe Balbi <balbi@ti.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>, romain.perier@gmail.com,
        Heiko Stuebner <heiko@sntech.de>, Sonny Rao <sonnyrao@chromium.org>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        lyz <lyz@rock-chips.com>, wulf <wulf@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jwerner@chromium.org
Subject: Re: [PATCH v3] usb: dwc2: add bus suspend/resume for dwc2
References: <1415624983-22413-1-git-send-email-kever.yang@rock-chips.com> <CAD=FV=V-D3qTtnwjme8k=boUkoGGPmfvcF=Jboq0qcRBzKrY6g@mail.gmail.com>
In-Reply-To: <CAD=FV=V-D3qTtnwjme8k=boUkoGGPmfvcF=Jboq0qcRBzKrY6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug,

On 11/13/2014 07:22 AM, Doug Anderson wrote:
> Kever,
>
> On Mon, Nov 10, 2014 at 5:09 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
>> Hcd controller needs bus_suspend/resume, dwc2 controller make
>> root hub generate suspend/resume signal with hprt0 register
>> when work in host mode.
>> After the root hub enter suspend, we can make controller enter
>> low power state with PCGCTL register.
>>
>> We also update the lx_state for hsotg state.
>>
>> This patch has tested on rk3288 with suspend/resume.
>>
>> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
>> Acked-by: Paul Zimmerman <paulz@synopsys.com>
>> ---
>>
>> Changes in v3:
>> - remove CONFIG_PM macro for bus_suspend/resume
>> - add PCGCTL operation for no device connect case
>>
>> Changes in v2:
>> - update commit message
>> - make dwc2 suspend/resume sourcecode work
>>
>>   drivers/usb/dwc2/hcd.c | 88 +++++++++++++++++++++++++++++++++++++++++++-------
>>   1 file changed, 77 insertions(+), 11 deletions(-)
> I would certainly appreciate confirmation, but my inclination is to
> NAK this change due to the fact that it regresses functionality.  I
> haven't done any serious review of it, but I've been testing it and it
> appears to break hotplug.
>
> Said another way, I did this:
>
> 1. Without this patch, I booted with a USB stick in.  It was detected.
> I unplugged it, waited 5 seconds, and then plugged it back in.  The
> USB stick was redetcted.
>
> 2. With this patch, I did the same thing.  The USB not redected after
> plugging it back in.
With this patch, the dwc2 hcd/root hub will be auto suspend after device
on port is disconnected, and it can't detect the device connect any more,
I think that's the problem.

I will figure out how to make dwc2 detect the device connect after auto 
suspend,
or disable the auto suspend feature for the dwc2 hcd.

- Kever

